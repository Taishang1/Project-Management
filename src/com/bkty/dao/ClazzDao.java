package com.bkty.dao;

import com.bkty.entity.Clazz;
import com.bkty.entity.TongJi;

import java.util.List;

public interface ClazzDao {
    List<TongJi> getTongJi();

    int updateClazz(Clazz clazz);

    List<Clazz> getClazzByPage(int start, int size);

    int getTotalCount();

    List<Clazz> getAll();

    int addClazz(Clazz clazz);

    List<Clazz> getAllClazz();

    int getTotalCount(String keyword);

    List<Clazz> getClazzByPage(int start, int size, String keyword);

    Clazz getClazzById(int cid);

    int deleteClazz(int cid);
}