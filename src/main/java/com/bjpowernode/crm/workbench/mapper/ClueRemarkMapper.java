package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
   List< ClueRemark> selectClueRemarkForDetailByClueId(String id);
   List<ClueRemark> selectDetailClueRemarkByClueId(String clueId);
int updateClueRemark(ClueRemark clueRemark);
int insertClueRemark(ClueRemark clueRemark);
int deleteClueRemarkByRemarkId(String clueRemarkId);

}
