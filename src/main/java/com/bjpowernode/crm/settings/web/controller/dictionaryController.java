package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.service.DicTypeService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class dictionaryController {
    @Autowired
    DicTypeService dicTypeService;
    @Autowired
    DicValueMapper dicValueMapper;

    @RequestMapping("/settings/dictionary/index.do")
    public String index(HttpServletRequest request){


        return "settings/dictionary/index";

    }


    @RequestMapping("/settings/dictionary/valueIndex.do")
    public String valueIndex(HttpServletRequest request) {
        List<DicValue> dicValues = dicValueMapper.selectAllForPage();
        request.setAttribute("dicValues",dicValues);
        return "settings/dictionary/value/index";
    }

    @RequestMapping("/settings/dictionary/typeIndex.do")
    public String typeIndex(HttpServletRequest request) {
        List<DicType> dicTypes = dicTypeService.selectAll();
        request.setAttribute("dicTypes",dicTypes);
        return "settings/dictionary/type/index";
    }
//    @RequestMapping("/settings/valueSave.do")
//    public String valueSave() {
//
//        return "settings/dictionary/value/save";
//    }
}
