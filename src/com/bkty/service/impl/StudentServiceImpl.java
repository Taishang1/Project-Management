package com.bkty.service.impl;

import com.bkty.dao.StudentDao;
import com.bkty.dao.impl.StudentDaoImpl;
import com.bkty.entity.Clazz;
import com.bkty.entity.PageBean;
import com.bkty.entity.Student;
import com.bkty.service.StudentService;
import com.bkty.service.ClazzService;

import java.util.List;

public class StudentServiceImpl implements StudentService {

    private StudentDao studentDao = new StudentDaoImpl();
    private ClazzService clazzService = new ClazzServiceImpl();

    @Override
    public List<Student> getAll(String sname, String phone) {
        return studentDao.getStudentByPage(0, Integer.MAX_VALUE, sname, phone);
    }

    @Override
    public int addStudent(Student student) {
        return studentDao.addStudent(student);
    }

    @Override
    public PageBean<Student> getStudentByPage(int index, String sname, String phone) {
        PageBean<Student> pageBean = new PageBean<>();
        pageBean.setIndex(index);
        pageBean.setSize(10); // 每页显示10条记录

        // 获取总记录数
        int totalCount = studentDao.getTotalCount(sname, phone);
        pageBean.setTotalCount(totalCount);

        // 获取当前页数据
        int start = (index - 1) * pageBean.getSize();
        List<Student> list = studentDao.getStudentByPage(start, pageBean.getSize(), sname, phone);
        pageBean.setList(list);

        return pageBean;
    }

    @Override
    public int updateStudent(Student student) {
        return studentDao.updateStudent(student);
    }

    @Override
    public Student getStudentById(int sid) {
        return studentDao.getStudentById(sid);
    }

    @Override
    public boolean deleteStudent(int sid) {
        return studentDao.deleteStudent(sid);
    }

    @Override
    public List<Clazz> getAllClazz() {
        return clazzService.getAllClazz();
    }

    @Override
    public boolean batchSaveStudents(List<Student> students) {
        return studentDao.batchSaveStudents(students);
    }

    @Override
    public int getStudentCount() {
        return studentDao.getStudentCount();
    }
}