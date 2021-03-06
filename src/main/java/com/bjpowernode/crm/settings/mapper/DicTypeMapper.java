package com.bjpowernode.crm.settings.mapper;

import com.bjpowernode.crm.settings.domain.DicType;

import java.util.List;

public interface DicTypeMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Sat Apr 09 13:30:25 GMT+08:00 2022
     */
    int deleteByPrimaryKey(String code);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Sat Apr 09 13:30:25 GMT+08:00 2022
     */
    int insert(DicType record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Sat Apr 09 13:30:25 GMT+08:00 2022
     */
    int insertSelective(DicType record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Sat Apr 09 13:30:25 GMT+08:00 2022
     */
    DicType selectByPrimaryKey(String code);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Sat Apr 09 13:30:25 GMT+08:00 2022
     */
    int updateByPrimaryKeySelective(DicType record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_dic_type
     *
     * @mbggenerated Sat Apr 09 13:30:25 GMT+08:00 2022
     */
    int updateByPrimaryKey(DicType record);
    List<DicType>selectAll();
}