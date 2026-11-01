package controller;

import dao.CategoryDAO;
import dao.ChapterDAO;
import dao.CommentDAO;
import dao.ComicDAO;
import dao.InteractionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import model.Category;
import model.Chapter;
import model.Comic;
import model.Comment;
import model.User;

@WebServlet(name = "ComicDetailController", urlPatterns = {"/comic"})
public class ComicDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int id = Integer.parseInt(idRaw);

        ComicDAO dao = new ComicDAO();

        // -------------------------------------------------------------
        // XỬ LÝ TĂNG LƯỢT XEM VÀ CHỐNG SPAM BẰNG HTTPSESSION
        // -------------------------------------------------------------
        HttpSession session = request.getSession();
        String sessionKey = "viewed_comic_" + id;

        // Nếu trong phiên làm việc này người dùng chưa truy cập bộ truyện 'id'
        if (session.getAttribute(sessionKey) == null) {
            dao.increaseViews(id);             // Tăng 1 lượt xem dưới SQL Server
            session.setAttribute(sessionKey, true); // Đánh dấu đã xem trong Session
        }
        // -------------------------------------------------------------

        // Lấy lại đối tượng Comic (sau khi đã cập nhật số views mới nhất)
        Comic comic = dao.getComicById(id);

        // 1. Lấy danh sách chapter
        ChapterDAO chapterDao = new ChapterDAO();
        List<Chapter> chapters = chapterDao.getChaptersByComicId(id);

        // 2. Lấy danh sách thể loại (Category)
        CategoryDAO categoryDao = new CategoryDAO();
        List<Category> categories = categoryDao.getCategoriesByComicId(id);

        // 3. Kiểm tra trạng thái Yêu thích (Favorite) của User đăng nhập
        User user = (User) session.getAttribute("loggedInUser");

        boolean isFavorite = false;
        InteractionDAO interactDao = new InteractionDAO();
        if (user != null) {
            isFavorite = interactDao.isFavorite(user.getUserId(), id);
            Set<Integer> readChapterIds = interactDao.getReadChapterIds(user.getUserId(), id);
            for (Chapter chapter : chapters) chapter.setRead(readChapterIds.contains(chapter.getChapterId()));
        }

        int favoriteCount = interactDao.countFavoritesByComicId(id);
        CommentDAO commentDao = new CommentDAO();
        List<Comment> comments = commentDao.getCommentsByComicId(id);

        // 4. Đẩy tất cả dữ liệu sang View
        request.setAttribute("comic", comic);
        request.setAttribute("chapters", chapters);
        request.setAttribute("categories", categories);
        request.setAttribute("isFavorite", isFavorite);
        request.setAttribute("favoriteCount", favoriteCount);
        request.setAttribute("comments", comments);
        request.setAttribute("commentCount", comments.size());

        // 5. Chuyển hướng duy nhất ở CUỐI HÀM
        request.getRequestDispatcher("/WEB-INF/client/comic-detail.jsp").forward(request, response);
    }
}
