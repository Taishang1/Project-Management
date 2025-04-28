package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class StudentCourse implements Serializable {
    private Integer scid;
    private Student student;
    private Course course;
    private Date selectTime;

    public StudentCourse() {
        this.student = new Student(); // 初始化 student 对象
        this.course = new Course(); // 初始化 course 对象
    }

    public Integer getScid() {
        return scid;
    }

    public void setScid(Integer scid) {
        this.scid = scid;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Date getSelectTime() {
        return selectTime;
    }

    public void setSelectTime(Date selectTime) {
        this.selectTime = selectTime;
    }

    @Override
    public String toString() {
        return "StudentCourse{" +
                "scid=" + scid +
                ", student=" + student +
                ", course=" + course +
                ", selectTime=" + selectTime +
                '}';
    }
}