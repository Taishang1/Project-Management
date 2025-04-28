<%-- 创建一个公共的样式文件，供所有功能页面引用 --%>
<style>
    /* 通用样式 */
    body {
        background: #f5f6fa;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .panel {
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        margin: 20px;
        overflow: hidden;
    }

    .panel-head {
        background: linear-gradient(120deg, #2c3e50, #3498db);
        color: #fff;
        padding: 15px 20px;
    }

    .panel-head strong {
        font-size: 16px;
        font-weight: 500;
    }

    .body-content {
        padding: 20px;
    }

    /* 表单样式 */
    .form-group {
        margin-bottom: 20px;
    }

    .form-group .label {
        margin-bottom: 8px;
    }

    .form-group .label label {
        color: #2c3e50;
        font-weight: 500;
    }

    .input {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 8px 12px;
        transition: all 0.3s;
    }

    .input:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 2px rgba(52,152,219,0.2);
    }

    /* 按钮样式 */
    .button {
        border-radius: 4px;
        padding: 8px 16px;
        transition: all 0.3s;
    }

    .bg-main {
        background: #3498db;
    }

    .bg-main:hover {
        background: #2980b9;
    }

    /* 表格样式 */
    .table {
        width: 100%;
        margin-bottom: 1rem;
        background-color: transparent;
        border-collapse: collapse;
    }

    .table th,
    .table td {
        padding: 1rem;
        vertical-align: middle;
        border-top: 1px solid #dee2e6;
    }

    .table thead th {
        background: linear-gradient(120deg, #2c3e50, #3498db);
        color: white;
        font-weight: 500;
        border-bottom: 2px solid #dee2e6;
    }

    .table tbody tr:nth-of-type(odd) {
        background-color: rgba(0, 0, 0, .05);
    }

    .table tbody tr:hover {
        background-color: rgba(0, 0, 0, .075);
    }

    /* 搜索区域样式 */
    .search {
        background: #fff;
        padding: 15px;
        border-radius: 4px;
        margin-bottom: 20px;
    }

    .search .input {
        margin-right: 10px;
    }

    /* 操作按钮样式 */
    .button-group a {
        margin: 0 5px;
        padding: 4px 8px;
        border-radius: 3px;
    }

    /* 响应式布局 */
    @media (max-width: 768px) {
        .panel {
            margin: 10px;
        }
        
        .form-group .field {
            width: 100%;
        }
        
        .input {
            width: 100% !important;
        }
    }

    /* 按钮组样式 */
    .button-group {
        display: flex;
        gap: 8px;
        justify-content: center;
    }

    .button-group .button {
        padding: 6px 12px;
        border-radius: 4px;
        display: inline-flex;
        align-items: center;
        gap: 4px;
    }

    .border-blue {
        color: #3498db;
        border: 1px solid #3498db;
    }

    .border-blue:hover {
        background: #3498db;
        color: white;
    }

    .border-red {
        color: #e74c3c;
        border: 1px solid #e74c3c;
    }

    .border-red:hover {
        background: #e74c3c;
        color: white;
    }

    /* 空数据提示样式 */
    .empty-data {
        padding: 40px;
        text-align: center;
        color: #666;
        font-size: 16px;
    }

    .empty-data i {
        font-size: 48px;
        color: #ddd;
        margin-bottom: 10px;
        display: block;
    }

    /* 添加加载状态样式 */
    .loading {
        padding: 20px;
        text-align: center;
        color: #666;
    }

    .loading i {
        margin-right: 5px;
        color: #3498db;
    }

    /* 错误提示样式 */
    .error-message {
        padding: 20px;
        text-align: center;
        color: #e74c3c;
    }

    .error-message i {
        margin-right: 5px;
    }
</style> 