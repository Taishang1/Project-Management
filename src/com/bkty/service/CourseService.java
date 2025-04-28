package com.bkty.service;

import com.bkty.entity.Course;
import com.bkty.entity.PageBean;

import java.util.List;

public interface CourseService {

    // 添加课程
    boolean addCourse(Course course);

    // 更新课程
    boolean updateCourse(Course course);

    // 删除课程
    boolean deleteCourse(int cid);

    // 根据ID获取课程
    Course getCourseById(int cid);

    // 获取所有课程
    List<Course> getAllCourses();

    // 根据条件查询课程
    List<Course> searchCourses(String keyword);

    int getCourseCount();

    // 添加分页查询方法
    PageBean<Course> getCourseByPage(int pageIndex, String keyword);
}