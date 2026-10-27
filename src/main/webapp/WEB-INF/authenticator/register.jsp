<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng Ký Tài Khoản</title>
        <style>
            body { font-family: Arial, sans-serif; background: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
            .card-register { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 320px; text-align: center; }
            .form-group { margin-bottom: 15px; text-align: left; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 13px; }
            .form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
            .btn-submit { width: 100%; background: #28a745; color: #fff; border: none; padding: 10px; border-radius: 4px; font-weight: bold; cursor: pointer; }
            .btn-submit:hover { background: #218838; }
            .error { color: red; font-size: 13px; margin-bottom: 12px; }
        </style>
    </head>
    <body>

        <div class="card-register">
            <h2 style="margin-top: 0;">Đăng Ký</h2>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST">
                <div class="form-group">
                    <label>Tên đăng nhập (*)</label>
                    <input type="text" name="username" required placeholder="Nhập username" autofocus />
                </div>
                <div class="form-group">
                    <label>Mật khẩu (*)</label>
                    <input type="password" name="password" required placeholder="Nhập password" />
                </div>
                <div class="form-group">
                    <label>Xác nhận mật khẩu (*)</label>
                    <input type="password" name="confirmPassword" required placeholder="Nhập lại password" />
                </div>
                <button type="submit" class="btn-submit">Đăng Ký Tài Khoản</button>
            </form>

            <p style="margin-top: 15px; font-size: 13px;">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" style="color: #007bff; text-decoration: none; font-weight: bold;">Đăng nhập ngay</a>
            </p>
        </div>

    </body>
</html>