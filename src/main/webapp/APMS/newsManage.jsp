<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/APMS/styles/newsmanage.css">
</head>

<div class="news-list-container">
    <table class="data-table">
        <thead>
            <tr>
                <th style="width: 60px">编号</th>
                <th>标题</th>
                <th style="width: 100px">类型</th>
                <th style="width: 150px">发布时间</th>
                <th style="width: 100px">发布者</th>
                <th style="min-width: 140px">操作</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${newsList}" var="news" varStatus="status">
                <tr>
                    <td>${startIndex + status.index}</td>
                    <td>${news.title}</td>
                    <td data-news-type="${news.newsType}">
                        <c:choose>
                            <%-- 主页新闻类型 --%>
                            <c:when test="${news.newsType == 'collegeNews'}">学院新闻</c:when>
                            <c:when test="${news.newsType == 'academicNotice'}">教务通知</c:when>
                            <c:when test="${news.newsType == 'announcement'}">通知公告</c:when>
                            <c:when test="${news.newsType == 'graduateTeaching'}">研究生教学</c:when>
                            <c:when test="${news.newsType == 'academicLecture'}">学术讲座</c:when>
                            <c:when test="${news.newsType == 'studentWork'}">学生工作</c:when>
                            <c:when test="${news.newsType == 'recruitment'}">招聘信息</c:when>

                            <%-- 学院概况 --%>
                            <c:when test="${news.newsType == 'collegeIntro'}">学院简介</c:when>
                            <c:when test="${news.newsType == 'leadership'}">学院领导</c:when>
                            <c:when test="${news.newsType == 'organization'}">组织机构</c:when>
                            <c:when test="${news.newsType == 'office'}">学院办公室</c:when>
                            <c:when test="${news.newsType == 'union'}">学院工会</c:when>

                            <%-- 师资队伍 --%>
                            <c:when test="${news.newsType == 'facultyOverview'}">师资概况</c:when>
                            <c:when test="${news.newsType == 'teacherDirectory'}">教师目录</c:when>
                            <c:when test="${news.newsType == 'facultyRecruitment'}">人才引进</c:when>

                            <%-- 本科教学 --%>

                            <c:when test="${news.newsType == 'majorIntro'}">专业介绍</c:when>
                            <c:when test="${news.newsType == 'cultivationPlan'}">培养方案</c:when>
                            <c:when test="${news.newsType == 'courseSystem'}">课程设置</c:when>
                            <c:when test="${news.newsType == 'teachingAchievement'}">教学成果</c:when>

                            <%-- 研究生 --%>
                            <c:when test="${news.newsType == 'graduateAdmission'}">研究生招生</c:when>
                            <c:when test="${news.newsType == 'graduateMajor'}">专业介绍</c:when>
                            <c:when test="${news.newsType == 'graduatePlan'}">培养方案</c:when>
                            <c:when test="${news.newsType == 'graduateRules'}">规章制度</c:when>
                            <c:when test="${news.newsType == 'tutorDirectory'}">导师目录</c:when>

                            <%-- 科学研究 --%>
                            <c:when test="${news.newsType == 'researchNews'}">科研动态</c:when>
                            <c:when test="${news.newsType == 'researchPapers'}">科研论著</c:when>
                            <c:when test="${news.newsType == 'researchTeam'}">科研团队</c:when>
                            <c:when test="${news.newsType == 'researchAchievement'}">科研成果</c:when>

                            <%-- 党群园地 --%>
                            <c:when test="${news.newsType == 'partyNews'}">党建动态</c:when>
                            <c:when test="${news.newsType == 'partyOrganization'}">组织建设</c:when>
                            <c:when test="${news.newsType == 'partyStudy'}">学习园地</c:when>

                            <%-- 国际交流 --%>
                            <c:when test="${news.newsType == 'internationalOverview'}">国际交流概况</c:when>
                            <c:when test="${news.newsType == 'internationalNews'}">国际交流动态</c:when>
                            <c:when test="${news.newsType == 'internationalRules'}">相关规章制度</c:when>

                            <%-- 校友专栏 --%>
                            <c:when test="${news.newsType == 'alumniStyle'}">校友风采</c:when>
                            <c:when test="${news.newsType == 'alumniNews'}">校友动态</c:when>

                            <%-- 毕业设计 --%>
                            <c:when test="${news.newsType == 'graduationNotice'}">公告通知</c:when>
                            <c:when test="${news.newsType == 'graduationTopics'}">毕业选题</c:when>
                            <c:when test="${news.newsType == 'graduationTemplates'}">文档模板</c:when>

                            <c:otherwise>${news.newsType}</c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${news.publishDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${news.publisher}</td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-edit" onclick="editNews(${news.id})">
                                <i class="fas fa-edit"></i> 编辑
                            </button>
                            <button class="btn-delete" onclick="newsManagement.confirmDelete(${news.id}, event)">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty newsList}">
                <tr>
                    <td colspan="6" style="text-align: center;">暂无新闻数据</td>
                </tr>
            </c:if>
        </tbody>
    </table>
    
    <!-- 修改分页控件部分 -->
    <div class="pagination">
        <span class="pagination-item ${currentPage == 1 ? 'disabled' : ''}" 
              onclick="goToPage(${currentPage - 1})">
            &lt;
        </span>
        
        <c:choose>
            <c:when test="${totalPages <= 7}">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                          onclick="goToPage(${i})">
                        ${i}
                    </span>
                </c:forEach>
            </c:when>
            
            <c:otherwise>
                <!-- 第一页 -->
                <span class="pagination-item ${currentPage == 1 ? 'active' : ''}" 
                      onclick="goToPage(1)">1</span>
                
                <!-- 当前页靠近开始位置 -->
                <c:if test="${currentPage <= 4}">
                    <c:forEach begin="2" end="5" var="i">
                        <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                              onclick="goToPage(${i})">${i}</span>
                    </c:forEach>
                    <span class="pagination-item disabled">...</span>
                </c:if>
                
                <!-- 当前页在中间位置 -->
                <c:if test="${currentPage > 4 && currentPage < totalPages - 3}">
                    <span class="pagination-item disabled">...</span>
                    <c:forEach begin="${currentPage - 2}" end="${currentPage + 2}" var="i">
                        <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                              onclick="goToPage(${i})">${i}</span>
                    </c:forEach>
                    <span class="pagination-item disabled">...</span>
                </c:if>
                
                <!-- 当前页靠近结束位置 -->
                <c:if test="${currentPage >= totalPages - 3}">
                    <span class="pagination-item disabled">...</span>
                    <c:forEach begin="${totalPages - 4}" end="${totalPages - 1}" var="i">
                        <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                              onclick="goToPage(${i})">${i}</span>
                    </c:forEach>
                </c:if>
                
                <!-- 最后一页 -->
                <span class="pagination-item ${currentPage == totalPages ? 'active' : ''}" 
                      onclick="goToPage(${totalPages})">${totalPages}</span>
            </c:otherwise>
        </c:choose>
        
        <span class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}" 
              onclick="goToPage(${currentPage + 1})">
            &gt;
        </span>
    </div>
</div>


<script>
    // 修改分页跳转函数
    function goToPage(page) {
        if (page < 1 || page > ${totalPages}) return;
        
        // 从父页面获取新闻类型
        const newsType = parent.document.getElementById('newsTypeFilter').value;
        loadNewsList(page, newsType);
    }

    // 添加新的加载新闻列表函数
    function loadNewsList(page, newsType) {
        const url = `${pageContext.request.contextPath}/news?type=list&page=${page}&newsType=${newsType}`;
        
        const xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById('content-main').innerHTML = xhr.responseText;
            }
        };
        xhr.send();
    }
</script>