package model;

public class Favorite {
    private int favoriteId;
    private int userId;
    private int comicId;

    public Favorite() {
    }

    public Favorite(int favoriteId, int userId, int comicId) {
        this.favoriteId = favoriteId;
        this.userId = userId;
        this.comicId = comicId;
    }

    public int getFavoriteId() {
        return favoriteId;
    }

    public void setFavoriteId(int favoriteId) {
        this.favoriteId = favoriteId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getComicId() {
        return comicId;
    }

    public void setComicId(int comicId) {
        this.comicId = comicId;
    }
}