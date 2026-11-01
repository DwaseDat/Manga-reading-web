<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${comic.title}</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background: #f3f3f3;
            }
            .page-container {
                width: calc(100% - 48px);
                max-width: 1500px;
                box-sizing: border-box;
                margin: 24px auto;
                padding: 24px 28px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 12px rgba(0,0,0,.06);
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
                font-weight: 400;
            }
            .chapter-item a.read-chapter { color: #6841a5; font-weight: 700; }
            .chapter-item a:hover {
                color: #0056b3;
            }
            .comments { margin: 30px 0; padding: 20px; background: #fff; border: 1px solid #eadcf5; border-radius: 8px; }
            .comments h3 { color: #8050ad; margin-top: 0; }
            .comment-form textarea { width: 100%; min-height: 90px; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; font: inherit; resize: vertical; }
            .comment-submit { margin-top: 8px; border: 0; border-radius: 5px; padding: 9px 16px; background: #9b59b6; color: #fff; font-weight: bold; cursor: pointer; }
            .comment-card { padding: 12px 0; border-bottom: 1px solid #eee; }
            .comment-meta { color: #777; font-size: 13px; margin-bottom: 5px; }
            .comment-content { white-space: pre-wrap; overflow-wrap: anywhere; }
            @media (max-width: 640px) {
                .page-container { width: 100%; margin: 0; padding: 18px 14px; border-radius: 0; }
                .detail-container { flex-direction: column; }
            }
        </style>
    </head>
    <body>

        <%@include file="../include/header.jsp" %>

        <main class="page-container">
        <div class="detail-container">
            <img src="${pageContext.request.contextPath}${comic.coverImage}" alt="${comic.title}" 
                 onerror="this.src='https://placehold.co/220x300?text=No+Cover';" />

            <div class="comic-info">
                <h2>${comic.title}</h2>
                <p><b>Tác giả:</b> ${comic.author}</p>
                <p><b>Tình trạng:</b> ${comic.status}</p>
                <p><b>Lượt xem:</b> ${comic.views}</p>
                <p><b>💜 Lượt yêu thích:</b> ${favoriteCount}</p>

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
                            <a class="${chap.read ? 'read-chapter' : ''}" href="${pageContext.request.contextPath}/read?chapterId=${chap.chapterId}">
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

        <section class="comments" id="comments">
            <h3>💬 Bình luận (${commentCount})</h3>
            <c:if test="${param.commented eq '1'}"><p style="color:green;">Bình luận đã được đăng.</p></c:if>
            <c:if test="${param.commentError eq '1'}"><p style="color:#d63031;">Bình luận không được để trống và tối đa 2.000 ký tự.</p></c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <form class="comment-form" action="${pageContext.request.contextPath}/comment" method="POST">
                        <input type="hidden" name="comicId" value="${comic.comicId}" />
                        <textarea name="content" maxlength="2000" required placeholder="Viết bình luận của bạn..."></textarea>
                        <button class="comment-submit" type="submit">Gửi bình luận</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <p><a href="${pageContext.request.contextPath}/login">Đăng nhập</a> để viết bình luận.</p>
                </c:otherwise>
            </c:choose>

            <div class="comment-list">
                <c:choose>
                    <c:when test="${not empty comments}">
                        <c:forEach var="comment" items="${comments}">
                            <article class="comment-card">
                                <div class="comment-meta"><b><c:out value="${comment.username}" default="Người dùng" /></b>
                                    <c:if test="${not empty comment.createdAt}"> · <fmt:formatDate value="${comment.createdAt}" pattern="dd/MM/yyyy HH:mm" /></c:if>
                                </div>
                                <div class="comment-content"><c:out value="${comment.content}" /></div>
                            </article>
                        </c:forEach>
                    </c:when>
                    <c:otherwise><p>Chưa có bình luận nào. Hãy là người đầu tiên bình luận!</p></c:otherwise>
                </c:choose>
            </div>
        </section>
        </main>

    </body>
</html>
