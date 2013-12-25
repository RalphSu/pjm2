#--encoding=UTF-8
require 'rjb'

# JVM loading
POI_LIB_HOME=File.join File.dirname(__FILE__), '/lib/poi-3.9'
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
Rjb::load(poi_jars.join(":"),  ['-Xms256M', '-Xmx512M'])


class PoiExcelReader
	  # Java classes import
	  include Rjb
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

	def read_excel(data)
		byte_stream = @@byte_stream_class.new(data)
		wb = @@workbook_class.new(byte_stream)
		sheet = wb.getSheetAt(0)
		if sheet.nil?
			raise ''
		end
		p "sheet contains row from #{sheet.getFirstRowNum() } to #{sheet.getLastRowNum()}"
		headrow = sheet.getRow(sheet.getFirstRowNum())
		if headrow.nil?
			raise ''
		end
		p headrow
		# read header row
		validate_header(headrow)

		## images
		#read_pics(wb, sheet)

		## texts
		m = sheet.getFirstRowNum() + 1
		p "sheet contains row from #{sheet.getFirstRowNum() } to #{sheet.getLastRowNum()}"
		while m <= sheet.getLastRowNum()
			p "starting row : #{m}"
			row = sheet.getRow(m)
		  	i = row.getFirstCellNum()
		  	while i < row.getLastCellNum()
		  		cell = row.getCell(i)
		  		cell_type = cell.getCellType()
		  		value = nil
		  		case
		  		when cell_type == cell.CELL_TYPE_BLANK
		  			value = cell.getRichStringCellValue().getString()
		  		when cell_type == cell.CELL_TYPE_BOOLEAN
		  			value = cell.getBooleanCellValue()
		  		when cell_type == cell.CELL_TYPE_FORMULA
		  			value = cell.getCellFormula()
		  		when cell_type == cell.CELL_TYPE_NUMERIC
		  			value = cell.getNumericCellValue()
		  		when cell_type == cell.CELL_TYPE_STRING
		  			value = cell.getRichStringCellValue().getString()
		  		when cell_type == cell.CELL_TYPE_ERROR
		  			# ignore error column
		  		else
		  			raise 'unknown cell type'
		  		end

		  		## FIXME :: DATE
		  		p value
		  		i= i+1
		  	end
		  	m = m+1
		end
	end

	def read_pics(wb, sheet)
		pictures = wb.getAllPictures()
	  	patriarch = sheet.getDrawingPatriarch();
	  	if patriarch.nil?
	  		return
	  	end

	  	pic_num = 0
	  	it = patriarch.getChildren().iterator()
      		while it.hasNext()
	 		shape = it.next()
		       	anchor =  shape.getAnchor()
		       	if (shape .getClass().equals(@@hssf_picture_class)) 
		          row = anchor.getRow1()
		          col = anchor.getCol1()
		          p "Found picture at --->row:" + row.to_s + ", column:"  + col.to_s
		          pic_index = shape.getPictureIndex() - 1
		          pic_data = pictures.get(pic_index)
		          save_pic(row, col, pic_data)

		          pic_num = pic_num + 1
	    	end  
	     end
	     p "Total picture number : #{pic_num}"
	end

	def save_pic(row, col, pic_data)
		file_name = "" + row.to_s + col.to_s + "." + pic_data.suggestFileExtension
		p "Save image with name #{file_name}"
		IO.binwrite(file_name, pic_data.getData())
	end

	def validate_header(headrow)
		
	end
end

pr = PoiExcelReader.new
file_name = File.join File.dirname(__FILE__), '/keyi_sample.xlsx'
#f = File.open(file_name)
data = IO.binread(file_name)
p data.size
pr.read_excel(data)
