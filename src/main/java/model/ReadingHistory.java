package model;

import java.sql.Timestamp;

public class ReadingHistory {
    private int historyId;
    private int userId;
    private int comicId;
    private int lastChapterId;
    private Timestamp readAt;

    public ReadingHistory() {
    }

    public ReadingHistory(int historyId, int userId, int comicId, int lastChapterId, Timestamp readAt) {
        this.historyId = historyId;
        this.userId = userId;
        this.comicId = comicId;
        this.lastChapterId = lastChapterId;
        this.readAt = readAt;
    }

    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getComicId() { return comicId; }
    public void setComicId(int comicId) { this.comicId = comicId; }

    public int getLastChapterId() { return lastChapterId; }
    public void setLastChapterId(int lastChapterId) { this.lastChapterId = lastChapterId; }

    public Timestamp getReadAt() { return readAt; }
    public void setReadAt(Timestamp readAt) { this.readAt = readAt; }
}