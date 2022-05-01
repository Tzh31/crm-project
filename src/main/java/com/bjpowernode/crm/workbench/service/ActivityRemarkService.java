package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivitiesRemark;
import org.springframework.stereotype.Service;

import java.util.List;

//@Service
public interface ActivityRemarkService {

    List<ActivitiesRemark> selectActivityRemarkForDetailByActivityId(String activityId);
    int saveActivityRemark(ActivitiesRemark remark);
//    int saveActivityRemark(ActivitiesRemark remark);
int deleteActivityRemarkById(String id);
int saveEditActivityRemark(ActivitiesRemark remark);
}
