package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.ActivitiesRemark;
import com.bjpowernode.crm.workbench.mapper.ActivitiesRemarkMapper;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    ActivitiesRemarkMapper activitiesRemarkMapper;
    @Override
    public List<ActivitiesRemark> selectActivityRemarkForDetailByActivityId(String activityId) {
        return activitiesRemarkMapper.selectActivityRemarkForDetailByActivityId(activityId);
    }

    @Override
    public int saveActivityRemark(ActivitiesRemark remark) {
        return activitiesRemarkMapper.insertActivityRemark(remark);
    }

    @Override
    public int deleteActivityRemarkById(String id) {
        return activitiesRemarkMapper.deleteActivityRemarkById(id);
    }

    @Override
    public int saveEditActivityRemark(ActivitiesRemark remark) {
        return activitiesRemarkMapper.updateActivityRemark(remark);
    }


//@Autowired
//ActivityRemarkMapper activityRemarkMapper

}
