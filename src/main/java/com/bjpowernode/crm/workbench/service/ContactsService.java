package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> queryContactsByConditionForPage(Contacts contans);
    int queryCountOfActivityByCondition(Contacts contacts);
    int deleteByIds(String []id);
    int saveNewContacts(Contacts contacts);
    List<Contacts> selectContactsByName(String fullname);

}
