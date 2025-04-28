package com.bkty.service;

import com.bkty.entity.Announcement;

import java.util.List;

public interface AnnouncementService {

    // 添加通知公告
    boolean addAnnouncement(Announcement announcement);

    // 更新通知公告
    boolean updateAnnouncement(Announcement announcement);

    // 删除通知公告
    boolean deleteAnnouncement(int anid);

    // 根据ID获取通知公告
    Announcement getAnnouncementById(int anid);

    // 获取所有通知公告
    List<Announcement> getAllAnnouncements();

    // 根据条件查询通知公告
    List<Announcement> searchAnnouncements(String keyword);
}