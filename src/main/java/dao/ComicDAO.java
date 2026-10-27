package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Comic;

public class ComicDAO extends DBContext {

    // 1. READ ALL
    public List<Comic> getAllComics() {
        List<Comic> list = new ArrayList<>();
        String sql = "SELECT * FROM Comics ORDER BY comic_id DESC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
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
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 2. READ ONE
    public Comic getComicById(int id) {
        String sql = "SELECT * FROM Comics WHERE comic_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Comic(
                        rs.getInt("comic_id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("cover_image"),
                        rs.getString("description"),
                        rs.getString("status"),
                        rs.getInt("views")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

// Thêm truyện mới và trả về ID (comic_id) vừa được tạo tự động trong DB
    public int insertComic(Comic comic) {
        String sql = "INSERT INTO Comics (title, author, cover_image, description, status, views) VALUES (?, ?, ?, ?, ?, ?);";
        try {
            // Sử dụng Statement.RETURN_GENERATED_KEYS để lấy ID tự tăng
            PreparedStatement ps = this.getConnection().prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, comic.getTitle());
            ps.setString(2, comic.getAuthor());
            ps.setString(3, comic.getCoverImage());
            ps.setString(4, comic.getDescription());
            ps.setString(5, comic.getStatus());
            ps.setInt(6, comic.getViews());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Trả về comic_id mới tạo
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0; // Trả về 0 nếu thêm thất bại
    }

    public boolean updateComic(Comic comic) {
        String sql = "UPDATE Comics SET title = ?, author = ?, cover_image = ?, description = ?, status = ? WHERE comic_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setString(1, comic.getTitle());
            ps.setString(2, comic.getAuthor());
            ps.setString(3, comic.getCoverImage());
            ps.setString(4, comic.getDescription());
            ps.setString(5, comic.getStatus());
            ps.setInt(6, comic.getComicId());

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // 5. DELETE COMIC (Gom gọn tất cả lệnh DELETE vào 1 chuỗi duy nhất)
    public void deleteComic(int id) {
        String sql = "DELETE FROM Chapter_Pages WHERE chapter_id IN (SELECT chapter_id FROM Chapters WHERE comic_id = ?); "
                + "DELETE FROM Chapters WHERE comic_id = ?; "
                + "DELETE FROM Comic_Categories WHERE comic_id = ?; "
                + "DELETE FROM Comments WHERE comic_id = ?; "
                + "DELETE FROM Favorites WHERE comic_id = ?; "
                + "DELETE FROM Ratings WHERE comic_id = ?; "
                + "DELETE FROM Reading_History WHERE comic_id = ?; "
                + "DELETE FROM Comics WHERE comic_id = ?;";

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            // Gán tham số id cho cả 8 vị trí dấu ? trong chuỗi SQL trên
            for (int i = 1; i <= 8; i++) {
                ps.setInt(i, id);
            }
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Cập nhật danh sách thể loại liên kết của một bộ truyện
    public void updateComicCategories(int comicId, String[] categoryIds) {
        // 1. Xóa toàn bộ thể loại cũ của comic này trong bảng trung gian
        String deleteSql = "DELETE FROM Comic_Categories WHERE comic_id = ?;";
        // 2. Chèn lại các thể loại mới được chọn vào bảng trung gian
        String insertSql = "INSERT INTO Comic_Categories (comic_id, category_id) VALUES (?, ?);";

        try {
            // Xóa dữ liệu cũ
            PreparedStatement psDelete = this.getConnection().prepareStatement(deleteSql);
            psDelete.setInt(1, comicId);
            psDelete.executeUpdate();

            // Chèn dữ liệu mới được tick chọn
            if (categoryIds != null && categoryIds.length > 0) {
                PreparedStatement psInsert = this.getConnection().prepareStatement(insertSql);
                for (String catIdStr : categoryIds) {
                    int catId = Integer.parseInt(catIdStr);
                    psInsert.setInt(1, comicId);
                    psInsert.setInt(2, catId);
                    psInsert.addBatch(); // Thêm vào batch thực thi hàng loạt
                }
                psInsert.executeBatch(); // Thực thi chèn danh sách
            }
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public List<Comic> searchComicsByName(String keyword) {
        List<Comic> list = new ArrayList<>();
        String sql = "SELECT * FROM Comics WHERE title LIKE ? ORDER BY comic_id DESC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
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
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    // Lấy danh sách truyện lọc theo ID Thể loại (truy vấn qua bảng trung gian Comic_Categories)

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
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Tự động tăng lượt xem (views) của bộ truyện thêm 1
    public void increaseViews(int comicId) {
        String sql = "UPDATE Comics SET views = views + 1 WHERE comic_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, comicId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Lấy danh sách truyện xếp theo lượt xem giảm dần
    public List<Comic> getHotComics() {
        List<Comic> list = new ArrayList<>();
        String sql = "SELECT * FROM Comics ORDER BY views DESC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
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
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    // Lấy danh sách truyện xếp hạng theo các tiêu chí: views, status, favorites
    public List<Comic> getRankedComics(String filter) {
        List<Comic> list = new ArrayList<>();
        String sql;

        if ("favorites".equalsIgnoreCase(filter)) {
            // Lọc theo lượt thích (Favorite) giảm dần
            sql = "SELECT c.*, ISNULL(f.fav_count, 0) AS fav_count "
                + "FROM Comics c "
                + "LEFT JOIN (SELECT comic_id, COUNT(*) AS fav_count FROM Favorites GROUP BY comic_id) f "
                + "ON c.comic_id = f.comic_id "
                + "ORDER BY fav_count DESC, c.views DESC;";
        } else if ("status".equalsIgnoreCase(filter)) {
            // Lọc theo tình trạng (Đã full trước, Đang tiến hành sau)
            sql = "SELECT * FROM Comics ORDER BY status ASC, views DESC;";
        } else {
            // Mặc định lọc theo lượt xem (views) giảm dần
            sql = "SELECT * FROM Comics ORDER BY views DESC;";
        }

        try (PreparedStatement ps = this.getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}
