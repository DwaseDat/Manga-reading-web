package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Category;
import model.Comic;

public class CategoryDAO extends DBContext {

    // 1. Lấy toàn bộ danh sách thể loại từ database (Sắp xếp theo tên)
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories ORDER BY category_name ASC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 2. Lấy danh sách category_id đã được gắn với một comic_id cụ thể
    public List<Integer> getCategoryIdsByComicId(int comicId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT category_id FROM Comic_Categories WHERE comic_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, comicId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("category_id"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 3. Lấy danh sách đối tượng Category (id & name) theo comic_id
    public List<Category> getCategoriesByComicId(int comicId) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.category_id, c.category_name "
                   + "FROM Categories c "
                   + "JOIN Comic_Categories cc ON c.category_id = cc.category_id "
                   + "WHERE cc.comic_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, comicId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 4. BỔ SUNG: Lấy thông tin 1 thể loại theo category_id (Phục vụ cho CategoryController)
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Categories WHERE category_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // 5. BỔ SUNG: Lấy danh sách truyện thuộc về 1 thể loại cụ thể (Join bảng Comics và Comic_Categories)
    public List<Comic> getComicsByCategoryId(int categoryId) {
        List<Comic> list = new ArrayList<>();
        String sql = "SELECT c.* FROM Comics c "
                   + "JOIN Comic_Categories cc ON c.comic_id = cc.comic_id "
                   + "WHERE cc.category_id = ? ORDER BY c.comic_id DESC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Comic(
                        rs.getInt("comic_id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("cover_image"),
                        rs.getString("description"),
                        rs.getString("status"),
                        rs.getInt("views")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}