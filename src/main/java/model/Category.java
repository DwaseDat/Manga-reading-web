package model;

public class Category {
    private int categoryId;
    private String categoryName;

    // 1. Constructor không tham số (Mặc định)
    public Category() {
    }

    // 2. Constructor đầy đủ tham số
    public Category(int categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    // 3. Getter và Setter cho các thuộc tính
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
}