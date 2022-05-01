package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.mapper.ClueRemarkMapper;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    ClueRemarkMapper mapper;
    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String id) {
        return mapper.selectClueRemarkForDetailByClueId(id);
    }

    @Override
    public int editClueRemark(ClueRemark clueRemark) {
        return mapper.updateClueRemark(clueRemark);
    }

    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return mapper.insertClueRemark(clueRemark);
    }

    @Override
    public int deleteClueRemarkByRemarkId(String clueRemarkId) {
        return mapper.deleteClueRemarkByRemarkId(clueRemarkId);
    }

}
