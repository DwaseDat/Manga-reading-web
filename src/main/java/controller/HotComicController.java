package controller;

import dao.ComicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Comic;

@WebServlet(name = "HotComicController", urlPatterns = {"/hot"})
public class HotComicController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ComicDAO comicDAO = new ComicDAO();
        // Lấy danh sách truyện sắp xếp giảm dần theo số lượt xem (views DESC)
        List<Comic> hotComics = comicDAO.getHotComics();
        
        // Truyền danh sách truyện Hot và tiêu đề sang trang JSP
        request.setAttribute("comics", hotComics);
        request.setAttribute("sectionTitle", "🔥 Truyện Tranh Nổi Bật (Xem Nhiều Nhất)");
        
        // Forward dữ liệu sang giao diện home.jsp (hoặc hot.jsp tùy bạn đặt)
        request.getRequestDispatcher("/WEB-INF/client/home.jsp").forward(request, response);
    }
}