package com.bkty.dao;

import com.bkty.entity.Clazz;
import com.bkty.entity.Student;

import java.util.List;

public interface StudentDao {
    int addStudent(Student student);

    int getTotalCount(String sname, String phone);

    List<Student> getStudentByPage(int start, int size, String sname, String phone);

    int updateStudent(Student student);

    Student getStudentById(int sid);

    int getStudentCount();

    boolean deleteStudent(int sid);

    int updateClazz(Clazz clazz);

    int addClazz(Clazz clazz);

    List<Student> getAll(String sname, String phone);

    int getStudentCount(String sname, String phone);

    List<Clazz> getAllClazz();

    boolean batchSaveStudents(List<Student> students);
}