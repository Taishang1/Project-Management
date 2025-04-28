package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class SystemLog implements Serializable {
    private Integer logId;
    private Integer uid;
    private String operation;
    private String module;
    private Date logTime;
    private String ipAddress;

    public SystemLog() {
    }

    public SystemLog(Integer uid, String operation, String module, Date logTime) {
        this.uid = uid;
        this.operation = operation;
        this.module = module;
        this.logTime = logTime;
    }

    public Integer getLogId() {
        return logId;
    }

    public void setLogId(Integer logId) {
        this.logId = logId;
    }

    public Integer getUid() {
        return uid;
    }

    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public Date getLogTime() {
        return logTime;
    }

    public void setLogTime(Date logTime) {
        this.logTime = logTime;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    @Override
    public String toString() {
        return "SystemLog{" +
                "logId=" + logId +
                ", uid=" + uid +
                ", operation='" + operation + '\'' +
                ", module='" + module + '\'' +
                ", logTime=" + logTime +
                ", ipAddress='" + ipAddress + '\'' +
                '}';
    }
}