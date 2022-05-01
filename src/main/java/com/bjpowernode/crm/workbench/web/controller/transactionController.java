package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import static com.bjpowernode.crm.commons.contans.Contans.RETURN_OBJECT_CODE_FAIL;
import static com.bjpowernode.crm.commons.contans.Contans.RETURN_OBJECT_CODE_SUCCESS;

@Controller
public class transactionController {
    @Autowired
    DicValueService dicValueService;
    @Autowired
    TranService tranService;
    @Autowired
    CustomerService customerService;
    @Autowired
    UserService userService;
    @Autowired
    TranRemarkService tranRemarkService;
    @Autowired
    TranHistoryService tranHistoryService;
    @Autowired
    ContactsService contactsService;
    @Autowired
    ActivityService activityService;

    @RequestMapping("workbench/transaction/index.do")
    public String index(HttpServletRequest request) {
        List<User> users = userService.selectAllUsers();

        request.setAttribute("userList", users);
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        request.setAttribute("source", source);
        request.setAttribute("stage", stage);
        request.setAttribute("transactionType", transactionType);

        return "workbench/transaction/index";

    }

    @RequestMapping("/workbench/transaction/queryTranByConditionForPage.do")
    @ResponseBody
    public Object queryTranByConditionForPage(String owner, String name, String customer, String stage, String type, String source, String contact
            , Integer pageSize, Integer pageNo) {
//        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customer", customer);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contact", contact);
        map.put("pageSize", pageSize);
        int beginNo = (pageNo - 1) * pageSize;
        map.put("beginNo", beginNo);
        List<Tran> trans = tranService.queryTranByConditionForPage(map);

        int totalRows = tranService.queryTranCountByCondition(map);
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("trans", trans);
        retMap.put("totalRows", totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/transaction/save.do")
    public String save(HttpServletRequest request) {
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        request.setAttribute("source", source);
        request.setAttribute("stage", stage);
        request.setAttribute("transactionType", transactionType);
        List<User> users = userService.selectAllUsers();
        request.setAttribute("users", users);

        return "workbench/transaction/save";
    }

    @RequestMapping("workbench/transaction/getPossibly.do")
    @ResponseBody
    public String getPossibly(String stageValue) {

        ResourceBundle bd = ResourceBundle.getBundle("db");
        String string = bd.getString(stageValue);
        return string;
    }

    @RequestMapping("workbench/transaction/queryCustomerName.do")
    public @ResponseBody
    Object queryCustomerName(String customerName) {

        List<Customer> customers = customerService.selectCustomerNamesByName(customerName);

        return customers;
    }

    @RequestMapping("workbench/transaction/saveNewTran.do")
    @ResponseBody
    public Object saveNewTran(@RequestParam Map<String, Object> map, HttpSession session) {
        User user = (User) session.getAttribute(Contans.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
            map.put("user", user);
            tranService.saveCreateTran(map);
            returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);

        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
        }
        return returnObject;

    }

    @RequestMapping("/workbench/transaction/detail.do")
    public String detail(String tranId, HttpServletRequest request) {
//tranService.
        Tran tran = tranService.queryTranForDetailByTranId(tranId);
        List<TranRemark> remarks = tranRemarkService.queryTranRemarkForDetailByTranId(tranId);
        List<TranHistory> tranHistories = tranHistoryService.queryTranHistoryForDetailByTranId(tranId);
        ResourceBundle resourceBundle = ResourceBundle.getBundle("db");
        String possibility = resourceBundle.getString(tran.getStage());
        tran.setPossibility(possibility);
        request.setAttribute("remarks", remarks);
        request.setAttribute("tran", tran);
        request.setAttribute("tranHistories", tranHistories);
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("stage", stage);
//        System.out.println(tran.getOrderNo()+"haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        return "workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/edit.do")
    public String edit(String id, HttpServletRequest request) {
        System.out.println(id+"jjjjjjjjjjjjjjjj");
        Tran tran = tranService.queryTranForDetail(id);
        List<User> users = userService.selectAllUsers();

        request.setAttribute("userList", users);
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueByTypeCode("transactionType");
        request.setAttribute("source", source);
        request.setAttribute("stage", stage);
        request.setAttribute("transactionType", transactionType);
        if (tran.getActivityId()!=null && tran.getActivityId().length()>2){
            Activity activity = activityService.selectActivityById(tran.getActivityId());
            tran.setActivityName(activity.getName());
        }
        if (tran.getCustomerId()!=null&&tran.getCustomerId()!=" "){
            Customer customer = customerService.queryCustomerById(tran.getCustomerId());

            tran.setCustomerName(customer.getName());

        }

        ResourceBundle resourceBundle = ResourceBundle.getBundle("db");

        DicValue dicValue = dicValueService.selectById(tran.getStage());
        String string = resourceBundle.getString(dicValue.getValue());
        tran.setPossibility(string);
        request.setAttribute("tran", tran);
        //想要修改，肯定要携带tran的id才能修改

        return "workbench/transaction/edit";
    }

    @ResponseBody
    @RequestMapping("/workbench/transaction/editStage.do")
    public Object editStage(String tranId, String orderNo, HttpSession session) {

        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Contans.SESSION_USER);

        Map<String, Object> map = new HashMap<>();
        map.put("user", user);
        map.put("orderNo", orderNo);
        map.put("tranId", tranId);
        try {
            Tran tran = tranService.editTranStage(map);
            List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
            List<TranHistory> tranHistories = tranHistoryService.queryTranHistoryForDetailByTranId(tranId);
            Tran tran1 = tranService.queryTranForDetailByTranId(tranId);

            tran1.setPossibility(tran.getPossibility());
            returnObject.setRetData(tran1);
            returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData1(stage);
            returnObject.setRetData2(tranHistories);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("服务器繁忙,请稍后再试.....");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/transaction/querryContactsByName.do")
    @ResponseBody
    public Object querryContactsByName(String fullname) {
        ReturnObject returnObject = new ReturnObject();
        List<Contacts> contacts = contactsService.selectContactsByName(fullname);
        for (Contacts contans : contacts) {
            System.out.println(contans);
        }

        returnObject.setRetData(contacts);
//        if (contacts)
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/querryActivityByName.do")
    @ResponseBody
    public Object querryActivityByName(String name) {
//        ReturnObject returnObject = new ReturnObject();
        List<Activity> activities = activityService.selectActivityForConvertByName(name);
//        List<Contacts> contacts = contactsService.selectContactsByName(fullname);
//        for (Contacts contans:contacts) {
//            System.out.println(contans);
//        }
//
//        returnObject.setRetData(contacts);
//        if (contacts)
        return activities;
    }
//    @RequestMapping("/workbench/transaction/edit.do")
//            public String edit()
//    {
//        return "workbench/transaction/edit";
//    }
}
