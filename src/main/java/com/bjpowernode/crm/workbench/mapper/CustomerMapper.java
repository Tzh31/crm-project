package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerMapper {
    int insertCustomer(Customer customer);
    List<Customer>selectCustomerNamesByName(String customerName);
    Customer selectCustomerByName(String customerName);

Customer selectCustomerById(String id);
}
