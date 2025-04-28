package com.bkty.dao.impl;

import com.bkty.dao.AnnouncementDao;
import com.bkty.dao.BaseDao;
import com.bkty.entity.Announcement;

import java.util.List;

public class AnnouncementDaoImpl extends BaseDao implements AnnouncementDao {

    @Override
    public int addAnnouncement(Announcement announcement) {
        String sql = "INSERT INTO announcement (title, content, publish_date, publisher) VALUES (?, ?, ?, ?)";
        return update(sql,
                announcement.getTitle(),
                announcement.getContent(),
                announcement.getPublishDate(),
                announcement.getPublisher());
    }

    @Override
    public int updateAnnouncement(Announcement announcement) {
        String sql = "UPDATE announcement SET title=?, content=?, publish_date=?, publisher=? WHERE anid=?";
        return update(sql,
                announcement.getTitle(),
                announcement.getContent(),
                announcement.getPublishDate(),
                announcement.getPublisher(),
                announcement.getAnid());
    }

    @Override
    public int deleteAnnouncement(int anid) {
        String sql = "DELETE FROM announcement WHERE anid=?";
        return update(sql, anid);
    }

    @Override
    public Announcement getAnnouncementById(int anid) {
        String sql = "SELECT anid, title, content, publish_date as publishDate, " +
                "publisher FROM announcement WHERE anid = ?";
        return queryForOne(Announcement.class, sql, anid);
    }

    @Override
    public List<Announcement> getAllAnnouncements() {
        String sql = "SELECT anid, title, content, publish_date as publishDate, " +
                "publisher FROM announcement ORDER BY publish_date DESC";
        try {
            System.out.println("执行公告查询SQL: " + sql);
            List<Announcement> list = queryForList(Announcement.class, sql);
            System.out.println("查询到公告记录数: " + (list != null ? list.size() : 0));
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("查询公告记录失败: " + e.getMessage());
        }
    }

    @Override
    public List<Announcement> searchAnnouncements(String keyword) {
        String sql = "SELECT anid, title, content, publish_date as publishDate, " +
                "publisher FROM announcement " +
                "WHERE title LIKE ? OR content LIKE ? " +
                "ORDER BY publish_date DESC";
        String pattern = "%" + keyword + "%";
        return queryForList(Announcement.class, sql, pattern, pattern);
    }
}