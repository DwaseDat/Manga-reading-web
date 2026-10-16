package controller;
import dao.ChapterDAO;
import dao.ComicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Chapter;
import model.Comic;

@WebServlet(name = "ComicDetailController", urlPatterns = {"/comic"})
public class ComicDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ComicDAO dao = new ComicDAO();

        Comic comic = dao.getComicById(id);
        // Lấy danh sách chapter bằng ChapterDAO hoặc ComicDAO
        ChapterDAO chapterDao = new ChapterDAO();
        List<Chapter> chapters = chapterDao.getChaptersByComicId(id);

        request.setAttribute("comic", comic);
        request.setAttribute("chapters", chapters);

        // Chuyển hướng vào đúng thư mục WEB-INF/client/
        request.getRequestDispatcher("/WEB-INF/client/comic-detail.jsp").forward(request, response);
    }
}