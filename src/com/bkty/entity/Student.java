package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class Student implements Serializable {
    private Integer sid;
    private String sname;
    private String gender;
    private Date birthday;
    private String sex;
    private String hobby;
    private String phone;
    private String reamrk;
    private Integer cid; // 班级编号
    private Clazz clazz;

    public Student() {
    }

    public Student(Integer sid, String sname, String sex, String hobby, Date birthdate, String phone, String reamrk,
            Integer cid, Clazz clazz) {
        this.sid = sid;
        this.sname = sname;
        this.sex = sex;
        this.hobby = hobby;
        this.birthday = birthdate;
        this.phone = phone;
        this.reamrk = reamrk;
        this.cid = cid;
        this.clazz = clazz;
    }

    public Integer getSid() {
        return sid;
    }

    public void setSid(Integer sid) {
        this.sid = sid;
    }

    public String getSname() {
        return sname;
    }

    public void setSname(String sname) {
        this.sname = sname;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getHobby() {
        return hobby;
    }

    public void setHobby(String hobby) {
        this.hobby = hobby;
    }

    public Date getBirthdate() {
        return birthday;
    }

    public void setBirthdate(Date birthday) {
        this.birthday = birthday;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getReamrk() {
        return reamrk;
    }

    public void setReamrk(String reamrk) {
        this.reamrk = reamrk;
    }

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public Clazz getClazz() {
        return clazz;
    }

    public void setClazz(Clazz clazz) {
        this.clazz = clazz;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    @Override
    public String toString() {
        return "Student{" +
                "sid=" + sid +
                ", sname='" + sname + '\'' +
                ", gender='" + gender + '\'' +
                ", birthday=" + birthday +
                ", sex='" + sex + '\'' +
                ", hobby='" + hobby + '\'' +
                ", phone='" + phone + '\'' +
                ", reamrk='" + reamrk + '\'' +
                ", cid=" + cid +
                ", clazz=" + clazz +
                '}';
    }
}
