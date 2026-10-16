<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${comic.title}</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 15px 30px;
            }
            .detail-container {
                display: flex;
                gap: 25px;
                margin-top: 20px;
            }
            .detail-container img {
                width: 220px;
                height: 300px;
                object-fit: cover;
                border-radius: 6px;
            }
            .chapter-list {
                margin-top: 25px;
            }
            .chapter-item {
                padding: 8px 0;
                border-bottom: 1px solid #ddd;
            }
        </style>
    </head>
    <body>

        <%@include file="../include/header.jsp" %>

        <div class="detail-container">
            <img src="${pageContext.request.contextPath}${comic.coverImage}" alt="${comic.title}" 
                 onerror="this.src='https://placehold.co/220x300?text=No+Cover';" />
            <div>
                <h2>${comic.title}</h2>
                <p><b>Tác giả:</b> ${comic.author}</p>
                <p><b>Tình trạng:</b> ${comic.status}</p>
                <p><b>Lượt xem:</b> ${comic.views}</p>
            </div>
        </div>

        <div class="chapter-list">
            <h3>Danh Sách Chương</h3>
            <c:choose>
                <c:when test="${not empty chapters}">
                    <c:forEach var="chap" items="${chapters}">
                        <div class="chapter-item">
                            <a href="${pageContext.request.contextPath}/read?chapterId=${chap.chapterId}" style="text-decoration: none; color: #007bff; font-weight: bold;">
                                Chương ${chap.chapterNumber}: ${chap.title}
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Chưa có chương nào được cập nhật.</p>
                </c:otherwise>
            </c:choose>
        </div>

    </body>
</html>