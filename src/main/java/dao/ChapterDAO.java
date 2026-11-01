package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Chapter;

public class ChapterDAO extends DBContext {

// Lấy danh sách Chapter theo comic_id
    public List<Chapter> getChaptersByComicId(int comicId) {
        List<Chapter> list = new ArrayList<>();
        String sql = "SELECT chapter_id, comic_id, chapter_number, title FROM Chapters WHERE comic_id = ? ORDER BY chapter_number ASC;";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, comicId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Chapter(
                            rs.getInt("chapter_id"),
                            rs.getInt("comic_id"),
                            rs.getInt("chapter_number"),
                            rs.getString("title")
                    ));
                }
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

    // Thêm Chapter mới và danh sách các trang ảnh tự động
    public boolean insertChapterWithPages(int comicId, int chapterNumber, String title, String folderPath, int totalPages) {
        List<String> urls = new ArrayList<>();
        for (int i = 1; i <= totalPages; i++) urls.add(folderPath + "/" + i + ".jpg");
        return insertChapterWithPages(comicId, chapterNumber, title, urls);
    }

    public boolean insertChapterWithPages(int comicId, int chapterNumber, String title, List<String> imageUrls) {
        String sqlChapter = "INSERT INTO Chapters (comic_id, chapter_number, title) VALUES (?, ?, ?);";
        String sqlPage = "INSERT INTO Chapter_Pages (chapter_id, page_number, image_url) VALUES (?, ?, ?);";

        try {
            // 1. Thêm Chapter mới và lấy về chapter_id tự tăng vừa tạo
            PreparedStatement ps1 = this.getConnection().prepareStatement(sqlChapter, Statement.RETURN_GENERATED_KEYS);
            ps1.setInt(1, comicId);
            ps1.setInt(2, chapterNumber);
            ps1.setString(3, title);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            int newChapterId = 0;
            if (rs.next()) {
                newChapterId = rs.getInt(1);
            }

            // 2. Chèn tự động danh sách các trang ảnh tương ứng vào Chapter_Pages
            if (newChapterId > 0) {
                PreparedStatement ps2 = this.getConnection().prepareStatement(sqlPage);
                for (int i = 0; i < imageUrls.size(); i++) {
                    ps2.setInt(1, newChapterId);
                    ps2.setInt(2, i + 1);
                    ps2.setString(3, imageUrls.get(i));
                    ps2.addBatch();
                }
                ps2.executeBatch(); // Thực thi chèn hàng loạt
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

// Xóa Chapter theo ID
    public boolean deleteChapter(int chapterId) {
        Connection connection = getConnection();
        if (connection == null) return false;
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement clearReadingHistory = connection.prepareStatement("UPDATE Reading_History SET last_chapter_id = NULL WHERE last_chapter_id = ?");
                 PreparedStatement deletePages = connection.prepareStatement("DELETE FROM Chapter_Pages WHERE chapter_id = ?");
                 PreparedStatement deleteChapter = connection.prepareStatement("DELETE FROM Chapters WHERE chapter_id = ?")) {
                clearReadingHistory.setInt(1, chapterId);
                clearReadingHistory.executeUpdate();
                deletePages.setInt(1, chapterId);
                deletePages.executeUpdate();
                deleteChapter.setInt(1, chapterId);
                boolean deleted = deleteChapter.executeUpdate() > 0;
                connection.commit();
                return deleted;
            } catch (SQLException ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    // Cập nhật Tập số và Tiêu đề Chapter
    public void updateChapter(int chapterId, int chapterNumber, String title) {
        String sql = "UPDATE Chapters SET chapter_number = ?, title = ? WHERE chapter_id = ?;";
        try (PreparedStatement ps = this.getConnection().prepareStatement(sql)) {
            ps.setInt(1, chapterNumber);
            ps.setString(2, title);
            ps.setInt(3, chapterId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ChapterDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
