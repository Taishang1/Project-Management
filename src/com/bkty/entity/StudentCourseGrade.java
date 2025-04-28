package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class StudentCourseGrade implements Serializable {
    private Integer scgid;
    private Student student;
    private Course course;
    private Double grade;
    private Date examDate;

    public StudentCourseGrade() {
        this.student = new Student();
        this.course = new Course();
    }

    public Integer getScgid() {
        return scgid;
    }

    public void setScgid(Integer scgid) {
        this.scgid = scgid;
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

    public Double getGrade() {
        return grade;
    }

    public void setGrade(Double grade) {
        this.grade = grade;
    }

    public Date getExamDate() {
        return examDate;
    }

    public void setExamDate(Date examDate) {
        this.examDate = examDate;
    }

    @Override
    public String toString() {
        return "StudentCourseGrade{" +
                "scgid=" + scgid +
                ", student=" + student +
                ", course=" + course +
                ", grade=" + grade +
                ", examDate=" + examDate +
                '}';
    }
}