package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Comic;

public class ComicDAO extends DBContext {

    // Lấy 1 bộ truyện đầu tiên hiển thị test trang Home
    public Comic getFirstComic() {
        Comic comic = null;
        try {
            // Viết câu truy vấn lấy truyện đầu tiên
            String sql = "SELECT TOP 1 comic_id, title, author, cover_image, status, views FROM Comics;";

            // Chuẩn bị câu lệnh (Statement)
            PreparedStatement preparedStatement = this.getConnection().prepareStatement(sql);

            ResultSet rs = preparedStatement.executeQuery();

            // Lấy dữ liệu
            if (rs.next()) {
                int comicId = rs.getInt("comic_id");
                String title = rs.getString("title");
                String author = rs.getString("author");
                String coverImage = rs.getString("cover_image");
                String status = rs.getString("status");
                int views = rs.getInt("views");

                comic = new Comic(comicId, title, author, coverImage, status, views);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return comic;
    }

    // Lấy chi tiết 1 truyện theo comic_id
    public Comic getComicById(int id) {
        Comic comic = null;
        try {
            String sql = "SELECT * FROM Comics WHERE comic_id = ?;";
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                comic = new Comic(
                        rs.getInt("comic_id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("cover_image"),
                        rs.getString("status"),
                        rs.getInt("views")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(ComicDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return comic;
    }

    // Lấy danh sách tất cả các bộ truyện hiển thị lên trang Home
    public java.util.List<Comic> getAllComics() {
        java.util.List<Comic> list = new java.util.ArrayList<>();
        String sql = "SELECT comic_id, title, author, cover_image, status, views FROM Comics ORDER BY comic_id ASC;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Comic(
                        rs.getInt("comic_id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("cover_image"),
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
