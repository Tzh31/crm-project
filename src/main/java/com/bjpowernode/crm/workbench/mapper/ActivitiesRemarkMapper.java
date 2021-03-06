package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ActivitiesRemark;

import java.util.List;

public interface ActivitiesRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Thu Apr 07 13:37:54 GMT+08:00 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Thu Apr 07 13:37:54 GMT+08:00 2022
     */
    int insert(ActivitiesRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Thu Apr 07 13:37:54 GMT+08:00 2022
     */
    int insertSelective(ActivitiesRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Thu Apr 07 13:37:54 GMT+08:00 2022
     */
    ActivitiesRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Thu Apr 07 13:37:54 GMT+08:00 2022
     */
    int updateByPrimaryKeySelective(ActivitiesRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity_remark
     *
     * @mbggenerated Thu Apr 07 13:37:54 GMT+08:00 2022
     */
    int updateByPrimaryKey(ActivitiesRemark record);
    List<ActivitiesRemark> selectActivityRemarkForDetailByActivityId(String activityId);
    int insertActivityRemark (ActivitiesRemark remark);
    int deleteActivityRemarkById(String id);
    int updateActivityRemark(ActivitiesRemark remark);
}