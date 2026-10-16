<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đọc Truyện</title>
        <style>
            /* Nền tối bảo vệ mắt, loại bỏ lề mặc định */
            body {
                font-family: Arial, sans-serif;
                background-color: #121212;
                margin: 0;
                padding: 0;
                color: #e0e0e0;
            }

            /* Thanh điều hướng phía trên cố định hoặc nổi bật */
            .top-nav {
                padding: 12px 20px;
                background-color: #1e1e1e;
                border-bottom: 1px solid #333;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .top-nav a {
                color: #fff;
                text-decoration: none;
                font-size: 14px;
                padding: 6px 12px;
                border-radius: 4px;
                background-color: #333;
                transition: background-color 0.2s;
            }

            .top-nav a:hover {
                background-color: #555;
            }

            /* Khung tranh cuộn dọc căn chính giữa */
            .comic-wrapper {
                max-width: 800px;
                margin: 0 auto;
                text-align: center;
                background-color: #000;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
            }

            /* Ảnh hiển thị dạng khối liền nhau, không có khe hở trắng/đen ở giữa các trang */
            .comic-wrapper img {
                width: 100%;
                display: block;
                margin: 0 auto;
                padding: 0;
                border: none;
                /* Chống giật trang khi ảnh đang load */
                min-height: 300px;
                background-color: #181818;
            }

            /* Thanh điều hướng chân trang */
            .bottom-nav {
                max-width: 800px;
                margin: 20px auto;
                padding: 15px;
                text-align: center;
            }
        </style>
    </head>
    <body>

        <!-- Thanh điều hướng trên cùng -->
        <!-- Thanh điều hướng trên cùng có nút Trước / Sau -->
        <div class="top-nav" style="display: flex; justify-content: space-between; align-items: center; padding: 10px 25px; background: #222;">
            <a href="${pageContext.request.contextPath}/comic?id=${currentChapter.comicId}" style="color: #fff; text-decoration: none; background: #444; padding: 6px 12px; border-radius: 4px;">
                ← Danh Sách Tập
            </a>

            <div style="display: flex; gap: 10px; align-items: center;">
                <!-- Nút Tập Trước -->
                <c:choose>
                    <c:when test="${not empty prevId}">
                        <a href="${pageContext.request.contextPath}/read?chapterId=${prevId}" style="color: #fff; text-decoration: none; background: #007bff; padding: 6px 12px; border-radius: 4px;">
                            ◀ Tập trước
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #777; background: #333; padding: 6px 12px; border-radius: 4px; cursor: not-allowed;">
                            ◀ Tập trước
                        </span>
                    </c:otherwise>
                </c:choose>

                <span style="font-weight: bold; color: #fff;">Chương ${currentChapter.chapterNumber}</span>

                <!-- Nút Tập Sau -->
                <c:choose>
                    <c:when test="${not empty nextId}">
                        <a href="${pageContext.request.contextPath}/read?chapterId=${nextId}" style="color: #fff; text-decoration: none; background: #007bff; padding: 6px 12px; border-radius: 4px;">
                            Tập sau ▶
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #777; background: #333; padding: 6px 12px; border-radius: 4px; cursor: not-allowed;">
                            Tập sau ▶
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <!-- Khung cuộn dọc các trang tranh -->
        <div class="comic-wrapper">
            <c:choose>
                <c:when test="${not empty pages}">
                    <c:forEach var="pageUrl" items="${pages}">
                        <!-- pageUrl trong DB đã có /images, nối với contextPath để ImageServlet phục vụ -->
                        <img src="${pageContext.request.contextPath}${pageUrl}" 
                             alt="comic page" 
                             loading="lazy" />
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="padding: 50px;">Chưa có trang tranh nào trong tập này.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Thanh điều hướng dưới chân trang -->
        <div class="bottom-nav">
            <a href="${pageContext.request.contextPath}/home" style="color: #4da3ff; text-decoration: none;">← Quay lại trang chủ</a>
        </div>

    </body>
</html>