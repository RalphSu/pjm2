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
				raise 'sheet is not found!'
			end
			headrow = sheet.getRow(sheet.getFirstRowNum())
			if headrow.nil?
				raise ' head row not found!'
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
				Rails.logger.info "	Row : #{m} has #{i} to #{sheet.getLastRowNum()} cells."
				while i < row.getLastCellNum()
					if i >= head_array.length
						# ingore mismatch with head
						break
					end

					# read columns, validation on type
					cell = row.getCell(i)
					if cell.nil?
						i = i + 1
						next
					end

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
						is_date_col = head_array[i] == "日期"
						if (@@date_util_class.isCellDateFormatted(cell) || @@date_util_class.isCellInternalDateFormatted(cell) || is_date_col)
							begin
								value = cell.getDateCellValue()
								value = parseDateValue(value)
							rescue Exception
								Rails.logger.info "Invalid date value : #{cell.toString()}"
								value=cell.getNumericCellValue()
							end
						else 
							value = cell.getNumericCellValue()
						end
					when cell_type == cell.CELL_TYPE_STRING
						value = cell.getRichStringCellValue().getString()
					when cell_type == cell.CELL_TYPE_ERROR
						# ignore error column
					else
						raise :unknow_cell_content
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

		def validate_text_header(row, headers)
			head = []
			Rails.logger.debug "Parsing header row of range [#{row.getFirstCellNum()}, #{row.getLastCellNum()})"

			# first column is the category name
			i = row.getFirstCellNum()
			cell = row.getCell(i)
			value = cell.getRichStringCellValue().getString()
			unless is_category_col( value )
				raise "First column must be the category!"
			end
			head << value
			i = i + 1

			# read other heads
			while i < row.getLastCellNum()
				cell = row.getCell(i)
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
					raise "File head is invalid. header row must be string!"
				end

				head << value

				i = i+1
			end

			# validate expectation
			headers.each { |expected|
				raise "File head is invalid. header #{expected.column_name} not presented!" unless head.include?(expected.column_name)
			}

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
			it = sheet.getRelations().iterator()
			picture_path = {}
			pic_num = 0
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
								ext = ".#{pic_data.suggestFileExtension}"
							end
							paths = save_pic(shape.getPictureData().getData(), ext)
							picture_path[anchor] = paths

							puts "Found picture at --->row:" + row.to_s + ", column:"  + col.to_s + ", paths: " + paths.to_s

							pic_num = pic_num + 1
						end
					end # end of shapes loop
				end
			end # end of relations loop
			puts "Total picture number : #{pic_num}"

			# construct image metadata
			image_metas = []
			picture_path.each do |anchor, paths|

				row = sheet.getRow(anchor.getRow())
				if row.nil?
					raise "Row not found for image at position row: #{anchor.getRow()}, col: #{anchor.getCol()}"
				end
				# FIXME :: why enforce title column just one column before the image??
				## title
				title_col = anchor.getCol() - 2
				if title_col < row.getFirstCellNum()
					title_col = row.getFirstCellNum()
				end
				cell = row.getCell(title_col)
				url = validate_get_cell_string(cell)

				## date
				date_col = anchor.getCol() - 1
				if date_col < row.getFirstCellNum()
					date_col = row.getFirstCellNum()
				end
				date_cell = row.getCell(date_col)
				date = nil ## to be a time instance
				unless date_cell.blank?
					cell_type = date_cell.getCellType()
					case
					when cell_type == cell.CELL_TYPE_NUMERIC
						Rails.logger.info "--------------------date cell is numeric!!"
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
						end
					else 
						Rails.logger.info "Invalid date value : cell type not numeric #{cell_type}"
					end
				end
				Rails.logger.info "----------------Image --- date --- :#{date}"

				img_meta = ImageMeta.new()
				img_meta.url = url
				img_meta.paths = paths
				img_meta.date = date
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
			expected_head = ['文章链接','日期', '贴图']
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
				raise "Image file head is invalid. Expected : #{expected_head} !" unless head.include?(e)
			end
			return head
		end

		def save_pic(pic_data, ext)
			folder = File.join File.dirname(__FILE__), "../../upload/#{@project.identifier}/"
			unless File.exists?(folder)
				Dir.mkdir(folder)
			end

			uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
			file_full_name = uuid + ext
			full_name = File.join folder,file_full_name
			# write full
			IO.binwrite(full_name, pic_data)
			full_name
		end

		def read_excel_image(data)
			puts "Read images from excel start...."
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

	def save_images(uploadImages)
		uploadImages.each do |m|
			img = Image.new()
			img.url = m.url
			img.file_path = m.paths
			img.image_date = m.date
			img.save
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
