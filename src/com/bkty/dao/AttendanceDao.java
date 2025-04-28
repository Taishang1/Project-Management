package com.bkty.dao;

import com.bkty.entity.Attendance;

import java.util.List;

public interface AttendanceDao {

    // 添加考勤记录
    int addAttendance(Attendance attendance);

    // 更新考勤记录
    int updateAttendance(Attendance attendance);

    // 删除考勤记录
    int deleteAttendance(int aid);

    // 根据ID获取考勤记录
    Attendance getAttendanceById(int aid);

    // 获取所有考勤记录
    List<Attendance> getAllAttendances();

    // 根据条件查询考勤记录
    List<Attendance> searchAttendances(String keyword);

    // 获取所有考勤记录及其详细信息
    List<Attendance> getAllAttendancesWithDetails();
}