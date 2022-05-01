package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.mapper.ActivityMapper;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    ActivityMapper activityMapper;
    @Override
    public int saveActivity(Activity activity) {
        return activityMapper.insert(activity);
    }

    @Override
    public List<Activity> selectActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int selectCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityByIds(String[] id) {
        return activityMapper.deleteActivityByIds(id);
    }

    @Override
    public Activity selectActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }
    public int updateByPrimaryKey(Activity activity){
        return activityMapper.updateByPrimaryKey(activity);
    }

    @Override
    public List<Activity> queryAllActivities() {
        return activityMapper.queryAllActivities();
    }

    @Override
    public List<Activity> querySelectActivities(String[]id) {
        return activityMapper.querySelectActivities(id);
    }

    @Override
    public int saveCreatActivityByList(List<Activity> activities) {
        return activityMapper.insertActivityByList(activities);
    }

    @Override
    public Activity queryActivityForDetail(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> selectActivityForDetailByClueId(String id) {
        return activityMapper.selectActivityForDetailByClueId(id);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameClueId(map);

    }

    @Override
    public List<Activity> queryActivityForConvertByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityForDetailByIds(String[] ids) {
        return activityMapper.selectActivityForDetailByIds(ids);
    }

    @Override
    public List<Activity> selectActivityForConvertByName(String name) {
        return activityMapper.selectActivityForConvertByName(name);
    }

}
