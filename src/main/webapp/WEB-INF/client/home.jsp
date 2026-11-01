<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${sectionTitle}</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 0; color: #333; }
            .container { max-width: 1200px; margin: 20px auto; padding: 0 15px; }
            .content-box { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,.1); }
            .content-title { font-size: 20px; font-weight: bold; margin: 0 0 15px; color: #333; border-bottom: 2px solid #CC7DFF; padding-bottom: 8px; }
            .comic-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 20px; }
            .comic-card { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,.1); text-decoration: none; color: #333; display: flex; flex-direction: column; transition: transform .2s; }
            .comic-card:hover { transform: translateY(-4px); box-shadow: 0 5px 12px rgba(80,45,120,.16); }
            .comic-card img { width: 100%; height: 250px; object-fit: cover; }
            .comic-info { padding: 12px; }
            .comic-title { font-weight: bold; font-size: 15px; margin-bottom: 7px; min-height: 36px; }
            .comic-meta { font-size: 13px; color: #666; margin-top: 4px; }
            @media (max-width: 600px) { .container { margin: 12px auto; padding: 0 10px; } .content-box { padding: 14px; } .comic-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; } .comic-card img { height: 220px; } }
        </style>
    </head>
    <body>

        <!-- 1. Nhúng Header chung của bạn -->
        <%@include file="../include/header.jsp" %>

        <main class="container">
            <section class="content-box">
                <h3 class="content-title">${empty sectionTitle ? '📚 Truyện Nổi Bật' : sectionTitle}</h3>
                <c:choose>
                    <c:when test="${not empty comics}">
                        <div class="comic-grid">
                            <c:forEach var="comic" items="${comics}">
                                <a href="${pageContext.request.contextPath}/comic?id=${comic.comicId}" class="comic-card">
                                    <img src="${pageContext.request.contextPath}${comic.coverImage}" alt="${comic.title}"
                                         onerror="this.src='https://placehold.co/180x250?text=No+Cover';" />
                                    <div class="comic-info">
                                        <div class="comic-title">${comic.title}</div>
                                        <div class="comic-meta">Tác giả: ${empty comic.author ? 'Chưa cập nhật' : comic.author}</div>
                                        <div class="comic-meta">Tình trạng: ${comic.status}</div>
                                        <div class="comic-meta">Lượt xem: ${comic.views}</div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align:center;color:#888;padding:32px 0;">Không tìm thấy truyện phù hợp.</p>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
        <%@ include file="../include/footer.jsp" %>
    </body>
    
</html>
