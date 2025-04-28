package com.bkty.service.impl;

import com.bkty.dao.StudentCourseGradeDao;
import com.bkty.dao.impl.StudentCourseGradeDaoImpl;
import com.bkty.entity.StudentCourseGrade;
import com.bkty.entity.PageBean;
import com.bkty.service.StudentCourseGradeService;
import java.util.List;

public class StudentCourseGradeServiceImpl implements StudentCourseGradeService {
    private StudentCourseGradeDao studentCourseGradeDao = new StudentCourseGradeDaoImpl();

    @Override
    public List<StudentCourseGrade> getAllGrades() {
        return studentCourseGradeDao.getAllGrades();
    }

    @Override
    public StudentCourseGrade getGradeById(int id) {
        return studentCourseGradeDao.getGradeById(id);
    }

    @Override
    public int addGrade(StudentCourseGrade grade) {
        return studentCourseGradeDao.addGrade(grade);
    }

    @Override
    public int updateGrade(StudentCourseGrade grade) {
        return studentCourseGradeDao.updateGrade(grade);
    }

    @Override
    public int deleteGrade(int id) {
        return studentCourseGradeDao.deleteGrade(id);
    }

    @Override
    public StudentCourseGrade getGradeByStudentAndCourse(int sid, int cid) {
        return studentCourseGradeDao.getGradeByStudentAndCourse(sid, cid);
    }

    @Override
    public List<StudentCourseGrade> searchGrades(String keyword) {
        return studentCourseGradeDao.searchGrades(keyword);
    }

    @Override
    public PageBean<StudentCourseGrade> getStudentCourseGradeByPage(int pageIndex, String keyword) {
        PageBean<StudentCourseGrade> pageBean = new PageBean<>();
        int pageSize = 10; // 每页显示10条记录

        // 获取总记录数
        int totalCount = studentCourseGradeDao.getTotalCount(keyword);
        pageBean.setTotalCount(totalCount);

        // 设置其他分页参数
        pageBean.setIndex(pageIndex);
        pageBean.setSize(pageSize);

        // 获取当前页数据
        int start = (pageIndex - 1) * pageSize;
        List<StudentCourseGrade> list = studentCourseGradeDao.getGradesByPage(start, pageSize, keyword);
        pageBean.setList(list);

        return pageBean;
    }
}