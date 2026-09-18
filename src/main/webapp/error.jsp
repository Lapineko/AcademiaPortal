<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/error.css">
    <title>错误页面</title>
</head>
<body>
    <%
        // 从request中获取errorMessage
        String errorMessage = (String) request.getAttribute("errorMessage");
    %>
    <div class="error-container">
        <h1 class="error-title">页面出错了</h1>
        <div class="error-message <%= errorMessage != null ? "permission-error" : "" %>">
            <% if(errorMessage != null) { %>
                <p><%= errorMessage %></p>
            <% } else if(exception != null) { %>
                <p>抱歉，处理您的请求时发生错误。</p>
                <p>错误信息：<%= exception.getMessage() %></p>
            <% } else { %>
                <p>抱歉，发生了未知错误。</p>
            <% } %>
        </div>
        <div class="button-group">
            <a href="javascript:history.back()" class="back-link">返回上一页</a>
            <a href="${pageContext.request.contextPath}/" class="back-link" style="margin-left: 10px;">返回首页</a>
        </div>
    </div>
</body>
</html> 