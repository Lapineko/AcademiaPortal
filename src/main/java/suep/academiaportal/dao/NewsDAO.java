package suep.academiaportal.dao;

import suep.academiaportal.entity.News;
import suep.academiaportal.util.SQLHelper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * 新闻数据访问对象类
 * 负责处理与新闻相关的所有数据库操作
 * 包括新闻的增删改查、置顶管理等功能
 */
public class NewsDAO {

    /**
     * 根据ID获取新闻详细信息
     * @param id 新闻ID
     * @return 如果找到则返回对应的News对象，否则返回null
     */
    public News getNewsById(Long id) {
        News news = null;
        String sql = "SELECT * FROM News WHERE id = ?";
        ResultSet rs = SQLHelper.executeQuery(sql, id);
        try {
            if (rs != null && rs.next()) {
                news = new News();
                news.setId(rs.getLong("id"));
                news.setTitle(rs.getString("title"));
                news.setContent(rs.getString("content"));
                news.setImageUrl(rs.getString("imageUrl"));
                news.setPublishDate(rs.getTimestamp("publishDate"));
                news.setViewCount(rs.getInt("viewCount"));
                news.setPublisher(rs.getString("publisher"));
                news.setNewsType(rs.getString("newsType"));
                news.setIsTop(rs.getBoolean("isTop"));
                news.setTopOrder(rs.getInt("topOrder"));
                news.setViewPermission(rs.getString("viewPermission"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return news;
    }

    /**
     * 增加新闻的浏览次数
     * @param newsId 新闻ID
     */
    public void incrementViewCount(Long newsId) {
        String sql = "UPDATE News SET viewCount = viewCount + 1 WHERE id = ?";
        SQLHelper.executeUpdate(sql, newsId);
    }

    /**
     * 获取最新的新闻列表
     * 优先返回置顶新闻，然后是最新发布的新闻
     * @param limit 限制返回的新闻数量
     * @return 新闻列表
     */
    public List<News> getLatestNews(int limit) {
        // 先获取置顶新闻，再获取最新新闻，总共返回limit条
        String sql = "SELECT * FROM News WHERE imageUrl IS NOT NULL AND newsType = 'collegeNews' " +
                    "ORDER BY isTop DESC, topOrder DESC, publishDate DESC LIMIT ?";
        List<News> newsList = new ArrayList<>();
        
        ResultSet rs = SQLHelper.executeQuery(sql, limit);
        if (rs != null) {
            try {
                while (rs.next()) {
                    News news = new News();
                    news.setId(rs.getLong("id"));
                    news.setTitle(rs.getString("title"));
                    news.setImageUrl(rs.getString("imageUrl"));
                    news.setPublishDate(rs.getTimestamp("publishDate"));
                    news.setIsTop(rs.getBoolean("isTop"));
                    news.setTopOrder(rs.getInt("topOrder"));
                    newsList.add(news);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return newsList;
    }

    /**
     * 获取指定类型的所有新闻
     * 按照置顶状态、置顶顺序和发布时间排序
     * @param newsType 新闻类型
     * @return 指定类型的新闻列表
     */
    public List<News> getNewsByType(String newsType) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM News WHERE newsType = ? ORDER BY isTop DESC, topOrder DESC, publishDate DESC";
        
        ResultSet rs = SQLHelper.executeQuery(sql, newsType);
        try {
            if (rs != null) {
                while (rs.next()) {
                    News news = new News();
                    news.setId(rs.getLong("id"));
                    news.setTitle(rs.getString("title"));
                    news.setContent(rs.getString("content"));
                    news.setImageUrl(rs.getString("imageUrl"));
                    news.setPublishDate(rs.getTimestamp("publishDate"));
                    news.setViewCount(rs.getInt("viewCount"));
                    news.setPublisher(rs.getString("publisher"));
                    news.setNewsType(rs.getString("newsType"));
                    news.setIsTop(rs.getBoolean("isTop"));
                    news.setTopOrder(rs.getInt("topOrder"));
                    newsList.add(news);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return newsList;
    }

    /**
     * 获取指定类型的新闻（带数量限制）
     * 按照发布时间降序排列
     * @param newsType 新闻类型
     * @param limit 限制返回的新闻数量
     * @return 指定类型的新闻列表
     */
    public List<News> getNewsByType(String newsType, int limit) {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM News WHERE newsType = ? ORDER BY publishDate DESC LIMIT ?";
        
        ResultSet rs = SQLHelper.executeQuery(sql, newsType, limit);
        try {
            if (rs != null) {
                while (rs.next()) {
                    News news = new News();
                    news.setId(rs.getLong("id"));
                    news.setTitle(rs.getString("title"));
                    news.setContent(rs.getString("content"));
                    news.setImageUrl(rs.getString("imageUrl"));
                    news.setPublishDate(rs.getTimestamp("publishDate"));
                    news.setViewCount(rs.getInt("viewCount"));
                    news.setPublisher(rs.getString("publisher"));
                    news.setNewsType(rs.getString("newsType"));
                    newsList.add(news);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return newsList;
    }

    /**
     * 删除指定ID的新闻
     * @param newsId 新闻ID
     * @return 删除成功返回true，失败返回false
     */
    public boolean deleteNews(Long newsId) {
        if (newsId == null) {
            return false;
        }

        String sql = "DELETE FROM News WHERE id = ?";
        try {
            int result = SQLHelper.executeUpdate(sql, newsId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新新闻信息
     * @param news 包含更新信息的新闻对象
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateNews(News news) {
        String sql = "UPDATE News SET title = ?, content = ?, newsType = ?, isTop = ?, topOrder = ?, viewPermission = ? WHERE id = ?";
        try {
            return SQLHelper.executeUpdate(sql, 
                news.getTitle(),
                news.getContent(),
                news.getNewsType(),
                news.getIsTop(),
                news.getTopOrder(),
                news.getViewPermission(),
                news.getId()) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 添加新闻
     * 自动设置默认值：发布时间、浏览次数、置顶状态、置顶顺序
     * @param news 要添加的新闻对象
     * @return 新添加新闻的ID，添加失败返回null
     */
    public Long addNews(News news) {
        String sql = "INSERT INTO News (title, content, imageUrl, publishDate, viewCount, publisher, newsType, isTop, topOrder, viewPermission) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // 设置默认值
        if (news.getPublishDate() == null) {
            news.setPublishDate(new Timestamp(System.currentTimeMillis()));
        }
        if (news.getViewCount() == null) {
            news.setViewCount(0);
        }
        if (news.getIsTop() == null) {
            news.setIsTop(false);
        }
        if (news.getTopOrder() == null) {
            news.setTopOrder(0);
        }
        
        try {
            long id = SQLHelper.executeInsertWithGeneratedKey(sql,
                news.getTitle(),
                news.getContent(),
                news.getImageUrl(),
                news.getPublishDate(),
                news.getViewCount(),
                news.getPublisher(),
                news.getNewsType(),
                news.getIsTop(),
                news.getTopOrder(),
                news.getViewPermission()
            );
            return id > 0 ? id : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 获取所有新闻列表
     * 按照置顶状态、置顶顺序和发布时间排序
     * @return 所有新闻的列表
     */
    public List<News> getAllNews() {
        List<News> newsList = new ArrayList<>();
        String sql = "SELECT * FROM News ORDER BY isTop DESC, topOrder DESC, publishDate DESC";
        
        ResultSet rs = SQLHelper.executeQuery(sql);
        
        try {
            if (rs != null) {
                while (rs.next()) {
                    try {
                        News news = new News();
                        news.setId(rs.getLong("id"));
                        news.setTitle(rs.getString("title"));
                        news.setContent(rs.getString("content"));
                        news.setPublishDate(rs.getTimestamp("publishDate"));
                        news.setPublisher(rs.getString("publisher"));
                        news.setNewsType(rs.getString("newsType"));
                        news.setViewCount(rs.getInt("viewCount"));
                        news.setIsTop(rs.getBoolean("isTop"));
                        news.setTopOrder(rs.getInt("topOrder"));
                        newsList.add(news);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return newsList;
    }

    /**
     * 更新新闻的置顶状态和顺序
     * @param id 新闻ID
     * @param isTop 是否置顶
     * @param topOrder 置顶顺序
     * @return 更新成功返回true，失败返回false
     */
    public boolean updateNewsTopStatus(Long id, Boolean isTop, Integer topOrder) {
        String sql = "UPDATE News SET isTop = ?, topOrder = ? WHERE id = ?";
        return SQLHelper.executeUpdate(sql, isTop, topOrder, id) > 0;
    }
    
    /**
     * 获取所有置顶新闻
     * 按照置顶顺序和发布时间降序排列
     * @return 置顶新闻列表
     */
    public List<News> getTopNews() {
        String sql = "SELECT * FROM News WHERE isTop = 1 ORDER BY topOrder DESC, publishDate DESC";
        List<News> topNewsList = new ArrayList<>();
        
        ResultSet rs = SQLHelper.executeQuery(sql);
        try {
            if (rs != null) {
                while (rs.next()) {
                    News news = new News();
                    news.setId(rs.getLong("id"));
                    news.setTitle(rs.getString("title"));
                    news.setContent(rs.getString("content"));
                    news.setImageUrl(rs.getString("imageUrl"));
                    news.setPublishDate(rs.getTimestamp("publishDate"));
                    news.setViewCount(rs.getInt("viewCount"));
                    news.setPublisher(rs.getString("publisher"));
                    news.setNewsType(rs.getString("newsType"));
                    news.setIsTop(rs.getBoolean("isTop"));
                    news.setTopOrder(rs.getInt("topOrder"));
                    topNewsList.add(news);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topNewsList;
    }

}
