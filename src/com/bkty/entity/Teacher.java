package com.bkty.entity;

import java.io.Serializable;

public class Teacher implements Serializable {
    private Integer tid;
    private String tname;
    private String sex;
    private String phone;
    private String email;
    private Integer cid;

    public Teacher() {
    }

    public Teacher(Integer tid, String tname, String sex, String phone, String email, Integer cid) {
        this.tid = tid;
        this.tname = tname;
        this.sex = sex;
        this.phone = phone;
        this.email = email;
        this.cid = cid;
    }

    public Teacher(String tname, String sex, String phone, String email, Integer cid) {
        this.tname = tname;
        this.sex = sex;
        this.phone = phone;
        this.email = email;
        this.cid = cid;
    }

    public Integer getTid() {
        return tid;
    }

    public void setTid(Integer tid) {
        this.tid = tid;
    }

    public String getTname() {
        return tname;
    }

    public void setTname(String tname) {
        this.tname = tname;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    @Override
    public String toString() {
        return "Teacher{" +
                "tid=" + tid +
                ", tname='" + tname + '\'' +
                ", sex='" + sex + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", cid=" + cid +
                '}';
    }
}