package com.bkty.service;

import com.bkty.entity.PageBean;
import com.bkty.entity.StudentCourse;

import java.util.List;

public interface StudentCourseService {

    // 学生选课
    int addStudentCourse(StudentCourse studentCourse);

    // 取消选课
    int deleteStudentCourse(int id);

    // 获取学生选课记录
    StudentCourse getStudentCourseById(int id);

    // 获取学生所有选课记录
    List<StudentCourse> getAllStudentCourses();

    // 根据条件查询选课记录
    List<StudentCourse> searchStudentCourses(String keyword);

    // 添加分页查询方法
    PageBean<StudentCourse> getStudentCoursesByPage(int pageIndex, String keyword);

    // 更新学生选课记录
    int updateStudentCourse(StudentCourse studentCourse);

}