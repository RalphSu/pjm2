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
		  in_stream = @@file_in_class.new(File.join File.dirname(__FILE__), '/my_spreadsheet.xls')
		  wb = @@workbook_class.new(in_stream)
		  sheet = wb.getSheetAt(0)
		  headrow = sheet.getRow(sheet.getFirstRowNum())

		  m = sheet.getFirstRowNum() + 1
		  #while m < sheet.getLastRowNum()
		  	row = sheet.getRow(m)
		  	i = row.getFirstCellNum()
		  	#while i < row.getLastCellNum()
		  		cell = row.getCell(i)
		  		if (cell.nil?||cell.getRichStringCellValue().getString().nil?||cell.getRichStringCellValue().getString().length()==0)
		  			# ignore this cell
		  		end
		  		p cell.getRichStringCellValue().getString()
		  		i++
		  	#end
		  	m++
		  #end

		##img
		pictures = wb.getAllPictures()
		pictures.each do |p|
	  		p "find a picture in the excel, now save it. index is #{p.getPictureIndex()}"
		  	#save 
		  	ext = pic.suggestFileExtension();
		  	bytes = p.getData(); 
			out = file_class.new(File.join File.dirname(__FILE__), '/extraced_from_excel.png')
		    	out.write(bytes);  
		    	out.close();  
	  	end

	end
end

pr = PoiExcelReader.new
pr.read_excel('abc')
