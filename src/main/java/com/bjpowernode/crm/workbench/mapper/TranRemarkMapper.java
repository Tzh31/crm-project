package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkMapper {
    int insertTranRemark(List<TranRemark> remark);
    List<TranRemark >selectTranRemarkForDetailByTranId(String tranId);
}
