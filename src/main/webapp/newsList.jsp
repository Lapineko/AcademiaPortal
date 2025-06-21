<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="suep.academiaportal.entity.News" %>
<%@ page import="suep.academiaportal.dao.NewsDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 获取当前页码，默认为1
    int currentPage = 1;
    try {
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }
    } catch (NumberFormatException e) {
        throw new RuntimeException(e);
    }
    
    // 设置每页显示的新闻数量为15（3列×5行）
    int pageSize = 15;
    
    // 获取新闻数据
    NewsDAO newsDAO = new NewsDAO();
    String newsType = request.getParameter("type");
    if (newsType == null || newsType.isEmpty()) {
        newsType = "collegeNews"; // 默认显示学院新闻
    }
    
    // 获取指定类型的所有新闻
    List<News> allNews = newsDAO.getNewsByType(newsType);
    
    // 计算总页数
    int totalItems = allNews.size();
    int totalPages = (int) Math.ceil((double) totalItems / pageSize);
    
    // 确保当前页码在有效范围内
    if (currentPage < 1) currentPage = 1;
    if (currentPage > totalPages) currentPage = totalPages;
    
    // 计算当前页的新闻
    List<News> currentPageNews;
    if (totalItems > 0) {
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalItems);
        currentPageNews = allNews.subList(startIndex, endIndex);
    } else {
        currentPageNews = new ArrayList<>();
    }
    
    // 将数据存储到request中供JSP使用
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("currentPageNews", currentPageNews);
    
    // 创建日期格式化工具
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    request.setAttribute("sdf", sdf);
%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新闻列表 - 计算机科学与技术学院</title>
    <link rel="stylesheet" href="styles/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/newsGrid.css">
