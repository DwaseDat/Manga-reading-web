    package controller;

    import dao.ChapterDAO;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import java.io.IOException;
    import java.util.List;
    import model.Chapter;

    @WebServlet(name = "ReadChapterController", urlPatterns = {"/read"})
    public class ReadChapterController extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            ChapterDAO chapterDao = new ChapterDAO();

            // 1. Lấy thông tin chapter hiện tại
            Chapter currentChapter = chapterDao.getChapterById(chapterId);
            if (currentChapter != null) {
                // 2. Tìm ID tập trước và tập kế tiếp
                Integer prevId = chapterDao.getPrevChapterId(currentChapter.getComicId(), currentChapter.getChapterNumber());
                Integer nextId = chapterDao.getNextChapterId(currentChapter.getComicId(), currentChapter.getChapterNumber());

                request.setAttribute("currentChapter", currentChapter);
                request.setAttribute("prevId", prevId);
                request.setAttribute("nextId", nextId);
            }

            // 3. Lấy danh sách trang ảnh
            List<String> pages = chapterDao.getPagesByChapterId(chapterId);
            request.setAttribute("pages", pages);

            request.getRequestDispatcher("/WEB-INF/client/read.jsp").forward(request, response);
        }
    }