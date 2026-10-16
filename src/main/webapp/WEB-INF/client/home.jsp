<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang Chủ - Web Đọc Truyện</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 15px 30px; }
            
            /* Khung chứa các thẻ truyện xếp thành hàng ngang */
            .comic-list { 
                display: flex; 
                flex-wrap: wrap; 
                gap: 20px; 
            }
            
            .comic-card { 
                border: 1px solid #ccc; 
                width: 220px; 
                padding: 10px; 
                border-radius: 6px; 
                background-color: #fff;
            }
            .comic-card img { 
                width: 100%; 
                height: 280px; 
                object-fit: cover; 
                border-radius: 4px; 
            }
        </style>
    </head>
    <body>

        <!-- 1. Nhúng Header chung của bạn -->
        <%@include file="../include/header.jsp" %>

        <h3>Truyện Nổi Bật</h3>

        <!-- 2. Hiển thị danh sách toàn bộ truyện -->
        <div class="comic-list">
            <c:choose>
                <c:when test="${not empty comics}">
                    <c:forEach var="comic" items="${comics}">
                        <div class="comic-card">
                            <!-- Ảnh lấy qua ImageServlet từ ổ D hoặc link online -->
                            <a href="${pageContext.request.contextPath}/comic?id=${comic.comicId}">
                                <img src="${pageContext.request.contextPath}${comic.coverImage}" alt="${comic.title}" 
                                     onerror="this.src='https://placehold.co/200x280?text=No+Cover';" />
                            </a>
                            
                            <h4 style="margin: 8px 0 4px 0;">
                                <a href="${pageContext.request.contextPath}/comic?id=${comic.comicId}" style="text-decoration: none; color: #000;">
                                    ${comic.title}
                                </a>
                            </h4>
                            <p style="margin: 4px 0; font-size: 13px; color: gray;">Tác giả: ${comic.author}</p>
                            <p style="margin: 4px 0; font-size: 13px;">Tình trạng: <b>${comic.status}</b></p>
                            <p style="margin: 4px 0; font-size: 13px;">Lượt xem: ${comic.views}</p>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>Chưa có truyện nào trong cơ sở dữ liệu.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <br/><hr/>
       
<%@ include file="../include/footer.jsp" %>
    </body>
    
</html>