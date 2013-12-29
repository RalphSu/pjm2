#--encoding=UTF-8
require 'rjb'
require 'uuidtools'

# JVM loading
POI_LIB_HOME=File.join File.dirname(__FILE__), '/lib/poi-3.9'
#POI_LIB_HOME= './lib/poi-3.9'
poi_jars = [
	"#{POI_LIB_HOME}/poi-3.9-20121203.jar",
	"#{POI_LIB_HOME}/poi-excelant-3.9-20121203.jar",
	"#{POI_LIB_HOME}/poi-ooxml-3.9-20121203.jar",
	"#{POI_LIB_HOME}/poi-ooxml-schemas-3.9-20121203.jar",
	"#{POI_LIB_HOME}/poi-scratchpad-3.9-20121203.jar",
	# common
	"#{POI_LIB_HOME}/lib/commons-codec-1.5.jar",
	"#{POI_LIB_HOME}/lib/commons-logging-1.1.jar",
	"#{POI_LIB_HOME}/lib/log4j-1.2.13.jar",
	# ooxml
	"#{POI_LIB_HOME}/ooxml-lib/dom4j-1.6.1.jar",
	"#{POI_LIB_HOME}/ooxml-lib/stax-api-1.0.1.jar",
	"#{POI_LIB_HOME}/ooxml-lib/xmlbeans-2.3.0.jar"
]
# loading
#p poi_jars.join(":")
Rjb::load(poi_jars.join(":"),  ['-Xms256M', '-Xmx512M'])

