package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.swing.*;
import javax.swing.text.Utilities;
import java.util.Date;
import java.util.List;

import static com.bjpowernode.crm.commons.contans.Contans.RETURN_OBJECT_CODE_FAIL;
import static com.bjpowernode.crm.commons.contans.Contans.RETURN_OBJECT_CODE_SUCCESS;

@Controller
public class ContactsController {
@Autowired
    DicValueService dicValueService;
@Autowired
    UserService userService;
@Autowired
    ContactsService contactsService;
@Autowired
CustomerMapper customerMapper;
        @RequestMapping("workbench/contacts/index.do")
        public String index(HttpServletRequest request){
            List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
            List<User> users = userService.selectAllUsers();

            request.setAttribute("userList", users);
            List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
            request.setAttribute("source", source);
//            request.setAttribute("stage", stage);
            request.setAttribute("appellation", appellation);
            //携带所有者的信息,称呼,来源
            return "workbench/contacts/index";
    }
    @RequestMapping("workbench/contacts/queryContactsByConditionForPage.do")
    @ResponseBody
    public Object queryContactsByConditionForPage(Contacts contacts, HttpSession session){
User user= (User) session.getAttribute(Contans.SESSION_USER);
//        Contacts contacts1 = new Contacts();

        int beginNo=contacts.getBeginNo();
//        System.out.println(beginNo+"hhhhhhhh");
//        System.out.println(contacts.getPageSize()+"hhhheiieieie");
        beginNo=(beginNo-1)*contacts.getPageSize();
//        System.out.println(beginNo+"hhhhhhhhhhhhhhhhhhhhhhhh");
        contacts.setBeginNo(beginNo);


        ReturnObject returnObject = new ReturnObject();
        try {
            List<Contacts> contacts1 = contactsService.queryContactsByConditionForPage(contacts);
            int totalRow= contactsService.queryCountOfActivityByCondition(contacts);
            if (contacts1!=null){
                returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);
returnObject.setRetData(contacts1);
returnObject.setRetData1(totalRow);
            }
            else {
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
    @RequestMapping("workbench/contacts/deleteByIds.do")
    public  Object deleteByIds( String id[]){
        for (String ids:id
             ) {
            System.out.println(ids+"hhhhhhhhhhhhhhhhhas");

        }
        ReturnObject returnObject = new ReturnObject();
        try {
            int i = contactsService.deleteByIds(id);
            if (i>0){

                returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("当前系统繁忙，请稍后.....");
            }
        } catch (Exception e) {
            e.printStackTrace();        returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("当前系统繁忙，请稍后.....");
        }

        return  returnObject;
    }
    @ResponseBody
    @RequestMapping("workbench/contacts/saveNewContacts.do")
    public Object  saveNewContacts(Contacts contacts,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        try {

            contacts.setId(UUIDUtils.getUUID());
           User user= (User) session.getAttribute(Contans.SESSION_USER);
            Customer customer = customerMapper.selectCustomerByName(contacts.getCustomerId());
            if (customer == null) {
                customer = new Customer();
                customer.setCreateBy(user.getId());
                customer.setCreateTime(DateUtils.formateDateTime(new Date()));
                customer.setId(UUIDUtils.getUUID());
                customer.setOwner(user.getId());
                customer.setName(contacts.getCustomerId());
                int i = customerMapper.insertCustomer(customer);

            }contacts.setCreateBy(user.getId());
            contacts.setCreateTime(DateUtils.formateDateTime(new Date()));

            int i = contactsService.saveNewContacts(contacts);
            if (i>0){

                returnObject.setCode(RETURN_OBJECT_CODE_SUCCESS);

            }else {
                returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("当前系统繁忙，请稍后.....");
            }
        } catch (Exception e) {
            e.printStackTrace();        returnObject.setCode(RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("当前系统繁忙，请稍后.....");
        }

        return  returnObject;
    }

}
