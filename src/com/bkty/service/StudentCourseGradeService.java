package com.bkty.service;

import com.bkty.entity.PageBean;
import com.bkty.entity.StudentCourseGrade;

import java.util.List;

public interface StudentCourseGradeService {

    // 获取所有成绩
    List<StudentCourseGrade> getAllGrades();

    // 获取成绩详情
    StudentCourseGrade getGradeById(int id);

    // 添加成绩
    int addGrade(StudentCourseGrade grade);

    // 更新成绩
    int updateGrade(StudentCourseGrade grade);

    // 删除成绩
    int deleteGrade(int id);

    // 获取学生某课程的成绩
    StudentCourseGrade getGradeByStudentAndCourse(int sid, int cid);

    // 根据条件查询成绩
    List<StudentCourseGrade> searchGrades(String keyword);

    // 分页查询
    PageBean<StudentCourseGrade> getStudentCourseGradeByPage(int pageIndex, String keyword);
}