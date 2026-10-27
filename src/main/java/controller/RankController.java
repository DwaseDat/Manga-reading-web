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

@WebServlet(name = "RankController", urlPatterns = {"/rank"})
public class RankController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số filter từ URL: /rank?filter=views (hoặc status, favorites)
        String filter = request.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) {
            filter = "views"; // Mặc định sắp xếp theo lượt xem
        }

        ComicDAO comicDAO = new ComicDAO();
        List<Comic> rankedComics = comicDAO.getRankedComics(filter);

        request.setAttribute("comics", rankedComics);
        request.setAttribute("currentFilter", filter);

        request.getRequestDispatcher("/WEB-INF/client/rank.jsp").forward(request, response);
    }
}