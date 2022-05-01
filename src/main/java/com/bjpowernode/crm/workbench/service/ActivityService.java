package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

//@Service
public interface ActivityService {

    int saveActivity(Activity activity);
    List<Activity>selectActivityByConditionForPage(Map<String,Object>map);
    int selectCountOfActivityByCondition(Map<String,Object>map);
    int deleteActivityByIds(String[]ids);
    Activity selectActivityById(String id);
    int updateByPrimaryKey(Activity activity);
    List<Activity> queryAllActivities();
    List<Activity> querySelectActivities(String[]id);
    int saveCreatActivityByList(List<Activity>activities);
    Activity queryActivityForDetail(String id);
   List<Activity>  selectActivityForDetailByClueId(String id);
List<Activity> queryActivityForDetailByNameClueId(Map<String,Object>map);
List<Activity> queryActivityForConvertByNameClueId(Map<String,Object>map);
List<Activity>queryActivityForDetailByIds(String[]ids);
    List<Activity>selectActivityForConvertByName(String name);

}
