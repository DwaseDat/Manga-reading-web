<%-- 
    Document   : footer
    Created on : Oct 13, 2026, 9:39:02 AM
    Author     : DAT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<style>
    .site-footer {
        background-color: #EACAFF;
        padding: 25px 40px;
        color: #493653;
        font-family: Arial, sans-serif;
    }

    .footer-inner {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 100px;
    }

    .footer-logo img {
        height: 100px;
        width: auto;
        display: block;
    }

    .footer-content {
        text-align: center;
        line-height: 1.8;
    }

    .footer-content p {
        margin: 8px 0;
    }

    .footer-policy {
        color: #493653;
        text-decoration: none;
        font-weight: bold;
    }

    .footer-description {
        color: #806B8A;
    }

    @media (max-width: 600px) {
        .footer-inner {
            flex-direction: column;
            gap: 15px;
        }

        .site-footer {
            padding: 20px;
        }
    }
</style>

<footer class="site-footer">
    <div class="footer-inner">

        <!-- Logo Nami Tales -->
        <div class="footer-logo">
            <a href="${pageContext.request.contextPath}/home">
                <img
                    src="${pageContext.request.contextPath}/img/logo.png"
                    alt="Nami Tales">
            </a>
        </div>

        <!-- Thông tin footer -->
        <div class="footer-content">

            <p>
                <span class="footer-policy">
                    Privacy Policy
                </span>
            </p>

            <p>
                &copy; 2026 Nami Tales. All rights reserved.
            </p>

            <p class="footer-description">
                Nami Tales - Thế giới truyện tranh dành cho bạn.
            </p>

        </div>

    </div>
</footer>