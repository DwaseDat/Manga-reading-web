package dao;

import db.DBContext;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

public class UserDAO extends DBContext {

    // 0. Phương thức băm mật khẩu MD5 để bảo mật thông tin
    public String hashMd5(String rawPassword) {
        if (rawPassword == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(rawPassword.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
            return rawPassword;
        }
    }

    // 1. Kiểm tra xem username đã được ai đăng ký chưa
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT [user_id] FROM [Users] WHERE [username] = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return true; // Đã tồn tại
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false; // Chưa tồn tại
    }

    // 2. Đăng ký tài khoản mới (Mặc định role = 'CUSTOMER' và mật khẩu được băm MD5)
    public boolean register(String username, String password) {
        if (checkUsernameExists(username)) {
            return false;
        }

        String hashedPassword = hashMd5(password);
        String sql = "INSERT INTO [Users] ([username], [password], [role]) VALUES (?, ?, 'CUSTOMER');";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Phương thức kiểm tra thông tin đăng nhập từ cơ sở dữ liệu
     *
     * @param username Tên đăng nhập
     * @param rawPassword Mật khẩu chưa mã hóa
     * @return Đối tượng User nếu đúng thông tin, trả về null nếu sai
     */
    public User login(String username, String rawPassword) {
        // Mã hóa mật khẩu đầu vào bằng MD5 trước khi so sánh với CSDL
        String hashedPassword = hashMd5(rawPassword);

        String sql = "SELECT [user_id], [username], [password], [role] "
                + "FROM [Users] "
                + "WHERE [username] = ? AND [password] = ?;";
        try {
            PreparedStatement ps = this.getConnection().prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashedPassword);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }
}