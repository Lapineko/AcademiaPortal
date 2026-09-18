<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录 - 计算机科学与技术学院</title>
    <link rel="stylesheet" type="text/css" href="styles/loginStyle.css">
</head>
<body class="login-page">
    <div class="login-wrapper">
        <div class="login-container">
            <div class="login-header">
                <img src="images/logonew_1.png" alt="学院logo" class="login-logo">
                <h2>欢迎登录</h2>
                <p class="subtitle">计算机学院认证登录</p>
            </div>
            <% 
                String errorMsg = (String)session.getAttribute("errorMsg");
                if(errorMsg != null) {
                    session.removeAttribute("errorMsg");
            %>
                <div class="error-message">
                    <%= errorMsg %>
                </div>
            <% } %>
            <form action="${pageContext.request.contextPath}/login" method="post" class="login-form" onsubmit="return validateForm()">
                <div class="form-group">
                    <input type="text" id="id" name="id" required onkeypress="return isNumberKey(event)" 
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                    <label for="id">学号/工号</label>
                    <span class="focus-border"></span>
                </div>
                
                <div class="form-group">
                    <input type="password" id="password" name="password" required>
                    <label for="password">密码</label>
                    <span class="focus-border"></span>
                </div>
                <input type="hidden" name="target" value="<%= request.getParameter("target") %>">
                <button type="submit" class="login-btn">
                    <span>登录</span>
                    <div class="ripple"></div>
                </button>
            </form>
        </div>
    </div>

    <script>
        // 限制只能输入数字
        function isNumberKey(evt) {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        // 表单提交验证
        function validateForm() {
            var id = document.getElementById('id').value;
            if (!/^\d+$/.test(id)) {
                var errorDiv = document.querySelector('.error-message');
                if (!errorDiv) {
                    errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message';
                    var form = document.querySelector('.login-form');
                    form.parentNode.insertBefore(errorDiv, form);
                }
                errorDiv.textContent = '请输入正确的学号/工号';
                return false;
            }
            return true;
        }
    </script>
</body>
</html> 