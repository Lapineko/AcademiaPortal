package suep.academiaportal.dao;

import suep.academiaportal.entity.NewsAttachment;
import suep.academiaportal.util.SQLHelper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 新闻附件数据访问对象类
 * 负责处理与新闻附件相关的所有数据库操作
 * 包括附件的上传、下载、删除等功能
 */
public class NewsAttachmentDAO {
    
    /**
     * 添加新闻附件
     * @param attachment 要添加的附件对象，包含文件名、URL、大小等信息
     * @return 新添加附件的ID
     */
    public Long addAttachment(NewsAttachment attachment) {
        String sql = "INSERT INTO NewsAttachment (newsId, fileName, fileUrl, fileSize, fileType) " +
                    "VALUES (?, ?, ?, ?, ?)";
        return SQLHelper.executeInsertWithGeneratedKey(sql,
                attachment.getNewsId(),
                attachment.getFileName(),
                attachment.getFileUrl(),
                attachment.getFileSize(),
                attachment.getFileType());
    }
    
    /**
     * 根据新闻ID获取该新闻的所有附件
     * 按照上传时间降序排列
     * @param newsId 新闻ID
     * @return 该新闻下的所有附件列表
     */
    public List<NewsAttachment> getAttachmentsByNewsId(Long newsId) {
        String sql = "SELECT * FROM NewsAttachment WHERE newsId = ? ORDER BY uploadTime DESC";
        List<NewsAttachment> attachments = new ArrayList<>();
        
        ResultSet rs = SQLHelper.executeQuery(sql, newsId);
        try {
            while (rs != null && rs.next()) {
                attachments.add(mapResultSetToAttachment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attachments;
    }
    
    /**
     * 根据附件ID获取单个附件信息
     * @param id 附件ID
     * @return 如果找到则返回对应的NewsAttachment对象，否则返回null
     */
    public NewsAttachment getAttachmentById(Long id) {
        String sql = "SELECT * FROM NewsAttachment WHERE id = ?";
        ResultSet rs = SQLHelper.executeQuery(sql, id);
        try {
            if (rs != null && rs.next()) {
                return mapResultSetToAttachment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 删除指定ID的附件
     * @param id 要删除的附件ID
     * @return 删除成功返回true，失败返回false
     */
    public boolean deleteAttachment(Long id) {
        String sql = "DELETE FROM NewsAttachment WHERE id = ?";
        return SQLHelper.executeUpdate(sql, id) > 0;
    }
    
    /**
     * 删除指定新闻下的所有附件
     * @param newsId 新闻ID
     * @return 删除成功返回true，失败返回false
     */
    public boolean deleteAttachmentsByNewsId(Long newsId) {
        String sql = "DELETE FROM NewsAttachment WHERE newsId = ?";
        return SQLHelper.executeUpdate(sql, newsId) > 0;
    }
    
    /**
     * 辅助方法：将数据库查询结果映射为NewsAttachment对象
     * @param rs 数据库查询结果集
     * @return 映射后的NewsAttachment对象
     * @throws SQLException 当数据库操作出现异常时抛出
     */
    private NewsAttachment mapResultSetToAttachment(ResultSet rs) throws SQLException {
        NewsAttachment attachment = new NewsAttachment();
        attachment.setId(rs.getLong("id"));
        attachment.setNewsId(rs.getLong("newsId"));
        attachment.setFileName(rs.getString("fileName"));
        attachment.setFileUrl(rs.getString("fileUrl"));
        attachment.setFileSize(rs.getLong("fileSize"));
        attachment.setFileType(rs.getString("fileType"));
        attachment.setUploadTime(rs.getTimestamp("uploadTime"));
        return attachment;
    }
} 