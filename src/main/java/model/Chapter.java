package model;

public class Chapter {
    private int chapterId;
    private int comicId;
    private int chapterNumber;
    private String title;

    public Chapter() {}

    public Chapter(int chapterId, int comicId, int chapterNumber, String title) {
        this.chapterId = chapterId;
        this.comicId = comicId;
        this.chapterNumber = chapterNumber;
        this.title = title;
    }

    public int getChapterId() { return chapterId; }
    public void setChapterId(int chapterId) { this.chapterId = chapterId; }

    public int getComicId() { return comicId; }
    public void setComicId(int comicId) { this.comicId = comicId; }

    public int getChapterNumber() { return chapterNumber; }
    public void setChapterNumber(int chapterNumber) { this.chapterNumber = chapterNumber; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
}