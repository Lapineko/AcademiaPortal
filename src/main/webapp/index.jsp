<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="suep.academiaportal.dao.NewsDAO" %>
<%@ page import="suep.academiaportal.dao.CarouselDAO" %>
<%@ page import="suep.academiaportal.entity.News" %>
<%@ page import="suep.academiaportal.entity.Carousel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    NewsDAO newsDAO = new NewsDAO();
%>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>计算机科学与技术学院</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/styles.css">
</head>
<body>
<div class="container">
    <!-- 顶部导航栏 -->
    <header>
        <div class="navbar">
            <div class="logo">
                <img src="<%= request.getContextPath() %>/images/logonew_1.png" class="logo-image">
                <img src="<%= request.getContextPath() %>/images/logonew_2.png" class="name-image">
            </div>
            
            <!-- 添加汉菜单按钮 -->
            <div class="menu-toggle">
                <span></span>
                <span></span>
                <span></span>
            </div>

            <ul class="nav">
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
                        <li><a href="newsList.jsp?type=onlineCourse">课程在线</a></li>
                    </ul>
                </li>
                <li>
                    研究生
                    <ul class="submenu">
                        <li><a href="newsList.jsp?type=graduateAdmission">研究生招生</a></li>
                        <li><a href="newsList.jsp?type=graduateNotice">通知公告</a></li>
                        <li><a href="newsList.jsp?type=graduateMajor">专业介绍</a></li>
                        <li><a href="newsList.jsp?type=graduatePlan">培养方案</a></li>
                        <li><a href="newsList.jsp?type=graduateRules">规章制度</a></li>
                        <li><a href="newsList.jsp?type=tutorDirectory">导师目录</a></li>
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
                        <li><a href="newsList.jsp?type=graduationTopic">毕业选题</a></li>
                        <li><a href="newsList.jsp?type=graduationTemplate">文档模板</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </header>

    <!-- 轮播图部分 -->
    <section class="carousel">
        <div class="carousel-container">
            <div class="carousel-track">
                <%
                    CarouselDAO carouselDAO = new CarouselDAO();
                    List<Carousel> activeCarousels = carouselDAO.getActiveCarousels();
                    for(Carousel carousel : activeCarousels) {
                %>
                <div class="carousel-slide">
                    <img src="<%= request.getContextPath() %>/<%= carousel.getImageUrl() %>" 
                         alt="<%= carousel.getTitle() %>">
                </div>
                <% } %>
            </div>
        </div>
        
        <div class="carousel-indicators">
            <% for(int i = 0; i < activeCarousels.size(); i++) { %>
                <div class="indicator <%= i == 0 ? "active" : "" %>">
                    <img src="<%= request.getContextPath() %>/<%= activeCarousels.get(i).getImageUrl() %>" 
                         alt="<%= activeCarousels.get(i).getTitle() %>">
                </div>
            <% } %>
        </div>
    </section>

    <!-- 修改新闻部 -->
    <section class="news-section">
        <div class="news-grid">
            <!-- 第一行：学院新闻 + 特色新闻 -->
            <div class="news-row">
                <!-- 学院新闻 -->
                <div class="news-list main-news">
                    <div class="news-title-bar">
                        <h2>学院新闻</h2>
                        <a href="newsList.jsp?type=collegeNews" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <%
                            List<News> collegeNews = newsDAO.getNewsByType("collegeNews", 8);
                            for (News news : collegeNews) {
                        %>
                        <li class="news-item">
                            <a href="news.jsp?id=<%= news.getId() %>">
                                <span class="news-title"><%= news.getTitle() %></span>
                                <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                            </a>
                        </li>
                        <% } %>
                    </ul>
                </div>
                
                <!-- 特色新闻 -->
                <div class="featured-news">
                    <% List<News> latestNews = newsDAO.getLatestNews(2); %>
                    <% if (!latestNews.isEmpty()) { 
                        for (News featuredNews : latestNews) {
                    %>
                        <a href="news.jsp?id=<%= featuredNews.getId() %>" class="featured-item">
                            <img src="<%= featuredNews.getImageUrl() != null ? featuredNews.getImageUrl() : "images/default.jpg" %>" 
                                 alt="<%= featuredNews.getTitle() %>">
                            <h3><%= featuredNews.getTitle() %></h3>
                        </a>
                    <% 
                        }
                       } 
                    %>
                </div>
            </div>
            
            <!-- 第二行：教务通知 + 通知公告 -->
            <div class="news-row">
                <div class="news-list">
                    <div class="news-title-bar">
                        <h2>教务通知</h2>
                        <a href="newsList.jsp?type=academicNotice" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <% List<News> academicNews = newsDAO.getNewsByType("academicNotice", 6); %>
                        <% for (News news : academicNews) { %>
                            <li class="news-item">
                                <a href="news.jsp?id=<%= news.getId() %>">
                                    <span class="news-title"><%= news.getTitle() %></span>
                                    <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
                
                <div class="news-list">
                    <div class="news-title-bar">
                        <h2>通知公告</h2>
                        <a href="newsList.jsp?type=announcement" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <% List<News> announcements = newsDAO.getNewsByType("announcement", 6); %>
                        <% for (News news : announcements) { %>
                            <li class="news-item">
                                <a href="news.jsp?id=<%= news.getId() %>">
                                    <span class="news-title"><%= news.getTitle() %></span>
                                    <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
            </div>
            
            <!-- 第三行：研究生教学 + 学术讲座 -->
            <div class="news-row">
                <div class="news-list">
                    <div class="news-title-bar">
                        <h2>研究生教学</h2>
                        <a href="newsList.jsp?type=graduateTeaching" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <% List<News> graduateNews = newsDAO.getNewsByType("graduateTeaching", 6); %>
                        <% for (News news : graduateNews) { %>
                            <li class="news-item">
                                <a href="news.jsp?id=<%= news.getId() %>">
                                    <span class="news-title"><%= news.getTitle() %></span>
                                    <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
                
                <div class="news-list">
                    <div class="news-title-bar">
                        <h2>学术讲座</h2>
                        <a href="newsList.jsp?type=academicLecture" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <% List<News> lectureNews = newsDAO.getNewsByType("academicLecture", 6); %>
                        <% for (News news : lectureNews) { %>
                            <li class="news-item">
                                <a href="news.jsp?id=<%= news.getId() %>">
                                    <span class="news-title"><%= news.getTitle() %></span>
                                    <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
            </div>
            
            <!-- 第四行：学生工作 + 招聘信息 -->
            <div class="news-row">
                <div class="news-list">
                    <div class="news-title-bar">
                        <h2>学生工作</h2>
                        <a href="newsList.jsp?type=studentWork" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <% List<News> studentNews = newsDAO.getNewsByType("studentWork", 6); %>
                        <% for (News news : studentNews) { %>
                            <li class="news-item">
                                <a href="news.jsp?id=<%= news.getId() %>">
                                    <span class="news-title"><%= news.getTitle() %></span>
                                    <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
                
                <div class="news-list">
                    <div class="news-title-bar">
                        <h2>招聘信息</h2>
                        <a href="newsList.jsp?type=recruitment" title="更多">···</a>
                    </div>
                    <ul class="news-items">
                        <% List<News> recruitmentNews = newsDAO.getNewsByType("recruitment", 6); %>
                        <% for (News news : recruitmentNews) { %>
                            <li class="news-item">
                                <a href="news.jsp?id=<%= news.getId() %>">
                                    <span class="news-title"><%= news.getTitle() %></span>
                                    <span class="news-date"><%= new SimpleDateFormat("yyyy-MM-dd").format(news.getPublishDate()) %></span>
                                </a>
                            </li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </div>
    </section>

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
                    // 除hover效果，只通过点击触发
                    item.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        
                        // 关闭其他打开的子菜单
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

            // 点击子菜单项阻止冒泡但不阻止默认行为
            document.querySelectorAll('.submenu li a').forEach(item => {
                item.addEventListener('click', (e) => {
                    e.stopPropagation();
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

            // 轮播图相关代码
            const slides = document.querySelectorAll('.carousel-slide');
            const indicators = document.querySelectorAll('.indicator');
            let currentIndex = 0;
            let autoPlayInterval;

            // 切换到指定幻灯片
            function showSlide(index) {
                // 确保索引在有效范围内
                if (index >= slides.length) {
                    index = 0;
                } else if (index < 0) {
                    index = slides.length - 1;
                }

                // 更新所有幻灯片的位置
                slides.forEach((slide, i) => {
                    slide.style.display = i === index ? 'block' : 'none';
                });
                
                // 更新指示器状态
                indicators.forEach((indicator, i) => {
                    indicator.classList.toggle('active', i === index);
                });

                currentIndex = index;
            }

            // 自动播放
            function startAutoPlay() {
                stopAutoPlay(); // 先清除之前的定时器
                autoPlayInterval = setInterval(() => {
                    showSlide(currentIndex + 1);
                }, 5000);
            }

            // 停止自动播放
            function stopAutoPlay() {
                if (autoPlayInterval) {
                    clearInterval(autoPlayInterval);
                }
            }

            // 为指示器加点击和悬浮事件
            indicators.forEach((indicator, index) => {
                // 点击事件
                indicator.addEventListener('click', () => {
                    showSlide(index);
                    stopAutoPlay();
                    startAutoPlay(); // 重新开始自动播放
                });

                // 鼠标悬浮事件
                indicator.addEventListener('mouseenter', () => {
                    showSlide(index);
                    stopAutoPlay(); // 悬浮时停止自动播放
                });

                // 鼠标离开事件
                indicator.addEventListener('mouseleave', () => {
                    startAutoPlay(); // 鼠标离开后重新开始自动播放
                });
            });

            // 初始化显示第一张幻灯片
            showSlide(0);
            
            // 启动自动播放
            startAutoPlay();

            // 当页面不可见时停止自动播放
            document.addEventListener('visibilitychange', () => {
                if (document.hidden) {
                    stopAutoPlay();
                } else {
                    startAutoPlay();
                }
            });
        });
    </script>
</div>
</body>
</html>
