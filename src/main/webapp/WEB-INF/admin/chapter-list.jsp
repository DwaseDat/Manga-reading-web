<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản Lý Chapter</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 0; background-color: #f9f9f9; }
            .list-box { max-width: 650px; margin: 30px auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
            
            .box-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 12px; margin-bottom: 20px; }
            .box-header h2 { margin: 0; font-size: 20px; color: #333; }
            
            /* Style bảng danh sách chapter */
            .chapter-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
            .chapter-table th, .chapter-table td { border: 1px solid #ddd; padding: 10px; text-align: left; font-size: 14px; }
            .chapter-table th { background-color: #f8f9fa; font-weight: bold; color: #495057; }
            .chapter-table tr:hover { background-color: #f1f1f1; }
            
            /* Thiết kế nút bấm đồng bộ */
            .btn-add { background: #28a745; color: #fff; text-decoration: none; padding: 8px 16px; border-radius: 4px; font-weight: bold; font-size: 14px; display: inline-block; }
            .btn-cancel { background: #6c757d; color: #fff; text-decoration: none; padding: 8px 16px; border-radius: 4px; font-size: 14px; display: inline-block; }
            .btn-edit { background: #007bff; color: #fff; text-decoration: none; padding: 5px 10px; border-radius: 4px; font-size: 13px; display: inline-block; margin-right: 4px; }
            .btn-delete { background: #dc3545; color: #fff; text-decoration: none; padding: 5px 10px; border-radius: 4px; font-size: 13px; display: inline-block; }
            
            .btn-add:hover { background: #218838; }
            .btn-cancel:hover { background: #5a6268; }
            .btn-edit:hover { background: #0069d9; }
            .btn-delete:hover { background: #c82333; }
            
            .empty-msg { text-align: center; color: #888; padding: 20px 0; font-style: italic; }
            .actions-bar { display: flex; gap: 10px; margin-top: 15px; }
        </style>
    </head>
    <body>

        <%-- Include Header chung của ứng dụng --%>
        <%@include file="../include/header.jsp" %>

        <div class="list-box">
            <c:if test="${param.deleted eq '1'}"><p style="color:green;">Đã xóa chapter thành công.</p></c:if>
            <c:if test="${param.deleteError eq '1'}"><p style="color:#dc3545;">Không thể xóa chapter. Vui lòng thử lại.</p></c:if>
            <c:if test="${param.uploaded eq '1'}"><p style="color:green;">Đã tạo chapter và lưu ảnh thành công.</p></c:if>
            <c:if test="${param.updated eq '1'}"><p style="color:green;">Đã cập nhật chapter thành công.</p></c:if>
            <div class="box-header">
                <h2>Danh Sách Chapter (Mã Truyện: ${comicId})</h2>
                <a href="${pageContext.request.contextPath}/admin/chapters?action=create&comicId=${comicId}" class="btn-add">+ Thêm Chapter Mới</a>
            </div>

            <table class="chapter-table">
                <thead>
                    <tr>
                        <th style="width: 10%;">STT</th>
                        <th style="width: 25%;">Tập Số</th>
                        <th>Tiêu Đề Chapter</th>
                        <th style="width: 25%; text-align: center;">Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty chapters}">
                            <c:forEach var="chap" items="${chapters}" varStatus="loop">
                                <tr>
                                    <td>${loop.count}</td>
                                    <td><strong>Chapter ${chap.chapterNumber}</strong></td>
                                    <td>${chap.title}</td>
                                    <td style="text-align: center;">
                                        <!-- NÚT SỬA CHAPTER -->
                                        <a href="${pageContext.request.contextPath}/admin/chapters?action=edit&chapterId=${chap.chapterId}&comicId=${comicId}" class="btn-edit">Sửa</a>

                                        <!-- NÚT XÓA CHAPTER -->
                                        <form action="${pageContext.request.contextPath}/admin/chapters" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="chapterId" value="${chap.chapterId}" />
                                            <input type="hidden" name="comicId" value="${comicId}" />
                                            <button type="submit" class="btn-delete" style="border:0;cursor:pointer;">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="empty-msg">Bộ truyện này hiện chưa có chapter nào.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="actions-bar">
                <a href="${pageContext.request.contextPath}/admin/comics" class="btn-cancel">Quay Lại Danh Sách Truyện</a>
            </div>
        </div>

    </body>
</html>
