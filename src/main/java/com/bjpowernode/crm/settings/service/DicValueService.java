package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
//String selectDicValueIdByOrderNoAndTypeCode(String orderNo);
    List<DicValue>selectAllForPage();
    DicValue selectById(String id);
}
