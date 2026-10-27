<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Style xóa viền trắng trang web -->
<style>
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
    }
    .nav-menu-link {
        color: #ffffff;
        text-decoration: none;
        transition: color 0.2s;
    }
    .nav-menu-link:hover {
        color: #555555;
    }
    .btn-auth {
        color: #d63031;
        text-decoration: none;
        font-weight: bold;
        background: #fff;
        padding: 6px 14px;
        border-radius: 20px;
    }
</style>

<!-- PHẦN 1: Thanh trên (Logo, Tìm kiếm, Đăng nhập / Đăng xuất) -->
<div style="background-color: #E0b0FF; color: #ffffff; padding: 15px 30px; width: 100%; box-sizing: border-box;">
    <table width="100%" style="border-collapse: collapse;">
        <tr>
            <!-- Logo -->
            <td width="20%">
                <a href="${pageContext.request.contextPath}/home">
                    <img src="${pageContext.request.contextPath}/img/logo.png"
                         alt="Logo" style="height: 100px; width: auto; display: block; border: none;"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" />
                    <span style="display:none; font-size:24px; font-weight:bold; color:#fff; text-decoration:none;">MANGA</span>
                </a>
            </td>

            <!-- Ô tìm kiếm (Gửi từ khóa về /home) -->
            <td width="60%" align="center">
                <form action="${pageContext.request.contextPath}/home" method="GET" style="display: flex; justify-content: center; align-items: center; gap: 5px;">
                    <input type="text" name="keyword" placeholder="Tìm kiếm truyện tranh..." style="width: 60%; padding: 8px 12px; border: 1px solid #444; border-radius: 4px; background-color: #F4E3FF; color: #333;" />
                    <button type="submit" style="padding: 8px 12px; background-color: #CC7DFF; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px;">🔍</button>
                </form>
            </td>

            <!-- Góc tài khoản -->
            <td width="20%" align="right" style="color: #ffffff;">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <span>Xin chào, <b style="color: #333;">${sessionScope.loggedInUser.username}</b>!</span>
                        <c:if test="${sessionScope.loggedInUser.role eq 'ADMIN'}">
                            | <a href="${pageContext.request.contextPath}/admin/comics" style="color: #6c5ce7; font-weight: bold; text-decoration: none;">Admin</a>
                        </c:if>
                        | <a href="${pageContext.request.contextPath}/logout" style="color: #d63031; text-decoration: none; font-weight: bold;">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-auth">Đăng nhập ♥</a>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
</div>

<!-- PHẦN 2: Thanh menu dưới -->
<div style="background-color: #EACAFF; color: #ffffff; padding: 10px 30px; width: 100%; box-sizing: border-box;">
    <div style="display: flex; justify-content: center; gap: 30px; font-weight: bold;">
        <a href="${pageContext.request.contextPath}/home" class="nav-menu-link">Home</a>
        <a href="${pageContext.request.contextPath}/hot" class="nav-menu-link">Hot</a>
        <a href="${pageContext.request.contextPath}/category" class="nav-menu-link">Category</a>
        <a href="${pageContext.request.contextPath}/rank" class="nav-menu-link">Rank</a>

        <!-- Chỉ hiển thị History và Favorite khi người dùng ĐÃ ĐĂNG NHẬP -->
        <c:if test="${not empty sessionScope.loggedInUser}">
            <a href="${pageContext.request.contextPath}/favorite" class="nav-menu-link">Follow</a>
            <a href="${pageContext.request.contextPath}/history" class="nav-menu-link">History</a>
        </c:if>
    </div>
</div>