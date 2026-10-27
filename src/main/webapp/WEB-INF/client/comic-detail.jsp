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
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            .comic-info p {
                margin: 10px 0;
                font-size: 15px;
            }
            .badge-category {
                display: inline-block;
                background-color: #E0b0FF;
                color: #ffffff;
                padding: 4px 12px;
                border-radius: 15px;
                font-size: 13px;
                font-weight: bold;
                margin-right: 6px;
                margin-bottom: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .chapter-list {
                margin-top: 30px;
            }
            .chapter-item {
                padding: 10px 0;
                border-bottom: 1px solid #ddd;
            }
            .chapter-item a {
                text-decoration: none;
                color: #007bff;
                font-weight: bold;
            }
            .chapter-item a:hover {
                color: #0056b3;
            }
        </style>
    </head>
    <body>

        <%@include file="../include/header.jsp" %>

        <div class="detail-container">
            <img src="${pageContext.request.contextPath}${comic.coverImage}" alt="${comic.title}" 
                 onerror="this.src='https://placehold.co/220x300?text=No+Cover';" />

            <div class="comic-info">
                <h2>${comic.title}</h2>
                <p><b>Tác giả:</b> ${comic.author}</p>
                <p><b>Tình trạng:</b> ${comic.status}</p>
                <p><b>Lượt xem:</b> ${comic.views}</p>

                <!-- HIỂN THỊ CÁC THỂ LOẠI -->
                <p>
                    <b>Thể loại:</b>
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <c:forEach var="cat" items="${categories}">
                                <span class="badge-category">${cat.categoryName}</span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #888; font-style: italic;">Chưa cập nhật thể loại</span>
                        </c:otherwise>
                    </c:choose>
                </p>

                <p style="margin-top: 15px;"><b>Mô tả:</b></p>
                <p style="color: #444; line-height: 1.6; max-width: 800px;">${comic.description}</p>

                <!-- NÚT YÊU THÍCH (FOLLOW) -->
                <form action="${pageContext.request.contextPath}/favorite" method="POST" style="margin-top: 15px;">
                    <input type="hidden" name="comicId" value="${comic.comicId}" />

                    <c:choose>
                        <c:when test="${isFavorite}">
                            <button type="submit" style="background-color: #ff4757; color: white; border: none; padding: 8px 18px; border-radius: 20px; cursor: pointer; font-weight: bold; font-size: 14px; box-shadow: 0 2px 6px rgba(255, 71, 87, 0.4);">
                                ❤️ Bỏ yêu thích
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="submit" style="background-color: #ffffff; color: #ff4757; border: 2px solid #ff4757; padding: 8px 18px; border-radius: 20px; cursor: pointer; font-weight: bold; font-size: 14px;">
                                🤍 Thêm vào yêu thích
                            </button>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>
        </div>

        <div class="chapter-list">
            <h3>Danh Sách Chương</h3>
            <c:choose>
                <c:when test="${not empty chapters}">
                    <c:forEach var="chap" items="${chapters}">
                        <div class="chapter-item">
                            <a href="${pageContext.request.contextPath}/read?chapterId=${chap.chapterId}">
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