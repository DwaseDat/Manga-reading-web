<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${not empty comic ? 'Sửa Truyện' : 'Thêm Truyện Mới'}</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 0; background-color: #f9f9f9; }
            .form-box { max-width: 650px; margin: 30px auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
            
            /* CSS khung chọn thể loại Checkbox */
            .category-group { display: flex; flex-wrap: wrap; gap: 12px; background: #f8f9fa; padding: 12px; border: 1px solid #ddd; border-radius: 4px; }
            .category-item { display: flex; align-items: center; gap: 5px; font-weight: normal; cursor: pointer; }
            
            .preview-img { width: 120px; height: 160px; object-fit: cover; margin-top: 8px; border: 1px solid #ddd; border-radius: 4px; display: block; }
            .btn-save { background: #28a745; color: #fff; border: none; padding: 10px 20px; border-radius: 4px; font-weight: bold; cursor: pointer; }
            .btn-cancel { background: #6c757d; color: #fff; text-decoration: none; padding: 9px 18px; border-radius: 4px; font-size: 14px; margin-left: 10px; }
        </style>
    </head>
    <body>

        <%@include file="../include/header.jsp" %>

        <div class="form-box">
            <h2>${not empty comic ? 'Sửa Thông Tin Truyện' : 'Thêm Truyện Mới'}</h2>

            <form action="${pageContext.request.contextPath}/admin/comics" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="save" />
                <input type="hidden" name="id" value="${comic.comicId}" />
                <input type="hidden" name="coverImageOld" value="${comic.coverImage}" />

                <div class="form-group">
                    <label>Tên Truyện (*)</label>
                    <input type="text" name="title" value="${comic.title}" style="width:100%; padding:8px;" required />
                </div>

                <!-- KHU VỰC CHỌN THỂ LOẠI (CATEGORY CHECKBOXES) -->
                <div class="form-group">
                    <label>Thể Loại (Categories)</label>
                    <div class="category-group">
                        <c:forEach var="cat" items="${allCategories}">
                            <label class="category-item">
                                <input type="checkbox" name="categories" value="${cat.categoryId}"
                                    <c:if test="${not empty selectedCategoryIds}">
                                        <c:forEach var="selectedId" items="${selectedCategoryIds}">
                                            <c:if test="${selectedId eq cat.categoryId}">checked</c:if>
                                        </c:forEach>
                                    </c:if>
                                />
                                ${cat.categoryName}
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <!-- BỔ SUNG: CẬP NHẬT ÁNH BÌA -->
                <div class="form-group">
                    <label>Ảnh Bìa Truyện (Cover Image)</label>
                    <c:if test="${not empty comic.coverImage}">
                        <div style="font-size: 13px; color: #555;">Ảnh hiện tại:</div>
                        <img src="${pageContext.request.contextPath}${comic.coverImage}" class="preview-img" onerror="this.src='https://placehold.co/120x160?text=No+Cover';" />
                    </c:if>
                    <input type="file" name="coverImageFile" accept="image/*" style="margin-top: 8px;" />
                    <small style="color: #666; display: block; margin-top: 4px;">(Để trống nếu muốn giữ nguyên ảnh cũ)</small>
                </div>

                <div class="form-group">
                    <label>Tác Giả</label>
                    <input type="text" name="author" value="${comic.author}" style="width:100%; padding:8px;" />
                </div>

                <div class="form-group">
                    <label>Tình Trạng</label>
                    <select name="status" style="width:100%; padding:8px;">
                        <option value="Đang tiến hành" ${comic.status eq 'Đang tiến hành' ? 'selected' : ''}>Đang tiến hành</option>
                        <option value="Đã full" ${comic.status eq 'Đã full' ? 'selected' : ''}>Đã full</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Mô Tả</label>
                    <textarea name="description" rows="4" style="width:100%; padding:8px;">${comic.description}</textarea>
                </div>

                <button type="submit" class="btn-save">Lưu Thông Tin</button>
                <a href="${pageContext.request.contextPath}/admin/comics" class="btn-cancel">Hủy Bỏ</a>
            </form>
        </div>

    </body>
</html>