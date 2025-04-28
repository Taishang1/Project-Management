package com.bkty.dao;

import com.bkty.entity.StudentCourse;

import java.util.List;

public interface StudentCourseDao {

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
    List<StudentCourse> getStudentCoursesByPage(int start, int size, String keyword);

    // 获取总记录数
    int getTotalCount(String keyword);

    // 更新学生选课记录
    int updateStudentCourse(StudentCourse studentCourse);
}