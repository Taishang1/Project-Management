package com.bkty.service;

import com.bkty.entity.Attendance;

import java.util.List;

public interface AttendanceService {

    // 添加考勤记录
    boolean addAttendance(Attendance attendance);

    // 更新考勤记录
    boolean updateAttendance(Attendance attendance);

    // 删除考勤记录
    boolean deleteAttendance(int aid);

    // 根据ID获取考勤记录
    Attendance getAttendanceById(int aid);

    // 获取所有考勤记录
    List<Attendance> getAllAttendances();

    // 根据条件查询考勤记录
    List<Attendance> searchAttendances(String keyword);

    List<Attendance> getAllAttendancesWithDetails();
}