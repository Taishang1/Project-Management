package com.bkty.service.impl;

import com.bkty.dao.TeacherDao;
import com.bkty.dao.impl.TeacherDaoImpl;
import com.bkty.entity.Teacher;
import com.bkty.service.TeacherService;

import java.util.List;

public class TeacherServiceImpl implements TeacherService {

    private TeacherDao teacherDao = new TeacherDaoImpl();

    @Override
    public boolean addTeacher(Teacher teacher) {
        return teacherDao.addTeacher(teacher) > 0;
    }

    @Override
    public boolean updateTeacher(Teacher teacher) {
        return teacherDao.updateTeacher(teacher) > 0;
    }

    @Override
    public boolean deleteTeacher(int tid) {
        return teacherDao.deleteTeacher(tid) > 0;
    }

    @Override
    public Teacher getTeacherById(int tid) {
        return teacherDao.getTeacherById(tid);
    }

    @Override
    public List<Teacher> getAllTeachers() {
        return teacherDao.getAllTeachers();
    }

    @Override
    public List<Teacher> searchTeachers(String keyword) {
        return teacherDao.searchTeachers(keyword);
    }
}