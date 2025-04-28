package com.bkty.service;

import com.bkty.entity.Clazz;
import com.bkty.entity.PageBean;
import com.bkty.entity.Student;

import java.util.List;

public interface StudentService {
    List<Student> getAll(String sname, String phone);

    int addStudent(Student student);

    PageBean<Student> getStudentByPage(int index, String sname, String phone);

    int updateStudent(Student student);

    Student getStudentById(int sid);

    boolean deleteStudent(int sid);

    List<Clazz> getAllClazz();

    boolean batchSaveStudents(List<Student> students);

    int getStudentCount();
}