package com.bjpowernode.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {
    public static final String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
