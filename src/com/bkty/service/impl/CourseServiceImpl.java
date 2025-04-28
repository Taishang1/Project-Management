package com.bkty.service.impl;

import com.bkty.dao.CourseDao;
import com.bkty.dao.impl.CourseDaoImpl;
import com.bkty.entity.Course;
import com.bkty.entity.PageBean;
import com.bkty.service.CourseService;

import java.util.List;

public class CourseServiceImpl implements CourseService {

    private CourseDao courseDao = new CourseDaoImpl();

    @Override
    public int getCourseCount() {
        return courseDao.getCourseCount();
    }

    @Override
    public boolean addCourse(Course course) {
        return courseDao.addCourse(course) > 0;
    }

    @Override
    public boolean updateCourse(Course course) {
        return courseDao.updateCourse(course) > 0;
    }

    @Override
    public boolean deleteCourse(int cid) {
        return courseDao.deleteCourse(cid) > 0;
    }

    @Override
    public Course getCourseById(int cid) {
        return courseDao.getCourseById(cid);
    }

    @Override
    public List<Course> getAllCourses() {
        return courseDao.getAllCourses();
    }

    @Override
    public List<Course> searchCourses(String keyword) {
        return courseDao.searchCourses(keyword);
    }

    @Override
    public PageBean<Course> getCourseByPage(int pageIndex, String keyword) {
        PageBean<Course> pageBean = new PageBean<>();
        pageBean.setIndex(pageIndex);
        int pageSize = 10; // 每页10条记录
        pageBean.setSize(pageSize);

        // 获取总记录数
        int totalCount = courseDao.getCourseCount();
        pageBean.setTotalCount(totalCount);

        // 不需要手动设置总页数，PageBean内部会计算

        // 获取当前页数据
        int start = (pageIndex - 1) * pageSize;
        List<Course> courses = courseDao.getByPage(start, pageSize, keyword);
        pageBean.setList(courses);

        return pageBean;
    }
}