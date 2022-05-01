package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {

    List<TranHistory> selectTranHistoryForDetailByTranId(String tranId);
int insertNewTranHistory(TranHistory tranHistory);
}
