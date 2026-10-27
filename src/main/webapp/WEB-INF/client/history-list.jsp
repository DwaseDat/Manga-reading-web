<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lịch Sử Đọc Truyện</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 0; background-color: #f9f9f9; }
            .container { padding: 20px 40px; max-width: 1200px; margin: 0 auto; }
            .grid-comics { display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px; }
            .card-comic { width: 180px; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
            .card-comic img { width: 100%; height: 240px; object-fit: cover; }
            .card-info { padding: 10px; }
            .card-title { font-weight: bold; font-size: 14px; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        </style>
    </head>
    <body>

        <%@include file="../include/header.jsp" %>

        <div class="container">
            <h2>📜 Lịch Sử Đọc Truyện Gần Đây</h2>

            <c:choose>
                <c:when test="${not empty historyComics}">
                    <div class="grid-comics">
                        <c:forEach var="c" items="${historyComics}">
                            <div class="card-comic">
                                <a href="${pageContext.request.contextPath}/comic?id=${c.comicId}" style="text-decoration:none; color:inherit;">
                                    <img src="${pageContext.request.contextPath}${c.coverImage}" 
                                         onerror="this.src='https://placehold.co/180x240?text=No+Cover';" />
                                    <div class="card-info">
                                        <div class="card-title">${c.title}</div>
                                        <div style="font-size: 12px; color: #888;">${c.status}</div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: #666; margin-top: 20px;">Bạn chưa đọc bộ truyện nào.</p>
                </c:otherwise>
            </c:choose>
        </div>

    </body>
</html> 