package suep.academiaportal.filter;

import suep.academiaportal.dao.NewsDAO;
import suep.academiaportal.entity.News;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 新闻权限过滤器
 * 用于控制新闻内容的访问权限
 * 根据新闻的权限级别和用户角色决定是否允许访问
 * 拦截首页、新闻详情页和新闻列表页的访问请求
 */
@WebFilter(urlPatterns = {"/index.jsp", "/news.jsp", "/newsList.jsp"})
public class NewsPermissionFilter implements Filter {
    private NewsDAO newsDAO;

    /**
     * 过滤器初始化方法
     * 初始化NewsDAO对象用于查询新闻信息
     * @param filterConfig 过滤器配置对象
     * @throws ServletException 初始化异常
     */
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        newsDAO = new NewsDAO();
    }

    /**
     * 执行过滤操作
     * 根据用户角色和新闻权限级别控制访问权限
     * 包含以下权限控制逻辑：
     * 1. 管理员和管理教师可以访问所有内容
     * 2. 公开新闻所有人可访问
     * 3. 其他情况根据用户角色和新闻权限级别判断
     * 
     * @param request 请求对象
     * @param response 响应对象
     * @param chain 过滤器链
     * @throws IOException IO异常
     * @throws ServletException Servlet异常
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession();

        // 获取当前用户角色
        String userRole = (String) session.getAttribute("userRole");

        // 如果是管理员或管理教师，直接放行
        if (userRole != null && (userRole.equals("admin") || userRole.equals("adminteacher"))) {
            chain.doFilter(request, response);
            return;
        }

        // 获取新闻ID
        String newsId = httpRequest.getParameter("id");

        // 如果是访问新闻详情页且有新闻ID
        if (("news.jsp".equals(getPageName(httpRequest)) || "newsList.jsp".equals(getPageName(httpRequest))) && newsId != null) {

            try {
                Long id = Long.parseLong(newsId);
                News news = newsDAO.getNewsById(id);

                if (news != null) {
                    String viewPermission = news.getViewPermission();

                    // 如果是公开的新闻，直接放行
                    if ("public".equals(viewPermission)) {
                        chain.doFilter(request, response);
                        return;
                    }

                    // 如果用户未登录，重定向到登录页面
                    if (userRole == null) {
                        String targetUrl = httpRequest.getRequestURI();
                        if (httpRequest.getQueryString() != null) {
                            targetUrl += "?" + httpRequest.getQueryString();
                        }
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?target=" + targetUrl);
                        return;
                    }

                    // 根据不同的权限级别进行判断
                    boolean hasPermission = false;

                    switch (viewPermission) {
                        case "allStudents":
                            hasPermission = userRole.equals("undergraduate") || userRole.equals("graduate") || userRole.equals("teacher") || userRole.equals("adminteacher") || userRole.equals("admin");
                            break;
                        case "undergraduate":
                            hasPermission = userRole.equals("undergraduate") || userRole.equals("teacher") || userRole.equals("adminteacher") || userRole.equals("admin");
                            break;
                        case "graduate":
                            hasPermission = userRole.equals("graduate") || userRole.equals("teacher") || userRole.equals("adminteacher") || userRole.equals("admin");
                            break;
                        case "teacher":
                            hasPermission = userRole.equals("teacher") || userRole.equals("adminteacher") || userRole.equals("admin");
                            break;
                    }

                    if (hasPermission) {
                        chain.doFilter(request, response);
                    } else {
                        // 如果没有权限，重定向到错误页面
                        httpRequest.setAttribute("errorMessage", "您无权访问此内容");
                        httpRequest.getRequestDispatcher("/error.jsp").forward(request, response);
                    }
                    return;
                }
            } catch (NumberFormatException e) {
                // 如果新闻ID格式不正确，重定向到错误页面
                httpRequest.setAttribute("errorMessage", "无效的新闻ID");
                httpRequest.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }

        // 其他情况（如首页）直接放行
        chain.doFilter(request, response);
    }

    /**
     * 过滤器销毁方法
     * 在Web容器卸载过滤器时调用
     */
    @Override
    public void destroy() {
        // 清理资源
    }

    /**
     * 获取请求的页面名称
     * 从请求URI中提取当前访问的页面名称
     * @param request HTTP请求对象
     * @return 页面名称（如：news.jsp）
     */
    private String getPageName(HttpServletRequest request) {
        String uri = request.getRequestURI();
        return uri.substring(uri.lastIndexOf("/") + 1);
    }
} 