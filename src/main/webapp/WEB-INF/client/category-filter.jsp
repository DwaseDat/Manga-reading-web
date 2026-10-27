<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thể Loại Truyện</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 0; }
            .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
            .category-box { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 25px; }
            .category-title { font-size: 20px; font-weight: bold; margin-bottom: 15px; color: #333; border-bottom: 2px solid #CC7DFF; padding-bottom: 8px; }
            .category-list { display: flex; flex-wrap: wrap; gap: 10px; }
            .cat-btn { text-decoration: none; padding: 8px 16px; background-color: #F4E3FF; color: #6c5ce7; border-radius: 20px; font-weight: bold; transition: all 0.2s; }
            .cat-btn:hover, .cat-btn.active { background-color: #CC7DFF; color: #fff; }
            
            .comic-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 20px; }
            .comic-card { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); text-decoration: none; color: #333; display: flex; flex-direction: column; transition: transform 0.2s; }
            .comic-card:hover { transform: translateY(-5px); }
            .comic-card img { width: 100%; height: 250px; object-fit: cover; }
            .comic-info { padding: 12px; }
            .comic-title { font-weight: bold; font-size: 15px; margin-bottom: 5px; height: 40px; overflow: hidden; }
            .comic-status { font-size: 13px; color: #666; }
        </style>
    </head>
    <body>

        <%-- Nhúng Header chung --%>
        <%@include file="../include/header.jsp" %>

        <div class="container">
            <!-- PHẦN 1: Danh sách các thể loại để người dùng chọn -->
            <div class="category-box">
                <div class="category-title">🏷️ Danh Sách Thể Loại</div>
                <div class="category-list">
                    <a href="${pageContext.request.contextPath}/category" class="cat-btn ${selectedCatId == null ? 'active' : ''}">Tất cả</a>
                    <c:forEach var="cat" items="${categories}">
                        <a href="${pageContext.request.contextPath}/category?id=${cat.categoryId}" 
                           class="cat-btn ${selectedCatId == cat.categoryId ? 'active' : ''}">
                            ${cat.categoryName}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <!-- PHẦN 2: Danh sách truyện lọc theo thể loại -->
            <div class="category-box">
                <div class="category-title">
                    📚 Kết quả: <span style="color: #6c5ce7;">${selectedCatName}</span> (${comics != null ? comics.size() : 0} bộ truyện)
                </div>
                
                <c:choose>
                    <c:when test="${not empty comics}">
                        <div class="comic-grid">
                            <c:forEach var="comic" items="${comics}">
                                <a href="${pageContext.request.contextPath}/comic?id=${comic.comicId}" class="comic-card">
                                    <img src="${pageContext.request.contextPath}${comic.coverImage}" 
                                         alt="${comic.title}" 
                                         onerror="this.src='https://placehold.co/180x250?text=No+Cover';" />
                                    <div class="comic-info">
                                        <div class="comic-title">${comic.title}</div>
                                        <div class="comic-status">Trạng thái: ${comic.status}</div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: #888; padding: 40px 0;">Không có bộ truyện nào thuộc thể loại này.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Nhúng Footer --%>
        <%@include file="../include/footer.jsp" %>

    </body>
</html>