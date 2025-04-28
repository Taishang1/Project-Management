package com.bkty.dao;

import com.bkty.entity.StudentCourseGrade;

import java.util.List;

public interface StudentCourseGradeDao {

    // 添加成绩
    int addGrade(StudentCourseGrade grade);

    // 更新成绩
    int updateGrade(StudentCourseGrade grade);

    // 删除成绩
    int deleteGrade(int scgid);

    // 获取成绩详情
    StudentCourseGrade getGradeById(int scgid);

    // 获取学生某课程的成绩
    StudentCourseGrade getGradeByStudentAndCourse(int sid, int cid);

    // 获取所有成绩
    List<StudentCourseGrade> getAllGrades();

    // 根据条件查询成绩
    List<StudentCourseGrade> searchGrades(String keyword);

    List<StudentCourseGrade> getGradesByPage(int start, int size, String keyword);

    int getTotalCount(String keyword);
}