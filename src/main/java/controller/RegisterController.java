package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Điều hướng đến giao diện đăng ký
        request.getRequestDispatcher("/WEB-INF/authenticator/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String confirmP = request.getParameter("confirmPassword");

        // Validate cơ bản phía Server
        if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
            request.setAttribute("error", "Tên đăng nhập và mật khẩu không được để trống!");
            request.getRequestDispatcher("/WEB-INF/client/register.jsp").forward(request, response);
            return;
        }

        if (!p.equals(confirmP)) {
            request.setAttribute("error", "Mật khẩu xác nhận không trùng khớp!");
            request.getRequestDispatcher("/WEB-INF/authenticator/register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean isSuccess = userDAO.register(u.trim(), p.trim());

        if (isSuccess) {
            // Đăng ký thành công -> Chuyển sang trang Đăng nhập kèm thông báo thành công
            request.setAttribute("message", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("/WEB-INF/authenticator/login.jsp").forward(request, response);
        } else {
            // Đăng ký thất bại (Username đã tồn tại)
            request.setAttribute("error", "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác!");
            request.getRequestDispatcher("/WEB-INF/authenticator/register.jsp").forward(request, response);
        }
    }
}