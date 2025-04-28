<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="main">
  <div class="content-header">
    <h2>欢迎使用班级后台管理系统</h2>
    <p>您好，用户ID: ${sessionScope.user.uid}，欢迎登录系统</p>
  </div>
  
  <div class="content-body">
    <div class="welcome-info">
      <p>在这里，您可以管理班级、学生、课程等相关信息</p>
      <p class="login-info">
        登录时间：${sessionScope.loginTime}<br>
        今日是：${sessionScope.today}
      </p>
    </div>
    </div>
</div>

<style>
  .content-header {
    margin-bottom: 20px;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
  }
  
  .content-header h2 {
    font-size: 24px;
    color: #333;
    margin: 0 0 10px 0;
  }
  
  .content-header p {
    color: #666;
    margin: 0;
  }
  
  .content-body {
    padding: 15px 0;
  }
  
  .welcome-info {
    background: #f8f9fa;
    border-left: 4px solid #3498db;
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 0 4px 4px 0;
  }
  
  .login-info {
    margin-top: 15px;
    padding-top: 10px;
    border-top: 1px dashed #ccc;
    color: #555;
    font-size: 14px;
  }
</style>