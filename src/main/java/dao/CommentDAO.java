/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Comment;

public class CommentDAO extends DBContext {
    public List<Comment> getCommentsByComicId(int comicId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.comment_id, c.comic_id, c.user_id, u.username, c.content, c.created_at "
                + "FROM Comments c LEFT JOIN Users u ON c.user_id = u.user_id "
                + "WHERE c.comic_id = ? AND c.parent_id IS NULL ORDER BY c.created_at DESC, c.comment_id DESC";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, comicId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    comments.add(new Comment(rs.getInt("comment_id"), rs.getInt("comic_id"),
                            rs.getInt("user_id"), rs.getString("username"), rs.getString("content"),
                            rs.getTimestamp("created_at")));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(CommentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return comments;
    }

    public boolean addComment(int comicId, int userId, String content) {
        String sql = "INSERT INTO Comments (comic_id, user_id, content, created_at) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, comicId);
            ps.setInt(2, userId);
            ps.setString(3, content);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            Logger.getLogger(CommentDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public int countByComicId(int comicId) {
        String sql = "SELECT COUNT(*) FROM Comments WHERE comic_id = ? AND parent_id IS NULL";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, comicId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? rs.getInt(1) : 0; }
        } catch (SQLException ex) {
            Logger.getLogger(CommentDAO.class.getName()).log(Level.SEVERE, null, ex);
            return 0;
        }
    }
}
