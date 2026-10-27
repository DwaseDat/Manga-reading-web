package controller;

import dao.ChapterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
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
        // CODE MỚI - Tự động đếm số trang ảnh từ thư mục
        String relativePath = request.getParameter("folderPath"); // Ví dụ: /comic_storage/chapters/ror/chap_2
        String realPath = getServletContext().getRealPath(relativePath);

        int totalPages = 0;
        if (realPath != null) {
            File folder = new File(realPath);
            if (folder.exists() && folder.isDirectory()) {
                File[] imageFiles = folder.listFiles((dir, name) -> {
                    String n = name.toLowerCase();
                    return n.endsWith(".jpg") || n.endsWith(".png") || n.endsWith(".jpeg") || n.endsWith(".webp");
                });
                if (imageFiles != null) {
                    totalPages = imageFiles.length; // Tự động lấy số lượng trang ảnh
                }
            }
        }

        ChapterDAO dao = new ChapterDAO();
        dao.insertChapterWithPages(comicId, chapterNumber, title, folderPath, totalPages);

        response.sendRedirect(request.getContextPath() + "/admin/comics");
    }
}
