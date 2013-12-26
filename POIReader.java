
import java.io.FileInputStream;  
import java.io.FileNotFoundException;  
import java.io.FileOutputStream;  
import java.io.IOException;  
import java.io.OutputStream;  
  
import org.apache.poi.hssf.usermodel.HSSFWorkbook;  
import org.apache.poi.ss.usermodel.Row;  
import org.apache.poi.ss.usermodel.Sheet;  
import org.apache.poi.ss.usermodel.Workbook;  
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class POIReader {  
	  public static void main(String[] args) {  
	        String execelFile = "./keyi_sample.xlsx" ;  
	        new POIReader().impExcel(execelFile) ;  
	        // String expFilePath = "C:/testBook.xls" ;  
	        // new OperationExcelForPOI().expExcel(expFilePath);
	}

	public void impExcel(String execelFile){  
	        try {
	        	XSSFWorkbook book = null;
			book = new XSSFWorkbook(new FileInputStream(execelFile));
			Sheet sheet = book.getSheetAt(0);
			System.out.println("Sheet 0 has " +  sheet.getFirstRowNum() + "-" + sheet.getLastRowNum() + " rows");
	        } catch (Exception e) {
			e.printStackTrace();
		}
	}

}