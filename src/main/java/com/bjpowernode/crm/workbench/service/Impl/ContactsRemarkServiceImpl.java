package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;
import com.bjpowernode.crm.workbench.mapper.ContactsRemarkMapper;
import com.bjpowernode.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    ContactsRemarkMapper contactsRemarkMapper;
    @Override
    public int saveContactsRemark(List<ContactsRemark> remarks) {
        return contactsRemarkMapper.insertContactsRemark(remarks);
    }
}
