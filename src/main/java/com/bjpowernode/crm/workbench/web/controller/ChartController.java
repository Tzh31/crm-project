package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.workbench.domain.FunnelVo;
import com.bjpowernode.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartController {
    @Autowired
    TranService tranService;
    @RequestMapping("/workbench/chart/transaction/index.do")
    public String index(){

        return "workbench/chart/transaction/index";
    }
    @ResponseBody
    @RequestMapping("/workbench/chart/selectCountOfTranGroupByStage.do")
    public Object selectCountOfTranGroupByStage(){

        List<FunnelVo> funnelVos = tranService.queryCountOfTranGroupByStage();
        for (FunnelVo f:funnelVos
             ) {
            System.out.println(f);

        }
return funnelVos;

    }
}
