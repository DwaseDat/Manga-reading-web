package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/favorite", "/rating", "/comment", "/history", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        String uri = req.getRequestURI();

        // 1. Nếu chưa đăng nhập mà vào các tính năng cá nhân/admin -> Đẩy về /login
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Nếu không phải ADMIN mà cố tình gõ link /admin/... -> Chặn đẩy về trang chủ
        if (uri.contains("/admin/") && !"ADMIN".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        chain.doFilter(request, response);
    }
}