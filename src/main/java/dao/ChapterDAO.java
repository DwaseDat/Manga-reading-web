package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

    // Thêm Chapter mới và danh sách các trang ảnh tự động
    public boolean insertChapterWithPages(int comicId, int chapterNumber, String title, String folderPath, int totalPages) {
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
                for (int i = 1; i <= totalPages; i++) {
                    ps2.setInt(1, newChapterId);
                    ps2.setInt(2, i);
                    // Ghép đường dẫn dạng: /comic_storage/chapters/ror/chap_2/1.jpg
                    ps2.setString(3, folderPath + "/" + i + ".jpg");
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
}
