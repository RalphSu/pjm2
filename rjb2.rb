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
	  @@workbook_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFWorkbook')
	  @@cell_style_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFCellStyle')
	  @@font_class = Rjb::import('org.apache.poi.hssf.usermodel.HSSFFont')
	  @@cell_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFCell')
          @@picture_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFPictureData')
	  @@date_util_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFDateUtil')
	  @@row_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFRow')
	  @@sheet_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFSheet')
	  @@string_stream_class=Rjb::import('java.io.StringBufferInputStream')
<<<<<<< HEAD
	  @@jString = Rjb::import('java.lang.String')
          @@arraylist_class=Rjb::import('java.util.ArrayList')
	  @@list_class=Rjb::import('java.util.List')
	def read_excel(data)
	          
		  in_stream = @@file_in_class.new(File.join File.dirname(__FILE__), '/my_spreadsheet.xls')
		  wb = @@workbook_class.new(in_stream)
	
		pictures = wb.getAllPictures()
                p pictures.java_methods
		pictures.each do |p|
	  		p "find a picture in the excel, now save it. index is #{p.getPictureIndex()}"
		  	#save 
		  	ext = pic.suggestFileExtension();
		  	bytes = p.getData(); 
			out = file_class.new(File.join File.dirname(__FILE__), '/extraced_from_excel.png')
		    	out.write(bytes);  
		    	out.close();  
		 end
	
=======
	  @@byte_stream_class=Rjb::import('java.io.ByteArrayInputStream')
	  @@hssf_picture_class=Rjb::import('org.apache.poi.hssf.usermodel.HSSFPicture')

	def read_excel(data)
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

		## images
		## p wb.java_methods
		read_pics(wb, sheet)

		## texts
		m = sheet.getFirstRowNum() + 1
		#while m < sheet.getLastRowNum()
			row = sheet.getRow(m)
		  	i = row.getFirstCellNum()
		  	# while i < row.getLastCellNum()
		  		cell = row.getCell(i)
		  		if (cell.nil?||cell.getRichStringCellValue().getString().nil?||cell.getRichStringCellValue().getString().length()==0)
		  			# ignore this cell
		  		end
		  		p cell.getRichStringCellValue().getString()
		  		i= i+1
		  	# end
		  	m = m+1
		#end
	end

	def read_pics(wb, sheet)
		pictures = wb.getAllPictures()
		# it = pictures.iterator()
		# while it.hasNext()
	 # 		p "find a picture in the excel, now save it."
		#   	#save 
		#   	p = it.next()
		#   	ext = p.suggestFileExtension();
		#   	bytes = p.getData(); 
		#   	# override
		# 	out = @@file_class.new(File.join File.dirname(__FILE__), '/extraced_from_excel.png')
		#     	out.write(bytes);  
		#     	out.close();  
	 # 	end

	  	patriarch = sheet.getDrawingPatriarch();
	  	if patriarch.nil?
	  		return
	  	end
>>>>>>> 94b9346ade948d288666815b03f2a50255778d12

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
end

pr = PoiExcelReader.new
file_name = File.join File.dirname(__FILE__), '/my_spreadsheet.xls'
#f = File.open(file_name)
data = IO.binread(file_name)
p data.size
pr.read_excel(data)
