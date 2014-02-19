#-- encoding: UTF-8
require 'rjb'

module ContentsHelper

	def project_content_tabs
		tabs = [
				{:name => 'news', :controller=> 'news_release', :action => 'index', :partial => 'contents/news', :label => :label_news},
				{:name => 'weibo',  :controller=> 'weibo', :action => 'index', :partial => 'contents/weibo', :label => :label_weibo},
				{:name => 'weixin',  :controller=> 'weixin', :action => 'index', :partial => 'contents/weixin', :label => :label_weixin},
				{:name => 'blog', :controller=> 'blog', :action => 'index', :partial => 'contents/blog', :label => :label_blog},
				{:name => 'forum', :controller=> 'forum', :action => 'index' , :partial => 'contents/forum', :label => :label_forum},
				{:name => 'summary',  :controller=> 'summary', :action => 'index', :partial => 'contents/summary', :label => :label_summary},
		]
		tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
		tabs
	end

	def import_types(selected)
		types = [
			[l(:label_data), "0"],
			[l(:label_image), "1"]
		]
		options_for_select(types, selected)
	end

	class PoiExcelReader
		# Java classes import
		@@file_class = Rjb::import('java.io.FileOutputStream')
		@@file_in_class = Rjb::import('java.io.FileInputStream')
		@@string_class = Rjb::import('java.lang.String')
		@@double_class = Rjb::import('java.lang.Double')
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
		@@opc_package_class=Rjb::import('org.apache.poi.openxml4j.opc.OPCPackage')

		def initialize(classified_hash, factory)
			#
			@classified_hash = classified_hash
			@factory = factory
		end

		def read_excel_text(file_name, headers)
			opc = @@opc_package_class.open(@@string_class.new(file_name))
			wb = @@workbook_class.new(opc)

			sheet = wb.getSheetAt(0)
			if sheet.nil?
				raise '没有Excel内容!'
			end
			headrow = sheet.getRow(sheet.getFirstRowNum())
			if headrow.nil?
				raise ' 没有列头行!'
			end
			# read header row
			head_array = validate_text_header(headrow, headers)
			Rails.logger.info "headers : #{head_array}"
			## read texts and return 
			result = read_texts(sheet, head_array)

			begin
				opc.close()
			rescue
				Rails.logger.info "TextReader:: close opc package failed, ignore and return"
			end
			return result
		end

		#  better to read the header, then read other row based on header row definition??
		def read_texts(sheet, head_array)
			result = []
			Rails.logger.info "sheet has : #{sheet.getFirstRowNum()} to #{sheet.getLastRowNum()} row."
			m = sheet.getFirstRowNum() + 1
			regions = init_merged_cells(sheet)
			while m <= sheet.getLastRowNum()
				Rails.logger.info "starting row : #{m}"
				row = sheet.getRow(m)
				if row.nil?
					Rails.logger.info "ignore null row : #{m}!"
					m = m+1
					next
				end
			
				line = nil

				i = row.getFirstCellNum()
				category_map = nil
				category_name = nil
				Rails.logger.info "	Row : #{m} has #{i} to #{row.getLastCellNum()} cells."
				while i < row.getLastCellNum()
					if i >= head_array.length
						# ingore mismatch with head
						break
					end

					# read columns with value validation on type
					cell = row.getCell(i)
					if cell.nil?
						i = i + 1
						next
					end

					# read the cell value itself, if blanck, double check the merged value
					value = get_cell_value(cell, head_array[i])
					if value.blank?
			  			merged_cell = get_merged_cell(sheet, regions, m, i)
			  			unless merged_cell.nil?
			  				value = get_cell_value(merged_cell, head_array[i])
			  			end
					end

					unless value.nil?
						Rails.logger.info "		Cell value : #{value.to_s}! current category is #{category_name}, head_array is #{head_array[i]}"
					end 

					# fill category first.
					if category_name.nil? && ( not value.nil?)  && ( is_category_col(head_array[i])  && @classified_hash.has_key?(value.to_s) )
						category_name = value.to_s
						Rails.logger.info "		Find category of row #{m} at col #{i}, category is #{category_name}"
						category_map = @classified_hash[value.to_s]
						i = i + 1
						next
					end

					# convert to string value
					unless (  value.nil? or category_map.nil? )
						if category_map.has_key?(head_array[i])
							if line.nil?
								line = UploadLine.new()
								line.entity = @factory.createEntity(category_name)
								line.items = []
							end
							value = value.to_s
							field = @factory.createField(value, category_map[head_array[i]])
							Rails.logger.info "		Add a field for row #{m}, at col #{i}, column_name is #{head_array[i]}!"
							line.items << field
						end
					end

					i = i+1
				end # end of cell loop

				Rails.logger.info "end row : #{m}"
				result << line unless line.nil?
				m = m+1
			end # end of row loop

			#Rails.logger.info result
			return result
		end

		def get_cell_value(cell, head_column_name)
			cell_type = cell.getCellType()
			value = nil
			case
			when cell_type == cell.CELL_TYPE_BLANK
				#ignore blank type
			when cell_type == cell.CELL_TYPE_BOOLEAN
				value = cell.getBooleanCellValue()
			when cell_type == cell.CELL_TYPE_FORMULA
				value = cell.getCellFormula()
			when cell_type == cell.CELL_TYPE_NUMERIC
				is_date_col = head_column_name == "日期"
				if is_date_col
					if (@@date_util_class.isCellDateFormatted(cell) || @@date_util_class.isCellInternalDateFormatted(cell) || is_date_col)
						Rails.logger.info "--------------------date cell is  date !!"
						begin
							value = cell.getDateCellValue()
							value = parseDateValue(value)
						rescue Exception
							Rails.logger.info "Invalid date value : #{cell.toString()}"
							value=cell.getNumericCellValue()
						end 
					else
						Rails.logger.info "--------------------date cell is  not date !!"
						begin
							value = cell.getDateCellValue()
							value = parseDateValue(value)
						rescue Exception => e
							Rails.logger.info "Invalid date value : #{cell.toString()}"
							value = cell.getNumericCellValue()
						end
					end
				else
					value = @@double_class.new(cell.getNumericCellValue()).longValue()
				end
			when cell_type == cell.CELL_TYPE_STRING
				value = cell.getRichStringCellValue().getString()
			when cell_type == cell.CELL_TYPE_ERROR
				# ignore error column
			else
				raise :unknow_cell_content
			end
			# return the value
			return value
		end

		def init_merged_cells(sheet)
			merged_regions = []
			region_num = sheet.getNumMergedRegions()
			#puts " number of merged regions : #{region_num}"
			if  region_num > 0 
				for index in 0 ... region_num
					merged_regions << sheet.getMergedRegion(index)
				end
			end
			#puts "merged_regions size : #{merged_regions.length}"
			return merged_regions
		end
		def get_merged_cell(sheet, regions, row, col)
			#puts "looking for merged cell at row: #{row}, column : #{col}.."
			match_regions = regions.select do |r|
				r.isInRange(row, col)
			end
			#puts "finded #{match_regions.length} for merged cell at row: #{row}, column : #{col}.."
			unless match_regions.length == 0
				r = match_regions.first
				r_row = r.getFirstRow()
				r_col = r.getFirstColumn()
				sheet.getRow(r_row).getCell(r_col)
			end
		end

		def validate_text_header(row, headers)
			head = []
			Rails.logger.debug "Parsing header row of range [#{row.getFirstCellNum()}, #{row.getLastCellNum()})"

			# first column is the category name
			i = row.getFirstCellNum()
			cell = row.getCell(i)
			value = cell.getRichStringCellValue().getString()
			unless is_category_col( value )
				raise "第一列必须是类别!"
			end
			head << value
			i = i + 1

			# read other heads
			while i < row.getLastCellNum()
				cell = row.getCell(i)
				if cell.blank?
					i = i + 1
					next
				end
				cell_type = cell.getCellType()
				value = nil
				# validate type
				Rails.logger.info "reading header cell at index #{i}, cell type is #{cell_type}, cell value as #{cell.getStringCellValue()}"
				case
				when cell_type == cell.CELL_TYPE_STRING
					value = cell.getRichStringCellValue().getString()
				when cell_type == cell.CELL_TYPE_BLANK
					# ignore blank type
				else
					Rails.logger.info cell_type
					raise "列头行不符合格式，头行必须是文字类型，不应含有别的类型数据！"
				end

				head << value

				i = i+1
			end

			# validate expectation
			miss_head = []
			headers.each { |expected|
				miss_head << expected.column_name unless  head.include?(expected.column_name)
			}
			unless miss_head.blank?
				# raise "列头行不符合格式. 列 #{miss_head} 没在头行里!"
			end

			#Rails.logger.info head
			return head
		end

		def is_category_col(col_val)
			col_val == "分类"
		end

		def parseDateValue(date)
			unless date.nil?
				dateFormat = @@date_format_class.new('yyyy-MM-dd')
				dateFormat.format(date)
			else
				""
			end
		end
	end

	## represents a activity like news adding
	class UploadLine
		attr_accessor :entity, :items

		@entity
		@items = []
	end

	#helper methods
	def save_tmp_file(data)
		file_name = "" + Time.now.to_f.to_s + "-" + Random.new().rand().to_s
		full_name = File.join File.dirname(__FILE__),file_name
		Rails.logger.info "Save file with name #{file_name}"
		IO.binwrite(full_name, data)
		full_name
	end

	def remove_tmp_file(file_name)
		begin
			File.delete(file_name)
		rescue Exception
			Rails.logger.info 'delete temp file failed, ignore and return'
		end
	end

	## excel image handling
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
			puts "read images from sheet"
			picture_path = {}
			# first find all images; save them, and record the information
			pic_num = find_save_images(sheet, picture_path)
			puts "Total picture number : #{pic_num}"

			# construct image metadata
			image_metas = []
			url_col = head_array['文章链接'].to_i
			date_col = head_array['日期'].to_i
			Rails.logger.info "url_col : #{url_col}, date_col : #{date_col}"

			# a hash to do merge between images of same url & date in current file
			# url -> {date - > img_meta}
			image_meta_merged_hash = {}

			picture_path.each do |anchor, paths|

				row = sheet.getRow(anchor.getRow())
				if row.nil?
					raise "在 : #{anchor.getRow()}, col: #{anchor.getCol()} 找不到对应的行，请注意图片的位置必须被单元格完全包含！"
				end
				# url
				cell = row.getCell(url_col)
				url = validate_get_cell_string(cell, anchor.getRow(), url_col)
				## date
				date_cell = row.getCell(date_col)
				date = validate_get_cell_date(date_cell)

				# collect with merged
				date_hash = image_meta_merged_hash[url]
				if date_hash.nil?
					date_hash = {}
					image_meta_merged_hash[url] = date_hash
				end
				img_meta = date_hash[date]
				if img_meta.nil?
					img_meta = ImageMeta.new()
					img_meta.url = url
					img_meta.date = date
					img_meta.paths = []

					image_metas << img_meta
					date_hash[date] = img_meta
				end
				img_meta.paths.concat(paths)
			end
			Rails.logger.info "Loaed image meta of : #{image_metas.size}"
			image_metas
		end

		def validate_get_cell_date(date_cell)
			date = nil ## to be a time instance
			unless date_cell.blank?
				cell_type = date_cell.getCellType()
				case
				when cell_type == date_cell.CELL_TYPE_NUMERIC
					Rails.logger.info "-------------------- cell is numeric!!"
					if (@@date_util_class.isCellDateFormatted(date_cell) || @@date_util_class.isCellInternalDateFormatted(date_cell) )
						Rails.logger.info "--------------------date cell is  date !!"
						begin
							date = date_cell.getDateCellValue()
							dateFormat = @@date_format_class.new('yyyy-MM-dd')
							date = dateFormat.format(date)
						rescue Exception
							Rails.logger.info "Invalid date value : #{date_cell.toString()}"
							date = ''
						end
					else
						Rails.logger.info "--------------------date cell is  not date !!"
						begin
							date = date_cell.getDateCellValue()
							dateFormat = @@date_format_class.new('yyyy-MM-dd')
							date = dateFormat.format(date)
						rescue Exception => e
							Rails.logger.info "Invalid date value : #{date_cell.toString()}"
							date = ''
						end
					end
				else 
					Rails.logger.info "Invalid date value : cell type not numeric #{cell_type}"
				end
			end
			puts "----------------Image --- date --- :#{date}"
			return date
		end

		def find_save_images(sheet, picture_path)
			pic_num = 0
			it = sheet.getRelations().iterator()
			while it.hasNext()
				doc_part = it.next()
				if doc_part.getClass().equals(@@xssf_drawing_class)
					shape_it = doc_part.getShapes().iterator()
					while shape_it.hasNext()
						shape = shape_it.next()
						if shape.getClass().equals(@@xssf_picture_class)
							anchor = shape.getPreferredSize().getFrom()
							row = anchor.getRow()
							col = anchor.getCol()
							# detect the file extension
							if shape.getPictureData().suggestFileExtension.blank?
								ext = ".png"
							else 
								ext = ".#{shape.getPictureData().suggestFileExtension}"
							end
							paths = save_pic(shape.getPictureData().getData(), ext, pic_num)
							if not picture_path.has_key?(anchor)
								picture_path[anchor] = []
							end
							picture_path[anchor] << paths

							puts "Found picture at --->row:" + row.to_s + ", column:"  + col.to_s + ", paths: " + paths.to_s

							pic_num = pic_num + 1
						end
					end # end of shapes loop
				end
			end # end of relations loop
		end

		def validate_get_cell_string(cell, row, col)
			unless cell.blank?
				case
				when cell.getCellType() == cell.CELL_TYPE_STRING
					return cell.getRichStringCellValue().getString()
				else
					raise "Expected string for the cell! But got cell type as #{cell.getCellType()}, row: #{row}, col: #{col}"
				end
			end
		end

		def validate_image_header(header_row)
			head = {}
			expected_head = ['文章链接','日期', '贴图']
			i = 0
			# read heads
			while i < header_row.getLastCellNum()
				cell = header_row.getCell(i)
				if cell.nil?
					i = i + 1
					next
				end

				cell_type = cell.getCellType()
				case
				when cell_type == cell.CELL_TYPE_STRING
					value = cell.getRichStringCellValue().getString()
					head[value] = i
				when cell_type = cell.CELL_TYPE_BLANK
					;
				else
					raise "图片文件头格式错误。期望包含列：#{expected_head} !"
				end

				i = i + 1
			end
			# validation for head existence
			expected_head.each do |e|
				raise "图片文件头格式错误。期望包含列：#{expected_head} ! 列 #{e} 没在头行里!" unless head.has_key?(e)
			end
			return head
		end

		def save_pic(pic_data, ext, pic_num)
			# prefix supposed to be the $PJM_HOME
			prefix = File.join File.dirname(__FILE__), "../../"
			# relative path is the file path related to the $PJM_HOME
			relative_path = "/public/upload/#{@project.identifier}/"
			# check foler existence
			folder = File.join prefix, relative_path
			unless File.exists?(folder)
				Dir.mkdir(folder)
			end

			uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
			file_full_name = uuid + '--' + pic_num.to_s + ext
			# append the file name to the relative path
			relative_path = File.join relative_path,file_full_name
			full_name = File.join prefix, relative_path
			# write full
			IO.binwrite(full_name, pic_data)
			relative_path
		end

		def read_excel_image(data)
			puts "Read images from excel start...."
			byte_stream = @@byte_stream_class.new(data)
			wb = @@workbook_class.new(byte_stream)
			sheet = wb.getSheetAt(0)
			if sheet.nil?
				raise '没有Excel内容!'
			end
			headrow = sheet.getRow(sheet.getFirstRowNum())
			if headrow.nil?
				raise '没有列头行!'
			end
			# read header row
			head_array = validate_image_header(headrow)
			puts "Image header rows : #{head_array} !!!"

			# read/store images and return the image metadata
			result = read_images(wb, sheet, head_array)

			begin
				byte_stream.close()
			rescue 
				puts "ImageReader :: Close stream failed, ignore and return"
			end
			puts "Read images from excel end...."
			result
		end
	end # end of POIExcelImageReader

	class ImageMeta
		attr_accessor :url, :paths, :date
		# the url which the image screenshot matches
		@url
		# the image stored path
		@paths
		@date
	end

	class Anchor
		attr_accessor :row, :col
		@row
		@col
	end


	def save_images(uploadImages)
		uploadImages.each do |m|
			existed_image = Image.find(:first, :conditions=>{:url => m.url, :image_date => m.date})
			if existed_image.blank?
				# no duplication, update
				img = Image.new()
				img.url = m.url
				img.file_path = m.paths.join(';')
				img.image_date = m.date
				img.save!
			else
				Rails.logger.info "Find existing image with url : #{m.url}, image_date : #{m.date}, ignore this image."
				# ignore the one  with existing 
				# find a existing, just appending the path
				#existed_image.file_path = [ existed_image.file_path, m.paths.join(';')].join(';')
				#existed_image.save!
			end
		end
	end

	def _save_news_event(title, summary, description)
		begin
			ActiveRecord::Base.transaction do
		     		news = News.new(:project => @project, :author => User.current)
				news.summary=summary
				news.title=title
				news.description= description
				if news.save
			      		Rails.logger.info "save news success"
			      	else
			      		Rails.logger.info "save  news failed"
			      		Rails.logger.info(news.errors.inspect) 
			      	end
		      	end
    		rescue Exception => e
		      	puts e.message
    		end
	end

end
