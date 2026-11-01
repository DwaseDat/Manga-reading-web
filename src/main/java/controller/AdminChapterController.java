package controller;

import dao.ChapterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import model.Chapter;
import util.ComicStorage;

@WebServlet(name = "AdminChapterController", urlPatterns = {"/admin/chapters"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 20,       // 20MB / file ảnh
    maxRequestSize = 1024 * 1024 * 200    // 200MB / tổng bộ ảnh
)
public class AdminChapterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String comicIdRaw = request.getParameter("comicId");
        ChapterDAO dao = new ChapterDAO();

        if (comicIdRaw == null || comicIdRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/comics");
            return;
        }

        int comicId = Integer.parseInt(comicIdRaw);

        // 2. MỞ FORM SỬA CHAPTER
        if ("edit".equalsIgnoreCase(action)) {
            String chapterIdRaw = request.getParameter("chapterId");
            if (chapterIdRaw != null && !chapterIdRaw.trim().isEmpty()) {
                int chapterId = Integer.parseInt(chapterIdRaw);
                Chapter chapter = dao.getChapterById(chapterId);
                request.setAttribute("chapter", chapter);
            }
            request.setAttribute("comicId", comicId);
            request.getRequestDispatcher("/WEB-INF/admin/chapter-form.jsp").forward(request, response);
            return;
        }

        // 3. MỞ FORM THÊM CHAPTER MỚI
        if ("create".equalsIgnoreCase(action)) {
            request.setAttribute("comicId", comicId);
            request.getRequestDispatcher("/WEB-INF/admin/chapter-form.jsp").forward(request, response);
            return;
        }

        // 4. MẶC ĐỊNH: HIỂN THỊ DANH SÁCH CHAPTER
        List<Chapter> chapters = dao.getChaptersByComicId(comicId);
        request.setAttribute("comicId", comicId);
        request.setAttribute("chapters", chapters);
        request.getRequestDispatcher("/WEB-INF/admin/chapter-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int comicId = Integer.parseInt(request.getParameter("comicId"));
        ChapterDAO dao = new ChapterDAO();

        if ("delete".equalsIgnoreCase(action)) {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            boolean deleted = dao.deleteChapter(chapterId);
            response.sendRedirect(request.getContextPath() + "/admin/chapters?comicId=" + comicId + (deleted ? "&deleted=1" : "&deleteError=1"));
            return;
        }

        int chapterNumber = Integer.parseInt(request.getParameter("chapterNumber"));
        String title = request.getParameter("title");

        // XỬ LÝ CẬP NHẬT CHAPTER
        if ("update".equalsIgnoreCase(action)) {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            dao.updateChapter(chapterId, chapterNumber, title);
        }
        // XỬ LÝ THÊM CHAPTER MỚI (TỰ ĐỘNG LƯU FILE ẢNH TẢI LÊN)
        else {
            String folderPath = "/images/chapters/" + comicId + "/chap_" + chapterNumber;
            File folder = new File(ComicStorage.root(getServletContext()), "chapters" + File.separator + comicId + File.separator + "chap_" + chapterNumber);
            if (!folder.exists() && !folder.mkdirs()) {
                throw new IOException("Không tạo được thư mục lưu chapter.");
            }

            Collection<Part> parts = request.getParts();
            List<Part> imageParts = new ArrayList<>();
            for (Part part : parts) {
                if ("chapterImages".equals(part.getName()) && part.getSize() > 0
                        && part.getSubmittedFileName() != null && part.getSubmittedFileName().matches("(?i).+\\.(jpg|jpeg|png|gif|webp|bmp)")) {
                    imageParts.add(part);
                }
            }
            imageParts.sort((left, right) -> naturalCompare(
                    Paths.get(left.getSubmittedFileName().replace('\\', '/')).getFileName().toString(),
                    Paths.get(right.getSubmittedFileName().replace('\\', '/')).getFileName().toString()));
            if (imageParts.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn ít nhất một file ảnh hợp lệ.");
                request.setAttribute("comicId", comicId);
                request.getRequestDispatcher("/WEB-INF/admin/chapter-form.jsp").forward(request, response);
                return;
            }

            List<String> imageUrls = new ArrayList<>();
            int pageNumber = 1;
            for (Part part : imageParts) {
                String submittedName = Paths.get(part.getSubmittedFileName().replace('\\', '/')).getFileName().toString();
                String extension = submittedName.substring(submittedName.lastIndexOf('.')).toLowerCase();
                String numberedName = pageNumber + extension;
                part.write(new File(folder, numberedName).getAbsolutePath());
                imageUrls.add(folderPath + "/" + numberedName);
                pageNumber++;
            }
            if (!dao.insertChapterWithPages(comicId, chapterNumber, title, imageUrls)) {
                throw new ServletException("Không lưu được thông tin chapter vào cơ sở dữ liệu.");
            }
        }

        String notice = "create".equalsIgnoreCase(action) ? "&uploaded=1" : "&updated=1";
        response.sendRedirect(request.getContextPath() + "/admin/chapters?comicId=" + comicId + notice);
    }

    private int naturalCompare(String first, String second) {
        int i = 0, j = 0;
        while (i < first.length() && j < second.length()) {
            char a = Character.toLowerCase(first.charAt(i));
            char b = Character.toLowerCase(second.charAt(j));
            if (Character.isDigit(a) && Character.isDigit(b)) {
                int startA = i, startB = j;
                while (i < first.length() && Character.isDigit(first.charAt(i))) i++;
                while (j < second.length() && Character.isDigit(second.charAt(j))) j++;
                String numberA = first.substring(startA, i).replaceFirst("^0+(?!$)", "");
                String numberB = second.substring(startB, j).replaceFirst("^0+(?!$)", "");
                int lengthCompare = Integer.compare(numberA.length(), numberB.length());
                if (lengthCompare != 0) return lengthCompare;
                int numberCompare = numberA.compareTo(numberB);
                if (numberCompare != 0) return numberCompare;
            } else {
                if (a != b) return Character.compare(a, b);
                i++; j++;
            }
        }
        return Integer.compare(first.length(), second.length());
    }
}
