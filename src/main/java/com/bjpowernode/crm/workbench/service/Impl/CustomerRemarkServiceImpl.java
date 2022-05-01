package com.bjpowernode.crm.workbench.service.Impl;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.mapper.CustomerRemarkMapper;
import com.bjpowernode.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    CustomerRemarkMapper customerRemarkMapper;
    @Override
    public int saveRemark(List<CustomerRemark> remarks) {
        return customerRemarkMapper.insertRemark(remarks);
    }
}
