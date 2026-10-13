<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div style="border-bottom: 2px solid #000; padding: 10px 0;">
    <!-- Hàng trên: Logo, Tìm kiếm, Account -->
    <table width="100%">
        <tr>
            <td width="20%">
                <h2><a href="${pageContext.request.contextPath}/home" style="text-decoration:none; color:#000;">NamePage</a></h2>
            </td>
            <td width="60%">
                <form action="${pageContext.request.contextPath}/comic" method="GET">
                    <input type="text" name="keyword" placeholder="Search..." style="width: 70%; height: 25px;" />
                    <input type="submit" value="🔍" />
                </form>
            </td>
            <td width="20%" align="right">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span>Xin chào, <b>${sessionScope.user.username}</b>!</span> | 
                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login">Account ♥</a>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <hr/>

    <!-- Hàng dưới: Menu các chức năng -->
    <p>
        <a href="${pageContext.request.contextPath}/home">Home</a> &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/home?filter=hot">Hot</a> &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/follow">Follow</a> &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/history">History</a> &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/category">Category</a> &nbsp;|&nbsp;
        <a href="${pageContext.request.contextPath}/rank">Rank</a>
    </p>
</div>