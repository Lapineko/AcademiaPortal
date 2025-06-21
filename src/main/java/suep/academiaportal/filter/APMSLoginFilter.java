package suep.academiaportal.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 学术之窗管理系统(APMS)登录过滤器
 * 用于拦截对APMS模块的访问请求，进行身份验证和权限控制
 * 只允许已登录的管理员和教师管理员访问APMS模块
 */
@WebFilter(urlPatterns = "/APMS/*")
public class APMSLoginFilter implements Filter {
    
    /**
     * 过滤器初始化方法
     * @param filterConfig 过滤器配置对象
     * @throws ServletException 初始化异常
     */
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    /**
     * 执行过滤操作
     * 检查用户是否已登录以及是否具有适当的访问权限
     * 对于未登录或权限不足的用户，重定向到登录页面
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

        // 检查用户是否已登录
        Object userId = session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");
        
        // 如果用户未登录或角色不正确
        if (userId == null || (role != null && !role.equals("admin") && !role.equals("adminteacher"))) {
            // 将用户重定向到登录页面
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?target=admin");
            return;
        }
        
        // 用户已登录且角色正确，继续处理请求
        chain.doFilter(request, response);
    }

    /**
     * 过滤器销毁方法
     * 在Web容器卸载过滤器时调用
     */
    @Override
    public void destroy() {
    }
}