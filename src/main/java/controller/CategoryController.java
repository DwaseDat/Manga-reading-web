package controller;

import dao.CategoryDAO;
import dao.ComicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Comic;

@WebServlet(name = "CategoryController", urlPatterns = {"/category"})
public class CategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        CategoryDAO categoryDao = new CategoryDAO();
        ComicDAO comicDao = new ComicDAO();

        // 1. Lấy toàn bộ danh sách thể loại để hiển thị lên Menu lọc
        List<Category> categories = categoryDao.getAllCategories();
        request.setAttribute("categories", categories);

        // 2. Kiểm tra xem người dùng có chọn thể loại cụ thể nào không (?id=...)
        String catIdRaw = request.getParameter("id");
        List<Comic> comicList;
        String selectedCatName = "Tất cả truyện";

        if (catIdRaw != null && !catIdRaw.trim().isEmpty()) {
            try {
                int categoryId = Integer.parseInt(catIdRaw);
                // Lấy danh sách truyện thuộc thể loại được chọn
                comicList = comicDao.getComicsByCategoryId(categoryId);
                
                // Tìm tên thể loại để hiển thị tiêu đề
                Category selectedCat = categoryDao.getCategoryById(categoryId);
                if (selectedCat != null) {
                    selectedCatName = selectedCat.getCategoryName();
                }
                request.setAttribute("selectedCatId", categoryId);
            } catch (NumberFormatException e) {
                comicList = comicDao.getAllComics();
            }
        } else {
            // Nếu không chọn thể loại -> Lấy tất cả truyện
            comicList = comicDao.getAllComics();
        }

        request.setAttribute("selectedCatName", selectedCatName);
        request.setAttribute("comics", comicList);

        // Forward dữ liệu tới view category-filter.jsp
        request.getRequestDispatcher("/WEB-INF/client/category-filter.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}