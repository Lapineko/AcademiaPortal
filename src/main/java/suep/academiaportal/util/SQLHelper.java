package suep.academiaportal.util;

import java.sql.*;
import java.util.Arrays;

/**
 * 数据库操作辅助工具类
 * 提供数据库连接管理和SQL操作的通用方法
 */
public class SQLHelper {
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/academiaportal?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "271828";
    
    /**
     * 静态初始化块
     * 在类加载时注册数据库驱动
     * 如果驱动加载失败，抛出运行时异常
     */
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("Error loading database driver: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("数据库驱动加载失败");
        }
    }

    /**
     * 获取数据库连接
     * 使用配置的URL、用户名和密码创建新的连接
     * 
     * @return 数据库连接对象
     * @throws RuntimeException 如果连接获取失败
     */
    private static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            return conn;
        } catch (SQLException e) {
            System.err.println("Error getting database connection: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("获取数据库连接失败", e);
        }
    }

    /**
     * 关闭数据库资源
     * 按照ResultSet、Statement、Connection的顺序关闭资源
     * 
     * @param conn 数据库连接
     * @param stmt SQL语句对象
     * @param rs 结果集
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 执行更新操作（INSERT、UPDATE、DELETE）
     * 支持预编译语句和参数绑定
     * 
     * @param sql SQL语句
     * @param params SQL参数数组
     * @return 受影响的行数，失败返回-1
     */
    public static int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            close(conn, pstmt, null);
        }
    }

    /**
     * 执行查询操作
     * 支持预编译语句和参数绑定
     * 注意：调用者需要负责关闭返回的ResultSet
     * 
     * @param sql SQL查询语句
     * @param params SQL参数数组
     * @return 查询结果集，失败返回null
     */
    public static ResultSet executeQuery(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            return pstmt.executeQuery();
        } catch (SQLException e) {
            System.err.println("Error executing query: " + e.getMessage());
            e.printStackTrace();
            close(conn, pstmt, null);
            return null;
        }
    }

    /**
     * 执行插入操作并返回生成的主键
     * 适用于自增主键的表
     * 
     * @param sql SQL插入语句
     * @param params SQL参数数组
     * @return 生成的主键值，失败返回-1
     */
    public static long executeInsertWithGeneratedKey(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            pstmt.executeUpdate();
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getLong(1);
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            close(conn, pstmt, rs);
        }
    }
} 