package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface UserService {
    public User queryUserByLoginActAndPwd(Map<String,Object> map);
    List<User>selectAllUsers();
int updatePwdById(User user);
}
