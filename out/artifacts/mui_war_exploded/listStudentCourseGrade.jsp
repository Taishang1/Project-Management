<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <meta name="renderer" content="webkit">
    <title>学生成绩列表</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .panel-head .button {
            margin-left: 10px;
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: normal;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .panel-head .button i {
            font-size: 14px;
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
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-bottom: 0;
        }
        
        .table th {
            background: #f4f6f9;
            color: #2c3e50;
            font-weight: 600;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e9ecef;
        }
        
        .table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        
        .table tr:hover td {
            background: #f8f9fa;
        }
        
        .grade-cell {
            font-weight: bold;
            color: #2c3e50;
        }
        
        .grade-pass {
            color: #27ae60;
        }
        
        .grade-fail {
            color: #e74c3c;
        }
        
        .button-group {
            display: flex;
            gap: 8px;
        }
        
        .btn-delete {
            padding: 6px 12px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-delete:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            padding: 20px 0;
            gap: 5px;
        }
        
        .pagination li {
            list-style: none;
        }
        
        .pagination a, .pagination span {
            padding: 8px 15px;
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
        
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-size: 16px;
        }
    </style>

    <script>
        $(function() {
            loadGrades(1);
            
            $('#searchBtn').click(function() {
                loadGrades(1);
            });
            
            // 添加加载动画
            $(document).ajaxStart(function() {
                $('.loading').show();
            }).ajaxStop(function() {
                $('.loading').hide();
            });
        });

        function searchGrades() {
            loadGrades(1);
        }

        function loadGrades(page) {
            $.ajax({
                url: 'StudentCourseGradeServlet',
                data: {
                    methodName: 'getAllGrades',
                    page: page,
                    keyword: $('#keyword').val()
                },
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    console.log("接收到的数据:", data);
                    if (data.error) {
                        console.error("服务器返回错误:", data.error);
                        alert("加载数据失败: " + data.error);
                        return;
                    }
                    if (!data.list) {
                        console.error("返回数据格式错误:", data);
                        alert("数据格式错误");
                        return;
                    }
                    displayGrades(data.list);
                    displayPagination(data);
                },
                error: function(xhr, status, error) {
                    console.error("请求失败:", error);
                    console.error("状态:", status);
                    console.error("响应文本:", xhr.responseText);
                    alert("加载数据失败: " + error);
                }
            });
        }

        function displayGrades(grades) {
            var tbody = $('#gradeList tbody');
            tbody.empty();
            if (grades.length === 0) {
                tbody.append('<tr><td colspan="5" style="text-align: center;">没有找到相关数据</td></tr>');
                return;
            }
            for (var i = 0; i < grades.length; i++) {
                var grade = grades[i];
                tbody.append(
                    '<tr>' +
                    '<td>' + (grade.student ? (grade.student.sid + ' - ' + grade.student.sname) : '未知学生') + '</td>' +
                    '<td>' + (grade.course ? (grade.course.cid + ' - ' + grade.course.cname) : '未知课程') + '</td>' +
                    '<td>' + (grade.grade !== null ? grade.grade.toFixed(1) : '暂无成绩') + '</td>' +
                    '<td>' + formatDate(grade.examDate) + '</td>' +
                    '<td>' +
                    '<div class="button-group">' +
                    '<a class="button border-blue" href="editGrade.jsp?scgid=' + grade.scgid + '">' +
                    '<i class="fas fa-edit"></i> 编辑</a>' +
                    '<a class="button border-red" href="javascript:void(0)" onclick="deleteGrade(' + grade.scgid + ')">' +
                    '<span class="icon-trash-o"></span> 删除</a>' +
                    '</div>' +
                    '</td>' +
                    '</tr>'
                );
            }
        }

        function displayPagination(pageBean) {
            var pagination = $('#pagination');
            pagination.empty();

            // 上一页
            if (pageBean.index > 1) {
                pagination.append(
                    '<li><a href="javascript:void(0)" onclick="loadGrades(' +
                    (pageBean.index - 1) + ')">&laquo; 上一页</a></li>'
                );
            }

            // 页码按钮
            for (var i = 1; i <= pageBean.totalPageCount; i++) {
                if (i === pageBean.index) {
                    pagination.append(
                        '<li class="active"><span>' + i + '</span></li>'
                    );
                } else {
                    pagination.append(
                        '<li><a href="javascript:void(0)" onclick="loadGrades(' + i + ')">' + i + '</a></li>'
                    );
                }
            }

            // 下一页
            if (pageBean.index < pageBean.totalPageCount) {
                pagination.append(
                    '<li><a href="javascript:void(0)" onclick="loadGrades(' +
                    (pageBean.index + 1) + ')">下一页 &raquo;</a></li>'
                );
            }
        }

        function deleteGrade(scgid) {
            if (confirm('确定要删除该成绩记录吗？')) {
                $.get('StudentCourseGradeServlet', { methodName: 'deleteGrade', scgid: scgid }, function (data) {
                    if (data == '1') {
                        alert('删除成功');
                        loadGrades(1);
                    } else {
                        alert('删除失败');
                    }
                });
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '';
            try {
                const date = new Date(dateStr);
                if (isNaN(date.getTime())) {
                    console.error('Invalid date:', dateStr);
                    return dateStr;
                }
                return date.toLocaleDateString('zh-CN', {
                    year: 'numeric',
                    month: '2-digit',
                    day: '2-digit'
                }).replace(/\//g, '-');
            } catch (e) {
                console.error('日期格式化失败:', e);
                return dateStr;
            }
        }
    </script>
</head>
<body>
    <div class="panel">
        <div class="panel-head">
            <strong><i class="fas fa-graduation-cap"></i> 学生成绩列表</strong>
            <a href="addGrade.jsp" class="button bg-main">
                <i class="fas fa-plus"></i> 添加成绩
            </a>
        </div>
        
        <div class="search-box">
            <input type="text" placeholder="请输入学生姓名或课程名称" id="keyword" class="search-input"/>
            <button class="search-btn" id="searchBtn">
                <i class="fas fa-search"></i> 搜索
            </button>
        </div>

        <table class="table" id="gradeList">
            <thead>
                <tr>
                    <th width="20%">学生姓名</th>
                    <th width="25%">课程名称</th>
                    <th width="15%">成绩</th>
                    <th width="20%">考试日期</th>
                    <th width="20%">操作</th>
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