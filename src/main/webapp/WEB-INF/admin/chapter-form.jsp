<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm Chapter Mới</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                background-color: #f9f9f9;
            }
            .form-box {
                max-width: 550px;
                margin: 30px auto;
                background: #fff;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
            }
            .form-group input {
                width: 100%;
                padding: 8px;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .btn-save {
                background: #007bff;
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 4px;
                font-weight: bold;
                cursor: pointer;
            }
            .btn-cancel {
                background: #6c757d;
                color: #fff;
                text-decoration: none;
                padding: 9px 18px;
                border-radius: 4px;
                font-size: 14px;
                margin-left: 10px;
            }
        </style>
    </head>
    <body>

        <%@include file="../include/header.jsp" %>

        <div class="form-box">
            <h2>Thêm Chapter Mới (Comic ID: ${comicId})</h2>

            <form action="${pageContext.request.contextPath}/admin/chapters" method="POST">
                <input type="hidden" name="comicId" value="${comicId}" />

                <div class="form-group">
                    <label>Tập Số (Chapter Number) (*)</label>
                    <input type="number" name="chapterNumber" required placeholder="Ví dụ: 2" />
                </div>

                <div class="form-group">
                    <label>Tiêu Đề Chapter (*)</label>
                    <input type="text" name="title" required placeholder="Ví dụ: Trận chiến Ragnarok thứ nhất" />
                </div>

                <div class="form-group">
                    <label>Đường Dẫn Thư Mục Chứa Tranh (Relative Path) (*)</label>
                    <input type="text" name="folderPath" required placeholder="/comic_storage/chapters/ror/chap_2" />
                </div>


                <button type="submit" class="btn-save">Thêm Chapter Mới</button>
                <a href="${pageContext.request.contextPath}/admin/comics" class="btn-cancel">Hủy Bỏ</a>
            </form>
        </div>

    </body>
</html>