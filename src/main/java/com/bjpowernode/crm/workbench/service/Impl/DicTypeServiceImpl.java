package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.settings.domain.DicType;
import com.bjpowernode.crm.settings.mapper.DicTypeMapper;
import com.bjpowernode.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    DicTypeMapper dicTypeMapper;
    @Override
    public List<DicType> selectAll() {
        return dicTypeMapper.selectAll();
    }
}
