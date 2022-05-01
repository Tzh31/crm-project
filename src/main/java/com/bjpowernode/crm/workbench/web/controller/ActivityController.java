package com.bjpowernode.crm.workbench.web.controller;
//import com.github.pagehelper.PageInfo;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.HSSFUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.ActivitiesRemark;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
//import java.net.http.HttpResponse;
import java.util.*;

import static com.bjpowernode.crm.commons.contans.Contans.RETURN_OBJECT_CODE_FAIL;
import static com.bjpowernode.crm.commons.contans.Contans.RETURN_OBJECT_CODE_SUCCESS;

@Controller
public class ActivityController {

    @Autowired
    UserService userService;

    @Autowired
    ActivityService activityService;
@Autowired
    ActivityRemarkService activityRemarkService;
    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request) {

        List<User> users = userService.selectAllUsers();

        request.setAttribute("userList", users);
        return "workbench/activity/index";
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/saveCreatActivity.do")
    public Object saveCreatActivity(Activity activity, HttpSession session) {
        User attribute = (User) session.getAttribute(Contans.SESSION_USER);
        System.out.println(attribute);
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        //这个地方的话，因为表的外键设置，id是不会变得，这是最好的标志
        activity.setCreateBy(attribute.getId());
//    activity.setOwner(attribute.getId());
        activity.setId(UUIDUtils.getUUID());
//activityService.insertActivity
        ReturnObject returnObject = new ReturnObject();
        int i = 0;
        try {
            i = activityService.saveActivity(activity);
            if (i == 1) {
                returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);

            } else {
                returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("当前系统繁忙，请稍后.....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("当前系统繁忙，请稍后.....");
        }


        return returnObject;

    }

    @ResponseBody
    @RequestMapping("/workbench/activity/querryActivityByConditionForPage.do")
    public Object querryActivityByConditionForPage(String name, String owner,
                                                   String startDate, String endDate, Integer pageSize, Integer pageNo) {

        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);

        map.put("pageSize", pageSize);
        int beginNo = (pageNo - 1) * pageSize;
        System.out.println(beginNo + "开始页数" + name);
        map.put("beginNo", beginNo);
//        System.out.println(name+owner+startDate+endDate+pageSize+pageNo+"hhhhhhhhhhhhhhhhhhhh");
        List<Activity> activities = activityService.selectActivityByConditionForPage(map);
        int i = activityService.selectCountOfActivityByCondition(map);
//        System.out.println(activities.get(0).getId()+"哈啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊");
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activities);
        retMap.put("totalRows", i);
        System.out.println(activities);
        return retMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id) {
        ReturnObject returnObject = new ReturnObject();
        System.out.println(id);
        int i = 0;
        try {

            i = activityService.deleteActivityByIds(id);
            if (i > 0) {
                returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);

            } else {
                returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,稍后再试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,稍后再试...。");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String ids) {
//        System.out.println(ids + "hhhhhhhhhhhhhhhhhhhhhhh");
        Activity activity = activityService.selectActivityById(ids);

        return activity;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/updateByPrimaryKey.do")
    public Object updateByPrimaryKey(Activity activity, HttpSession session) {
        User attribute = (User) session.getAttribute(Contans.SESSION_USER);
        System.out.println(attribute);
        activity.setEditTime(DateUtils.formateDateTime(new Date()));
        //这个地方的话，因为表的外键设置，id是不会变得，这是最好的标志
//        activity.setCreateBy(attribute.getId());
//    activity.setOwner(attribute.getId());
        activity.setEditBy(attribute.getId());
        ReturnObject returnObject = new ReturnObject();
        System.out.println(activity + "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        int i = 0;
        try {
//            activityService.
            i = activityService.updateByPrimaryKey(activity);
//            System.out.println(i+"ddddddddddddddddddddddddddddddd");
            if (i == 1) {
                returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);

            } else {
                returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("当前系统繁忙，请稍后.....");
            }
        } catch (Exception e) {
            e.printStackTrace();
//            System.out.println(i+"ddddddddddddddddddddddddddddddd");
            returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("当前系统繁忙，请稍后.....");
        }


        return returnObject;

    }

    @RequestMapping("/workbench/activity/fileDownLoad.do")
    public void fileDownLoad(HttpServletResponse response) throws IOException {
        response.setContentType("application/octet-stream;charset=UTF-8");
        ServletOutputStream outputStream = response.getOutputStream();

        FileInputStream fileInputStream = new FileInputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下\\studentList.xls");
        response.addHeader("Content-Disposition", "attachment;filename=myDtudentList.xls");
        byte[] b = new byte[255];
        int length = -1;
        while ((length = fileInputStream.read(b)) > -1) {
            outputStream.write(b, 0, length);
        }
        fileInputStream.close();
        outputStream.flush();
    }

    @RequestMapping("/workbench/activity/downLoad.do")
    public void dowLoad(HttpServletResponse response) throws IOException {

        List<Activity> activities = activityService.queryAllActivities();
        HSSFWorkbook sheets = new HSSFWorkbook();
        //新的表
        HSSFSheet sheet = sheets.createSheet("市场活动信息");
        //创建第一行
        HSSFRow row = sheet.createRow(0);
        //第一列
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");

        cell = row.createCell(1);
        cell.setCellValue("所有者");

        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建日期");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");
        System.out.println(activities);
//    FileInputStream fileInputStream = new FileInputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下");
        if (activities != null && activities.size() > 0) {
            for (int i = 0; i < activities.size(); i++) {
                HSSFRow row1 = sheet.createRow(i + 1);

                HSSFCell cell1 = row1.createCell(0);
                cell1.setCellValue(activities.get(i).getId());
                cell1 = row1.createCell(1);
                cell1.setCellValue(activities.get(i).getOwner());
                cell1 = row1.createCell(2);
                cell1.setCellValue(activities.get(i).getName());
                cell1 = row1.createCell(3);
                cell1.setCellValue(activities.get(i).getStartDate());
                cell1 = row1.createCell(4);
                cell1.setCellValue(activities.get(i).getEndDate());
                cell1 = row1.createCell(5);
                cell1.setCellValue(activities.get(i).getCost());
                cell1 = row1.createCell(6);
                cell1.setCellValue(activities.get(i).getDescription());
                cell1 = row1.createCell(7);
                cell1.setCellValue(activities.get(i).getCreateTime());
                cell1 = row1.createCell(8);
                cell1.setCellValue(activities.get(i).getCreateBy());
                cell1 = row1.createCell(9);
                cell1.setCellValue(activities.get(i).getEditTime());
                cell1 = row1.createCell(10);
                cell1.setCellValue(activities.get(i).getEditBy());
            }
            FileOutputStream fileOutputStream = null;
//    try {
////        fileOutputStream = new FileOutputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下\\市场活动.xls");
////        sheets.write(fileOutputStream);
//        fileOutputStream.close();
//        sheets.close();
//    } catch (FileNotFoundException e) {
//        e.printStackTrace();
//    } catch (IOException e) {
//        e.printStackTrace();
//    }
//            response.addHeader("Content-Disposition", "attachment;filename=市场活动.xls");
            response.addHeader("Content-Disposition", "attachment;filename=activity.xls");

            response.setContentType("application/octet-stream;charset=UTF-8");
            ServletOutputStream outputStream = response.getOutputStream();

//    FileInputStream fileInputStream = new FileInputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下\\市场活动.xls");

//    byte[] b = new byte[255];
//    int length=-1;
//    while ( (length=fileInputStream.read(b))>-1){
//        outputStream.write(b,0,length);
//    }
//    fileInputStream.close();
            sheets.write(outputStream);
            sheets.close();
            outputStream.flush();


        }

    }

    @RequestMapping("/workbench/activity/selectdownLoad.do")
    public void selectdownLoad(String[] id, HttpServletResponse response) throws IOException {
        List<Activity> activities = activityService.querySelectActivities(id);
        HSSFWorkbook sheets = new HSSFWorkbook();
        //新的表
        HSSFSheet sheet = sheets.createSheet("市场活动信息");
        //创建第一行
        HSSFRow row = sheet.createRow(0);
        //第一列
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");

        cell = row.createCell(1);
        cell.setCellValue("所有者");

        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建日期");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");
        System.out.println(activities);
//    FileInputStream fileInputStream = new FileInputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下");
        if (activities != null && activities.size() > 0) {
            for (int i = 0; i < activities.size(); i++) {
                HSSFRow row1 = sheet.createRow(i + 1);

                HSSFCell cell1 = row1.createCell(0);
                cell1.setCellValue(activities.get(i).getId());
                cell1 = row1.createCell(1);
                cell1.setCellValue(activities.get(i).getOwner());
                cell1 = row1.createCell(2);
                cell1.setCellValue(activities.get(i).getName());
                cell1 = row1.createCell(3);
                cell1.setCellValue(activities.get(i).getStartDate());
                cell1 = row1.createCell(4);
                cell1.setCellValue(activities.get(i).getEndDate());
                cell1 = row1.createCell(5);
                cell1.setCellValue(activities.get(i).getCost());
                cell1 = row1.createCell(6);
                cell1.setCellValue(activities.get(i).getDescription());
                cell1 = row1.createCell(7);
                cell1.setCellValue(activities.get(i).getCreateTime());
                cell1 = row1.createCell(8);
                cell1.setCellValue(activities.get(i).getCreateBy());
                cell1 = row1.createCell(9);
                cell1.setCellValue(activities.get(i).getEditTime());
                cell1 = row1.createCell(10);
                cell1.setCellValue(activities.get(i).getEditBy());
            }
            FileOutputStream fileOutputStream = null;
//    try {
////        fileOutputStream = new FileOutputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下\\市场活动.xls");
////        sheets.write(fileOutputStream);
//        fileOutputStream.close();
//        sheets.close();
//    } catch (FileNotFoundException e) {
//        e.printStackTrace();
//    } catch (IOException e) {
//        e.printStackTrace();
//    }
            response.addHeader("Content-Disposition", "attachment;filename=activity.xls");
            response.setContentType("application/octet-stream;charset=UTF-8");
            ServletOutputStream outputStream = response.getOutputStream();

//    FileInputStream fileInputStream = new FileInputStream("C:\\Users\\86189\\Desktop\\资料夹\\大三下\\市场活动.xls");

//    byte[] b = new byte[255];
//    int length=-1;
//    while ( (length=fileInputStream.read(b))>-1){
//        outputStream.write(b,0,length);
//    }
//    fileInputStream.close();
            sheets.write(outputStream);
            sheets.close();
            outputStream.flush();

        }
    }

    @RequestMapping("/workbench/activity/fileUpLoad.do")
    public @ResponseBody
    Object fileUpLoad(MultipartFile myfile) throws Exception {
        String originalFilename = myfile.getOriginalFilename();
        //要上传到的路径地址
        File file = new File("C:\\Users\\86189\\Desktop", originalFilename);
        myfile.transferTo(file);
        ReturnObject returnObject = new ReturnObject();
        returnObject.setMessage("上传成功");
        returnObject.setCode("1");
        return returnObject;

    }

    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile myfile, HttpSession session) {
        ReturnObject returnObject = new ReturnObject();

        try {
            //通过myfile来拿到用户要上传的文件,需要先保存到本地，然后再通过解析拿到里面的数据，来进行保存到数据库
            //拿到用户文件的名字
            String originalFilename = myfile.getOriginalFilename();
//            System.out.println(originalFilename + "hhhhhhhhhhhhhhhhhhhhhhhhh");
            //要上传到的路径地址
//            File file = new File("C:\\Users\\86189\\Desktop\\", originalFilename);
//            myfile.transferTo(file);
//            FileInputStream fileInputStream = new FileInputStream("C:\\Users\\86189\\Desktop\\" + originalFilename);
           InputStream InputStream=myfile.getInputStream();
            HSSFWorkbook sheets = new HSSFWorkbook(InputStream);
            //拿到第一个表
            HSSFSheet sheetAt = sheets.getSheetAt(0);
            HSSFRow row = null;
            HSSFCell cell = null;
            String CellValue = null;
            List<Activity> activities = new ArrayList<>();
            Activity activity ;
            User attribute = (User) session.getAttribute(Contans.SESSION_USER);


            for (int i = 1; i <= sheetAt.getLastRowNum(); i++) {
                activity=new Activity();
                activity.setOwner(attribute.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                activity.setId(UUIDUtils.getUUID());
                activity.setCreateBy(attribute.getId());
                System.out.println(activity.getId());
                //拿到第二行
                row = sheetAt.getRow(i);
                System.out.println(row.getLastCellNum());
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    cell = row.getCell(j);
                    CellValue = HSSFUtils.getCellValueForStr(cell);
                    System.out.print(CellValue+" ");
                    if (j == 0) {
                        activity.setName(CellValue);
                    } else if (j == 1) {
                        activity.setStartDate(CellValue);
                    } else if (j == 2) {
                        activity.setEndDate(CellValue);
                    } else if (j == 3) {
                        activity.setCost(CellValue);
                    } else if (j == 4) {
                        activity.setDescription(CellValue);
                    }
                }
                System.out.println();
                activities.add(activity);

            }
            int i = activityService.saveCreatActivityByList(activities);
            returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(i);

        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
        }

        return returnObject;
    }
    @RequestMapping("/workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request)
    {
        Activity activities = activityService.queryActivityForDetail(id);
        List<ActivitiesRemark> activitiesRemarks = activityRemarkService.selectActivityRemarkForDetailByActivityId(id);
        request.setAttribute("activity",activities);
        System.out.println(activities+"黑河或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或或");
        request.setAttribute("activitiesRemarks",activitiesRemarks);
        System.out.println(activitiesRemarks);
        return "workbench/activity/detail";
    }
}
