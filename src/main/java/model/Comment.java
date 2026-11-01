/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class Comment {
    private int commentId;
    private int comicId;
    private int userId;
    private String username;
    private String content;
    private Timestamp createdAt;

    public Comment(int commentId, int comicId, int userId, String username, String content, Timestamp createdAt) {
        this.commentId = commentId;
        this.comicId = comicId;
        this.userId = userId;
        this.username = username;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getCommentId() { return commentId; }
    public int getComicId() { return comicId; }
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getContent() { return content; }
    public Timestamp getCreatedAt() { return createdAt; }
}
