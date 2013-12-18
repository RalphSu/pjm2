
require 'rjb'

# JVM loading
POI_LIB_HOME='/home/ralph/lib'
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
      @@file_class = Rjb::import('java.io.FileOutputStream')
      @@file_in_class = Rjb::import('java.io.FileInputStream')
      @@workbook_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFWorkbook')
      @@cell_style_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFCellStyle')
      @@font_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFFont')
      @@cell_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFCell')
      @@date_util_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFDateUtil')
      @@row_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFRow')
      @@sheet_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFSheet')
      @@string_stream_class=Rjb::import('java.io.StringBufferInputStream')

    def read_excel(data)
      in_stream = @@file_in_class.new('/home/ralph/dev/pjm2/my_spreadsheet.xls')
      wb = @@workbook_class.new(in_stream)
      sheet = wb.getSheetAt(0)
      headrow = sheet.getRow(sheet.getFirstRowNum())

      m = sheet.getFirstRowNum()
      while m < sheet.getLastRowNum()
      	sheet.getRow(m)

      	m++
      end

    end


  ## represents a activity like news adding
  class UploadLine
    attr_accessor :entity, :items

    @entity
    @items = []
  end


# Java classes import
file_class = Rjb::import('java.io.FileOutputStream')
workbook_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFWorkbook')
cell_style_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFCellStyle')
font_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFFont')

# Workbook, will contain worksheets
book = workbook_class.new

# First worksheet
sheet = book.createSheet('My worksheet')

# All columns will have the length of 20 characters
sheet.setDefaultColumnWidth(20)

# Default font style with Verdana
verdana_font = book.createFont
verdana_font.setFontName 'Verdana'

# Defaut style using Verdana
default_style = book.createCellStyle
default_style.setFont verdana_font

# Writing cells
row = sheet.createRow(0) # First line
cell = row.createCell(0) # First column
cell.setCellValue('Foo')
cell.setCellStyle(default_style) # Styles your cell

# Saves your file in the same directory
file_name = 'my_spreadsheet-new.xls'
out = file_class.new(File.join File.dirname(__FILE__), file_name)
book.write(out)
out.close
