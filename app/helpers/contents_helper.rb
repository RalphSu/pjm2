#-- encoding: UTF-8
require 'rjb'

module ContentsHelper

  def project_content_tabs
    tabs = [
            {:name => 'news', :controller=> 'news_release', :action => 'index', :partial => 'contents/news', :label => :label_news},    
            #{:name => 'weibo',  :controller=> 'weibo', :action => 'index', :partial => 'contents/weibo', :label => :label_weibo},
            #{:name => 'press', :action => press, :partial => 'contents/press', :label => :label_press},
            #{:name => 'blog', :action => :blog, :partial => 'contents/blog', :label => :label_blog},
            #{:name => 'micro_talk', :action => :micro_talk, :partial => 'contents/micro_talk', :label => :label_micro_talk},
            #{:name => 'micro_topic', :action => :micro_topic, :partial => 'contents/micro_topic', :label => :label_micro_topic},
            #{:name => 'forum', :action => :forum, :partial => 'contents/forum', :label => :label_forum},
            ]
    tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
    tabs
  end

  def get_project_name(id)
  	return id
  end 

  class PoiExcelReader
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

    def initialize(project)
      @project = project
    end

    def read_excel_text(data, headers)
      byte_stream = @@byte_stream_class.new(data)
      wb = @@workbook_class.new(byte_stream)
      sheet = wb.getSheetAt(0)
      if sheet.nil?
        raise ''
      end
      headrow = sheet.getRow(sheet.getFirstRowNum())
      if headrow.nil?
        raise ''
      end
      # read header row
      head_array = validate_header(headrow, headers)

      ## texts
      read_texts(sheet, head_array)
    end

    def read_texts(sheet, head_array)
      result = []

      #Rails.logger.info "sheet has : #{sheet.getFirstRowNum()} to #{sheet.getLastRowNum()} row."
      m = sheet.getFirstRowNum() + 1
      while m < sheet.getLastRowNum()
        #Rails.logger.info "starting row : #{m}"
        row = sheet.getRow(m)
        
        line = nil

        i = row.getFirstCellNum()
        while i < row.getLastCellNum()
          cell = row.getCell(i)
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
            if @@date_util_class.isCellDateFormatted(cell)
              value = cell.getDateCellValue()
              value = parseDateValue(value)
            else 
              value = cell.getNumericCellValue()
            end
          when cell_type == cell.CELL_TYPE_STRING
            value = cell.getRichStringCellValue().getString()
          when cell_type == cell.CELL_TYPE_ERROR
            # ignore error column
          else
            raise l(:unknow_cell_content)
          end

          # convert to string value
          unless value.nil?
            if line.nil?
              line = UploadLine.new()
              line.entity = NewsRelease.new()
              line.items = []
            end
            value = value.to_s
            field = NewsReleaseField.new()
            field.body = value
            field.news_classified = head_array[i]
            line.items << field
          end

          i = i+1
        end

        #Rails.logger.info "end row : #{m}"
        result << line unless line.nil?
        m = m+1
      end

      #Rails.logger.info result
      return result
    end

    def validate_header(row, headers)
      head = []
      head_hash = {}
      # build column_name to classifield hash
      headers.each do |h|
        head_hash[h.template.column_name] = h
      end

      #Rails.logger.debug head_hash
      #Rails.logger.debug "Parsing header row of range [#{row.getFirstCellNum()}, #{row.getLastCellNum()})"

      i = 0
      # read heads
      while i < row.getLastCellNum()
        cell = row.getCell(i)
        cell_type = cell.getCellType()
        value = nil

        #Rails.logger.info "reading header cell at index #{i}, cell type is #{cell_type}, cell value as #{cell.getStringCellValue()}"
        case
        when cell_type == cell.CELL_TYPE_STRING
          value = cell.getRichStringCellValue().getString()
        when cell_type == cell.CELL_TYPE_BLANK
          # ignore blank type
        else
          Rails.logger.info cell_type
          raise "File head is invalid. header row must be string!"
        end

        unless value.blank?
          #raise "File has empty column header!"
          if head_hash.has_key?(value)
            head << head_hash[value]
          else 
            raise "unexpected header column #{value}!"
          end
        end

        i= i+1
      end

      # validation
      headers.each { |expected|
        raise "File head is invalid. header #{expected} not presented!" unless head.include?(expected)
      }

      #Rails.logger.info head

      return head
    end

    def parseDateValue(date)
      unless date.nil?
        dateFormat = @@date_format_class.new('yyyy-MM-dd')
        dateFormat.format(date)
      else
        ""
      end
    end

    def read_images(wb, sheet)
      pictures = wb.getAllPictures()
      patriarch = sheet.getDrawingPatriarch();
      if patriarch.nil?
        return
      end

      # get and write pictures
      pic_num = 0
      it = patriarch.getChildren().iterator()
      # anchor => path hash
      picture_path = {}
      while it.hasNext()
        shape = it.next()
        anchor =  shape.getAnchor()
        if (shape .getClass().equals(@@hssf_picture_class)) 
          row = anchor.getRow1()
          col = anchor.getCol1()
          Rails.logger.info "Found picture at --->row:" + row.to_s + ", column:"  + col.to_s
          pic_index = shape.getPictureIndex() - 1
          pic_data = pictures.get(pic_index)
          paths = save_pic(row, col, pic_data)

          picture_path[anchor] = paths

          pic_num = pic_num + 1
        end  
      end
      Rails.logger.info "Total picture number : #{pic_num}"

      # construct image metadata
      image_metas = []
      picture_path.each do |anchor, paths|
        row = sheet.getRow(anchor.getRow1())
        if row.nil?
          raise "Row not found for image at position row: #{anchor.getRow1()}, col: #{anchor.getCol1()}"
        end

        title_col = anchor.getCol1() - 1
        if title_col >= row.getFirstCellNum()
          cell = row.getCell(title_col)
          url = validate_get_cell_string(cell)

          img_meta = ImageMeta.new()
          img_meta.url = url
          img_meta.paths = paths
          image_metas << img_meta
        else
          raise "Image at : #{anchor.getRow1()}, col: #{anchor.getCol1()}, doesn't have title link prefix!"
        end
      end

      Rails.logger.info image_metas
      image_metas
    end

    def validate_get_cell_string(cell)
      case
      when cell_type == cell.CELL_TYPE_STRING
        return cell.getRichStringCellValue().getString()
      else
        raise "Expected string for the cell!"
      end
    end

    # TODO: allow whole blank column
    def validate_image_header(header_row)
      head = []
      expected_head = ['文章链接','贴图']
      i = 0
      # read heads
      while i < row.getLastCellNum()
        cell = header_row.getCell(i)
        case
        when cell_type == cell.CELL_TYPE_STRING
          head << value = cell.getRichStringCellValue().getString()
        else
          raise "Image file head is invalid. Expected : 文章链接,贴图 !"
        end
      end
      # validation for head existence
      expected_head.each do |e|
        raise "Image file head is invalid. Expected : 文章链接,贴图 !" unless head.include?(e)
      end
      return head
    end

    def save_pic(row, col, pic_data)
      folder = File.join File.dirname(__FILE__), "../../upload/#{@project.identifier}/"
      unless File.exists?(folder)
         Dir.mkdir(folder) 
      end
      if pic_data.suggestFileExtension.blank?
        ext1 = '.full.png';
        ext2 = '.small.png';
      else 
        ext1 = ".full.#{pic_data.suggestFileExtension}";
        ext2 = ".small.#{pic_data.suggestFileExtension}";
      end

      uuid = UUIDTools::UUID.timestamp_create.to_s.gsub('-','')
      file_full_name = uuid + ext1
      file_small_name = uuid + ext2
      full_name = File.join folder file_full_name
      small_name = File.join folder file_small_name
      # write full
      IO.binwrite(full_name, pic_data.getData())
      # TODO write small
      IO.binwrite(small_name, pic_data.getData())
      
      [full_name, small_name]
    end

    def read_excel_image(date)
      byte_stream = @@byte_stream_class.new(data)
      wb = @@workbook_class.new(byte_stream)
      sheet = wb.getSheetAt(0)
      if sheet.nil?
        raise ''
      end
      headrow = sheet.getRow(sheet.getFirstRowNum())
      if headrow.nil?
        raise ''
      end
      # read header row
      head_array = validate_image_header(headrow, headers)

      read_images(wb, sheet, head_array)
    end

  end

  ## represents a activity like news adding
  class UploadLine
    attr_accessor :entity, :items

    @entity
    @items = []
  end

  class ImageMeta
    attr_accessor :url, :paths
    @url
    @paths
  end

end
