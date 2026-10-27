<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Truyện - Admin</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 0; background-color: #f9f9f9; }
            .container { padding: 20px 40px; }
            .btn-add { background: #28a745; color: #fff; padding: 8px 16px; text-decoration: none; border-radius: 4px; font-weight: bold; }
            .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; background: #fff; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
            .admin-table th, .admin-table td { border: 1px solid #ddd; padding: 10px; text-align: center; }
            .admin-table th { background: #343a40; color: #fff; }
            .admin-table img { width: 50px; height: 70px; object-fit: cover; border-radius: 3px; }
            
            /* CSS các nút thao tác */
            .btn-chapter { background: #17a2b8; color: #fff; padding: 4px 10px; text-decoration: none; border-radius: 3px; font-size: 13px; font-weight: bold; margin-right: 5px; }
            .btn-chapter:hover { background: #138496; }
            .btn-edit { background: #007bff; color: #fff; padding: 4px 10px; text-decoration: none; border-radius: 3px; font-size: 13px; margin-right: 5px; }
            .btn-edit:hover { background: #0069d9; }
            .btn-delete { background: #dc3545; color: #fff; padding: 4px 10px; text-decoration: none; border-radius: 3px; font-size: 13px; }
            .btn-delete:hover { background: #c82333; }
        </style>
    </head>
    <body>
        <%@include file="../include/header.jsp" %>
        <div class="container">
            <h2>Quản Lý Danh Sách Truyện</h2>
            <a href="${pageContext.request.contextPath}/admin/comics?action=create" class="btn-add">+ Thêm Truyện Mới</a>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ảnh Bìa</th>
                        <th>Tên Truyện</th>
                        <th>Tác Giả</th>
                        <th>Tình Trạng</th>
                        <th>Lượt Xem</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${comics}">
                        <tr>
                            <td>${c.comicId}</td>
                            <td>
                                <img src="${pageContext.request.contextPath}${c.coverImage}" 
                                     onerror="this.src='https://placehold.co/50x70?text=No+Img';" />
                            </td>
                            <td style="text-align: left; font-weight: bold;">${c.title}</td>
                            <td>${c.author}</td>
                            <td><b>${c.status}</b></td>
                            <td>${c.views}</td>
                            
                            <!-- Bổ sung nút + Thêm Chapter ở ô Thao Tác -->
                            <td style="white-space: nowrap;">
                                <a href="${pageContext.request.contextPath}/admin/chapters?comicId=${c.comicId}" class="btn-chapter">
                                    + Thêm Chapter
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/comics?action=edit&id=${c.comicId}" class="btn-edit">Sửa</a>
                                <a href="${pageContext.request.contextPath}/admin/comics?action=delete&id=${c.comicId}" class="btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa truyện này?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>