package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.FunnelVo;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranMapper {
    int insertTran(Tran tran);
    List<Tran> selectTranByConditionForPage(Map<String,Object>map);
    int selectTranCountByCondition(Map<String,Object>map);
    Tran selectTranForDetailByTranId(String tranId);
    List<FunnelVo>selectCountOfTranGroupByStage();
    int updateStageByPrimaryKey(Tran tran);
    Tran selectTranForDetail(String id);
}
