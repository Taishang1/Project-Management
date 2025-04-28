<%--
  Created by IntelliJ IDEA.
  User: 支全亮
  Date: 2025/3/13
  Time: 0:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta name="renderer" content="webkit">
    <title>学生选课列表</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/pintuer.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="js/jquery.js"></script>
    <script src="js/pintuer.js"></script>

    <style>
        .panel {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            margin: 20px;
            overflow: hidden;
        }
        
        .panel-head {
            background: linear-gradient(120deg, #2c3e50, #3498db);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
        }
        
        .panel-head strong {
            font-size: 18px;
        }
        
        .search-box {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .search-input {
            flex: 1;
            max-width: 300px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 8px 12px;
            transition: all 0.3s;
        }
        
        .search-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52,152,219,0.3);
        }
        
        .search-btn {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .search-btn:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .table {
            margin: 0;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table th {
            background: #f4f6f9;
            color: #2c3e50;
            font-weight: 600;
            padding: 12px 8px;
        }
        
        .table td {
            padding: 12px 8px;
            border-bottom: 1px solid #eee;
            transition: all 0.3s;
            vertical-align: middle;
            line-height: 1.5;
        }
        
        .table tr:hover td {
            background: #f8f9fa;
        }
        
        .btn {
            padding: 6px 12px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
            border: none;
        }
        
        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            padding: 20px 0;
        }
        
        .pagination li {
            list-style: none;
        }
        
        .pagination a, .pagination span {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #3498db;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .pagination .active span {
            background: #3498db;
            color: white;
            border-color: #3498db;
        }
        
        .loading {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 20px 40px;
            border-radius: 8px;
            display: none;
        }
        
        .button-group .button {
            padding: 6px 15px;
            font-size: 14px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .button-group .button.border-red {
            background: #e74c3c;
            color: white;
            border: none;
        }
        
        .button-group .button.border-blue {
            background: #3498db;
            color: white;
            border: none;
        }
        
        .button-group .button.border-red:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .button-group .button.border-blue:hover {
            background: #2980b9;
            transform: translateY(-2px);
        }
        
        .button-group .button i {
            margin-right: 5px;
        }
        
        .add-btn {
            background: #2ecc71;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
        }
        
        .add-btn:hover {
            background: #27ae60;
            transform: translateY(-2px);
        }
        
        .add-btn i {
            margin-right: 5px;
        }
    </style>

    <script>
        $(function () {
            loadStudentCourses(1);
            
            $('#searchBtn').click(function() {
                loadStudentCourses(1);
            });
        });

        function loadStudentCourses(page) {
            $.ajax({
                url: 'StudentCourseServlet',
                method: 'GET',
                data: {
                    methodName: 'getAllStudentCourses',
                    page: page,
                    keyword: $('#keyword').val()
                },
                dataType: 'json',
                success: function(data) {
                    if (data.error) {
                        alert("加载数据失败: " + data.error);
                        return;
                    }
                    displayStudentCourses(data.list);
                    displayPagination(data);
                },
                error: function(xhr, status, error) {
                    console.error("请求失败:", error);
                    alert("加载数据失败");
                }
            });
        }

        function displayStudentCourses(courses) {
            var tbody = $('#studentCourseList tbody');
            tbody.empty();
            if (!courses || courses.length === 0) {
                tbody.append('<tr><td colspan="4" class="text-center">没有找到相关数据</td></tr>');
                return;
            }
            
            courses.forEach(function(course) {
                tbody.append(
                    '<tr>' +
                    '<td>' + (course.student ? course.student.sname : '-') + '</td>' +
                    '<td>' + (course.course ? course.course.cname : '-') + '</td>' +
                    '<td>' + formatDate(course.selectTime) + '</td>' +
                    '<td>' +
                    '<div class="button-group">' +
                    '<a class="button border-blue" href="javascript:void(0)" onclick="editStudentCourse(' + course.scid + ')">' +
                    '<i class="fas fa-edit"></i> 编辑</a> ' +
                    '<a class="button border-red" href="javascript:void(0)" onclick="deleteStudentCourse(' + course.scid + ')">' +
                    '<i class="fas fa-trash-alt"></i> 删除</a>' +
                    '</div>' +
                    '</td>' +
                    '</tr>'
                );
            });
        }

        function displayPagination(pageBean) {
            var pagination = $('#pagination');
            pagination.empty();
            
            if (pageBean.index > 1) {
                pagination.append(
                    '<li><a href="javascript:void(0)" onclick="loadStudentCourses(' + 
                    (pageBean.index - 1) + ')">&laquo; 上一页</a></li>'
                );
            }

            for (var i = 1; i <= pageBean.totalPageCount; i++) {
                if (i === pageBean.index) {
                    pagination.append(
                        '<li class="active"><span>' + i + '</span></li>'
                    );
                } else {
                    pagination.append(
                        '<li><a href="javascript:void(0)" onclick="loadStudentCourses(' + i + ')">' + i + '</a></li>'
                    );
                }
            }

            if (pageBean.index < pageBean.totalPageCount) {
                pagination.append(
                    '<li><a href="javascript:void(0)" onclick="loadStudentCourses(' + 
                    (pageBean.index + 1) + ')">下一页 &raquo;</a></li>'
                );
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            try {
                const date = new Date(dateStr);
                if (isNaN(date.getTime())) {
                    return dateStr;
                }
                return date.toLocaleDateString('zh-CN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit',
                    hour: '2-digit',
                    minute: '2-digit'
                }).replace(/\//g, '-');
            } catch (e) {
                console.error('日期格式化失败:', e);
                return dateStr;
            }
        }

        function deleteStudentCourse(scid) {
            if (confirm('确定要删除该选课记录吗？此操作不可恢复。')) {
                $.get('StudentCourseServlet', {
                    methodName: 'deleteStudentCourse', 
                    scid: scid
                }, function (data) {
                    if (data == '1') {
                        alert('删除成功');
                        loadStudentCourses(1);
                    } else {
                        alert('删除失败，请稍后重试');
                    }
                });
            }
        }

        function editStudentCourse(scid) {
            location.href = 'editStudentCourse.jsp?scid=' + scid;
        }

        // 添加加载动画
        $(document).ajaxStart(function() {
            $('.loading').show();
        }).ajaxStop(function() {
            $('.loading').hide();
        });

        // 添加按钮事件
        $(function() {
            $('#addBtn').click(function() {
                location.href = 'addStudentCourse.jsp';
            });
        });
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong><i class="fas fa-list"></i> 学生选课列表</strong>
        </div>
        
        <div class="search-box">
            <input type="text" placeholder="请输入学生姓名或课程名称" id="keyword" class="search-input"/>
            <button class="search-btn" id="searchBtn">
                <i class="fas fa-search"></i> 搜索
            </button>
            <button class="add-btn" id="addBtn" style="background: #2ecc71; margin-left: 10px;">
                <i class="fas fa-plus"></i> 添加选课
            </button>
        </div>

        <table class="table" id="studentCourseList">
            <thead>
                <tr>
                    <th width="20%">学生姓名</th>
                    <th width="25%">课程名称</th>
                    <th width="20%">选课时间</th>
                    <th width="15%">操作</th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        
        <div class="pagination" id="pagination"></div>
    </div>

    <div class="loading">
        <i class="fas fa-spinner fa-spin"></i> 加载中...
    </div>
</body>
</html>