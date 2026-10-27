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

public class InteractionDAO extends DBContext {

    // 1. Kiểm tra người dùng đã thêm bộ truyện này vào yêu thích chưa
    public boolean isFavorite(int userId, int comicId) {
        String sql = "SELECT 1 FROM Favorites WHERE user_id = ? AND comic_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, comicId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(InteractionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // 2. Thêm hoặc Bỏ yêu thích (Thêm nếu chưa có, Xóa nếu đã có)
    public boolean toggleFavorite(int userId, int comicId) {
        if (isFavorite(userId, comicId)) {
            String sql = "DELETE FROM Favorites WHERE user_id = ? AND comic_id = ?;";
            try {
                PreparedStatement ps = this.getConnection().prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, comicId);
                return ps.executeUpdate() > 0;
            } catch (SQLException ex) {
                Logger.getLogger(InteractionDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            String sql = "INSERT INTO Favorites (user_id, comic_id) VALUES (?, ?);";
            try {
                PreparedStatement ps = this.getConnection().prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, comicId);
                return ps.executeUpdate() > 0;
            } catch (SQLException ex) {
                Logger.getLogger(InteractionDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return false;
    }

    // 3. Lấy danh sách các truyện đã thích để hiển thị tại trang Follow (/favorite)
    public List<Comic> getFavoriteComicsByUserId(int userId) {
        List<Comic> list = new ArrayList<>();
        String sql = "SELECT c.* FROM Comics c "
                + "JOIN Favorites f ON c.comic_id = f.comic_id "
                + "WHERE f.user_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, userId);
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
            Logger.getLogger(InteractionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // 1. Tự động Lưu hoặc Cập nhật Lịch sử đọc
    public void saveOrUpdateHistory(int userId, int comicId, int chapterId) {
        String checkSql = "SELECT user_id FROM Reading_History WHERE user_id = ? AND comic_id = ?;";
        String updateSql = "UPDATE Reading_History SET last_chapter_id = ?, updated_at = GETDATE() WHERE user_id = ? AND comic_id = ?;";
        String insertSql = "INSERT INTO Reading_History (user_id, comic_id, last_chapter_id, updated_at) VALUES (?, ?, ?, GETDATE());";

        try {
            PreparedStatement psCheck = this.getConnection().prepareStatement(checkSql);
            psCheck.setInt(1, userId);
            psCheck.setInt(2, comicId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Đã đọc bộ truyện này trước đó -> Cập nhật chapter mới & thời gian đọc mới nhất
                PreparedStatement psUpdate = this.getConnection().prepareStatement(updateSql);
                psUpdate.setInt(1, chapterId);
                psUpdate.setInt(2, userId);
                psUpdate.setInt(3, comicId);
                psUpdate.executeUpdate();
            } else {
                // Lần đầu đọc bộ truyện này -> Thêm bản ghi mới
                PreparedStatement psInsert = this.getConnection().prepareStatement(insertSql);
                psInsert.setInt(1, userId);
                psInsert.setInt(2, comicId);
                psInsert.setInt(3, chapterId);
                psInsert.executeUpdate();
            }
        } catch (SQLException ex) {
            Logger.getLogger(InteractionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // 2. Lấy danh sách truyện trong Lịch sử đọc theo thứ tự vừa xem mới nhất
    public List<Comic> getReadingHistoryByUserId(int userId) {
        List<Comic> list = new ArrayList<>();
        String sql = "SELECT c.* FROM Comics c "
                + "JOIN Reading_History rh ON c.comic_id = rh.comic_id "
                + "WHERE rh.user_id = ? "
                + "ORDER BY rh.updated_at DESC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, userId);
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
            Logger.getLogger(InteractionDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

}
