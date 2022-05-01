package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.mapper.ClueMapper;
import com.bjpowernode.crm.workbench.mapper.ClueRemarkMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.aspectj.weaver.patterns.IfPointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.text.Utilities;
import java.util.*;

@Controller
public class ClueController {
    //这个是数据字典的东西
    @Autowired
    DicValueService dicValueService;
    @Autowired
    UserService userService;
    @Autowired
    ClueService clueService;
    @Autowired
    ClueRemarkService clueRemarkService;

    @Autowired
    ActivityService activityService;
    @Autowired
    ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request) {
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<User> users = userService.selectAllUsers();
        List<DicValue> clueState = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        request.setAttribute("appellation", appellation);
        request.setAttribute("users", users);
        request.setAttribute("source", source);
        request.setAttribute("cluState", clueState);

        return "workbench/clue/index";

    }

    @ResponseBody
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public Object savaCreateClue(Clue clue, HttpSession session) {
        System.out.println("heihie");
        System.out.println(clue.getFullname()+"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        ReturnObject returnObject = new ReturnObject();
        User attribute = (User) session.getAttribute(Contans.SESSION_USER);
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        clue.setCreateBy(attribute.getId());
        clue.setId(UUIDUtils.getUUID());

        try {
            int i = clueService.saveCreateClue(clue);
            if (i > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙，请稍后再试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙，请稍后再试....");
        }

        return returnObject;


    }

    @ResponseBody
    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    public Object queryClueByConditionForPage(String owner,
                                              String company,
                                              String appellation,
                                              String phone,
                                              String fulname,
                                              String mphone,
                                              String state,
                                              String source,
                                              Integer pageNo,
                                              Integer pageSize) {


        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();

        map.put("owner", owner);
        map.put("company", company);
        map.put("appellation", appellation);
        map.put("fulname", fulname);
//    map.put("job           ", job           );
//    map.put("email         ", email         );
        map.put("phone", phone);
//    map.put("website       ", website       );
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("source", source);
//    map.put("description   ", description   );
//    map.put("contactSummary", contactSummary);
//    map.put("nextContactTim", nextContactTim);
//    map.put("address       ", address       );

        int beginNo = (pageNo - 1) * pageSize;
//    System.out.println(beginNo + "开始页数" + name);
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        Map<String, Object> retMap = new HashMap<>();

        try {
            List<Clue> clues = clueService.queryClueByConditionForPage(map);
            int i = clueService.queryCountClue(map);
            retMap.put("activityList", clues);
            retMap.put("totalRows", i);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return retMap;
    }

    @RequestMapping("/workbench/clue/detail.do")
    public String detail(String id, HttpServletRequest request) {
        List<ClueRemark> clueRemark = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        Clue clue = clueService.queryClueForDetailById(id);
        List<Activity> activity = activityService.selectActivityForDetailByClueId(id);

        System.out.println(clueRemark);
//        System.out.println(clue.getCompany()+"hahah");
        System.out.println(activity);
        request.setAttribute("clueRemark", clueRemark);
        request.setAttribute("clue", clue);

        request.setAttribute("activity", activity);

        return "workbench/clue/detail";
    }

    @ResponseBody
    @RequestMapping("/workbench/clue/selectActivityForDetailByNameClueId.do")
    public Object selectActivityForDetailByNameClueId(String activityName, String clueId) {
        Map<String, Object> map = new HashMap<>();
        map.put("activityName", activityName);
        map.put("clueId", clueId);
        List<Activity> activities = null;
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map1 = new HashMap<>();
        try {
            activities = activityService.queryActivityForDetailByNameClueId(map);
            returnObject.setRetData(activities);
            map1.put("activities", activities);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map1;


    }

    @ResponseBody
    @RequestMapping("/workbench/clue/saveCreateClueActivityForDetailByNameClueId.do")
    public Object saveCreateClueActivityForDetailByNameClueId(String[] id, String clueId) {
        Map<String, Object> map = new HashMap<>();
//        ClueActivityRelation clueActivityRelation;
        List<ClueActivityRelation> clueActivityRelations = new ArrayList<>();
        ReturnObject returnObject = new ReturnObject();
        if (id != null) {
            for (String ids : id
            ) {
                System.out.println(ids);
                ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
                clueActivityRelation.setActivityId(ids);
                clueActivityRelation.setId(UUIDUtils.getUUID());
                clueActivityRelation.setClueId(clueId);
                clueActivityRelations.add(clueActivityRelation);
//            map.put("id")
            }
            try {
                int i = clueActivityRelationService.saveCreateClueActivityRelationByList(clueActivityRelations);
                if (i > 0) {
                    returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
                    List<Activity> activities = activityService.queryActivityForDetailByIds(id);
                    returnObject.setRetData(activities);
                    System.out.println(activities + "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
                } else {
                    returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("服务器繁忙,请稍后再试....");
                }
            } catch (Exception e) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,请稍后再试....");
                e.printStackTrace();
            }

        } else {
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");
        }


        return returnObject;
    }

    @ResponseBody
    @RequestMapping("/workbench/clue/deleteClueActivityRelationByClueIdActivityId.do")
    public Object deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation) {
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(clueActivityRelation);
            if (i > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);

            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,请稍后再试....");
            }

        } catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");

        }


        return returnObject;
    }

    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id, HttpServletRequest request) {
        Clue clue = clueService.queryClueForDetailById(id);
//        System.out.println("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("clue", clue);
        request.setAttribute("stage", stage);
        return "workbench/clue/convert";
    }

    @ResponseBody
    @RequestMapping("/workbench/clue/queryActivityForConvertByNameClueId.do")
    public Object queryActivityForConvertByNameClueId(String clueId, String activityName) {

        HashMap<String, Object> Map = new HashMap<>();
        Map.put("clueId", clueId);
        Map.put("activityName", activityName);


        List<Activity> activities = activityService.queryActivityForConvertByNameClueId(Map);


        return activities;
    }

    @ResponseBody
    @RequestMapping("/workbench/clue/deleteClueByClueId.do")
    public Object deleteClueByClueId(String[] id) {

        ReturnObject returnObject = new ReturnObject();


        try {
            int i = clueService.deleteClueByClueId(id);
            if (i > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);

            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("服务器繁忙,请稍后再试....");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");
        }

        return returnObject;
    }



    @ResponseBody
    @RequestMapping("/workbench/clue/transfer.do")
    public Object transfer(String clueId, String isTransfer,String money,String name,String expectedDate,
            String source,String stage,String activityId, HttpSession session) {

        ReturnObject returnObject = new ReturnObject();
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("clueId", clueId);
            map.put("isTransfer",isTransfer);
            map.put("money",money);
            map.put("name",name);
            map.put("expectedDate",expectedDate);
            map.put("source",source);
            map.put("stage",stage);
            map.put("activityId",activityId);
            User user = (User) session.getAttribute(Contans.SESSION_USER);
            map.put(Contans.SESSION_USER, user);
            clueService.saveConvertClue(map);
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);

        } catch (Exception e) {
            e.printStackTrace();

            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试....");
        }
        return returnObject;
    }

}
