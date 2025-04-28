package com.bkty.entity;

import java.io.Serializable;

public class Course implements Serializable {
    private Integer cid;
    private String cname;
    private Integer credit;
    private String teacher;
    private String description;

    // 无参构造函数
    public Course() {
    }

    // 带参构造函数 (cid, cname, description)
    public Course(Integer cid, String cname, String description) {
        this.cid = cid;
        this.cname = cname;
        this.description = description;
    }

    // 带参构造函数 (cname, description)
    public Course(String cname, String description) {
        this.cname = cname;
        this.description = description;
    }

    // Getter 和 Setter 方法
    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public Integer getCredit() {
        return credit;
    }

    public void setCredit(Integer credit) {
        this.credit = credit;
    }

    public String getTeacher() {
        return teacher;
    }

    public void setTeacher(String teacher) {
        this.teacher = teacher;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Course{" +
                "cid=" + cid +
                ", cname='" + cname + '\'' +
                ", credit=" + credit +
                ", teacher='" + teacher + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}