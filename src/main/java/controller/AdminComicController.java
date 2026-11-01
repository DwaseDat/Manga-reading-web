package controller;

import dao.CategoryDAO;
import dao.ComicDAO;
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
import java.util.List;
import model.Category;
import model.Comic;
import util.ComicStorage;

@WebServlet(name = "AdminComicController", urlPatterns = {"/admin/comics"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminComicController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        ComicDAO comicDAO = new ComicDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Lấy danh sách tất cả thể loại để hiển thị lên Form Checkbox
        List<Category> allCategories = categoryDAO.getAllCategories();
        request.setAttribute("allCategories", allCategories);

        switch (action) {
            case "create":
                request.getRequestDispatcher("/WEB-INF/admin/comic-form.jsp").forward(request, response);
                break;

            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Comic comic = comicDAO.getComicById(editId);
                
                // Lấy danh sách ID thể loại mà bộ truyện này đang có
                List<Integer> selectedCategoryIds = categoryDAO.getCategoryIdsByComicId(editId);
                
                request.setAttribute("comic", comic);
                request.setAttribute("selectedCategoryIds", selectedCategoryIds);
                request.getRequestDispatcher("/WEB-INF/admin/comic-form.jsp").forward(request, response);
                break;

            case "delete":
                try {
                    String idRaw = request.getParameter("id");
                    if (idRaw != null && !idRaw.trim().isEmpty()) {
                        int deleteId = Integer.parseInt(idRaw);
                        comicDAO.deleteComic(deleteId); // Gọi hàm xóa trong ComicDAO
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.sendRedirect(request.getContextPath() + "/admin/comics");
                return;

            case "list":
            default:
                List<Comic> list = comicDAO.getAllComics();
                request.setAttribute("comics", list);
                request.getRequestDispatcher("/WEB-INF/admin/comic-list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ComicDAO comicDAO = new ComicDAO();

        if ("save".equals(action)) {
            String idRaw = request.getParameter("id");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            
            // Nhận mảng các category_id được Admin tích chọn trên giao diện Checkbox
            String[] categoryIds = request.getParameterValues("categories");
            String coverImage = request.getParameter("coverImageOld"); // Mặc định giữ đường dẫn ảnh cũ
            Part filePart = request.getPart("coverImageFile");

            if (idRaw == null || idRaw.trim().isEmpty()) {
                // Thêm mới truyện
                Comic newComic = new Comic(0, title, author, coverImage, description, status, 0);
                int generatedId = comicDAO.insertComic(newComic);
                if (generatedId > 0) {
                    if (hasUpload(filePart)) {
                        coverImage = saveCover(filePart, generatedId);
                        newComic.setComicId(generatedId);
                        newComic.setCoverImage(coverImage);
                        comicDAO.updateComic(newComic);
                    }
                    if (categoryIds != null) comicDAO.updateComicCategories(generatedId, categoryIds);
                }
            } else {
                // Cập nhật truyện
                int id = Integer.parseInt(idRaw);
                Comic existingComic = comicDAO.getComicById(id);
                int views = (existingComic != null) ? existingComic.getViews() : 0;

                if (hasUpload(filePart)) coverImage = saveCover(filePart, id);

                Comic updateComic = new Comic(id, title, author, coverImage, description, status, views);
                comicDAO.updateComic(updateComic);
                
                // Cập nhật danh sách thể loại liên kết cho truyện
                comicDAO.updateComicCategories(id, categoryIds);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/comics");
    }

    private boolean hasUpload(Part part) {
        return part != null && part.getSize() > 0 && part.getSubmittedFileName() != null;
    }

    private String saveCover(Part part, int comicId) throws IOException, ServletException {
        String submittedName = Paths.get(part.getSubmittedFileName().replace('\\', '/')).getFileName().toString();
        int dot = submittedName.lastIndexOf('.');
        if (dot < 0) throw new ServletException("File ảnh bìa không có phần mở rộng hợp lệ.");
        String extension = submittedName.substring(dot).toLowerCase();
        if (!extension.matches("\\.(jpg|jpeg|png|gif|webp|bmp)")) {
            throw new ServletException("Chỉ chấp nhận file ảnh JPG, PNG, GIF, WEBP hoặc BMP.");
        }

        File coverDirectory = new File(ComicStorage.root(getServletContext()), "covers");
        if (!coverDirectory.exists() && !coverDirectory.mkdirs()) {
            throw new IOException("Không tạo được thư mục comic_storage/covers.");
        }
        String fileName = comicId + extension;
        part.write(new File(coverDirectory, fileName).getAbsolutePath());
        return "/images/covers/" + fileName;
    }
}
