package suep.academiaportal.servlet;

import suep.academiaportal.dao.NewsDAO;
import suep.academiaportal.dao.NewsAttachmentDAO;
import suep.academiaportal.entity.News;
import suep.academiaportal.entity.NewsAttachment;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 新闻管理Servlet
 * 处理新闻的增删改查、图片上传、附件管理等功能
 * 支持新闻内容中的网络图片本地化处理
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,    // 1 MB
        maxFileSize = 1024 * 1024 * 10,     // 10 MB
        maxRequestSize = 1024 * 1024 * 50    // 50 MB
)
public class NewsServlet extends HttpServlet {
    private final NewsDAO newsDAO = new NewsDAO();
    private static final String UPLOAD_DIR_COVERS = "uploads/covers";
    private static final String UPLOAD_DIR_NEWS = "uploads/news";

    /**
     * 处理GET请求
     * 主要处理新闻列表查询和单个新闻信息获取
     * 支持分页显示和新闻类型筛选
     *
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @throws ServletException Servlet异常
     * @throws IOException IO异常
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");

        if ("list".equals(type)) {

            List<News> allNews;

            // 获取新闻类型参数和页码参数
            String newsType = request.getParameter("newsType");
            int currentPage = 1;
            int pageSize = 10; // 每页显示10条新闻

            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.isEmpty()) {
                    currentPage = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                throw new RuntimeException(e);
            }

            // 根据类型获取新闻列表
            if (newsType != null && !newsType.equals("all")) {
                allNews = newsDAO.getNewsByType(newsType);
            } else {
                allNews = newsDAO.getAllNews();
            }

            // 计算总页数和当前页的新闻
            int totalItems = allNews.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (totalPages == 0) totalPages = 1; // 确保至少有1页

            // 确保当前页码在有效范围内
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages;

            // 获取当前页的新闻
            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalItems);

            List<News> currentPageNews;
            if (totalItems > 0) {
                currentPageNews = allNews.subList(fromIndex, toIndex);
            } else {
                currentPageNews = new ArrayList<>();
            }

            // 计算起始编号
            int startIndex = (currentPage - 1) * pageSize + 1;

            // 添加调试日志
            // 将分页信息入request属性中
            request.setAttribute("startIndex", startIndex);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("newsList", currentPageNews);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("selectedNewsType", newsType != null ? newsType : "all");

            // 转发到JSP页面
            request.getRequestDispatcher("/APMS/newsManage.jsp").forward(request, response);
        } else if ("get".equals(type)) {
            String newsIdStr = request.getParameter("id");
            if (newsIdStr != null) {
                try {
                    Long newsId = Long.parseLong(newsIdStr);
                    News news = newsDAO.getNewsById(newsId);
                    if (news != null) {
                        // 返回用 | 分隔的字符串，加入置顶相关信息
                        String responseText = news.getTitle() + "|" +
                                news.getNewsType() + "|" +
                                news.getContent() + "|" +
                                news.getIsTop() + "|" +
                                news.getTopOrder() + "|" +
                                news.getViewPermission();
                        response.getWriter().write(responseText);
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    }
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                }
            }
        } else if ("update".equals(type)) {
            String newsIdStr = request.getParameter("id");
            if (newsIdStr != null) {
                try {
                    Long newsId = Long.parseLong(newsIdStr);
                    News news = newsDAO.getNewsById(newsId);
                    if (news != null) {
                        news.setTitle(request.getParameter("title"));
                        news.setContent(request.getParameter("content"));
                        news.setNewsType(request.getParameter("newsType"));

                        // 处理置顶信息
                        news.setIsTop(Boolean.parseBoolean(request.getParameter("isTop")));
                        news.setTopOrder(Integer.parseInt(request.getParameter("topOrder")));
                        news.setViewPermission(request.getParameter("viewPermission"));

                        // 处理封面图片
                        if ("collegeNews".equals(news.getNewsType())) {
                            Part coverPart = request.getPart("coverImage");
                            if (coverPart != null && coverPart.getSize() > 0) {
                                // BUG FIX: Specify the correct directory for covers
                                String fileName = processUploadedFile(coverPart, UPLOAD_DIR_COVERS);
                                news.setImageUrl(UPLOAD_DIR_COVERS + "/" + fileName);
                            }
                        }

                        if (newsDAO.updateNews(news)) {
                            response.getWriter().write("success");
                        } else {
                            response.getWriter().write("更新失败");
                        }
                    } else {
                        response.getWriter().write("未找到要更新的新闻");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().write("更新失败: " + e.getMessage());
                }
            } else {
                response.getWriter().write("新闻ID不能为空");
            }
        }
    }

    /**
     * 处理POST请求
     * 处理新闻的添加、更新、删除等操作
     * 包含图片上传、附件处理和置顶管理
     *
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @throws ServletException Servlet异常
     * @throws IOException IO异常
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String type = request.getParameter("type");

        if ("get".equals(type)) {
            try {
                Long id = Long.parseLong(request.getParameter("id"));
                NewsDAO newsDAO = new NewsDAO();
                News news = newsDAO.getNewsById(id);

                // 获取附件信息
                NewsAttachmentDAO attachmentDAO = new NewsAttachmentDAO();
                List<NewsAttachment> attachments = attachmentDAO.getAttachmentsByNewsId(id);


                // 构建附件信息字符串
                StringBuilder attachmentStr = new StringBuilder();
                if (attachments != null && !attachments.isEmpty()) {
                    for (int i = 0; i < attachments.size(); i++) {
                        NewsAttachment attachment = attachments.get(i);
                        if (i > 0) {
                            attachmentStr.append(";");
                        }
                        attachmentStr.append(attachment.getId()).append(",").append(attachment.getFileName());


                    }
                }

                // 返回格式：标题|类型|内容|是否置顶|置顶顺序|附件信息|查看权限
                String responseStr = String.format("%s|%s|%s|%s|%d|%s|%s",
                        news.getTitle(),
                        news.getNewsType(),
                        news.getContent(),
                        news.getIsTop(),
                        news.getTopOrder() != null ? news.getTopOrder() : 0,
                        attachmentStr.length() > 0 ? attachmentStr.toString() : "",
                        news.getViewPermission()
                );


                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write(responseStr);

            } catch (Exception e) {

                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else if ("uploadImage".equals(type)) {
            try {
                // 处理图片上传
                Part imagePart = request.getPart("image");
                if (imagePart != null && imagePart.getSize() > 0) {
                    // BUG FIX: Specify the correct directory for news content images
                    String fileName = processUploadedFile(imagePart, UPLOAD_DIR_NEWS);
                    String imageUrl = request.getContextPath() + "/" + UPLOAD_DIR_NEWS + "/" + fileName;

                    // 直接建JSON字符串
                    String jsonResponse = String.format(
                            "{\"errno\":0,\"data\":{\"url\":\"%s\",\"alt\":\"\",\"href\":\"\"}}",
                            imageUrl
                    );

                    response.getWriter().write(jsonResponse);
                    return;
                }

                // 上传失败
                response.getWriter().write("{\"errno\":1,\"message\":\"图片上传失败\"}");

            } catch (Exception e) {
                e.printStackTrace();
                String errorMsg = e.getMessage().replace("\"", "'"); // 转义引号
                response.getWriter().write(
                        String.format("{\"errno\":1,\"message\":\"图片上传错误: %s\"}", errorMsg)
                );
            }
            return;
        } else if ("update".equals(type)) {
            String newsIdStr = request.getParameter("id");
            if (newsIdStr != null) {
                try {
                    Long newsId = Long.parseLong(newsIdStr);
                    News news = newsDAO.getNewsById(newsId);
                    if (news != null) {
                        news.setTitle(request.getParameter("title"));
                        news.setContent(request.getParameter("content"));
                        news.setNewsType(request.getParameter("newsType"));

                        // 处理置顶信息
                        news.setIsTop(Boolean.parseBoolean(request.getParameter("isTop")));
                        news.setTopOrder(Integer.parseInt(request.getParameter("topOrder")));
                        news.setViewPermission(request.getParameter("viewPermission"));

                        // 处理封面图片
                        if ("collegeNews".equals(news.getNewsType())) {
                            Part coverPart = request.getPart("coverImage");
                            if (coverPart != null && coverPart.getSize() > 0) {
                                // BUG FIX: Specify the correct directory for covers
                                String fileName = processUploadedFile(coverPart, UPLOAD_DIR_COVERS);
                                news.setImageUrl(UPLOAD_DIR_COVERS + "/" + fileName);
                            }
                        }

                        if (newsDAO.updateNews(news)) {
                            response.getWriter().write("success");
                        } else {
                            response.getWriter().write("更新失败");
                        }
                    } else {
                        response.getWriter().write("未找到要更新的新闻");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().write("更新失败: " + e.getMessage());
                }
            } else {
                response.getWriter().write("新闻ID不能为空");
            }
        } else if ("delete".equals(type)) {
            String newsIdStr = request.getParameter("id");


            if (newsIdStr != null && !newsIdStr.trim().isEmpty()) {
                try {
                    Long newsId = Long.parseLong(newsIdStr);


                    if (newsDAO.deleteNews(newsId)) {

                        response.getWriter().write("success");
                    } else {

                        response.getWriter().write("fail: 删除失败，请稍后重试");
                    }
                } catch (NumberFormatException e) {

                    response.getWriter().write("fail: 无效的新闻ID");
                } catch (Exception e) {

                    e.printStackTrace();
                    response.getWriter().write("fail: " + e.getMessage());
                }
            } else {

                response.getWriter().write("fail: 新闻ID不能为空");
            }
        } else if ("list".equals(type)) {

            List<News> allNews;

            // 获取新闻类型参数和页码参数
            String newsType = request.getParameter("newsType");
            int currentPage = 1;
            int pageSize = 10; // 每页显示10条新闻

            try {
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.isEmpty()) {
                    currentPage = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {
                throw new RuntimeException(e);
            }

            // 根据类型获取新闻列表
            if (newsType != null && !newsType.equals("all")) {
                allNews = newsDAO.getNewsByType(newsType);
            } else {
                allNews = newsDAO.getAllNews();
            }

            // 计算总页数和当前页的新闻
            int totalItems = allNews.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (totalPages == 0) totalPages = 1; // 确保至少有1页

            // 确保当前页码在有效范围内
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages;

            // 获取当前页的新闻
            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalItems);

            List<News> currentPageNews;
            if (totalItems > 0) {
                currentPageNews = allNews.subList(fromIndex, toIndex);
            } else {
                currentPageNews = new ArrayList<>();
            }

            // 计算起始编号
            int startIndex = (currentPage - 1) * pageSize + 1;



            // 将分页信息放入request属性中
            request.setAttribute("startIndex", startIndex);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("newsList", currentPageNews);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("selectedNewsType", newsType != null ? newsType : "all");

            // 转发到JSP页面
            request.getRequestDispatcher("/APMS/newsManage.jsp").forward(request, response);
        } else if ("add".equals(type)) {
            try {
                News news = new News();
                news.setTitle(request.getParameter("title"));
                news.setContent(request.getParameter("content"));
                news.setNewsType(request.getParameter("newsType"));
                news.setPublisher((String) request.getSession().getAttribute("realName"));

                // 设置置顶信息
                news.setIsTop(Boolean.parseBoolean(request.getParameter("isTop")));
                news.setTopOrder(Integer.parseInt(request.getParameter("topOrder")));
                news.setViewPermission(request.getParameter("viewPermission"));

                // 处理内容中的网络图片
                String processedContent = processContentImages(news.getContent(), request);

                news.setContent(processedContent); // 使用处理后的内容

                // 处理封面图片
                if ("collegeNews".equals(news.getNewsType())) {
                    Part coverPart = request.getPart("coverImage");
                    if (coverPart != null && coverPart.getSize() > 0) {
                        // BUG FIX: Specify the correct directory for covers
                        String fileName = processUploadedFile(coverPart, UPLOAD_DIR_COVERS);
                        news.setImageUrl(UPLOAD_DIR_COVERS + "/" + fileName);

                    }
                }

                // 保存新闻
                Long newsId = newsDAO.addNews(news);

                if (newsId != null && newsId > 0) {
                    // 处理附件上传
                    Collection<Part> parts = request.getParts();
                    for (Part part : parts) {
                        if ("attachments".equals(part.getName()) && part.getSize() > 0) {
                            String fileName = getSubmittedFileName(part);
                            String fileType = getFileType(fileName);
                            String uniqueFileName = UUID.randomUUID().toString() + getFileExtension(fileName);

                            // 保存文件到服务器
                            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads/attachments";
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }

                            part.write(uploadPath + File.separator + uniqueFileName);

                            // 保存到数据库
                            NewsAttachment attachment = new NewsAttachment();
                            attachment.setNewsId(newsId);
                            attachment.setFileName(fileName);
                            attachment.setFileUrl("uploads/attachments/" + uniqueFileName);
                            attachment.setFileSize(part.getSize());
                            attachment.setFileType(fileType);

                            NewsAttachmentDAO attachmentDAO = new NewsAttachmentDAO();
                            attachmentDAO.addAttachment(attachment);
                        }
                    }
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("保存新闻失败");
                }
            } catch (Exception e) {

                e.printStackTrace();
                response.getWriter().write("发布失败：" + e.getMessage());
            }
        } else if ("updateTop".equals(type)) {
            String newsIdStr = request.getParameter("id");
            String isTopStr = request.getParameter("isTop");
            String topOrderStr = request.getParameter("topOrder");

            try {
                Long newsId = Long.parseLong(newsIdStr);
                Boolean isTop = Boolean.parseBoolean(isTopStr);
                Integer topOrder = Integer.parseInt(topOrderStr);

                if (newsDAO.updateNewsTopStatus(newsId, isTop, topOrder)) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("更新置顶状态失败");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("更新失败: " + e.getMessage());
            }
        }
    }

    /**
     * BUG FIX: Method now accepts a target directory.
     * 处理上传的文件
     * 生成唯一文件名并保存到指定目录
     *
     * @param filePart 上传的文件部分
     * @param targetDir 目标上传目录 (e.g., UPLOAD_DIR_COVERS or UPLOAD_DIR_NEWS)
     * @return 保存后的文件名
     * @throws IOException 文件处理过程中的IO异常
     */
    private String processUploadedFile(Part filePart, String targetDir) throws IOException {
        String fileName = UUID.randomUUID() + getFileExtension(filePart);
        String uploadPath = getServletContext().getRealPath("") + File.separator + targetDir;

        // 确保上传目录存在
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 保存文件
        filePart.write(uploadPath + File.separator + fileName);

        return fileName;
    }

