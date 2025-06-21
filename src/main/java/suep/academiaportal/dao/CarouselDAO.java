package suep.academiaportal.dao;

import suep.academiaportal.entity.Carousel;
import suep.academiaportal.util.SQLHelper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 轮播图数据访问对象类
 * 负责处理与轮播图相关的所有数据库操作
 * 包括轮播图的增删改查等功能
 */
public class CarouselDAO {
    
    /**
     * 获取所有轮播图信息
     * 按照排序顺序升序和创建时间降序排列
     * @return 包含所有轮播图信息的List集合
     */
    public List<Carousel> getAllCarousels() {
        String sql = "SELECT * FROM Carousel ORDER BY sortOrder ASC, createTime DESC";
        List<Carousel> carousels = new ArrayList<>();
        
        ResultSet rs = SQLHelper.executeQuery(sql);
        try {
            while (rs != null && rs.next()) {
                Carousel carousel = mapResultSetToCarousel(rs);
                carousels.add(carousel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carousels;
    }
    
    /**
     * 获取所有已激活的轮播图信息
     * 仅返回isActive=1的轮播图，并按照排序顺序升序和创建时间降序排列
     * @return 包含所有激活状态轮播图的List集合
     */
    public List<Carousel> getActiveCarousels() {
        String sql = "SELECT * FROM Carousel WHERE isActive = 1 ORDER BY sortOrder ASC, createTime DESC";
        List<Carousel> carousels = new ArrayList<>();
        
        ResultSet rs = SQLHelper.executeQuery(sql);
        try {
            while (rs != null && rs.next()) {
                Carousel carousel = mapResultSetToCarousel(rs);
                carousels.add(carousel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carousels;
    }
    
    /**
     * 根据ID查询特定轮播图信息
     * @param id 轮播图ID
     * @return 如果找到则返回对应的Carousel对象，否则返回null
     */
    public Carousel getCarouselById(Long id) {
        String sql = "SELECT * FROM Carousel WHERE id = ?";
        ResultSet rs = SQLHelper.executeQuery(sql, id);
        try {
            if (rs != null && rs.next()) {
                return mapResultSetToCarousel(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 添加新的轮播图记录
     * @param carousel 要添加的轮播图对象
     * @return 新添加记录的ID
     */
    public Long addCarousel(Carousel carousel) {
        String sql = "INSERT INTO Carousel (title, imageUrl, sortOrder, isActive, publisher) VALUES (?, ?, ?, ?, ?)";
        return SQLHelper.executeInsertWithGeneratedKey(sql,
                carousel.getTitle(),
                carousel.getImageUrl(),
                carousel.getSortOrder(),
                carousel.getIsActive(),
                carousel.getPublisher());
    }
    
    /**
     * 更新现有轮播图信息
     * @param carousel 包含更新信息的轮播图对象
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateCarousel(Carousel carousel) {
        String sql = "UPDATE Carousel SET title = ?, imageUrl = ?, sortOrder = ?, isActive = ?, publisher = ? WHERE id = ?";
        return SQLHelper.executeUpdate(sql,
                carousel.getTitle(),
                carousel.getImageUrl(),
                carousel.getSortOrder(),
                carousel.getIsActive(),
                carousel.getPublisher(),
                carousel.getId()) > 0;
    }
    
    /**
     * 根据ID删除轮播图记录
     * @param id 要删除的轮播图ID
     * @return 删除成功返回true，失败返回false
     */
    public boolean deleteCarousel(Long id) {
        String sql = "DELETE FROM Carousel WHERE id = ?";
        return SQLHelper.executeUpdate(sql, id) > 0;
    }

    /**
     * 辅助方法：将数据库查询结果映射为Carousel对象
     * @param rs 数据库查询结果集
     * @return 映射后的Carousel对象
     * @throws SQLException 当数据库操作出现异常时抛出
     */
    private Carousel mapResultSetToCarousel(ResultSet rs) throws SQLException {
        Carousel carousel = new Carousel();
        carousel.setId(rs.getLong("id"));
        carousel.setTitle(rs.getString("title"));
        carousel.setImageUrl(rs.getString("imageUrl"));
        carousel.setSortOrder(rs.getInt("sortOrder"));
        carousel.setIsActive(rs.getBoolean("isActive"));
        carousel.setPublisher(rs.getString("publisher"));
        carousel.setCreateTime(rs.getTimestamp("createTime"));
        return carousel;
    }

}