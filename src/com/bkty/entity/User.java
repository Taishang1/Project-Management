package com.bkty.entity;

import java.io.Serializable;

public class User implements Serializable {
    private Integer uid;
    private String ukey;
    private String pwd;
    private String realname;
    private Integer type;
    private Integer refId; // 新增字段
    private String userType; // 新增字段
    private String head;
    private Integer roleId;
    private Role role; // 角色对象，替换原来的String role

    public User() {
    }

    public User(Integer uid, String ukey, String pwd, String realname, Integer type) {
        this.uid = uid;
        this.ukey = ukey;
        this.pwd = pwd;
        this.realname = realname;
        this.type = type;
    }

    public User(Integer uid, String ukey, String pwd, String realname, Integer type, String head) {
        this.uid = uid;
        this.ukey = ukey;
        this.pwd = pwd;
        this.realname = realname;
        this.type = type;
        this.head = head;
    }

    public Integer getUid() {
        return uid;
    }

    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public String getUkey() {
        return ukey;
    }

    public void setUkey(String ukey) {
        this.ukey = ukey;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getRealname() {
        return realname;
    }

    public void setRealname(String realname) {
        this.realname = realname;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Integer getRefId() {
        return refId;
    }

    public void setRefId(Integer refId) {
        this.refId = refId;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getHead() {
        return head;
    }

    public void setHead(String head) {
        this.head = head;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
        if (role != null) {
            this.roleId = role.getRoleId();
            this.type = role.getRoleId(); // 保持与原有type字段的兼容
        }
    }

    @Override
    public String toString() {
        return "User{" +
                "uid=" + uid +
                ", ukey='" + ukey + '\'' +
                ", pwd='" + pwd + '\'' +
                ", realname='" + realname + '\'' +
                ", type=" + type +
                ", refId=" + refId +
                ", userType='" + userType + '\'' +
                ", head='" + head + '\'' +
                ", roleId=" + roleId +
                ", role=" + role +
                '}';
    }
}