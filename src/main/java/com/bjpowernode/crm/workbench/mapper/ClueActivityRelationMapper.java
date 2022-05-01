package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationMapper {
    public int insertClueActivityRelationByList(List<ClueActivityRelation>list);
    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);
List<ClueActivityRelation> selectClueActivityRelation(String clueId);
int deleteClueActivityRelationByClueId(String clueId);
}
