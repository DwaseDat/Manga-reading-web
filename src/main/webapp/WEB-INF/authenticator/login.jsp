<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng Nhập System</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .card-login {
                background: #fff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
                width: 320px;
                text-align: center;
            }
            .form-group {
                margin-bottom: 15px;
                text-align: left;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                font-size: 13px;
            }
            .form-group input[type="text"], .form-group input[type="password"] {
                width: 100%;
                padding: 8px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .btn-submit {
                width: 100%;
                background: #007bff;
                color: #fff;
                border: none;
                padding: 10px;
                border-radius: 4px;
                font-weight: bold;
                cursor: pointer;
            }
            .btn-submit:hover {
                background: #0056b3;
            }
            .error {
                color: red;
                font-size: 13px;
                margin-bottom: 10px;
            }
            .checkbox-wrapper {
                margin-top: 12px;
                text-align: left;
                font-size: 13px;
            }
        </style>
    </head>
    <body>
        <div class="card-login">
            <h2 style="margin-top: 0;">Đăng Nhập</h2>
            
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div style="color: green; font-size: 13px; margin-bottom: 10px;">${message}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" value="${rememberedUser}" required placeholder="Nhập username" autofocus />
                </div>
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" required placeholder="Nhập password" />
                </div>

                <!-- Thêm checkbox Remember Me vào Form Login -->
                <div class="checkbox-wrapper">
                    <label>
                        <input type="checkbox" id="rememberMe" name="rememberMe" value="on" ${not empty rememberedUser ? 'checked' : ''}>
                        Ghi nhớ đăng nhập (Remember me)
                    </label>
                </div>

                <button type="submit" class="btn-submit" style="margin-top: 15px;">Đăng Nhập</button>
            </form>

            <p style="margin-top: 15px; font-size: 13px;">
                <a href="${pageContext.request.contextPath}/home" style="color: #666; text-decoration: none;">← Quay về trang chủ</a>
            </p>

            <p style="margin-top: 15px; font-size: 13px;">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" style="color: #28a745; text-decoration: none; font-weight: bold;">Đăng ký tài khoản</a>
            </p>
        </div>
    </body>
</html>