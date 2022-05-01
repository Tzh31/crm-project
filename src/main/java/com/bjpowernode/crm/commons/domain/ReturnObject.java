package com.bjpowernode.crm.commons.domain;

public class ReturnObject {
    private String      code;
    private String message;
    private Object retData;
private Object retData1;
private Object retData2;

    public Object getRetData1() {
        return retData1;
    }

    public void setRetData1(Object retData1) {
        this.retData1 = retData1;
    }

    public Object getRetData2() {
        return retData2;
    }

    public void setRetData2(Object retData2) {
        this.retData2 = retData2;
    }



    @Override
    public String toString() {
        return "ReturnObject{" +
                "code='" + code + '\'' +
                ", message='" + message + '\'' +
                ", retData=" + retData +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
