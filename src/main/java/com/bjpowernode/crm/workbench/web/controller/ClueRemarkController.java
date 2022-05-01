package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {
    @Autowired
    ClueRemarkService clueRemarkService;


    @ResponseBody
    @RequestMapping("/workbench/clue/editClueRemark.do")
    public Object editClueRemark(String id, String noteContent, HttpSession session) {
        User attribute = (User) session.getAttribute(Contans.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(id);

        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditBy(attribute.getId());
        clueRemark.setEditFlag(Contans.REMAIN_REMARK_SUCCESS);
        clueRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        try {
            int i = clueRemarkService.editClueRemark(clueRemark);
            if (i > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
returnObject.setRetData(clueRemark);
            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,请稍后再试....");
            }
        } catch (Exception e) {
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");
            e.printStackTrace();
        }
        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/workbench/clue/saveClueRemark.do")
    public Object saveClueRemark(String noteContent,String clueId,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contans.SESSION_USER);
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setClueId(clueId);
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        clueRemark.setNoteContent(noteContent);
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setEditFlag(Contans.REMAIN_REMARK_FLAG);
        try {
            int i = clueRemarkService.saveClueRemark(clueRemark);
            if (i > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,请稍后再试....");
            }
        } catch (Exception e) {
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");
            e.printStackTrace();
        }

        return returnObject;
    }
    @ResponseBody
    @RequestMapping("/workbench/clue/deleteClueRemarkByRemarkId.do")
    public Object saveClueRemark(String clueRemarkId){
        ReturnObject returnObject = new ReturnObject();

        try {
            int i = clueRemarkService.deleteClueRemarkByRemarkId(clueRemarkId);
            if (i > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);

            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,请稍后再试....");
            }
        } catch (Exception e) {
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");
            e.printStackTrace();
        }

        return returnObject;


    }
}
