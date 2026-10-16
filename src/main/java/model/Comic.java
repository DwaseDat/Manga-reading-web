package model;

public class Comic {
    private int comicId;
    private String title;
    private String author;
    private String coverImage;
    private String status;
    private int views;

    public Comic() {
    }

    public Comic(int comicId, String title, String author, String coverImage, String status, int views) {
        this.comicId = comicId;
        this.title = title;
        this.author = author;
        this.coverImage = coverImage;
        this.status = status;
        this.views = views;
    }

    public int getComicId() { return comicId; }
    public void setComicId(int comicId) { this.comicId = comicId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getViews() { return views; }
    public void setViews(int views) { this.views = views; }
}
