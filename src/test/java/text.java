import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.bjpowernode.crm.commons.utils.HSSFUtils.getCellValueForStr;
//@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = {"classpath:applicationContext_dao.xml","classpath:applicationContext_service.xml"})
//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

public class text {
//    @Autowired
//    ProductInfoMapper productInfoMapper;
    @Test
    public void text1(){
        HSSFWorkbook sheets = new HSSFWorkbook();
        HSSFSheet sheet = sheets.createSheet("学生列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("学号");
        cell= row.createCell(1);
        cell.setCellValue("姓名");
        cell= row.createCell(2);
        cell.setCellValue("年龄");
        HSSFCellStyle cellStyle = sheets.createCellStyle();
        cellStyle.setAlignment(HorizontalAlignment.CENTER);

//        cellStyle.setFont("微软雅黑");
        for (int i=0;i<=10;i++)
        {
            row = sheet.createRow(i);
            cell=row.createCell(0);
            cell.setCellValue(i+100);
            cell=row.createCell(1);
            cell.setCellValue("嘿嘿"+i);
            cell.setCellStyle(cellStyle);
            cell=row.createCell(2);
cell.setCellValue(20+i);


        }
        try {
            FileOutputStream fileOutputStream = new FileOutputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下\\studentList.xls");
            sheets.write(fileOutputStream);
            fileOutputStream.close();
            sheets.close();
            System.out.println("嘿嘿嘿额Hi好IEhi诶嘿IEhi诶嘿IEhi诶诶hi诶嘿IEhi诶嘿IEhi诶嘿IEhi哈尔了副经理束带结发");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
@Test
    public void upLoadTest() throws IOException {
    FileInputStream fileInputStream=new FileInputStream("C:\\Users\\86189\\Downloads\\activity.xls");
    HSSFWorkbook sheets = new HSSFWorkbook(fileInputStream);
    HSSFSheet sheetAt = sheets.getSheetAt(0);
    for (int i=0;i<=sheetAt.getLastRowNum();i++){
        HSSFRow row = sheetAt.getRow(i);
        for (int d=0;d<row.getLastCellNum();d++)
        {
            System.out.print(getCellValueForStr(row.getCell(d)));
        }
        System.out.println();
    }

}
    @Test
    public void ha() throws IOException {
//        Activity activity=new Activity();
//List<Activity>list=new ArrayList<>();
//for (int i=0;i<10;i++)
//{
//    activity.setId("123"+i);
////    activity.setId("456");
//    list.add(activity);
//    System.out.println(activity.getId());
//}
//
//        System.out.print(list);
        String d="b";
        List list=new ArrayList();
list.add(d);
d="bb";
        System.out.println(list);
    }
    @Test
    public void text2(){
        String zz = MD5Util.getMD5("zz");
        System.out.println(zz);
    }
}
