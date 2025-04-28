package com.bkty.dao;

import com.bkty.entity.Course;

import java.util.List;

public interface CourseDao {

    // 添加课程
    int addCourse(Course course);

    // 更新课程
    int updateCourse(Course course);

    // 删除课程
    int deleteCourse(int cid);

    // 根据ID获取课程
    Course getCourseById(int cid);

    // 获取所有课程
    List<Course> getAllCourses();

    // 根据条件查询课程
    List<Course> searchCourses(String keyword);

    // 获取课程总数
    int getCourseCount();

    // 分页查询课程
    List<Course> getByPage(int start, int size, String keyword);
}