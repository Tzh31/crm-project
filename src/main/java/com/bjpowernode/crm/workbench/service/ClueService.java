package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Clue;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveCreateClue(Clue clue);
    List<Clue> queryClueByConditionForPage(Map<String,Object>map);
    int queryCountClue(Map<String,Object>map);
   Clue queryClueForDetailById(String id);

   void saveConvertClue(Map<String,Object>map);
   int deleteClueByClueId(String[]id);
}
