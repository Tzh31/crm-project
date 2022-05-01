package com.bjpowernode.crm.workbench.domain;

public class FunnelVo {
    private String value;
    private String name;

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "FunnelVo{" +
                "value='" + value + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
