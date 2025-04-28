package com.bkty.service.impl;

import com.bkty.dao.StudentCourseDao;
import com.bkty.dao.impl.StudentCourseDaoImpl;
import com.bkty.entity.StudentCourse;
import com.bkty.entity.PageBean;
import com.bkty.service.StudentCourseService;
import java.util.List;

public class StudentCourseServiceImpl implements StudentCourseService {
    private StudentCourseDao studentCourseDao = new StudentCourseDaoImpl();

    @Override
    public List<StudentCourse> getAllStudentCourses() {
        return studentCourseDao.getAllStudentCourses();
    }

    @Override
    public StudentCourse getStudentCourseById(int id) {
        return studentCourseDao.getStudentCourseById(id);
    }

    @Override
    public int addStudentCourse(StudentCourse studentCourse) {
        return studentCourseDao.addStudentCourse(studentCourse);
    }

    @Override
    public int updateStudentCourse(StudentCourse studentCourse) {
        return studentCourseDao.updateStudentCourse(studentCourse);
    }

    @Override
    public int deleteStudentCourse(int id) {
        return studentCourseDao.deleteStudentCourse(id);
    }

    @Override
    public List<StudentCourse> searchStudentCourses(String keyword) {
        return studentCourseDao.searchStudentCourses(keyword);
    }

    @Override
    public PageBean<StudentCourse> getStudentCoursesByPage(int pageIndex, String keyword) {
        PageBean<StudentCourse> pageBean = new PageBean<>();
        int pageSize = 10; // 每页显示10条记录

        // 获取总记录数
        int totalCount = studentCourseDao.getTotalCount(keyword);
        pageBean.setTotalCount(totalCount);

        // 设置其他分页参数
        pageBean.setIndex(pageIndex);
        pageBean.setSize(pageSize);

        // 获取当前页数据
        int start = (pageIndex - 1) * pageSize;
        List<StudentCourse> list = studentCourseDao.getStudentCoursesByPage(start, pageSize, keyword);
        pageBean.setList(list);

        return pageBean;
    }
}