    /**
     * 获取文件扩展名
     * 从Part对象的content-disposition头中提取文件扩展名
     *
     * @param part 文件部分
     * @return 文件扩展名（包含点号）
     */
    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                return fileName.substring(fileName.lastIndexOf("."));
            }
        }
        return "";
    }

    /**
     * 处理新闻内容中的网络图片
     * 下载远程图片并替换为本地URL
     *
     * @param content 新闻内容
     * @param request HTTP请求对象
     * @return 处理后的内容
     */
    private String processContentImages(String content, HttpServletRequest request) {
        if (content == null || content.isEmpty()) {
            return content;
        }

        // 匹配图片标签中的src属性
        Pattern pattern = Pattern.compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
        Matcher matcher = pattern.matcher(content);
        StringBuffer sb = new StringBuffer();

        while (matcher.find()) {
            String imgUrl = matcher.group(1);
            if (imgUrl.startsWith("http://") || imgUrl.startsWith("https://")) {
                try {
                    // 下载并保存图片
                    String newFileName = downloadImage(imgUrl);
                    // 替换为本地路径
                    String newUrl = request.getContextPath() + "/" + UPLOAD_DIR_NEWS + "/" + newFileName;
                    matcher.appendReplacement(sb, "<img src=\"" + newUrl + "\"");
                } catch (IOException e) {
                    e.printStackTrace();
                    // 如果下载失败，保留原始URL
                    matcher.appendReplacement(sb, matcher.group(0));
                }
            } else {
                // 如果不是网络图片，保持原样
                matcher.appendReplacement(sb, matcher.group(0));
            }
        }
        matcher.appendTail(sb);
        return sb.toString();
    }

    /**
     * 下载网络图片到本地
     * 生成唯一文件名并保存
     *
     * @param imageUrl 图片URL
     * @return 保存后的文件名
     * @throws IOException 下载过程中的IO异常
     */
    private String downloadImage(String imageUrl) throws IOException {
        URL url = new URL(imageUrl);
        URLConnection conn = url.openConnection();
        // 设置请求头，模拟浏览器访问
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");

        // 获取文件扩展名
        String fileExtension = getFileExtensionFromUrl(imageUrl);
        String fileName = UUID.randomUUID() + fileExtension;

        // 确保目录存在
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_NEWS;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 保存文件
        try (InputStream in = conn.getInputStream();
             FileOutputStream out = new FileOutputStream(uploadPath + File.separator + fileName)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }

        return fileName;
    }

    /**
     * 从URL中获取文件扩展名
     * 处理带查询参数的URL
     *
     * @param url 图片URL
     * @return 文件扩展名（包含点号）
     */
    private String getFileExtensionFromUrl(String url) {
        String fileName = url.substring(url.lastIndexOf('/') + 1);
        int queryIndex = fileName.indexOf('?');
        if (queryIndex > 0) {
            fileName = fileName.substring(0, queryIndex);
        }
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            return fileName.substring(dotIndex);
        }
        // 如果无法获取扩展名，默认返回.jpg
        return ".jpg";
    }

    /**
     * 获取上传文件的原始文件名
     * 从Part对象的content-disposition头中提取
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
     * 从文件名中提取扩展名
     *
     * @param fileName 文件名
     * @return 文件扩展名（包含点号）
     */
    private String getFileExtension(String fileName) {
        int lastDot = fileName.lastIndexOf(".");
        return lastDot > 0 ? fileName.substring(lastDot) : "";
    }

    /**
     * 根据文件名判断文件类型
     * 支持常见的文档格式
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