package com.bkty.service;

import com.bkty.entity.Teacher;

import java.util.List;

public interface TeacherService {

    // 添加教师
    boolean addTeacher(Teacher teacher);

    // 更新教师信息
    boolean updateTeacher(Teacher teacher);

    // 删除教师
    boolean deleteTeacher(int tid);

    // 根据ID获取教师
    Teacher getTeacherById(int tid);

    // 获取所有教师
    List<Teacher> getAllTeachers();

    // 根据条件查询教师
    List<Teacher> searchTeachers(String keyword);
}