package com.bjpowernode.crm.settings.web.controller;

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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(HttpServletRequest request) {
        //视图解析器已经加了
        Map<String, Object> map = new HashMap<>();
        boolean f = false;
        boolean f2 = false;
        for (Cookie cookie : request.getCookies()) {
            System.out.println(cookie.getName());
            if ("loginAct".equals(cookie.getName())) {;
                f = true;
                map.put("loginAct", cookie.getValue());
                System.out.println("账号有");
            }
            if ("loginPwd".equals(cookie.getName())) {
                f2 = true;
                map.put("loginPwd", cookie.getValue());
                System.out.println("密码有");
            }
        }
        if (f == true && f2 == true) {
            System.out.println("怎么不跳啊");
            User user = userService.queryUserByLoginActAndPwd(map);
            request.getSession().setAttribute(Contans.SESSION_USER, user);
            return "workbench/index";

        }

        return "settings/qx/user/login";

    }

    @ResponseBody
    @RequestMapping("/setting/qx/user/login.do")
    public Object login(String loginAct, String loginPwd, String idRemPwd, HttpServletRequest request, HttpServletResponse response) {
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
//        boolean f = false;
//        for (Cookie cookie : request.getCookies()) {
//            if ("loginAct".equals(cookie.getName())) {
//
////                System.out.println("已经有了哦");
//            }
//        }
//        if (loginPwd.length() == 40) {
//            f = true;
//        }
//        System.out.println(loginPwd.length()+"hahahhaha");
//        if (!f) {

            loginPwd = MD5Util.getMD5(loginPwd);

//        }
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        User user = userService.queryUserByLoginActAndPwd(map);

//    for (Cookie cookie : request.getCookies()) {
//        System.out.println(cookie.getName()+"  "+cookie.getValue());
//    }

        if (user == null) {
            returnObject.setCode("0");
            returnObject.setMessage("用户名或者密码错误");
        } else {
            String format = DateUtils.formateDateTime(new Date());
            if (format.compareTo(user.getExpireTime()) > 0) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号期限已到");
            } else if (user.getLockState().equals(Contans.RETURN_OBJECT_CODE_FAIL)) {
                returnObject.setMessage("账号被锁定");
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
            } else if (!user.getAllowIps().contains(request.getRemoteAddr())) {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("ip受限");
//        System.out.println(request.getRemoteAddr());
            } else {
                returnObject.setCode(Contans.RETURN_OBJECT_CODE_SUCCESS);
                request.getSession().setAttribute(Contans.SESSION_USER, user);
                if ("true".equals(idRemPwd)) {
                    System.out.println(idRemPwd);
                    boolean flag = false;
                    for (Cookie cookie : request.getCookies()) {
//        System.out.println(cookie.getName()+"  "+cookie.getValue());
                        System.out.println(cookie.getName());
                        if ("loginAct".equals(cookie.getName())) {
                            flag = true;
                            System.out.println("已经有了哦");
                        }
                        if (!flag) {
                            Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                            c1.setPath("/");
                            c1.setMaxAge(60 * 60 * 24 * 10);
                            response.addCookie(c1);
                            Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                            c2.setPath("/");
                            c2.setMaxAge(60 * 60 * 24 * 10);
                            response.addCookie(c2);

                        }


                    }


                } else {
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setPath("/");

                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setPath("/");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }


        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response) {
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setPath("/");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setPath("/");
        c2.setMaxAge(0);
        response.addCookie(c2);
        return "redirect:/";
    }

}
