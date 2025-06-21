package suep.academiaportal.dao;

import suep.academiaportal.util.SQLHelper;
import java.sql.*;

/**
 * 用户数据访问对象类
 * 负责处理与用户相关的所有数据库操作
 * 包括用户验证、角色查询、用户信息获取等功能
 */
public class UserDAO {
    
    /**
     * 验证用户登录信息
     * 检查用户ID和密码是否匹配
     * @param id 用户ID
     * @param password 用户密码
     * @return 验证成功返回true，失败返回false
     */
    public boolean validateUser(int id, String password) {
        String sql = "SELECT * FROM Users WHERE id = ? AND password = ?";
        ResultSet rs = SQLHelper.executeQuery(sql, id, password);
        try {
            return rs != null && rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取用户角色信息
     * @param id 用户ID
     * @return 用户角色字符串，如果未找到用户则返回null
     */
    public String getUserRole(int id) {
        String sql = "SELECT role FROM Users WHERE id = ?";
        ResultSet rs = SQLHelper.executeQuery(sql, id);
        try {
            if (rs != null && rs.next()) {
                return rs.getString("role");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取用户真实姓名
     * @param id 用户ID
     * @return 用户真实姓名，如果未找到用户则返回null
     */
    public String getUserRealName(int id) {
        String sql = "SELECT realName FROM Users WHERE id = ?";
        ResultSet rs = SQLHelper.executeQuery(sql, id);
        try {
            if (rs != null && rs.next()) {
                return rs.getString("realName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
} 