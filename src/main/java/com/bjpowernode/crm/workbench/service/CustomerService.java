package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerService {
    List<Customer> selectCustomerNamesByName(String customerName);
Customer queryCustomerById(String id);
}
