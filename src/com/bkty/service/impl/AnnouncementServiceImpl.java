package com.bkty.service.impl;

import com.bkty.dao.AnnouncementDao;
import com.bkty.dao.impl.AnnouncementDaoImpl;
import com.bkty.entity.Announcement;
import com.bkty.service.AnnouncementService;

import java.util.List;

public class AnnouncementServiceImpl implements AnnouncementService {

    private AnnouncementDao announcementDao = new AnnouncementDaoImpl();

    @Override
    public boolean addAnnouncement(Announcement announcement) {
        return announcementDao.addAnnouncement(announcement) > 0;
    }

    @Override
    public boolean updateAnnouncement(Announcement announcement) {
        return announcementDao.updateAnnouncement(announcement) > 0;
    }

    @Override
    public boolean deleteAnnouncement(int anid) {
        return announcementDao.deleteAnnouncement(anid) > 0;
    }

    @Override
    public Announcement getAnnouncementById(int anid) {
        return announcementDao.getAnnouncementById(anid);
    }

    @Override
    public List<Announcement> getAllAnnouncements() {
        return announcementDao.getAllAnnouncements();
    }

    @Override
    public List<Announcement> searchAnnouncements(String keyword) {
        return announcementDao.searchAnnouncements(keyword);
    }
}