## excel image handling:
class PoiExcelImageReader
	# Java classes import
	@@file_class = Rjb::import('java.io.FileOutputStream')
	@@file_in_class = Rjb::import('java.io.FileInputStream')
	@@workbook_class = Rjb::import('org.apache.poi.xssf.usermodel.XSSFWorkbook')
	@@cell_style_class = Rjb::import('org.apache.poi.xssf.usermodel.XSSFCellStyle')
	@@font_class = Rjb::import('org.apache.poi.xssf.usermodel.XSSFFont')
	@@cell_class=Rjb::import('org.apache.poi.xssf.usermodel.XSSFCell')
	@@row_class=Rjb::import('org.apache.poi.xssf.usermodel.XSSFRow')
	@@sheet_class=Rjb::import('org.apache.poi.xssf.usermodel.XSSFSheet')
	@@string_stream_class=Rjb::import('java.io.StringBufferInputStream')
	@@byte_stream_class=Rjb::import('java.io.ByteArrayInputStream')
	@@xssf_picture_class=Rjb::import('org.apache.poi.xssf.usermodel.XSSFPicture')
	@@cell_interface_class=Rjb::import('org.apache.poi.ss.usermodel.Cell')
	@@date_util_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFDateUtil')
	@@date_format_class = Rjb::import('java.text.SimpleDateFormat')
	@@xssf_drawing_class = Rjb::import('org.apache.poi.xssf.usermodel.XSSFDrawing')

	def initialize(project)
	  @project = project
	end

	def read_images(wb, sheet, head_array)
		it = sheet.getRelations().iterator()
		picture_path = {}
		pic_num = 0
		while it.hasNext
			doc_part = it.next()
			if doc_part.getClass().equals(@@xssf_drawing_class)
				shape_it = doc_part.getShapes().iterator()
				while shape_it.hasNext
					shape = shape_it.next()
					if shape.getClass().equals(@@xssf_picture_class)
						anchor = shape.getPreferredSize().getFrom()
						row = anchor.getRow()
						col = anchor.getCol()
						# Rails.logger.info "Found picture at --->row:" + row.to_s + ", column:"  + col.to_s
						p "Found picture at --->row:" + row.to_s + ", column:"  + col.to_s

						paths = save_pic(shape.getPictureData())
						picture_path[anchor] = paths

						pic_num = pic_num + 1
					end
				end # end of shapes loop
			end
		end # end of relations loop
		p "Total picture number : #{pic_num}"

		# construct image metadata
		image_metas = []
		picture_path.each do |anchor, paths|
			# p "Row: #{anchor.getRow()}, Col : #{anchor.getCol()}. Paths : #{paths}"

			row = sheet.getRow(anchor.getRow())
			if row.nil?
				raise "Row not found for image at position row: #{anchor.getRow()}, col: #{anchor.getCol()}"
			end
			# FIXME :: why enforce title column just one column before the image??
			title_col = anchor.getCol() - 1
			if title_col < row.getFirstCellNum()
				title_col = row.getFirstCellNum()
			end
			cell = row.getCell(title_col)
			url = validate_get_cell_string(cell)

			img_meta = ImageMeta.new()
			img_meta.url = url
			img_meta.paths = paths
			image_metas << img_meta
		end

		image_metas
	end

	def validate_get_cell_string(cell)
		case
		when cell.getCellType() == cell.CELL_TYPE_STRING
			return cell.getRichStringCellValue().getString()
		else
			raise "Expected string for the cell!"
		end
	end

	def validate_image_header(header_row)
		head = []
		expected_head = ['文章链接','贴图']
		i = 0
		# read heads
		while i < header_row.getLastCellNum()
			cell = header_row.getCell(i)
			i = i + 1
			if cell.nil?
				next
			end

			cell_type = cell.getCellType()
			case
			when cell_type == cell.CELL_TYPE_STRING
				head << value = cell.getRichStringCellValue().getString()
			when cell_type = cell.CELL_TYPE_BLANK
				head << ""
			else
				raise "Image file head is invalid. Expected : #{expected_head} !"
			end
		end
		# validation for head existence
		expected_head.each do |e|
			raise "Image file head is invalid. Expected : #{expected_head} ! #{e} missed!" unless head.include?(e)
		end
		return head
	end

	def save_pic(pic_data)
		folder = File.join File.dirname(__FILE__), "/upload/#{@project.identifier}"
		p folder
		unless File.exists?(folder)
			Dir.mkdir(folder)
		end
		# p "suggestFileExtension is #{pic_data.suggestFileExtension()}"
		if (not pic_data.suggestFileExtension().nil?) && (pic_data.suggestFileExtension().length() > 0)
			ext1 = ".full.#{pic_data.suggestFileExtension}";
			ext2 = ".small.#{pic_data.suggestFileExtension}";

		else 
			ext1 = '.full.png';
			ext2 = '.small.png';
		end

		uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
		file_full_name = uuid + ext1
		file_small_name = uuid + ext2
		full_name = File.join folder, file_full_name
		small_name = File.join folder, file_small_name
		# write full
		IO.binwrite(full_name, pic_data.getData())
		# TODO write small
		IO.binwrite(small_name, pic_data.getData())

		[full_name, small_name]
	end

	def read_excel_image(data)
		byte_stream = @@byte_stream_class.new(data)
		wb = @@workbook_class.new(byte_stream)
		sheet = wb.getSheetAt(0)
		if sheet.nil?
			raise 'Can not find sheet!'
		end
		headrow = sheet.getRow(sheet.getFirstRowNum())
		if headrow.nil?
			raise 'No head row!'
		end
		# read header row
		head_array = validate_image_header(headrow)
		p head_array
		# read/store images and return the image metadata
		result = read_images(wb, sheet, head_array)

		begin
			byte_stream.close()
		rescue 
			Rails.logger.info "ImageReader:: Close stream failed, ignore and return"
		end
		result
	end
end # end of POIExcelImageReader

class Project
	attr_accessor :identifier
	@identifier = "test-image-import"
end

class ImageMeta
	attr_accessor :url, :paths
	# the url which the image screenshot matches
	@url
	# the image stored paths
	@paths
end

pr = PoiExcelImageReader.new(Project.new)
file_name = File.join File.dirname(__FILE__), '/image_import_ralph.xlsx'
data = IO.binread(file_name)

p " data size " + data.size.to_s
pr.read_excel_image(data)
