package com.bkty.entity;

import java.io.Serializable;
import java.util.Date;

public class Attendance implements Serializable {
    private Integer aid;
    private Integer sid;
    private Integer cid;
    private Date attendanceDate;
    private String status;

    // 临时字段，用于存储关联数据
    private String studentName;
    private String courseName;

    // 关联属性
    private Student student;
    private Course course;

    public Attendance() {
    }

    public Attendance(Integer sid, Integer cid, Date attendanceDate, String status) {
        this.sid = sid;
        this.cid = cid;
        this.attendanceDate = attendanceDate;
        this.status = status;
    }

    public Attendance(Integer aid, Integer sid, Integer cid, Date attendanceDate, String status) {
        this.aid = aid;
        this.sid = sid;
        this.cid = cid;
        this.attendanceDate = attendanceDate;
        this.status = status;
    }

    public Integer getAid() {
        return aid;
    }

    public void setAid(Integer aid) {
        this.aid = aid;
    }

    public Integer getSid() {
        return sid;
    }

    public void setSid(Integer sid) {
        this.sid = sid;
    }

    public Integer getCid() {
        return cid;
    }

    public void setCid(Integer cid) {
        this.cid = cid;
    }

    public Date getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(Date attendanceDate) {
        this.attendanceDate = attendanceDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    @Override
    public String toString() {
        return "Attendance{" +
                "aid=" + aid +
                ", sid=" + sid +
                ", cid=" + cid +
                ", attendanceDate=" + attendanceDate +
                ", status='" + status + '\'' +
                '}';
    }
}