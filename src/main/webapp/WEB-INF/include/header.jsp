<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Style tapno maikkat dagiti puraw nga igid ti webpage -->
<style>
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
    }
</style>

<!-- PHẦN 1: Thanh trên (Logo, Tìm kiếm, Account) -->
<div style="background-color: #E0b0FF; color: #ffffff; padding: 15px 30px; width: 100%; box-sizing: border-box;">
    <table width="100%" style="border-collapse: collapse;">
        <tr>
            <td width="20%">
                <a href="${pageContext.request.contextPath}/home">
                    <img src="${pageContext.request.contextPath}/img/logo.png"
                         alt="Logo" style="height: 100px; width: auto; display: block; border: none;">
                </a>
            </td>
            <td width="60%" align="center">
                <form action="${pageContext.request.contextPath}/comic" method="GET" style="display: flex; justify-content: center; align-items: center; gap: 5px;">
                    <input type="text" name="keyword" placeholder="Tìm kiếm truyện tranh..." style="width: 60%; padding: 8px 12px; border: 1px solid #444; border-radius: 4px; background-color: #F4E3FF; color: #333;" />
                    <button type="submit" style="padding: 8px 12px; background-color: #CC7DFF; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px;">🔍</button>
                </form>
            </td>
            <td width="20%" align="right" style="color: #ffffff;">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span>Xin chào, <b style="color: #555;">${sessionScope.user.username}</b>!</span> | 
                        <a href="${pageContext.request.contextPath}/logout" style="color: #d63031; text-decoration: none; font-weight: bold;">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" style="color: #d63031; text-decoration: none; font-weight: bold; background: #fff; padding: 6px 14px; border-radius: 20px;">Account ♥</a>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
</div>

<!-- PHẦN 2: Thanh menu dưới (Home, Hot, Follow,...) căn giữa -->
<div style="background-color: #EACAFF; color: #ffffff; padding: 10px 30px; width: 100%; box-sizing: border-box;">
    <div style="display: flex; justify-content: center; gap: 30px; font-weight: bold;">
        <a href="${pageContext.request.contextPath}/home" style="color: #ffffff; text-decoration: none; transition: color 0.2s;">Home</a>
        <a href="${pageContext.request.contextPath}/home?filter=hot" style="color: #ffffff; text-decoration: none; transition: color 0.2s;">Hot</a>
        <a href="${pageContext.request.contextPath}/follow" style="color: #ffffff; text-decoration: none; transition: color 0.2s;">Follow</a>
        <a href="${pageContext.request.contextPath}/history" style="color: #ffffff; text-decoration: none; transition: color 0.2s;">History</a>
        <a href="${pageContext.request.contextPath}/category" style="color: #ffffff; text-decoration: none; transition: color 0.2s;">Category</a>
        <a href="${pageContext.request.contextPath}/rank" style="color: #ffffff; text-decoration: none; transition: color 0.2s;">Rank</a>
    </div>
</div>