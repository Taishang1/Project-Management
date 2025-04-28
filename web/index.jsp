<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <meta name="renderer" content="webkit">
  <title>班级管理后台系统</title>
  <base href="${pageContext.request.contextPath}/">
  <link rel="stylesheet" href="css/pintuer.css">
  <link rel="stylesheet" href="css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
  <script src="js/jquery.js"></script>
  <script src="js/pintuer.js"></script>
  <script src="js/echarts.min.js"></script>

  <style>
    /* 整体布局 */
    body {
      margin: 0;
      padding: 0;
      background: #f5f6fa;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* 顶部导航栏 */
    .header {
      background: linear-gradient(120deg, #2c3e50, #3498db);
      color: #fff;
      padding: 15px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      position: fixed;
      width: 100%;
      top: 0;
      z-index: 1000;
      box-sizing: border-box;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 15px;
    }

    .logo h1 {
      color: #ffffff;
      font-size: 20px;
      font-weight: 600;
      margin: 0;
      text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
    }

    .logo img {
      margin-right: 15px;
      border: 2px solid #fff;
      border-radius: 50%;
      width: 40px;
      height: 40px;
    }

    /* 时间日期显示 */
    .datetime-container {
      position: absolute;
      right: 30px;
      top: 50%;
      transform: translateY(-50%);
      color: #fff;
      font-family: 'Consolas', monospace;
      text-align: right;
    }
    
    .datetime-wrapper {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      position: relative;
      padding: 8px 15px;
      border-radius: 4px;
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(5px);
      -webkit-backdrop-filter: blur(5px);
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    
    .datetime-wrapper::before {
      content: '';
      position: absolute;
      left: 0;
      top: 5px;
      bottom: 5px;
      width: 3px;
      background: linear-gradient(to bottom, #3498db, #2ecc71);
      border-radius: 3px;
    }
    
    .datetime-time {
      font-size: 24px;
      font-weight: 700;
      letter-spacing: 1.5px;
      text-shadow: 0 0 10px rgba(52, 152, 219, 0.5);
      margin-bottom: 3px;
      position: relative;
    }
    
    .datetime-time::after {
      content: '';
      position: absolute;
      bottom: -2px;
      left: 0;
      width: 100%;
      height: 1px;
      background: rgba(255, 255, 255, 0.3);
    }
    
    .datetime-date {
      display: flex;
      flex-direction: column;
      font-size: 12px;
      opacity: 0.85;
      letter-spacing: 1px;
    }
    
    #current-day {
      margin-top: 2px;
      font-weight: 600;
      color: #a1e2ff;
    }
    
    /* 时间数字跳动动画 */
    @keyframes pulse {
      0% { transform: scale(1); }
      50% { transform: scale(1.03); }
      100% { transform: scale(1); }
    }
    
    .datetime-time .second {
      display: inline-block;
      animation: pulse 1s infinite;
      color: #74b9ff;
    }

    /* 左侧菜单 */
    .leftnav {
      position: fixed;
      left: 0;
      top: 70px;
      bottom: 0;
      width: 220px;
      background: #fff;
      box-shadow: 2px 0 10px rgba(0,0,0,0.1);
      overflow-y: auto;
      z-index: 999;
      overscroll-behavior: contain;
      scrollbar-width: thin;
      height: calc(100vh - 70px);
      display: flex;
      flex-direction: column;
    }

    /* 自定义滚动条样式 */
    .leftnav::-webkit-scrollbar {
      width: 8px;
    }

    .leftnav::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 4px;
    }

    .leftnav::-webkit-scrollbar-thumb {
      background: #bbb;
      border-radius: 4px;
    }

    .leftnav::-webkit-scrollbar-thumb:hover {
      background: #999;
    }

    .leftnav-title {
      background: #f8f9fa;
      padding: 15px 20px;
      border-bottom: 1px solid #eee;
      position: sticky;
      top: 0;
      z-index: 2;
    }

    .leftnav-title strong {
      color: #2c3e50; /* 深色文字确保可见 */
      font-weight: bold;
      font-size: 16px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .leftnav-title strong i {
      color: #3498db; /* 图标使用蓝色 */
    }

    .leftnav-content {
      flex: 1;
      overflow-y: auto;
      padding-bottom: 50px; /* 增加底部填充，确保最后一项可见 */
    }

    .leftnav h2 {
      padding: 12px 20px;
      color: #2c3e50;
      font-size: 16px;
      cursor: pointer;
      margin: 0;
      display: flex;
      align-items: center;
      gap: 8px;
      background: linear-gradient(to right, #f8f9fa, #fff);
    }

    .leftnav h2 i {
      width: 20px;
      text-align: center;
      color: #3498db;
    }

    .leftnav ul {
      padding: 0;
      margin: 0;
      list-style: none;
      display: none;
    }

    .leftnav ul.active {
      display: block;
    }

    .leftnav ul li a {
      display: flex;
      align-items: center;
      padding: 10px 20px 10px 40px;
      color: #666;
      text-decoration: none;
      gap: 8px;
    }

    .leftnav ul li a i {
      font-size: 12px;
      width: 15px;
      text-align: center;
      color: #3498db;
    }

    .leftnav ul li a:hover {
      background: rgba(52, 152, 219, 0.1);
      color: #3498db;
      padding-left: 45px;
      transition: all 0.3s;
    }

    .leftnav ul li a:hover i {
      transform: translateX(3px);
      transition: transform 0.3s;
    }

    /* 激活菜单项样式 */
    .leftnav ul li a.active {
      background: #f1f2f6;
      color: #3498db;
      border-left: 4px solid #3498db;
      font-weight: 500;
    }

    /* 主要内容区域 */
    .admin {
      background: #fff;
      position: fixed;
      top: 70px;
      left: 220px;
      right: 0;
      bottom: 0;
      overflow: auto;
      padding: 0;
      margin: 0;
      box-sizing: border-box;
      border-left: 1px solid #b5cfd9;
    }

    #content-container {
      width: 100%;
      min-height: 300px;
      padding: 20px;
      box-sizing: border-box;
    }

    /* 图表容器 */
    .chart-container {
      background: #fff;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      margin: 0 20px 20px;
      width: calc(100% - 40px);
      box-sizing: border-box;
    }

    #chart {
      height: 400px;
      width: 100%;
    }

    /* 面包屑导航 */
    .bread {
      padding: 15px 20px;
      margin-bottom: 0;
      border-bottom: 1px solid #eee;
      background: #fff;
    }

    .bread li {
      display: inline-block;
      margin-right: 10px;
    }

    .bread li a {
      color: #666;
      text-decoration: none;
    }

    /* 响应式设计 */
    @media (max-width: 768px) {
      .leftnav {
        width: 180px;
      }
      .admin {
        margin-left: 180px;
      }
    }

    /* 动画效果 */
    .leftnav h2, .leftnav ul li a {
      position: relative;
      overflow: hidden;
    }

    .leftnav h2:after, .leftnav ul li a:after {
      content: '';
      position: absolute;
      left: 0;
      bottom: 0;
      height: 2px;
      width: 0;
      background: #3498db;
      transition: width 0.3s;
    }

    .leftnav h2:hover:after, .leftnav ul li a:hover:after {
      width: 100%;
    }
  </style>
</head>
<body>
<!-- 顶部导航栏 -->
<div class="header">
  <div class="logo">
    <img src="${sessionScope.user.head != null ? sessionScope.user.head : 'images/default-avatar.png'}"
         class="radius-circle" height="40" alt="用户头像">
    <h1>班级管理后台系统</h1>
  </div>
  <div class="datetime-container">
    <div class="datetime-wrapper">
      <div class="datetime-time" id="current-time">00:00:00</div>
      <div class="datetime-date">
        <span id="current-date">2023-01-01</span>
        <span id="current-day">星期一</span>
      </div>
    </div>
  </div>
</div>

<!-- 左侧菜单 -->
<div class="leftnav">
  <div class="leftnav-title">
    <strong><i class="fas fa-list"></i> 功能菜单</strong>
  </div>
  <div class="leftnav-content">
    <h2><i class="fas fa-users"></i> 班级管理</h2>
    <ul>
      <li><a href="listClazz.jsp"><i class="fas fa-chevron-right"></i> 展示班级</a></li>
    </ul>
    <h2><i class="fas fa-user-graduate"></i> 学生管理</h2>
    <ul>
      <li><a href="listStudent.jsp"><i class="fas fa-chevron-right"></i> 展示学生</a></li>
    </ul>
    <h2><i class="fas fa-book"></i> 课程管理</h2>
    <ul>
      <li><a href="listCourse.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示课程</a></li>
    </ul>
    <h2><i class="fas fa-clipboard-list"></i> 选课管理</h2>
    <ul>
      <li><a href="listStudentCourse.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示选课</a></li>
    </ul>
    <h2><i class="fas fa-chart-line"></i> 成绩管理</h2>
    <ul>
      <li><a href="listStudentCourseGrade.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示成绩</a></li>
    </ul>
    <h2><i class="fas fa-chalkboard-teacher"></i> 教师管理</h2>
    <ul>
      <li><a href="listTeacher.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示教师</a></li>
    </ul>
    <h2><i class="fas fa-tasks"></i> 教学计划</h2>
    <ul>
      <li><a href="listTeachingPlan.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示计划</a></li>
    </ul>
    <h2><i class="fas fa-calendar-check"></i> 考勤管理</h2>
    <ul>
      <li><a href="listAttendance.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示考勤</a></li>
    </ul>
    <h2><i class="fas fa-bullhorn"></i> 通知公告</h2>
    <ul>
      <li><a href="listAnnouncement.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示公告</a></li>
    </ul>
    <h2><i class="fas fa-history"></i> 系统日志</h2>
    <ul>
      <li><a href="listSystemLog.jsp" target="right"><i class="fas fa-chevron-right"></i> 展示日志</a></li>
    </ul>
    <h2><i class="fas fa-cogs"></i> 系统管理</h2>
    <ul>
      <li><a href="admin/roleManagement.jsp" target="right"><i class="fas fa-user-shield"></i> 角色管理</a></li>
      <li><a href="admin/permissionManagement.jsp" target="right"><i class="fas fa-key"></i> 权限管理</a></li>
    </ul>
  </div>
</div>

<!-- 主要内容区域 -->
<div class="admin">
  <div class="bread">
    <ul>
      <li><a href="welcome.jsp" id="home-link"><i class="fas fa-home"></i> 首页</a></li>
      <li><i class="fas fa-angle-right"></i></li>
      <li><span id="current-page">控制台</span></li>
    </ul>
  </div>
  <div id="content-container"></div>
  <div class="chart-container">
    <div id="chart"></div>
  </div>
</div>

<script type="text/javascript">
  $(function(){
    // 确保头部和导航栏样式
    function ensureStyles() {
      $(".header").css({
        "background": "linear-gradient(120deg, #2c3e50, #3498db)",
        "padding": "15px 30px",
        "box-shadow": "0 2px 10px rgba(0,0,0,0.1)",
        "position": "fixed",
        "width": "100%",
        "top": "0",
        "z-index": "1000"
      });
      
      // 确保左侧导航样式
      $(".leftnav").css({
        "position": "fixed",
        "left": "0",
        "top": "70px",
        "bottom": "0",
        "width": "220px",
        "background": "#fff",
        "box-shadow": "2px 0 10px rgba(0,0,0,0.1)",
        "overflow-y": "auto",
        "z-index": "999",
        "overscroll-behavior": "contain",
        "scrollbar-width": "thin",
        "height": "calc(100vh - 70px)",
        "display": "flex",
        "flex-direction": "column"
      });
      
      $(".leftnav-title").css({
        "background": "#f8f9fa",
        "padding": "15px 20px",
        "border-bottom": "1px solid #eee",
        "position": "sticky",
        "top": "0",
        "z-index": "2"
      });
      
      $(".leftnav-title strong").css({
        "color": "#2c3e50",
        "font-weight": "bold",
        "font-size": "16px",
        "display": "flex",
        "align-items": "center",
        "gap": "8px"
      });
      
      $(".leftnav-title strong i").css({
        "color": "#3498db"
      });
      
      $(".leftnav-content").css({
        "flex": "1",
        "overflow-y": "auto",
        "padding-bottom": "50px"
      });
      
      $(".leftnav h2").css({
        "padding": "12px 20px",
        "color": "#2c3e50",
        "font-size": "16px",
        "cursor": "pointer",
        "margin": "0",
        "display": "flex",
        "align-items": "center",
        "gap": "8px",
        "background": "linear-gradient(to right, #f8f9fa, #fff)"
      });
      
      $(".leftnav h2 i").css({
        "width": "20px",
        "text-align": "center",
        "color": "#3498db"
      });
      
      $(".leftnav ul li a").css({
        "display": "flex",
        "align-items": "center",
        "padding": "10px 20px 10px 40px",
        "color": "#666",
        "text-decoration": "none",
        "gap": "8px"
      });
      
      $(".leftnav ul li a i").css({
        "font-size": "12px",
        "width": "15px",
        "text-align": "center",
        "color": "#3498db"
      });
      
      // 确保日期时间可见
      $(".datetime-container").css({
        "position": "absolute",
        "right": "30px",
        "top": "50%",
        "transform": "translateY(-50%)",
        "color": "#fff",
        "font-family": "'Consolas', monospace",
        "text-align": "right"
      });
      
      $(".datetime-wrapper").css({
        "display": "flex",
        "flex-direction": "column",
        "align-items": "flex-end",
        "position": "relative",
        "padding": "8px 15px",
        "border-radius": "4px",
        "background": "rgba(255, 255, 255, 0.1)",
        "backdrop-filter": "blur(5px)",
        "-webkit-backdrop-filter": "blur(5px)",
        "box-shadow": "0 4px 6px rgba(0, 0, 0, 0.1)"
      });
      
      $(".datetime-wrapper::before").css({
        "content": "''",
        "position": "absolute",
        "left": "0",
        "top": "5px",
        "bottom": "5px",
        "width": "3px",
        "background": "linear-gradient(to bottom, #3498db, #2ecc71)",
        "border-radius": "3px"
      });
      
      $(".datetime-time").css({
        "font-size": "24px",
        "font-weight": "700",
        "letter-spacing": "1.5px",
        "text-shadow": "0 0 10px rgba(52, 152, 219, 0.5)",
        "margin-bottom": "3px",
        "position": "relative"
      });
      
      $(".datetime-time::after").css({
        "content": "''",
        "position": "absolute",
        "bottom": "-2px",
        "left": "0",
        "width": "100%",
        "height": "1px",
        "background": "rgba(255, 255, 255, 0.3)"
      });
      
      $(".datetime-time .second").css({
        "display": "inline-block",
        "animation": "pulse 1s infinite",
        "color": "#74b9ff"
      });
      
      $(".datetime-date").css({
        "display": "flex",
        "flex-direction": "column",
        "font-size": "12px",
        "opacity": "0.85",
        "letter-spacing": "1px"
      });
      
      $("#current-day").css({
        "margin-top": "2px",
        "font-weight": "600",
        "color": "#a1e2ff"
      });
      
      // 确保logo样式
      $(".logo h1").css({
        "color": "#fff",
        "margin": "0",
        "font-size": "24px"
      });
      
      $(".logo img").css({
        "margin-right": "15px",
        "border": "2px solid #fff",
        "border-radius": "50%",
        "width": "40px",
        "height": "40px"
      });
    }
    
    // 页面加载后立即应用样式
    ensureStyles();
    
    // 每5秒钟检查一次样式
    setInterval(ensureStyles, 5000);
    
    // 菜单展开/收起
    $(".leftnav h2").click(function(){
      $(this).next().slideToggle(200);
      $(this).toggleClass("on");
      ensureStyles();
    });

    // 处理首页链接点击
    $("#home-link").click(function(e){
      e.preventDefault();
      $("#current-page").text("控制台");
      
      // 显示图表容器
      $(".chart-container").show();
      
      // 加载内容
      $("#content-container").html('<div class="loading" style="text-align:center;padding:50px;">加载中...</div>');
      $.ajax({
        url: 'welcome.jsp',
        type: 'GET',
        success: function(response) {
          $("#content-container").html(response);
          loadStatisticsChart();
          ensureStyles();
        },
        error: function() {
          $("#content-container").html('<div class="error-message" style="text-align:center;padding:50px;color:red;">加载失败，请稍后重试</div>');
        }
      });
      
      return false;
    });

    // 处理菜单点击
    $(".leftnav ul li a").click(function(e){
      e.preventDefault();
      var url = $(this).attr("href");
      var menuText = $(this).text();
      $("#current-page").text(menuText);
      
      // 移除所有菜单项的active类，并为当前点击项添加active类
      $(".leftnav ul li a").removeClass("active");
      $(this).addClass("active");
      
      // 隐藏图表容器，只在首页显示
      $(".chart-container").hide();
      
      // 加载内容
      $("#content-container").html('<div class="loading" style="text-align:center;padding:50px;">加载中...</div>');
      $.ajax({
        url: url,
        type: 'GET',
        success: function(response) {
          // 提取内容部分，忽略头部等
          var $content = $(response);
          var mainContent = $content.find('.main').html() || response;
          $("#content-container").html(mainContent);
          
          // 确保所有表格和表单有正确的样式
          $("#content-container table").addClass("table");
          $("#content-container form").addClass("form-x");
          
          // 重新绑定事件
          rebindEvents();
          
          // 确保头部和导航栏样式不丢失
          ensureStyles();
        },
        error: function() {
          $("#content-container").html('<div class="error-message" style="text-align:center;padding:50px;color:red;">加载失败，请稍后重试</div>');
        }
      });
    });
    
    // 重新绑定加载内容后的事件
    function rebindEvents() {
      $("#content-container button, #content-container .button").on("click", function() {
        $(this).addClass("hover");
        setTimeout(function() {
          $(this).removeClass("hover");
        }.bind(this), 200);
      });
    }

    // 更新时间
    function updateDateTime() {
      var now = new Date();
      
      // 格式化时间组件
      var hours = String(now.getHours()).padStart(2, '0');
      var minutes = String(now.getMinutes()).padStart(2, '0');
      var seconds = String(now.getSeconds()).padStart(2, '0');
      
      // 创建带HTML的时间字符串，让秒数有动画效果
      var timeHtml = '<span class="hour">' + hours + '</span>:' +
                     '<span class="minute">' + minutes + '</span>:' +
                     '<span class="second">' + seconds + '</span>';
      
      // 格式化日期 YYYY-MM-DD
      var dateStr = now.getFullYear() + '-' + 
                   String(now.getMonth() + 1).padStart(2, '0') + '-' + 
                   String(now.getDate()).padStart(2, '0');
      
      // 星期
      var dayStr = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'][now.getDay()];
      
      // 更新显示
      $("#current-time").html(timeHtml);
      $("#current-date").text(dateStr);
      $("#current-day").text(dayStr);
    }

    updateDateTime();
    setInterval(updateDateTime, 1000);

    // 初始加载欢迎页面
    $.ajax({
      url: 'welcome.jsp',
      type: 'GET',
      success: function(response) {
        $("#content-container").html(response);
        // 首页显示图表
        $(".chart-container").show();
        // 加载统计图表
        loadStatisticsChart();
        
        // 确保头部和导航栏样式
        ensureStyles();
      }
    });
  });

  function loadStatisticsChart() {
    // 获取班级统计
    $.get('ClazzServlet', { methodName: 'getTongJi' }, function (data) {
      var clazzStats;
      try {
        // Check if data is already an object
        if (typeof data === 'object' && data !== null) {
          clazzStats = data;
        } else {
          clazzStats = JSON.parse(data);
        }
      } catch (e) {
        console.error("Error parsing class statistics:", e);
        clazzStats = []; // Use empty array as fallback
      }

      // 初始化 ECharts 实例
      var chartDom = document.getElementById('chart');
      if (!chartDom) {
        console.error("Chart container not found");
        return;
      }
      
      var myChart = echarts.init(chartDom);
      
      // 准备数据
      var classNames = [];
      var studentCounts = [];
      
      // 确保clazzStats是数组并且有数据
      if (Array.isArray(clazzStats) && clazzStats.length > 0) {
        clazzStats.forEach(function(item) {
          classNames.push(item.name || '未命名班级');
          studentCounts.push(item.count || 0);
        });
      }

      // 指定图表的配置项和数据
      var option = {
        title: {
          text: '班级人数统计',
          left: 'center',
          top: 10,
          textStyle: {
            fontSize: 18
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          },
          formatter: '{b}: {c}人'
        },
        grid: {
          left: '5%',
          right: '5%',
          bottom: '10%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: classNames,
          axisLabel: {
            interval: 0,
            rotate: 30,
            textStyle: {
              fontSize: 12
            }
          }
        },
        yAxis: {
          type: 'value',
          name: '学生人数',
          minInterval: 1,
          axisLabel: {
            formatter: '{value}人'
          }
        },
        series: [
          {
            name: '班级人数',
            type: 'bar',
            data: studentCounts,
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                {offset: 0, color: '#83bff6'},
                {offset: 0.5, color: '#188df0'},
                {offset: 1, color: '#188df0'}
              ])
            },
            emphasis: {
              itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  {offset: 0, color: '#2378f7'},
                  {offset: 0.7, color: '#2378f7'},
                  {offset: 1, color: '#83bff6'}
                ])
              }
            },
            label: {
              show: true,
              position: 'top',
              formatter: '{c}人',
              fontSize: 12,
              color: '#666'
            }
          }
        ]
      };

      // 使用刚指定的配置项和数据显示图表
      myChart.setOption(option);

      // 响应式调整图表大小
      window.addEventListener('resize', function () {
        myChart.resize();
      });
    });
  }
</script>
</body>
</html>