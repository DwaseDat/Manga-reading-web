package controller;

import dao.ChapterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminChapterController", urlPatterns = {"/admin/chapters"})
public class AdminChapterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String comicId = request.getParameter("comicId");
        request.setAttribute("comicId", comicId);
        request.getRequestDispatcher("/WEB-INF/admin/chapter-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int comicId = Integer.parseInt(request.getParameter("comicId"));
        int chapterNumber = Integer.parseInt(request.getParameter("chapterNumber"));
        String title = request.getParameter("title");
        String folderPath = request.getParameter("folderPath"); // Ví dụ: /comic_storage/chapters/ror/chap_2
        int totalPages = Integer.parseInt(request.getParameter("totalPages"));

        ChapterDAO dao = new ChapterDAO();
        dao.insertChapterWithPages(comicId, chapterNumber, title, folderPath, totalPages);

        response.sendRedirect(request.getContextPath() + "/admin/comics");
    }
}