package com.bkty.service;

import com.bkty.entity.TeachingPlan;

import java.util.List;

public interface TeachingPlanService {

    // 添加教学计划
    boolean addTeachingPlan(TeachingPlan teachingPlan);

    // 更新教学计划
    boolean updateTeachingPlan(TeachingPlan teachingPlan);

    // 删除教学计划
    boolean deleteTeachingPlan(int tpid);

    // 根据ID获取教学计划
    TeachingPlan getTeachingPlanById(int tpid);

    // 获取所有教学计划
    List<TeachingPlan> getAllTeachingPlans();

    // 根据条件查询教学计划
    List<TeachingPlan> searchTeachingPlans(String keyword);
}