</head>
<body>
    <!-- 导航栏 -->
    <header>
        <div class="navbar">
            <div class="logo">
                <img src="images/logonew_1.png" class="logo-image">
                <img src="images/logonew_2.png" class="name-image">
            </div>
            
            <div class="menu-toggle">
                <span></span>
                <span></span>
                <span></span>
            </div>

            <ul class="nav">
                <li><a href="index.jsp">首页</a></li>
                <li>
                    学院概况
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=collegeIntro">学院简介</a></li>
                        <li><a href="newsList.jsp?type=leadership">学院领导</a></li>
                        <li><a href="newsList.jsp?type=organization">组织机构</a></li>
                        <li><a href="newsList.jsp?type=office">学院办公室</a></li>
                        <li><a href="newsList.jsp?type=union">学院工会</a></li>
                    </ul>
                </li>
                <li>
                    师资队伍
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=facultyOverview">师资概况</a></li>
                        <li><a href="newsList.jsp?type=teacherDirectory">教师目录</a></li>
                        <li><a href="newsList.jsp?type=facultyRecruitment">人才引进</a></li>
                    </ul>
                </li>
                <li>
                    本科教学
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=academicNotice">教务通知</a></li>
                        <li><a href="newsList.jsp?type=majorIntro">专业介绍</a></li>
                        <li><a href="newsList.jsp?type=cultivationPlan">培养方案</a></li>
                        <li><a href="newsList.jsp?type=courseSystem">课程设置</a></li>
                        <li><a href="newsList.jsp?type=teachingAchievement">教学成果</a></li>
                    </ul>
                </li>
                <li>
                    科学研究
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=researchNews">科研动态</a></li>
                        <li><a href="newsList.jsp?type=researchPapers">科研论著</a></li>
                        <li><a href="newsList.jsp?type=researchTeam">科研团队</a></li>
                        <li><a href="newsList.jsp?type=researchAchievement">科研成果</a></li>
                    </ul>
                </li>
                <li>
                    党群园地
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=partyNews">党建动态</a></li>
                        <li><a href="newsList.jsp?type=partyOrganization">组织建设</a></li>
                        <li><a href="newsList.jsp?type=partyStudy">学习园地</a></li>
                    </ul>
                </li>
                <li>
                    国际交流
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=internationalOverview">国际交流概况</a></li>
                        <li><a href="newsList.jsp?type=internationalNews">国际交流动态</a></li>
                        <li><a href="newsList.jsp?type=internationalRules">相关规章制度</a></li>
                    </ul>
                </li>
                <li>
                    校友专栏
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=alumniStyle">校友风采</a></li>
                        <li><a href="newsList.jsp?type=alumniNews">校友动态</a></li>
                    </ul>
                </li>
                <li>
                    毕业设计
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=graduationNotice">公告通知</a></li>
                        <li><a href="newsList.jsp?type=graduationTopics">毕业选题</a></li>
                        <li><a href="newsList.jsp?type=graduationTemplates">文档模板</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </header>

    <!-- 新闻列表内容 -->
    <div class="news-list-page">
        <c:choose>
            <%-- 学院新闻使用网格布局 --%>
            <c:when test="${param.type == 'collegeNews'}">
                <c:choose>
                    <c:when test="${empty currentPageNews}">
                        <div class="news-grid-container">
                            <div class="empty-news">暂无新闻内容</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="news-grid-container">
                            <c:forEach items="${currentPageNews}" var="news">
                                <div class="news-grid-item">
                                    <a href="news.jsp?id=${news.id}">
                                        <div class="news-image">
                                            <img src="${not empty news.imageUrl ? news.imageUrl : 'images/default-news.jpg'}" 
                                                 alt="${news.title}">
                                        </div>
                                        <div class="news-content">
                                            <div class="news-title">${news.title}</div>
                                            <div class="news-date">
                                                ${sdf.format(news.publishDate)}
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <%-- 其他类型使用左侧导航+列表布局 --%>
            <c:otherwise>
                <div class="news-with-nav">
                    <!-- 左侧导航 -->
                    <div class="news-nav">
                        <ul>
                            <c:choose>
                                <%-- 学院概况子菜单 --%>
                                <c:when test="${param.type == 'collegeIntro' || param.type == 'leadership' || 
                                              param.type == 'organization' || param.type == 'office' || 
                                              param.type == 'union'}">
                                    <li class="${param.type == 'collegeIntro' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=collegeIntro">学院简介</a>
                                    </li>
                                    <li class="${param.type == 'leadership' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=leadership">学院领导</a>
                                    </li>
                                    <li class="${param.type == 'organization' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=organization">组织机构</a>
                                    </li>
                                    <li class="${param.type == 'office' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=office">学院办公室</a>
                                    </li>
                                    <li class="${param.type == 'union' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=union">学院工会</a>
                                    </li>
                                </c:when>

                                <%-- 师资队伍子菜单 --%>
                                <c:when test="${param.type == 'facultyOverview' || param.type == 'teacherDirectory' || 
                                              param.type == 'facultyRecruitment'}">
                                    <li class="${param.type == 'facultyOverview' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=facultyOverview">师资概况</a>
                                    </li>
                                    <li class="${param.type == 'teacherDirectory' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=teacherDirectory">教师目录</a>
                                    </li>
                                    <li class="${param.type == 'facultyRecruitment' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=facultyRecruitment">人才引进</a>
                                    </li>
                                </c:when>

                                <%-- 本科教学子菜单 --%>
                                <c:when test="${param.type == 'academicNotice' || param.type == 'majorIntro' || 
                                              param.type == 'cultivationPlan' || param.type == 'courseSystem' || 
                                              param.type == 'teachingAchievement'}">
                                    <li class="${param.type == 'academicNotice' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=academicNotice">教务通知</a>
                                    </li>
                                    <li class="${param.type == 'majorIntro' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=majorIntro">专业介绍</a>
                                    </li>
                                    <li class="${param.type == 'cultivationPlan' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=cultivationPlan">培养方案</a>
                                    </li>
                                    <li class="${param.type == 'courseSystem' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=courseSystem">课程设置</a>
                                    </li>
                                    <li class="${param.type == 'teachingAchievement' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=teachingAchievement">教学成果</a>
                                    </li>
                                </c:when>

                                <%-- 科学研究子菜单 --%>
                                <c:when test="${param.type == 'researchNews' || param.type == 'researchPapers' || 
                                              param.type == 'researchTeam' || param.type == 'researchAchievement'}">
                                    <li class="${param.type == 'researchNews' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=researchNews">科研动态</a>
                                    </li>
                                    <li class="${param.type == 'researchPapers' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=researchPapers">科研论著</a>
                                    </li>
                                    <li class="${param.type == 'researchTeam' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=researchTeam">科研团队</a>
                                    </li>
                                    <li class="${param.type == 'researchAchievement' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=researchAchievement">科研成果</a>
                                    </li>
                                </c:when>

                                <%-- 党群园地子菜单 --%>
                                <c:when test="${param.type == 'partyNews' || param.type == 'partyOrganization' || 
                                              param.type == 'partyStudy'}">
                                    <li class="${param.type == 'partyNews' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=partyNews">党建动态</a>
                                    </li>
                                    <li class="${param.type == 'partyOrganization' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=partyOrganization">组织建设</a>
                                    </li>
                                    <li class="${param.type == 'partyStudy' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=partyStudy">学习园地</a>
                                    </li>
                                </c:when>

                                <%-- 国际交流子菜单 --%>
                                <c:when test="${param.type == 'internationalOverview' || param.type == 'internationalNews' || 
                                              param.type == 'internationalRules'}">
                                    <li class="${param.type == 'internationalOverview' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=internationalOverview">国际交流概况</a>
                                    </li>
                                    <li class="${param.type == 'internationalNews' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=internationalNews">国际交流动态</a>
                                    </li>
                                    <li class="${param.type == 'internationalRules' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=internationalRules">相关规章制度</a>
                                    </li>
                                </c:when>

                                <%-- 校友专栏子菜单 --%>
                                <c:when test="${param.type == 'alumniStyle' || param.type == 'alumniNews'}">
                                    <li class="${param.type == 'alumniStyle' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=alumniStyle">校友风采</a>
                                    </li>
                                    <li class="${param.type == 'alumniNews' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=alumniNews">校友动态</a>
                                    </li>
                                </c:when>

                                <%-- 毕业设计子菜单 --%>
                                <c:when test="${param.type == 'graduationNotice' || param.type == 'graduationTopics' || 
                                              param.type == 'graduationTemplates'}">
                                    <li class="${param.type == 'graduationNotice' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=graduationNotice">公告通知</a>
                                    </li>
                                    <li class="${param.type == 'graduationTopics' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=graduationTopics">毕业选题</a>
                                    </li>
                                    <li class="${param.type == 'graduationTemplates' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=graduationTemplates">文档模板</a>
                                    </li>
                                </c:when>

                                <%-- 默认显示主页新闻类型的子菜单 --%>
                                <c:otherwise>
                                    <li class="${param.type == 'academicNotice' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=academicNotice">教务通知</a>
                                    </li>
                                    <li class="${param.type == 'announcement' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=announcement">通知公告</a>
                                    </li>
                                    <li class="${param.type == 'graduateTeaching' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=graduateTeaching">研究生教学</a>
                                    </li>
                                    <li class="${param.type == 'academicLecture' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=academicLecture">学术讲座</a>
                                    </li>
                                    <li class="${param.type == 'studentWork' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=studentWork">学生工作</a>
                                    </li>
                                    <li class="${param.type == 'recruitment' ? 'active' : ''}">
                                        <a href="newsList.jsp?type=recruitment">招聘信息</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                    
                    <!-- 右侧新闻列表 -->
                    <div class="news-list-content">
                        <c:choose>
                            <c:when test="${empty currentPageNews}">
                                <div class="empty-news">暂无新闻内容</div>
                            </c:when>
                            <c:otherwise>
                                <ul class="news-items">
                                    <c:forEach items="${currentPageNews}" var="news">
                                        <li class="news-item">
                                            <a href="news.jsp?id=${news.id}">
                                                <div class="news-title">${news.title}</div>
                                                <div class="news-summary">
                                                    <%
                                                        News news = (News)pageContext.getAttribute("news");
                                                        String content = news.getContent().replaceAll("<[^>]*>", "");
                                                        if(content.length() > 100) {
                                                            content = content.substring(0, 100) + "...";
                                                        }
                                                        out.print(content);
                                                    %>
                                                </div>
                                                <div class="news-date">
                                                    ${sdf.format(news.publishDate)}
                                                </div>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- 分页控件,仅在有新闻内容时显示 -->
        <c:if test="${not empty currentPageNews}">
            <div class="pagination">
                <span class="pagination-item ${currentPage == 1 ? 'disabled' : ''}" 
                      onclick="goToPage(${currentPage - 1}, '${param.type}')">
                    <
                </span>
                
                <c:choose>
                    <c:when test="${totalPages <= 7}">
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                                  onclick="goToPage(${i}, '${param.type}')">
                                ${i}
                            </span>
                        </c:forEach>
                    </c:when>
                    
                    <c:otherwise>
                        <span class="pagination-item ${currentPage == 1 ? 'active' : ''}" 
                              onclick="goToPage(1, '${param.type}')">1</span>
                        
                        <c:if test="${currentPage <= 4}">
                            <c:forEach begin="2" end="5" var="i">
                                <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                                      onclick="goToPage(${i}, '${param.type}')">${i}</span>
                            </c:forEach>
                            <span class="pagination-item disabled">...</span>
                        </c:if>
                        
                        <c:if test="${currentPage > 4 && currentPage < totalPages - 3}">
                            <span class="pagination-item disabled">...</span>
                            <c:forEach begin="${currentPage - 2}" end="${currentPage + 2}" var="i">
                                <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                                      onclick="goToPage(${i}, '${param.type}')">${i}</span>
                            </c:forEach>
                            <span class="pagination-item disabled">...</span>
                        </c:if>
                        
                        <c:if test="${currentPage >= totalPages - 3}">
                            <span class="pagination-item disabled">...</span>
                            <c:forEach begin="${totalPages - 4}" end="${totalPages - 1}" var="i">
                                <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                                      onclick="goToPage(${i}, '${param.type}')">${i}</span>
                            </c:forEach>
                        </c:if>
                        
                        <span class="pagination-item ${currentPage == totalPages ? 'active' : ''}" 
                              onclick="goToPage(${totalPages}, '${param.type}')">${totalPages}</span>
                    </c:otherwise>
                </c:choose>
                
                <span class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}" 
                      onclick="goToPage(${currentPage + 1}, '${param.type}')">
                    >
                </span>
            </div>
        </c:if>
    </div>

    <script>
        // 导航菜单交互
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.querySelector('.menu-toggle');
            const nav = document.querySelector('.nav');
            
            menuToggle.addEventListener('click', function() {
                this.classList.toggle('active');
                nav.classList.toggle('active');
            });

            const menuItems = document.querySelectorAll('.nav > li');
            menuItems.forEach(item => {
                const submenu = item.querySelector('.submenu');
                if(submenu) {
                    item.addEventListener('click', function(e) {
                        if (e.target.tagName.toLowerCase() === 'a') {
                            return;
                        }
                        
                        e.preventDefault();
                        e.stopPropagation();
                        
                        menuItems.forEach(otherItem => {
                            if(otherItem !== this && otherItem.classList.contains('active')) {
                                otherItem.classList.remove('active');
                            }
                        });
                        
                        this.classList.toggle('active');
                    });
                }
            });

            document.querySelectorAll('.submenu li a').forEach(item => {
                item.addEventListener('click', (e) => {
                    e.stopPropagation();
                });
            });

            document.addEventListener('click', (e) => {
                if (!nav.contains(e.target)) {
                    menuItems.forEach(item => {
                        item.classList.remove('active');
                    });
                }
            });
        });

        // 修改分页跳转函数，添加调试日志
        function goToPage(page, newsType) {
            
            if (page < 1) {

                return;
            }
            
            // 构建URL
            let url = 'newsList.jsp?page=' + page;
            if (newsType) {
                url += '&type=' + newsType;
            }
            

            window.location.href = url;
        }
    </script>


</body>
</html> 