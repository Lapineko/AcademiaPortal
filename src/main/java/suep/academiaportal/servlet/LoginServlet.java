package suep.academiaportal.servlet;

import suep.academiaportal.dao.UserDAO;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户登录Servlet
 * 处理用户登录验证、会话管理和权限控制
 * 支持不同角色用户的登录和重定向
 */
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    /**
     * 处理POST请求
     * 验证用户登录信息并进行相应处理：
     * 1. 验证用户名密码
     * 2. 设置用户会话信息
     * 3. 根据目标页面和用户角色进行重定向
     * 
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @throws ServletException Servlet异常
     * @throws IOException IO异常
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String password = request.getParameter("password");
        String target = request.getParameter("target");
        
        try {
            int id = Integer.parseInt(idStr);
            
            if (userDAO.validateUser(id, password)) {
                HttpSession session = request.getSession();
                String role = userDAO.getUserRole(id);
                session.setAttribute("userId", id);
                session.setAttribute("userRole", role);
                session.setAttribute("realName", userDAO.getUserRealName(id));
                session.setAttribute("user", String.valueOf(id));

                switch(target) {
                    case "admin":
                        if ("admin".equals(role) || "adminteacher".equals(role)) {
                            response.sendRedirect(request.getContextPath() + "/APMS/admin.jsp");
                        } else {
                            request.getSession().setAttribute("errorMsg", "您没有权限访问该页面");
                            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
                            rd.forward(request, response);
                        }
                        break;
                    default:
                        if (target != null && !target.isEmpty()) {
                            response.sendRedirect(target);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/index.jsp");
                        }
                }
            } else {
                request.getSession().setAttribute("errorMsg", "账号或密码不正确");
                RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
                rd.forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "账号或密码不正确");
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMsg", "系统错误，请稍后重试");
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
        }
    }

    /**
     * 处理GET请求
     * 将所有GET请求转发到POST方法处理
     * 
     * @param request HTTP请求对象
     * @param response HTTP响应对象
     * @throws ServletException Servlet异常
     * @throws IOException IO异常
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
} 