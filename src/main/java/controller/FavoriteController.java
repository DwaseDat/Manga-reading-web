package controller;

import dao.InteractionDAO; // Hoặc dao.FavoriteDAO tùy tên file DAO của bạn
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Comic;
import model.User;

@WebServlet(name = "FavoriteController", urlPatterns = {"/favorite"})
public class FavoriteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đối tượng người dùng trong Session (tự động thử cả 2 tên key phổ biến)
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                user = (User) session.getAttribute("user");
            }
        }

        // Nếu chưa đăng nhập -> Chuyển hướng tới trang Đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        InteractionDAO interactDao = new InteractionDAO();
        // Lấy danh sách truyện đã thả tim của tài khoản này
        List<Comic> favoriteComics = interactDao.getFavoriteComicsByUserId(user.getUserId());

        // Đẩy đúng tên biến "favoriteComics" sang View JSP
        request.setAttribute("favoriteComics", favoriteComics);
        request.getRequestDispatcher("/WEB-INF/client/favorite-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                user = (User) session.getAttribute("user");
            }
        }

        // Nếu chưa đăng nhập -> Chuyển hướng tới trang Đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int comicId = Integer.parseInt(request.getParameter("comicId"));
        InteractionDAO interactDao = new InteractionDAO();
        
        // Thực thi thêm hoặc xóa khỏi danh sách yêu thích
        interactDao.toggleFavorite(user.getUserId(), comicId);

        // Chuyển hướng quay trở lại trang người dùng vừa thao tác
        String referer = request.getHeader("referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/favorite");
        }
    }
}