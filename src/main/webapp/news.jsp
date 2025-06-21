<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="suep.academiaportal.dao.NewsDAO,suep.academiaportal.entity.News" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="suep.academiaportal.dao.NewsAttachmentDAO" %>
<%@ page import="suep.academiaportal.entity.NewsAttachment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page errorPage="/error.jsp" %>
<%
    News news;
    List<NewsAttachment> attachments = null;
    String newsId = request.getParameter("id");
    Long id = newsId != null ? Long.parseLong(newsId) : 1L; // 默认显示ID为1的新闻
    
    try {
        NewsDAO newsDAO = new NewsDAO();
        news = newsDAO.getNewsById(id);
        
        // 如果没有找到新闻，使用测试数据
        if (news == null) {
            news = new News();
            news.setTitle("测试新闻标题");
            news.setContent("<div class='news-content'>这是测试新闻内容</div>");
            news.setPublishDate(new Timestamp(System.currentTimeMillis()));
            news.setViewCount(0);
            attachments = new ArrayList<>();
        } else {
            // 更新浏览次数
            newsDAO.incrementViewCount(news.getId());
            
            // 获取新闻附件
            NewsAttachmentDAO attachmentDAO = new NewsAttachmentDAO();
            attachments = attachmentDAO.getAttachmentsByNewsId(news.getId());
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        news = new News();
        news.setTitle("新闻加载失败");
        news.setContent("<div class='error-message'>抱歉，新闻加载失败，请稍后重试。</div>");
        news.setPublishDate(new Timestamp(System.currentTimeMillis()));
        news.setViewCount(0);
        attachments = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= news.getTitle() %> - 计算机科学与技术学院</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/styles.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/newsStyles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <!-- 导航栏 -->
    <header>
        <div class="navbar">
            <div class="logo">
                <img src="<%= request.getContextPath() %>/images/logonew_1.png" class="logo-image">
                <img src="<%= request.getContextPath() %>/images/logonew_2.png" class="name-image">
            </div>
            
            <div class="menu-toggle">
                <span></span>
                <span></span>
                <span></span>
            </div>

            <ul class="nav">
                <li>
                    <a href="<%= request.getContextPath() %>/index.jsp">首页</a>
                </li>
                <li>
                    学院概况
                    <ul class="submenu">
                        <li>学院简介</li>
                        <li>学院领导</li>
                        <li>组织机构</li>
                        <li>学院办公室</li>
                        <li>学院工会</li>
                    </ul>
                </li>
                <li>
                    师资队伍
                    <ul class="submenu">
                        <li>师资概况</li>
                        <li>教师目录</li>
                        <li>人才引进</li>
                    </ul>
                </li>
                <li>
                    本科教学
                    <ul class="submenu">
                        <li>教务通知</li>
                        <li>专业介绍</li>
                        <li>培养方案</li>
                        <li>课程设置</li>
                        <li>教学成果</li>
                        <li>课程在线</li>
                    </ul>
                </li>
                <li>
                    研究生
                    <ul class="submenu">
                        <li>研究生招生</li>
                        <li>通知公告</li>
                        <li>专业介绍</li>
                        <li>培养方案</li>
                        <li>规章制度</li>
                        <li>导师目录</li>
                    </ul>
                </li>
                <li>科学研究</li>
                <li>党群园地</li>
                <li>国际交流</li>
                <li>校友专栏</li>
            </ul>
        </div>
    </header>

    <!-- 新闻内容 -->
    <div class="news-page">
        <div class="container">
            <article class="news-article">
                <div class="news-content">
                    <h4 style="font-weight:500;font-size:22px;font-family:微软雅黑;text-align:center;">
                        <%= news.getTitle() %>
                    </h4>
                    <div class="news-meta">
                        <span class="publish-date">发布日期：<%= news.getPublishDate() %></span>
                        <span class="view-count">浏览次数：<%= news.getViewCount() %></span>
                    </div>
                    <div class="content-body">
                        <%= news.getContent() %>
                    </div>
                    
                    <% if (!attachments.isEmpty()) { %>
                    <div class="attachments-section">
                        <h3>附件下载</h3>
                        <div class="attachment-list">
                            <% for (NewsAttachment attachment : attachments) { %>
                                <div class="attachment-item">
                                    <i class="fas fa-paperclip"></i>
                                    <a href="<%= request.getContextPath() %>/<%= attachment.getFileUrl() %>" 
                                       download="<%= attachment.getFileName() %>"
                                       class="attachment-link">
                                        <%= attachment.getFileName() %>
                                        <span class="file-size">
                                            (<%= formatFileSize(attachment.getFileSize()) %>)
                                        </span>
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            </article>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 汉堡菜单相关代码
            const menuToggle = document.querySelector('.menu-toggle');
            const nav = document.querySelector('.nav');
            
            menuToggle.addEventListener('click', function() {
                this.classList.toggle('active');
                nav.classList.toggle('active');
            });

            // 修改菜单项的点击事件处理
            const menuItems = document.querySelectorAll('.nav > li');
            menuItems.forEach(item => {
                const submenu = item.querySelector('.submenu');
                if(submenu) {
                    // 移除hover效果，只通过点击触发
                    item.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        // ���闭其他打开的子菜单
                        menuItems.forEach(otherItem => {
                            if(otherItem !== this && otherItem.classList.contains('active')) {
                                otherItem.classList.remove('active');
                            }
                        });
                        
                        // 切换当前子菜单
                        this.classList.toggle('active');
                    });
                }
            });

            // 点击子菜单项阻止冒泡并允许跳转
            document.querySelectorAll('.submenu li').forEach(item => {
                item.addEventListener('click', (e) => {
                    e.stopPropagation();
                    // 这里可以添加跳转逻辑
                });
            });

            // 点击页面其他地方关闭有子菜单
            document.addEventListener('click', (e) => {
                if (!nav.contains(e.target)) {
                    menuItems.forEach(item => {
                        item.classList.remove('active');
                    });
                }
            });
        });
    </script>

    <%!
        // 文件大小格式化辅助方法
        private String formatFileSize(long size) {
            if (size < 1024) {
                return size + " B";
            } else if (size < 1024 * 1024) {
                return String.format("%.1f KB", size / 1024.0);
            } else if (size < 1024 * 1024 * 1024) {
                return String.format("%.1f MB", size / (1024.0 * 1024));
            } else {
                return String.format("%.1f GB", size / (1024.0 * 1024 * 1024));
            }
        }
    %>
</body>
</html> 