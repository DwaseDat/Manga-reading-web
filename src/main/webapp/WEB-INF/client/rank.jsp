<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bảng Xếp Hạng Truyện Tranh</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; }
        .container { max-width: 1100px; margin: 30px auto; padding: 0 15px; }
        .rank-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #007bff; padding-bottom: 10px; margin-bottom: 20px; }
        .filter-buttons a {
            text-decoration: none;
            padding: 8px 16px;
            margin-left: 5px;
            border-radius: 20px;
            background: #e9ecef;
            color: #495057;
            font-weight: bold;
            font-size: 14px;
        }
        .filter-buttons a.active {
            background: #007bff;
            color: white;
        }
        .rank-list { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; }
        .rank-item { display: flex; align-items: center; padding: 15px; border-bottom: 1px solid #eee; text-decoration: none; color: inherit; }
        .rank-item:hover { background-color: #f1f3f5; }
        .rank-number { font-size: 20px; font-weight: bold; width: 50px; text-align: center; color: #6c757d; }
        .rank-number.top-1 { color: #d63031; font-size: 24px; }
        .rank-number.top-2 { color: #e17055; }
        .rank-number.top-3 { color: #fdcb6e; }
        .comic-cover { width: 60px; height: 80px; object-fit: cover; border-radius: 4px; margin-right: 15px; }
        .comic-details { flex-grow: 1; }
        .comic-title { font-size: 16px; font-weight: bold; margin-bottom: 5px; color: #2d3436; }
        .comic-meta { font-size: 13px; color: #636e72; }
        .badge-status { background: #10b981; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px; }
    </style>
</head>
<body>

    <%-- Include Header / Navbar --%>
    <%@include file="../include/header.jsp" %>

    <div class="container">
        <div class="rank-header">
            <h2>🏆 Bảng Xếp Hạng Truyện Tranh</h2>
            
            <%-- Bộ lọc sắp xếp --%>
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/rank?filter=views" class="${currentFilter == 'views' ? 'active' : ''}">👁️ Lượt Xem</a>
                <a href="${pageContext.request.contextPath}/rank?filter=favorites" class="${currentFilter == 'favorites' ? 'active' : ''}">❤️ Yêu Thích</a>
                <a href="${pageContext.request.contextPath}/rank?filter=status" class="${currentFilter == 'status' ? 'active' : ''}">📌 Tình Trạng</a>
            </div>
        </div>

        <div class="rank-list">
            <c:choose>
                <c:when test="${not empty comics}">
                    <c:forEach var="comic" items="${comics}" varStatus="loop">
                        <a href="${pageContext.request.contextPath}/comic?id=${comic.comicId}" class="rank-item">
                            <div class="rank-number ${loop.count == 1 ? 'top-1' : (loop.count == 2 ? 'top-2' : (loop.count == 3 ? 'top-3' : ''))}">
                                #${loop.count}
                            </div>
                            
                            <img src="${pageContext.request.contextPath}${comic.coverImage}" class="comic-cover" alt="${comic.title}" onerror="this.src='https://placehold.co/60x80?text=No+Cover';" />
                            
                            <div class="comic-details">
                                <div class="comic-title">${comic.title}</div>
                                <div class="comic-meta">
                                    Tác giả: <strong>${comic.author}</strong> | 
                                    Lượt xem: <strong><fmt:formatNumber value="${comic.views}" type="number"/></strong>
                                </div>
                            </div>

                            <div>
                                <span class="badge-status">${comic.status}</span>
                            </div>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="padding: 30px; text-align: center; color: #888;">Chưa có dữ liệu xếp hạng.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
 <%@ include file="../include/footer.jsp" %>
</body>
</html>