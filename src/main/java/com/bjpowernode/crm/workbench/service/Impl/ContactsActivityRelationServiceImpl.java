package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;
import com.bjpowernode.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.bjpowernode.crm.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {
    @Autowired
    ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Override
    public int insertContactsActivityRelation(List<ContactsActivityRelation> contactsActivityRelation) {
        return contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelation);

    }
}
