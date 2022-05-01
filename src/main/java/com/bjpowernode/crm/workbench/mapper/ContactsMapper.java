package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsMapper {
int insertContacts(Contacts contacts);
List<Contacts>selectContactsByConditionForPage(Contacts contacts);
int selectCountOfActivityByCondition(Contacts contacts);
int deleteByIds(String id[]);
int insertNewContacts(Contacts contacts);
List<Contacts> selectContactsByName(String fullname);
}
