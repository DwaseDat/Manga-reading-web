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

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        ComicDAO comicDao = new ComicDAO();
        List<Comic> comicList;

        // Nếu người dùng gõ từ khóa tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            comicList = comicDao.searchComicsByName(keyword.trim());
        } else {
            // Không gõ từ khóa -> Lấy toàn bộ danh sách truyện
            comicList = comicDao.getAllComics();
        }

        // Gửi danh sách qua JSP
        request.setAttribute("comics", comicList);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/WEB-INF/client/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}