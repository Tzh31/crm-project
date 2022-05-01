package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list);
    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation clueActivityRelation);
    List<ClueActivityRelation> selectClueActivityRelation(String clueId);

}
