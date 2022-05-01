package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
@Controller
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    ContactsMapper contactsMapper;
    @Override
    public List<Contacts> queryContactsByConditionForPage(Contacts Contacts) {
        return contactsMapper.selectContactsByConditionForPage(Contacts);
    }

    @Override
    public int queryCountOfActivityByCondition(Contacts contacts) {
        return contactsMapper.selectCountOfActivityByCondition(contacts);
    }

    @Override
    public int deleteByIds(String[] id) {
        return contactsMapper.deleteByIds(id);
    }

    @Override
    public int saveNewContacts(Contacts contacts) {
        return contactsMapper.insertNewContacts(contacts);
    }

    @Override
    public List<Contacts> selectContactsByName(String fullname) {
        return contactsMapper.selectContactsByName(fullname);
    }
}
