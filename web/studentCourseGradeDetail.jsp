<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/13
  Time: 0:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bkty.entity.StudentCourseGrade" %>
<%@ page import="com.bkty.service.StudentCourseGradeService" %>
<%@ page import="com.bkty.service.impl.StudentCourseGradeServiceImpl" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>学生成绩详情</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            var sid = '<%= request.getParameter("sid") %>';
            var cid = '<%= request.getParameter("cid") %>';
            if (sid && cid) {
                loadGrade(sid, cid);
            } else {
                alert('未提供学生ID或课程ID');
                location.href = 'listStudentCourse.jsp';
            }
        });

        function loadGrade(sid, cid) {
            $.get('StudentCourseGradeServlet', { methodName: 'getGradeByStudentAndCourse', sid: sid, cid: cid }, function (data) {
                var grade = JSON.parse(data);
                if (grade) {
                    $('#studentInfo').text(grade.student.sid + ' - ' + grade.student.sname);
                    $('#courseInfo').text(grade.course.cid + ' - ' + grade.course.cname);
                    $('#grade').text(grade.grade);
                    $('#examDate').text(grade.examDate ? grade.examDate : '未记录');
                    $('#editBtn').show();
                } else {
                    $('#studentInfo').text(grade.student.sid + ' - ' + grade.student.sname);
                    $('#courseInfo').text(grade.course.cid + ' - ' + grade.course.cname);
                    $('#grade').text('未记录');
                    $('#examDate').text('未记录');
                    $('#editBtn').hide();
                }
            });
        }

        function editGrade(sid, cid) {
            location.href = 'editGrade.jsp?sid=' + sid + '&cid=' + cid;
        }
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong class="icon-reorder"> 学生成绩详情</strong></div>
    <div class="body-content">
        <div class="form-group">
            <div class="label">
                <label>学生信息：</label>
            </div>
            <div class="field">
                <p id="studentInfo"></p>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>课程信息：</label>
            </div>
            <div class="field">
                <p id="courseInfo"></p>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>成绩：</label>
            </div>
            <div class="field">
                <p id="grade"></p>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label>考试日期：</label>
            </div>
            <div class="field">
                <p id="examDate"></p>
            </div>
        </div>
        <div class="form-group">
            <div class="label">
                <label></label>
            </div>
            <div class="field">
                <button class="button bg-main icon-edit" id="editBtn" onclick="editGrade('<%= request.getParameter("sid") %>', '<%= request.getParameter("cid") %>')" style="display: none;">编辑成绩</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
