package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contans.Contans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.MD5Util;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class WorkbenchIndexController {
    @Autowired
    UserService userService;

    @RequestMapping("/workbench/index.do")
    public String index(HttpServletRequest request, HttpSession session) {
       User user= (User) session.getAttribute(Contans.SESSION_USER);
       request.setAttribute(Contans.SESSION_USER,user);
//        System.out.println(user+"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        return "workbench/index";

    }

    @RequestMapping("/workbench/editPassWord.do")
    @ResponseBody
    public Object editPassWord(String oldPwd, String newPwd, String confirmPwd, HttpSession session, HttpServletResponse response) {
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        //拿到的旧的user信息,为了
        User user = (User) session.getAttribute(Contans.SESSION_USER);
        map.put("loginAct", user.getLoginAct());
        map.put("loginPwd", MD5Util.getMD5(oldPwd));
        //用old放进去查询,看看这个用户的密码是不是正确
        User user1 = userService.queryUserByLoginActAndPwd(map);

        if (user1 == null) {
            returnObject.setMessage("旧密码输入错误");
            returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
        } else {
            if (newPwd.equals(confirmPwd)) {
                //看是不是新密码相等
                user.setLoginPwd(MD5Util.getMD5(newPwd));
                user.setEditBy(user.getId());
                user.setEditTime(DateUtils.formateDateTime(new Date()));
                try {
                    int i = userService.updatePwdById(user);
                    returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setPath("/");

                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setPath("/");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                } catch (Exception e) {
                    e.printStackTrace();
                    returnObject.setMessage("服务器繁忙");
                    returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                }
            } else {
                returnObject.setMessage("旧密码输入错误");
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            }

        }


//    user.setLoginPwd(newPwd);


        return returnObject;
    }
}
