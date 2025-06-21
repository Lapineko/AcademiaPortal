package suep.academiaportal.servlet;

import suep.academiaportal.dao.NewsAttachmentDAO;
import suep.academiaportal.entity.NewsAttachment;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

/**
 * 新闻附件处理Servlet
 * 负责处理新闻附件的上传和删除
 * 支持多文件上传，并对文件大小进行限制
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class NewsAttachmentServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/attachments";
    private final NewsAttachmentDAO attachmentDAO = new NewsAttachmentDAO();

    /**
     * 处理POST请求
     * 处理附件的上传和删除操作
     * 上传：保存文件到服务器并记录到数据库
     * 删除：删除服务器文件和数据库记录
     * 
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @throws ServletException Servlet异常
     * @throws IOException IO异常
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String type = request.getParameter("type");
        
        if ("upload".equals(type)) {
            Long newsId = Long.parseLong(request.getParameter("newsId"));
            Collection<Part> attachmentParts = request.getParts();
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            for (Part part : attachmentParts) {
                if (part.getName().equals("attachments") && part.getSize() > 0) {
                    String fileName = getSubmittedFileName(part);
                    String fileType = getFileType(fileName);
                    String uniqueFileName = UUID.randomUUID().toString() + getFileExtension(fileName);
                    
                    // 保存文件到服务器
                    part.write(uploadPath + File.separator + uniqueFileName);
                    
                    // 保存到数据库
                    NewsAttachment attachment = new NewsAttachment();
                    attachment.setNewsId(newsId);
                    attachment.setFileName(fileName);
                    attachment.setFileUrl(UPLOAD_DIR + "/" + uniqueFileName);
                    attachment.setFileSize(part.getSize());
                    attachment.setFileType(fileType);
                    
                    attachmentDAO.addAttachment(attachment);
                }
            }
            response.getWriter().write("success");
        } else if ("delete".equals(type)) {
            Long attachmentId = Long.parseLong(request.getParameter("attachmentId"));
            NewsAttachment attachment = attachmentDAO.getAttachmentById(attachmentId);
            
            if (attachment != null) {
                // 删除物理文件
                String filePath = getServletContext().getRealPath("") + File.separator + 
                                attachment.getFileUrl();
                File file = new File(filePath);
                if (file.exists()) {
                    file.delete();
                }
                
                // 从数据库删除记录
                if (attachmentDAO.deleteAttachment(attachmentId)) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("删除失败");
                }
            }
        }
    }
    
    /**
     * 获取上传文件的原始文件名
     * 从请求头中解析content-disposition获取文件名
     * 
     * @param part 文件部分
     * @return 原始文件名
     */
    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    /**
     * 获取文件扩展名
     * 从文件名中提取扩展名（包含点号）
     * 
     * @param fileName 文件名
     * @return 文件扩展名，如果没有则返回空字符串
     */
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf(".");
        return lastDot > 0 ? fileName.substring(lastDot) : "";
    }
    
    /**
     * 根据文件名判断文件类型
     * 通过文件扩展名确定文件类型
     * 支持PDF、Word、Excel、Text等类型
     * 
     * @param fileName 文件名
     * @return 文件类型描述
     */
    private String getFileType(String fileName) {
        String extension = getFileExtension(fileName).toLowerCase();
        switch (extension) {
            case ".pdf": return "PDF";
            case ".doc":
            case ".docx": return "Word";
            case ".xls":
            case ".xlsx": return "Excel";
            case ".txt": return "Text";
            default: return "Other";
        }
    }
} 