package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Chapter;

public class ChapterDAO extends DBContext {

    // Lấy danh sách Chapter của 1 bộ truyện theo comicId
    public List<Chapter> getChaptersByComicId(int comicId) {
        List<Chapter> list = new ArrayList<>();
        String sql = "SELECT * FROM Chapters WHERE comic_id = ? ORDER BY chapter_number ASC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, comicId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Chapter(
                        rs.getInt("chapter_id"),
                        rs.getInt("comic_id"),
                        rs.getInt("chapter_number"),
                        rs.getString("title")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    // Lấy danh sách link ảnh của 1 Chapter
    public java.util.List<String> getPagesByChapterId(int chapterId) {
        java.util.List<String> list = new java.util.ArrayList<>();
        try {
            String sql = "SELECT image_url FROM Chapter_Pages WHERE chapter_id = ? ORDER BY page_number ASC;";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, chapterId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("image_url"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    // 1. Lấy thông tin chapter hiện tại theo chapterId
    public Chapter getChapterById(int chapterId) {
        String sql = "SELECT * FROM Chapters WHERE chapter_id = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, chapterId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Chapter(
                        rs.getInt("chapter_id"),
                        rs.getInt("comic_id"),
                        rs.getInt("chapter_number"),
                        rs.getString("title")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    // 2. Tìm chapter trước đó (số tập < tập hiện tại, lấy tập lớn nhất gần kề)

    public Integer getPrevChapterId(int comicId, int currentChapNum) {
        String sql = "SELECT TOP 1 chapter_id FROM Chapters WHERE comic_id = ? AND chapter_number < ? ORDER BY chapter_number DESC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, comicId);
            ps.setInt(2, currentChapNum);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("chapter_id");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null; // Không có tập trước (đang ở tập đầu)
    }
    // 3. Tìm chapter tiếp theo (số tập > tập hiện tại, lấy tập nhỏ nhất gần kề)

    public Integer getNextChapterId(int comicId, int currentChapNum) {
        String sql = "SELECT TOP 1 chapter_id FROM Chapters WHERE comic_id = ? AND chapter_number > ? ORDER BY chapter_number ASC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, comicId);
            ps.setInt(2, currentChapNum);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("chapter_id");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null; // Không có tập sau (đang ở tập mới nhất)
    }
}
