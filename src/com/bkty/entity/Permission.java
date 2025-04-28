package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class Permission implements Serializable {
  private Integer permId;
  private String permName;
  private String permCode;
  private String permDesc;
  private Date createTime;

  // 构造方法
  public Permission() {
  }

  // getter和setter方法
  public Integer getPermId() {
    return permId;
  }

  public void setPermId(Integer permId) {
    this.permId = permId;
  }

  public String getPermName() {
    return permName;
  }

  public void setPermName(String permName) {
    this.permName = permName;
  }

  public String getPermCode() {
    return permCode;
  }

  public void setPermCode(String permCode) {
    this.permCode = permCode;
  }

  public String getPermDesc() {
    return permDesc;
  }

  public void setPermDesc(String permDesc) {
    this.permDesc = permDesc;
  }

  public Date getCreateTime() {
    return createTime;
  }

  public void setCreateTime(Date createTime) {
    this.createTime = createTime;
  }

  @Override
  public String toString() {
    return "Permission{" +
        "permId=" + permId +
        ", permName='" + permName + '\'' +
        ", permCode='" + permCode + '\'' +
        ", permDesc='" + permDesc + '\'' +
        ", createTime=" + createTime +
        '}';
  }
}