package com.bkty.controller;

import com.bkty.entity.Announcement;
import com.bkty.service.AnnouncementService;
import com.bkty.service.impl.AnnouncementServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/AnnouncementServlet")
public class AnnouncementServlet extends BaseServlet {

    private AnnouncementService announcementService = new AnnouncementServiceImpl();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    // 添加通知公告
    protected void addAnnouncement(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String publisher = req.getParameter("publisher");
        resp.setContentType("text/html; charset=UTF-8");

        Announcement announcement = new Announcement(title, content, new Date(), publisher);

        boolean result = announcementService.addAnnouncement(announcement);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 更新通知公告
    protected void updateAnnouncement(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");
        String anidStr = req.getParameter("anid");
        int anid = Integer.parseInt(anidStr);
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String publisher = req.getParameter("publisher");

        Announcement announcement = new Announcement(anid, title, content, new Date(), publisher);

        boolean result = announcementService.updateAnnouncement(announcement);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 删除通知公告
    protected void deleteAnnouncement(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String anidStr = req.getParameter("anid");
        int anid = Integer.parseInt(anidStr);

        boolean result = announcementService.deleteAnnouncement(anid);
        resp.getWriter().write(result ? "1" : "0");
    }

    // 获取通知公告列表
    protected void getAllAnnouncements(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            resp.setContentType("application/json;charset=UTF-8");
            List<Announcement> announcements = announcementService.getAllAnnouncements();

            if (announcements != null) {
                StringBuilder jsonArray = new StringBuilder("[");

                for (int i = 0; i < announcements.size(); i++) {
                    Announcement announcement = announcements.get(i);
                    if (i > 0) {
                        jsonArray.append(",");
                    }

                    jsonArray.append("{")
                            .append("\"anid\":").append(announcement.getAnid())
                            .append(",\"title\":\"").append(escapeJson(announcement.getTitle())).append("\"")
                            .append(",\"content\":\"").append(escapeJson(announcement.getContent())).append("\"")
                            .append(",\"publishDate\":\"")
                            .append(announcement.getPublishDate() != null ? sdf.format(announcement.getPublishDate())
                                    : "")
                            .append("\"")
                            .append(",\"publisher\":\"").append(escapeJson(announcement.getPublisher())).append("\"")
                            .append("}");
                }

                jsonArray.append("]");
                String json = jsonArray.toString();
                System.out.println("返回公告JSON: " + json);
                resp.getWriter().write(json);
            } else {
                resp.getWriter().write("[]");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // 根据ID获取通知公告
    protected void getAnnouncementById(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String anidStr = req.getParameter("anid");
        int anid = Integer.parseInt(anidStr);
        Announcement announcement = announcementService.getAnnouncementById(anid);

        if (announcement != null) {
            StringBuilder json = new StringBuilder("{");
            json.append("\"anid\":").append(announcement.getAnid())
                    .append(",\"title\":\"").append(escapeJson(announcement.getTitle())).append("\"")
                    .append(",\"content\":\"").append(escapeJson(announcement.getContent())).append("\"")
                    .append(",\"publishDate\":\"")
                    .append(announcement.getPublishDate() != null ? sdf.format(announcement.getPublishDate()) : "")
                    .append("\"")
                    .append(",\"publisher\":\"").append(escapeJson(announcement.getPublisher())).append("\"")
                    .append("}");

            System.out.println("返回单个公告JSON: " + json.toString());
            resp.getWriter().write(json.toString());
        } else {
            resp.getWriter().write("{}");
        }
    }

    // 搜索通知公告
    protected void searchAnnouncements(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String keyword = req.getParameter("keyword");
            System.out.println("执行公告搜索，关键词: " + keyword);

            if (keyword == null || keyword.trim().isEmpty()) {
                // 如果关键词为空，则返回全部公告
                getAllAnnouncements(req, resp);
                return;
            }

            resp.setContentType("application/json;charset=UTF-8");
            List<Announcement> announcements = announcementService.searchAnnouncements(keyword);

            if (announcements != null) {
                StringBuilder jsonArray = new StringBuilder("[");

                for (int i = 0; i < announcements.size(); i++) {
                    Announcement announcement = announcements.get(i);
                    if (i > 0) {
                        jsonArray.append(",");
                    }

                    jsonArray.append("{")
                            .append("\"anid\":").append(announcement.getAnid())
                            .append(",\"title\":\"").append(escapeJson(announcement.getTitle())).append("\"")
                            .append(",\"content\":\"").append(escapeJson(announcement.getContent())).append("\"")
                            .append(",\"publishDate\":\"")
                            .append(announcement.getPublishDate() != null ? sdf.format(announcement.getPublishDate())
                                    : "")
                            .append("\"")
                            .append(",\"publisher\":\"").append(escapeJson(announcement.getPublisher())).append("\"")
                            .append("}");
                }

                jsonArray.append("]");
                String json = jsonArray.toString();
                System.out.println("搜索到的公告条数: " + announcements.size());
                System.out.println("返回搜索结果JSON: " + json);
                resp.getWriter().write(json);
            } else {
                resp.getWriter().write("[]");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            resp.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // 转义JSON字符串中的特殊字符
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}