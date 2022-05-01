package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.FunnelVo;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    List<Tran>queryTranByConditionForPage(Map<String,Object>map);
    int queryTranCountByCondition(Map<String,Object>map);
    void saveCreateTran(Map<String,Object>map);
    Tran queryTranForDetailByTranId(String tranId);
    List<FunnelVo>queryCountOfTranGroupByStage();
//    Tran  updateStageByPrimaryKey(Map<String,Object>map);
Tran queryTranForDetail(String id);

    Tran editTranStage(Map<String, Object> map);
}
