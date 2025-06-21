package suep.academiaportal.servlet;

import suep.academiaportal.dao.CarouselDAO;
import suep.academiaportal.entity.Carousel;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 轮播图管理Servlet
 * 处理轮播图的增删改查等操作
 * 包括轮播图列表分页显示、图片上传等功能
 */
public class CarouselServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/carousel";
    private final CarouselDAO carouselDAO = new CarouselDAO();

    /**
     * 处理GET请求
     * 主要用于处理轮播图列表查询和单个轮播图信息获取
     * 支持分页显示功能
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
            int currentPage = 1;
            try {
                String pageStr = request.getParameter("page");

                if (pageStr != null && !pageStr.isEmpty()) {
                    currentPage = Integer.parseInt(pageStr);
                }
            } catch (NumberFormatException e) {

                currentPage = 1;
            }
            
            int pageSize = 10;
            
            List<Carousel> allCarousels = carouselDAO.getAllCarousels();

            
            int totalItems = allCarousels.size();
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            
            int fromIndex = (currentPage - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalItems);
            
            int startIndex = (currentPage - 1) * pageSize + 1;

            
            List<Carousel> currentPageCarousels = totalItems > 0 ? 
                allCarousels.subList(fromIndex, toIndex) : new ArrayList<>();
            
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("carouselList", currentPageCarousels);
            request.setAttribute("startIndex", startIndex);
            

            request.getRequestDispatcher("/APMS/carouselManage.jsp").forward(request, response);
        } else if ("get".equals(type)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                Long id = Long.parseLong(idStr);
                Carousel carousel = carouselDAO.getCarouselById(id);
                if (carousel != null) {
                    String responseData = String.format("%s|%s|%d|%d|%s|%s",
                            carousel.getTitle(),
                            carousel.getImageUrl(),
                            carousel.getSortOrder(),
                            carousel.getIsActive() ? 1 : 0,
                            carousel.getPublisher(),
                            carousel.getId());
                    
                    response.setContentType("text/plain");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(responseData);
                }
            }
        }
    }

    /**
     * 处理POST请求
     * 处理轮播图的添加、更新和删除操作
     * 包含图片文件上传处理
     * 
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @throws IOException IO异常
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String type = request.getParameter("type");
        
        try {
            if ("add".equals(type)) {
                Carousel carousel = new Carousel();
                carousel.setTitle(request.getParameter("title"));
                carousel.setSortOrder(Integer.parseInt(request.getParameter("sortOrder")));
                carousel.setIsActive("1".equals(request.getParameter("isActive")));
                String publisher = (String) request.getSession().getAttribute("realName");
                carousel.setPublisher(publisher);
                
                // 处理图片上传
                Part imagePart = request.getPart("imageUrl");
                if (imagePart != null && imagePart.getSize() > 0) {
                    String fileName = processUploadedFile(imagePart);
                    carousel.setImageUrl(UPLOAD_DIR + "/" + fileName);
                }
                
                Long id = carouselDAO.addCarousel(carousel);
                response.getWriter().write(id != null ? "success" : "添加失败");
                
            } else if ("update".equals(type)) {
                Long id = Long.parseLong(request.getParameter("id"));
                Carousel carousel = carouselDAO.getCarouselById(id);
                
                if (carousel != null) {
                    carousel.setTitle(request.getParameter("title"));
                    carousel.setSortOrder(Integer.parseInt(request.getParameter("sortOrder")));
                    carousel.setIsActive("1".equals(request.getParameter("isActive")));
                    
                    Part imagePart = request.getPart("imageUrl");
                    if (imagePart != null && imagePart.getSize() > 0) {
                        String fileName = processUploadedFile(imagePart);
                        carousel.setImageUrl(UPLOAD_DIR + "/" + fileName);
                    }
                    
                    boolean success = carouselDAO.updateCarousel(carousel);
                    response.getWriter().write(success ? "success" : "更新失败");
                }
                
            } else if ("delete".equals(type)) {
                Long id = Long.parseLong(request.getParameter("id"));
                boolean success = carouselDAO.deleteCarousel(id);
                response.getWriter().write(success ? "success" : "删除失败");
            }
        } catch (Exception e) {
            response.getWriter().write("操作失败：" + e.getMessage());
        }
    }

    /**
     * 处理上传的图片文件
     * 生成唯一文件名并保存到指定目录
     * 
     * @param filePart 上传的文件部分
     * @return 保存后的文件名
     * @throws IOException 文件处理过程中的IO异常
     */
    private String processUploadedFile(Part filePart) throws IOException {
        String fileName = System.currentTimeMillis() + "_" + 
                         filePart.getSubmittedFileName().replaceAll("\\s+", "_");
        String uploadPath = getServletContext().getRealPath("") + "/" + UPLOAD_DIR;
        java.io.File uploadDir = new java.io.File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // 删除旧文件（如果存在）
        if (filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
            filePart.write(uploadPath + "/" + fileName);
        }
        
        return fileName;
    }
} 