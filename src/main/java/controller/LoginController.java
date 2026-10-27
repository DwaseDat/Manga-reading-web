package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đọc Cookie từ Client để kiểm tra username đã được lưu trước đó chưa
        Cookie[] cookies = request.getCookies();
        String rememberedUser = "";
        
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberUser".equals(c.getName())) {
                    rememberedUser = c.getValue();
                    break;
                }
            }
        }
        
        // Truyền giá trị username đã ghi nhớ sang login.jsp
        request.setAttribute("rememberedUser", rememberedUser);
        request.getRequestDispatcher("/WEB-INF/authenticator/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe"); // Nhận trạng thái checkbox Remember Me

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(u, p);

        if (user != null) {
            // 1. Quản lý Session đăng nhập
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);

            // 2. Quản lý Cookie "Remember Me"
            Cookie cUser = new Cookie("rememberUser", u);
            cUser.setPath(request.getContextPath()); // Scope toàn bộ ứng dụng

            if ("on".equals(rememberMe)) {
                // Tích chọn "Remember Me" -> Lưu Cookie trong 7 ngày (7 * 24 * 60 * 60 giây)
                cUser.setMaxAge(7 * 24 * 60 * 60);
            } else {
                // Không tích -> Xóa Cookie ngay lập tức
                cUser.setMaxAge(0);
            }
            response.addCookie(cUser);

            // 3. Phân luồng điều hướng theo vai trò (Role)
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/comics");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            request.getRequestDispatcher("/WEB-INF/authenticator/login.jsp").forward(request, response);
        }
    }
}