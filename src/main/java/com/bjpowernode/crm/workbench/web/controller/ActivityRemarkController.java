package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.ActivitiesRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Autowired

    ActivityRemarkService remarkService;

    @ResponseBody
    @RequestMapping("/workbench/activity/saveActivityRemark.do")

    public Object saveActivityRemark(String noteContent, String activityId, HttpSession session) {
        ActivitiesRemark activitiesRemark = new ActivitiesRemark();

        User attribute = (User) session.getAttribute(Contans.SESSION_USER);

        activitiesRemark.setCreateBy(attribute.getId());
        activitiesRemark.setActivityId(activityId);
//        System.out.println(attribute);
        activitiesRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        activitiesRemark.setEditFlag(Contans.REMAIN_REMARK_FLAG);
        String id=UUIDUtils.getUUID();
        activitiesRemark.setId(id);

        activitiesRemark.setNoteContent(noteContent);
        ReturnObject returnObject=new ReturnObject();
        returnObject.setRetData(activitiesRemark);
        try {

            int i = remarkService.saveActivityRemark(activitiesRemark);
            if (i>0){
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);

            }
            else {
                returnObject.setMessage("服务器繁忙,稍后再试....");
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    public Object deleteActivityRemarkById(String id){
        System.out.println(id+"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        ReturnObject returnObject=new ReturnObject();
        try {
            int i = remarkService.deleteActivityRemarkById(id);
            if (i>0){
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);

            }
            else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,稍后再试....");
            }
        } catch (Exception e) {
            e.printStackTrace(); returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,稍后再试....");
        }
        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/workbench/activity/savaActivityRemark.do")
    public Object savaActivityRemark(String id,String noteContent,HttpSession session){

        ReturnObject returnObject=new ReturnObject();

        ActivitiesRemark remark=new ActivitiesRemark();
        remark.setNoteContent(noteContent);
        remark.setId(id);
        User attribute = (User) session.getAttribute(Contans.SESSION_USER);
        remark.setEditBy(attribute.getId());
        remark.setEditFlag(Contans.REMAIN_REMARK_SUCCESS);
        remark.setEditTime(DateUtils.formateDateTime(new Date()));
        try {
            int i = remarkService.saveEditActivityRemark(remark);

            if (i>0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);

            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试.....");

        }

        return returnObject;
    }
}
