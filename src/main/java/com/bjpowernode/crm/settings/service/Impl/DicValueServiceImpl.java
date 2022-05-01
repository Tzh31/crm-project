package com.bjpowernode.crm.settings.service.Impl;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.mapper.DicValueMapper;
import com.bjpowernode.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    DicValueMapper dicValueMapper;
    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }

    @Override
    public List<DicValue> selectAllForPage() {
        return dicValueMapper.selectAllForPage();
    }

    @Override
    public DicValue selectById(String id) {
        return dicValueMapper.selectById(id);
    }


}
