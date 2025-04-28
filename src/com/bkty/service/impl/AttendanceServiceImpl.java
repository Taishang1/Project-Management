package com.bkty.service.impl;

import com.bkty.dao.AttendanceDao;
import com.bkty.dao.impl.AttendanceDaoImpl;
import com.bkty.entity.Attendance;
import com.bkty.service.AttendanceService;

import java.util.List;

public class AttendanceServiceImpl implements AttendanceService {

    private AttendanceDao attendanceDao = new AttendanceDaoImpl();

    @Override
    public boolean addAttendance(Attendance attendance) {
        return attendanceDao.addAttendance(attendance) > 0;
    }

    @Override
    public boolean updateAttendance(Attendance attendance) {
        return attendanceDao.updateAttendance(attendance) > 0;
    }

    @Override
    public boolean deleteAttendance(int aid) {
        return attendanceDao.deleteAttendance(aid) > 0;
    }

    @Override
    public Attendance getAttendanceById(int aid) {
        return attendanceDao.getAttendanceById(aid);
    }

    @Override
    public List<Attendance> getAllAttendances() {
        return attendanceDao.getAllAttendances();
    }

    @Override
    public List<Attendance> searchAttendances(String keyword) {
        return attendanceDao.searchAttendances(keyword);
    }

    @Override
    public List<Attendance> getAllAttendancesWithDetails() {
        return attendanceDao.getAllAttendancesWithDetails();
    }
}