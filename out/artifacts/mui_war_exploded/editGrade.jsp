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
    <title>编辑成绩</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <script>
        $(function () {
            var scgid = '<%= request.getParameter("scgid") %>';
            if (scgid && scgid != 'null') {
                $.ajax({
                    url: 'StudentCourseGradeServlet',
                    data: { methodName: 'getGradeById', scgid: scgid },
                    method: 'GET',
                    dataType: 'json',
                    success: function (grade) {
                        try {
                            if (typeof grade === 'string') {
                                grade = JSON.parse(grade);
                            }
                            $('#studentId').val(grade.student.sid);
                            $('#courseId').val(grade.course.cid);
                            $('#grade').val(grade.grade);
                            $('#examDate').val(grade.examDate ? grade.examDate.split(' ')[0] : '');
                        } catch (e) {
                            console.error("解析成绩数据失败:", e);
                            alert("加载成绩数据失败，请刷新重试");
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("请求失败:", error);
                        alert("加载成绩数据失败: " + error);
                    }
                });
            }

            // 加载学生列表
            $.ajax({
                url: 'StudentServlet',
                data: { methodName: 'getAllStudents' },
                method: 'GET',
                dataType: 'json',
                success: function (data) {
                    try {
                        var students = data;
                        if (typeof data === 'string') {
                            students = JSON.parse(data);
                        }
                        var studentSelect = $('#studentId');
                        studentSelect.empty().append('<option value="">--请选择学生--</option>');
                        for (var i = 0; i < students.length; i++) {
                            studentSelect.append('<option value="' + students[i].sid + '">' + students[i].sname + '</option>');
                        }
                    } catch (e) {
                        console.error("解析学生数据失败:", e);
                        alert("加载学生数据失败，请刷新重试");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("请求失败:", error);
                    alert("加载学生数据失败: " + error);
                }
            });

            // 加载课程列表
            $.ajax({
                url: 'CourseServlet',
                data: { methodName: 'getAllCourses' },
                method: 'GET',
                dataType: 'json',
                success: function (data) {
                    try {
                        var courses = data;
                        if (typeof data === 'string') {
                            courses = JSON.parse(data);
                        }
                        var courseSelect = $('#courseId');
                        courseSelect.empty().append('<option value="">--请选择课程--</option>');
                        for (var i = 0; i < courses.length; i++) {
                            courseSelect.append('<option value="' + courses[i].cid + '">' + courses[i].cname + '</option>');
                        }
                    } catch (e) {
                        console.error("解析课程数据失败:", e);
                        alert("加载课程数据失败，请刷新重试");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("请求失败:", error);
                    alert("加载课程数据失败: " + error);
                }
            });

            $('#submitBtn').click(function () {
                var scgid = '<%= request.getParameter("scgid") %>';
                var sid = $('#studentId').val();
                var cid = $('#courseId').val();
                var grade = $('#grade').val();
                var examDate = $('#examDate').val();

                if (!sid || !cid || !grade || !examDate) {
                    alert('请填写完整信息');
                    return;
                }

                $.post('StudentCourseGradeServlet', {
                    methodName: 'updateGrade',
                    scgid: scgid,
                    grade: grade,
                    exam_date: examDate
                }, function (data) {
                    if (data == '1') {
                        alert('更新成功');
                        location.href = 'listStudentCourseGrade.jsp';
                    } else {
                        alert('更新失败');
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="panel admin-panel">
    <div class="panel-head"><strong><span class="icon-pencil-square-o"></span>编辑成绩</strong></div>
    <div class="body-content">
        <form method="post" class="form-x" action="">
            <div class="form-group">
                <div class="label">
                    <label>学生：</label>
                </div>
                <div class="field">
                    <select class="input" name="studentId" id="studentId" style="width:30%">
                        <option value="">--请选择学生--</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>课程：</label>
                </div>
                <div class="field">
                    <select class="input" name="courseId" id="courseId" style="width:30%">
                        <option value="">--请选择课程--</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>成绩：</label>
                </div>
                <div class="field">
                    <input type="number" class="input" name="grade" id="grade" value="" style="width:30%"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label>考试日期：</label>
                </div>
                <div class="field">
                    <input type="date" class="input" name="examDate" id="examDate" value="" style="width:30%"/>
                </div>
            </div>
            <div class="form-group">
                <div class="label">
                    <label></label>
                </div>
                <div class="field">
                    <button class="button bg-main icon-check-square-o" id="submitBtn" type="button"> 提交</button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>
