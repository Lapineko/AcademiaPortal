<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 验证用户身份，只允许admin和adminteacher角色访问
    String role = (String) session.getAttribute("userRole");

    if (role == null || (!role.equals("admin") && !role.equals("adminteacher"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?target=admin");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>后台管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/APMS/styles/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/APMS/styles/newsmanage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/APMS/styles/newsEdit.css">
    <link href="${pageContext.request.contextPath}/editer/normalize.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/editer/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/editer/layout.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/editer/index.js"></script>

</head>
<body>
    <div class="admin-container">
        <!-- 左侧菜单 -->
        <div class="admin-sidebar">
            <div class="logo">
                <div class="logo-title">后台管理系统</div>
                <div class="welcome-text">欢迎回来, <%= session.getAttribute("realName") %></div>
            </div>
            <ul class="menu">
                <li class="menu-item" data-page="news" onclick="switchMenu(this, 'news')">
                    <i class="fas fa-newspaper"></i>
                    <span>新闻管理</span>
                </li>
                <li class="menu-item" data-page="carousel" onclick="switchMenu(this, 'carousel')">
                    <i class="fas fa-images"></i>
                    <span>轮播图管理</span>
                </li>
            </ul>
        </div>
        
        <!-- 右侧内容区 -->
        <div class="admin-content">
            <div class="content-header">
                <h2 id="content-title">新闻管理</h2>
                <div class="header-controls">
                    <label for="newsTypeFilter"></label><select id="newsTypeFilter" class="form-control" onchange="filterNewsByType(this.value)">
                        <option value="all">全部类型</option>
                        <optgroup label="主页">
                            <option value="collegeNews">学院新闻</option>
                            <option value="academicNotice">教务通知</option>
                            <option value="announcement">通知公告</option>
                            <option value="graduateTeaching">研究生教学</option>
                            <option value="academicLecture">学术讲座</option>
                            <option value="studentWork">学生工作</option>
                            <option value="recruitment">招聘信息</option>
                        </optgroup>
                        <optgroup label="学院概况">
                            <option value="collegeIntro">学院简介</option>
                            <option value="leadership">学院领导</option>
                            <option value="organization">组织机构</option>
                            <option value="office">学院办公室</option>
                            <option value="union">学院工会</option>
                        </optgroup>
                        <optgroup label="师资队伍">
                            <option value="facultyOverview">师资概况</option>
                            <option value="teacherDirectory">教师目录</option>
                            <option value="facultyRecruitment">人才引进</option>
                        </optgroup>
                        <optgroup label="本科教学">
                            <option value="undergraduateNotice">教务通知</option>
                            <option value="majorIntro">专业介绍</option>
                            <option value="cultivationPlan">培养方案</option>
                            <option value="courseSystem">课程设置</option>
                            <option value="teachingAchievement">教学成果</option>
                        </optgroup>
                        <optgroup label="研究生">
                            <option value="graduateAdmission">研究生招生</option>
                            <option value="graduateMajor">专业介绍</option>
                            <option value="graduatePlan">培养方案</option>
                            <option value="graduateRules">规章制度</option>
                            <option value="tutorDirectory">导师目录</option>
                        </optgroup>
                        <optgroup label="科学研究">
                            <option value="researchNews">科研动态</option>
                            <option value="researchPapers">科研论著</option>
                            <option value="researchTeam">科研团队</option>
                            <option value="researchAchievement">科研成果</option>
                        </optgroup>
                        <optgroup label="党群园地">
                            <option value="partyNews">党建动态</option>
                            <option value="partyOrganization">组织建设</option>
                            <option value="partyStudy">学习园地</option>
                        </optgroup>
                        <optgroup label="国际交流">
                            <option value="internationalOverview">国际交流概况</option>
                            <option value="internationalNews">国际交流动态</option>
                            <option value="internationalRules">相关规章制度</option>
                        </optgroup>
                        <optgroup label="校友专栏">
                            <option value="alumniStyle">校友风采</option>
                            <option value="alumniNews">校友动态</option>
                        </optgroup>
                        <optgroup label="毕业设计">
                            <option value="graduationNotice">公告通知</option>
                            <option value="graduationTopics">毕业选题</option>
                            <option value="graduationTemplates">文档模板</option>
                        </optgroup>
                    </select>
                    <button id="addButton" class="btn-primary">新增新闻</button>
                </div>
            </div>
            <div class="content-main" id="content-main">
                <div class="news-list-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th width="5%">编号</th>
                                <th width="25%">标题</th>
                                <th width="10%">类型</th>
                                <th width="15%">发布时间</th>
                                <th width="10%">发布者</th>
                                <th width="15%">操作</th>
                            </tr>
                        </thead>
                        <tbody id="newsListBody">
                            <!-- 新闻列表 JavaScript 动态加载 -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 修改模态框结构 -->
    <div id="newsModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <span>新增新闻</span>
                <span class="close" onclick="closeNewsModal()">×</span>
            </div>
            <div class="modal-body">
                <jsp:include page="newsEdit.jsp" />
            </div>
        </div>
    </div>


    <script>
    // 在脚本开始处添加编辑器变量声明
    let editor;

    // 添加编辑器初始化函数
    function initEditor() {
        // 先销毁已存在的编辑器实例
        if (editor) {
            editor.destroy();
            editor = null;
        }
        
        const E = window.wangEditor;
        const LANG = 'zh-CN';
        E.i18nChangeLanguage(LANG);
        
        // 创建新的编辑器实例
        editor = E.createEditor({
            selector: '#editor-text-area',
            html: '<p><br></p>',
            config: {
                placeholder: '请输入新闻内容...',
                MENU_CONF: {
                    uploadImage: {
                        server: '${pageContext.request.contextPath}/news?type=uploadImage',
                        fieldName: 'image',
                        maxFileSize: 10 * 1024 * 1024,
                        meta: {},
                        headers: {},
                        onSuccess(file, res) {
                            if(res.errno === 0) {
                                return res.data.url;
                            }
                            return '';
                        },
                        onFailed(file, res) {
                                             alert('图片上传失败：' + (res.message || '未知错误'));
                        },
                        onError(file, err, res) {
                            alert('图片上传错误：' + (err.message || '未知错误'));
                        }
                    }
                },
                onChange(editor) {
                    document.getElementById('content').value = editor.getHtml();
                }
            }
        });

        // 创建工具栏
        const toolbar = E.createToolbar({
            editor: editor,
            selector: '#editor-toolbar',
            config: {}
        });
        
        return editor; // 返回创建的编辑器实例
    }

    // 定义全局新闻管理函数
    window.newsManagement = {
        confirmDelete: function(id, event) {
            if (confirm('此操作不可逆，确定要删除这新闻吗？')) {
                const button = event.target.closest('.btn-delete');
                button.disabled = true;
                button.innerHTML = '删除中...';
                
                // 用XMLHttpRequest发送删除请求
                const xhr = new XMLHttpRequest();
                xhr.open('POST', '${pageContext.request.contextPath}/news?type=delete&id=' + id, true);
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            const result = xhr.responseText;
                            if (result === 'success') {
                                // 删除成功后重新加载新闻列表
                                loadNewsList();
                            } else {
                                alert('删除失败：' + result);
                                button.disabled = false;
                                button.innerHTML = '删除';
                            }
                        } else {
                            alert('删除失败');
                            button.disabled = false;
                            button.innerHTML = '删除';
                        }
                    }
                };
                
                xhr.send();
            }
        }
    };

    // 页面加载完成新闻列表
    document.addEventListener('DOMContentLoaded', function() {
        loadNewsList();
    });

    // 加载新闻列表
    function loadNewsList() {
    
        const contentMain = document.getElementById('content-main');
        const newsType = document.getElementById('newsTypeFilter').value;
        
        const xhr = new XMLHttpRequest();
        const formData = new FormData();
        formData.append('type', 'list');
        if (newsType !== 'all') {
            formData.append('newsType', newsType);
        }
        
        xhr.open('POST', '${pageContext.request.contextPath}/news', true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    contentMain.innerHTML = xhr.responseText;
                } else {
                    contentMain.innerHTML = '<div class="error-message">加载新闻列表失败</div>';
                }
            }
        };
        
        xhr.send(formData);
    }

    // 加辅助函数
    function getNewsTypeName(type) {
        const types = {
            // 主页新闻类型
            'collegeNews': '学院新闻',
            'academicNotice': '教务通知',
            'announcement': '通知公告',
            'graduateTeaching': '研究生教学',
            'academicLecture': '学术讲座',
            'studentWork': '学生工作',
            'recruitment': '招聘信息',

            // 学院概况
            'collegeIntro': '学院简介',
            'leadership': '学院领导',
            'organization': '组织机构',
            'office': '学院办公室',
            'union': '学院工会',

            // 师资队伍
            'facultyOverview': '师资概况',
            'teacherDirectory': '教师目录',
            'facultyRecruitment': '人才引进',

            // 本科教学
            'undergraduateNotice': '教务通知',
            'majorIntro': '专业介绍',
            'cultivationPlan': '培养方案',
            'courseSystem': '课程设置',
            'teachingAchievement': '教学成果',

            // 研究生
            'graduateAdmission': '研究生招生',
            'graduateMajor': '专业介绍',
            'graduatePlan': '培养方案',
            'graduateRules': '规章制度',
            'tutorDirectory': '导师目录',

            // 科学研究
            'researchNews': '科研动态',
            'researchPapers': '科研论著',
            'researchTeam': '科研团队',
            'researchAchievement': '科研成果',

            // 党群园地
            'partyNews': '党建动态',
            'partyOrganization': '组织建设',
            'partyStudy': '学习园地',

            // 国际交流
            'internationalOverview': '国际交流概况',
            'internationalNews': '国际交流动态',
            'internationalRules': '相关规章制度',

            // 校友专栏
            'alumniStyle': '校友风采',
            'alumniNews': '校友动态',

            // 毕业设计
            'graduationNotice': '公告通知',
            'graduationTopics': '毕业选题',
            'graduationTemplates': '文档模板'
        };
        return types[type] || type;
    }

    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    // 修改提交新闻的函数
    function submitNews() {
        const form = document.getElementById('newsForm');
        const formData = new FormData(form);
        
        // 获取编辑器内容并设置到隐藏字段
        const content = editor.getHtml();
        document.getElementById('content').value = content;
        
        // 验证必填字段
        const title = document.getElementById('title').value;
        const newsType = document.getElementById('newsType').value;
        
        if (!title) {
            alert('请输入标题');
            return false;
        }
        
        if (!content || content === '<p><br></p>') {
            alert('请输入内容');
            return false;
        }
        
        // 判断是新闻还是编辑
        const editId = form.getAttribute('data-edit-id');
        const actionType = editId ? 'update' : 'add';
        
        // 如果是学院新闻，验证封面图片
        if (newsType === 'collegeNews') {
            const coverImage = document.getElementById('coverImage').files[0];
            if (!coverImage && !editId) { // 仅在新增时强制要求
                alert('学院新闻必须上传封面图片');
                return false;
            }
        }
        
        // 如果是编辑，添加ID到formData
        if (editId) {
            formData.append('id', editId);
        }
        formData.append('type', actionType);
        
        // 发送请求
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/news', true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    if (xhr.responseText === 'success') {
                        alert(editId ? '更新成功！' : '发布成功！');
                        closeNewsModal();
                        // 重新加载新闻列表
                        loadNewsList();
                    } else {
                        alert(editId ? '更新失败：' + xhr.responseText : '发布失败：' + xhr.responseText);
                    }
                } else {
                    alert(editId ? '更新失败' : '发布失败');
                }
            }
        };
        
        xhr.send(formData);
        return false;
    }

    // 修改编辑新闻的函数
    function editNews(id) {
        const modal = document.getElementById('newsModal');
        modal.style.display = 'block';
        
        modal.querySelector('.modal-header span:first-child').textContent = '编辑新闻';
        
        if (window.editor) {
            window.editor.destroy();
            window.editor = null;
        }
        
        editor = initEditor();
        
        // 获取新闻数据
        const formData = new FormData();
        formData.append('type', 'get');
        formData.append('id', id);
        
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/news', true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {

                const news = xhr.responseText.split('|');
                document.getElementById('title').value = news[0] || '';
                document.getElementById('newsType').value = news[1] || 'collegeNews';
                
                if (editor && news[2]) {
                    editor.setHtml(news[2]);
                }
                
                const isTop = document.getElementById('isTop');
                const topOrder = document.getElementById('topOrder');
                const topOrderGroup = document.getElementById('topOrderGroup');
                
                const isTopValue = news[3] === 'true';
                isTop.value = isTopValue ? 'true' : 'false';
                
                if (isTopValue) {
                    topOrderGroup.style.display = 'block';
                    topOrder.value = news[4] || '1';
                } else {
                    topOrderGroup.style.display = 'none';
                    topOrder.value = '0';
                }
                
                document.getElementById('viewPermission').value = news[6] || 'public';
                
                // 处理附件
                const attachmentsContainer = document.getElementById('attachments-container');
                attachmentsContainer.innerHTML = ''; // 清空现有附件
                
                // 如果有附件信息（在news[5]中）
                if (news[5] && news[5] !== 'null' && news[5] !== 'undefined') {
                         const attachments = news[5].split(';').filter(Boolean);
                    const attachmentsContainer = document.getElementById('attachments-container');
                    attachmentsContainer.innerHTML = ''; // 清空现有附件
                    
                    attachments.forEach(attachment => {
                        try {
                            const [attachmentId, fileName] = attachment.split(',');
                            const cleanId = attachmentId.trim().replace(/['"]/g, '');
                            const cleanName = fileName.trim().replace(/['"]/g, '');
                         
                            
                            if (!cleanId || !cleanName) {
                              
                                return;
                            }
                            
                            // 创建元素
                            const attachmentDiv = document.createElement('div');
                            attachmentDiv.className = 'attachment-group';
                            
                            // 创建文件名显示元素
                            const nameSpan = document.createElement('span');
                            nameSpan.textContent = cleanName;
                            nameSpan.style.flex = '1';
                            nameSpan.style.marginRight = '10px';
                            
                            // 创建隐藏的input
                            const hiddenInput = document.createElement('input');
                            hiddenInput.type = 'hidden';
                            hiddenInput.name = 'existingAttachments';
                            hiddenInput.value = cleanId;
                            
                            // 创建删除按钮
                            const deleteButton = document.createElement('button');
                            deleteButton.type = 'button';
                            deleteButton.className = 'remove-attachment';
                            deleteButton.textContent = '×';
                            deleteButton.onclick = function() { removeAttachment(this); };
                            
                            // 创建容器div
                            const containerDiv = document.createElement('div');
                            containerDiv.className = 'existing-attachment';
                            containerDiv.style.display = 'flex';
                            containerDiv.style.alignItems = 'center';
                            containerDiv.style.padding = '8px';
                            containerDiv.style.background = '#f8f9fa';
                            containerDiv.style.borderRadius = '4px';
                            containerDiv.style.marginBottom = '8px';
                            
                            // 组装元素
                            containerDiv.appendChild(nameSpan);
                            containerDiv.appendChild(hiddenInput);
                            containerDiv.appendChild(deleteButton);
                            attachmentDiv.appendChild(containerDiv);
                            
                            // 添��到容器中
                            attachmentsContainer.appendChild(attachmentDiv);
                            
                         
                            
                        } catch (e) {
                           
                        }
                    });
                }
                
                document.getElementById('newsForm').setAttribute('data-edit-id', id);
                toggleCoverImageField();
            }
        };
        
        xhr.send(formData);
    }

    // 修改增按钮点击事件处理
    document.getElementById('addButton').addEventListener('click', function() {
        const modal = document.getElementById('newsModal');
        modal.style.display = 'block';
        
        // 重置模态框标题
        modal.querySelector('.modal-header span:first-child').textContent = '新增新闻';
        
        // 清空表单编辑状态
        document.getElementById('newsForm').reset();
        document.getElementById('newsForm').removeAttribute('data-edit-id');
        
        // 确保编辑器已初始化
        if (!editor) {
            initEditor();
        } else {
            editor.setHtml('<p><br></p>');
        }
        
        // 初始化时调用一次 toggleCoverImage
        toggleCoverImage();
    });

    // 修改关闭模态框的函数
    function closeNewsModal() {
        const modal = document.getElementById('newsModal');
        modal.style.display = 'none';
        
        // 清空内容
        document.getElementById('title').value = '';
        document.getElementById('newsForm').reset();
        
        // 销毁编辑器实例
        if (editor) {
            editor.destroy();
            editor = null;
        }
        
        // 清除编辑状态
        document.getElementById('newsForm').removeAttribute('data-edit-id');
        document.getElementById('attachments-container').innerHTML = `
            <div class="attachment-group">
                <input type="file" name="attachments" class="form-control attachment-input">
                <button type="button" class="remove-attachment" onclick="removeAttachment(this)">&times;</button>
            </div>
        `;
    }

    // 修改 toggleCoverImage 函数
    function toggleCoverImage() {
        const newsType = document.getElementById('newsType').value;
        const coverImageGroup = document.getElementById('coverImageGroup');
        const coverImage = document.getElementById('coverImage');
        
        if (newsType === 'collegeNews') {
            if (coverImageGroup) {
                coverImageGroup.style.display = 'block';
            }
            if (coverImage) {
                coverImage.required = true;
            }
        } else {
            if (coverImageGroup) {
                coverImageGroup.style.display = 'none';
            }
            if (coverImage) {
                coverImage.required = false;
                coverImage.value = ''; // 清空已选择的文件
            }
        }
    }

    // 修改 filterNewsByType 函数
    function filterNewsByType(type) {
        // 发送 AJAX 请求获取选后的新闻列表
        const xhr = new XMLHttpRequest();
        xhr.open('POST', `${pageContext.request.contextPath}/news`, true);
        
        // 创建 FormData 对象
        const formData = new FormData();
        formData.append('type', 'list');
        formData.append('newsType', type);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // 更新新闻列表内容
                document.getElementById('content-main').innerHTML = xhr.responseText;
            }
        };
        
        xhr.send(formData);
    }

    // 修改 switchMenu 函数
    function switchMenu(element, page) {
        document.querySelectorAll('.menu-item').forEach(item => {
            item.classList.remove('active');
        });
        
        element.classList.add('active');
        
        document.getElementById('content-title').textContent = 
            page === 'news' ? '新闻管理' : '轮播图管理';
        
        const headerControls = document.querySelector('.header-controls');
        
        if (page === 'news') {
            headerControls.innerHTML = `
                <select id="newsTypeFilter" class="form-control" onchange="filterNewsByType(this.value)">
                   <option value="all">全部类型</option>
                        <optgroup label="主页">
                            <option value="collegeNews">学院新闻</option>
                            <option value="academicNotice">教务通知</option>
                            <option value="announcement">通知公告</option>
                            <option value="graduateTeaching">研究生教学</option>
                            <option value="academicLecture">学术讲座</option>
                            <option value="studentWork">学生工作</option>
                            <option value="recruitment">招聘信息</option>
                        </optgroup>
                        <optgroup label="学院概况">
                            <option value="collegeIntro">学院简介</option>
                            <option value="leadership">学院领导</option>
                            <option value="organization">组织机构</option>
                            <option value="office">学院办公室</option>
                            <option value="union">学院工会</option>
                        </optgroup>
                        <optgroup label="师资队伍">
                            <option value="facultyOverview">师资概况</option>
                            <option value="teacherDirectory">教师目录</option>
                            <option value="facultyRecruitment">人才引进</option>
                        </optgroup>
                        <optgroup label="本科教学">
                            <option value="undergraduateNotice">教务通知</option>
                            <option value="majorIntro">专业介绍</option>
                            <option value="cultivationPlan">培养方案</option>
                            <option value="courseSystem">课程设置</option>
                            <option value="teachingAchievement">教学成果</option>
                        </optgroup>
                        <optgroup label="研究生">
                            <option value="graduateAdmission">研究生招生</option>
                            <option value="graduateMajor">专业介绍</option>
                            <option value="graduatePlan">培养方案</option>
                            <option value="graduateRules">规章制度</option>
                            <option value="tutorDirectory">导师目录</option>
                        </optgroup>
                        <optgroup label="科学研究">
                            <option value="researchNews">科研动态</option>
                            <option value="researchPapers">科研论著</option>
                            <option value="researchTeam">科研团队</option>
                            <option value="researchAchievement">科研成果</option>
                        </optgroup>
                        <optgroup label="党群园地">
                            <option value="partyNews">党建动态</option>
                            <option value="partyOrganization">组织建设</option>
                            <option value="partyStudy">学习园地</option>
                        </optgroup>
                        <optgroup label="国际交流">
                            <option value="internationalOverview">国际交流概况</option>
                            <option value="internationalNews">国际交流动态</option>
                            <option value="internationalRules">相关规章制度</option>
                        </optgroup>
                        <optgroup label="校友专栏">
                            <option value="alumniStyle">校友风采</option>
                            <option value="alumniNews">校友动态</option>
                        </optgroup>
                        <optgroup label="毕业设计">
                            <option value="graduationNotice">公告通知</option>
                            <option value="graduationTopics">毕业选题</option>
                            <option value="graduationTemplates">文档模板</option>
                        </optgroup>
                </select>
                <button id="addButton" class="btn-primary">新增新闻</button>
            `;
            
            document.getElementById('addButton').addEventListener('click', function() {
                const modal = document.getElementById('newsModal');
                modal.style.display = 'block';
                toggleCoverImage();
                initEditor();
            });
            
            loadNewsList();
        } else if (page === 'carousel') {
            headerControls.innerHTML = `
                <button id="addButton" class="btn-primary" onclick="openCarouselModal()">
                    <i class="fas fa-plus"></i> 新增轮播图
                </button>
            `;
            loadContent('carouselManage.jsp');
        }
    }

    // 修改 loadContent 函数
    function loadContent(page) {
        const xhr = new XMLHttpRequest();
        const url = page === 'carouselManage.jsp' 
            ? '${pageContext.request.contextPath}/carousel?type=list'
            : '${pageContext.request.contextPath}/APMS/' + page;
        
        xhr.open('GET', url, true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    const contentMain = document.getElementById('content-main');
                    contentMain.innerHTML = xhr.responseText;
                }
            }
        };
        
        xhr.send();
    }

    // 确保这个函数可以被调用
    function openCarouselModal() {
        const modal = document.getElementById('carouselEditModal');
        if (modal) {
            modal.style.display = 'block';
        }
    }

    // 添加关闭模态框的函数
    function closeCarouselModal() {
        const modal = document.getElementById('carouselEditModal');
        if (modal) {
            modal.style.display = 'none';
            // 清空表单
            document.getElementById('carouselEditForm').reset();
        }
    }

    // 添加提交轮播图的函数
    function submitCarousel() {
        const form = document.getElementById('carouselEditForm');
        const formData = new FormData(form);
        const editId = form.getAttribute('data-edit-id');
        
        const title = document.getElementById('carouselTitle').value;
        const imageFile = document.getElementById('carouselImage').files[0];
        
        if (!title) {
            alert('请输入标题');
            return;
        }
        
        // 新增时必须选择图片，编辑时可选
        if (!editId && !imageFile) {
            alert('请选择图片');
            return;
        }
        
        formData.append('type', editId ? 'update' : 'add');
        if (editId) {
            formData.append('id', editId);
        }
        
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/carousel', true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    if (xhr.responseText === 'success') {
                        alert(editId ? '更新成功！' : '添加成功！');
                        closeCarouselModal();
                        loadContent('carouselManage.jsp');
                    } else {
                        alert(editId ? '更新失败：' + xhr.responseText : '添加失败：' + xhr.responseText);
                    }
                } else {
                    alert(editId ? '更新���败' : '添加失败');
                }
            }
        };
        
        xhr.send(formData);
    }

    // 添加确认删除轮播图的函数
    function confirmDeleteCarousel(id, event) {
        if (confirm('此操作不可逆，确定要删除这个轮播图吗？')) {
            const button = event.target.closest('.btn-delete');
            button.disabled = true;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 删除中...';
            
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/carousel?type=delete&id=' + id, true);
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === 'success') {
                            // 删除成功后重新加载轮播图列表
                            loadContent('carouselManage.jsp');
                        } else {
                            alert('删除失败：' + xhr.responseText);
                            button.disabled = false;
                            button.innerHTML = '<i class="fas fa-trash"></i> 删除';
                        }
                    } else {
                        alert('删除失败');
                        button.disabled = false;
                        button.innerHTML = '<i class="fas fa-trash"></i> 删除';
                    }
                }
            };
            
            xhr.send();
        }
    }

    // 添加编辑轮播图的函数
    function editCarousel(id) {
        const modal = document.getElementById('carouselEditModal');
        const modalTitle = document.getElementById('carouselModalTitle');
        const form = document.getElementById('carouselEditForm');
        const imageInput = document.getElementById('carouselImage');
        
        modalTitle.textContent = '编辑轮播图';
        form.reset();
        
        // 编辑时图片不是必填
        imageInput.required = false;
        
        // 加载轮播图数据
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/carousel?type=get&id=' + id, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const data = xhr.responseText.split('|');
                document.getElementById('carouselTitle').value = data[0];
                document.getElementById('carouselSortOrder').value = data[2];
                document.getElementById('carouselIsActive').value = data[3];
                form.setAttribute('data-edit-id', id);
            }
        };
        xhr.send();
        
        modal.style.display = 'block';
    }

    // 在loadContent函数后添加goToPage函数
    function goToPage(page) {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/news?type=list&page=' + page, true);
        
        const newsType = document.getElementById('newsTypeFilter').value;
        const formData = new FormData();
        formData.append('type', 'list');
        formData.append('page', page);
        if (newsType !== 'all') {
            formData.append('newsType', newsType);
        }
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    document.getElementById('content-main').innerHTML = xhr.responseText;
                } else {
                    alert('加载页面失败，请重试');
                }
            }
        };
        
        xhr.send(formData);
    }

    // 在loadContent函数后添加goToCarouselPage函数
    function goToCarouselPage(page) {
        if (page < 1) return;
        
        const xhr = new XMLHttpRequest();
        const baseUrl = '${pageContext.request.contextPath}/carousel';
        const url = baseUrl + '?type=list&page=' + page;
        
        xhr.open('GET', url, true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    const contentMain = document.getElementById('content-main');
                    if (contentMain) {
                        contentMain.innerHTML = xhr.responseText;
                    }
                } else {
                    alert('加载轮播图页面失败，请重试');
                }
            }
        };
        
        xhr.send();
    }

    // 添加附件上传字段
    function addAttachmentField() {
        const container = document.getElementById('attachments-container');
        const newGroup = document.createElement('div');
        newGroup.className = 'attachment-group';
        newGroup.innerHTML = `
            <input type="file" name="attachments" class="form-control attachment-input">
            <button type="button" class="remove-attachment" onclick="removeAttachment(this)">&times;</button>
        `;
        container.appendChild(newGroup);
    }

    // 删除附件上传字段
    function removeAttachment(button) {
        const attachmentGroup = button.closest('.attachment-group');
        const existingAttachment = attachmentGroup.querySelector('input[name="existingAttachments"]');
        
        if (existingAttachment) {
            // 如果是现有附件，添加到待删除列表
            const deletedAttachmentsInput = document.querySelector('input[name="deletedAttachments"]');
            if (!deletedAttachmentsInput) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'deletedAttachments';
                input.value = existingAttachment.value;
                document.getElementById('newsForm').appendChild(input);
            } else {
                deletedAttachmentsInput.value += ',' + existingAttachment.value;
            }
        }
        
        attachmentGroup.remove();
    }
    </script>

    <!-- 在admin.jsp中包含carouselEdit.jsp以确保模态框代码可用 -->
    <jsp:include page="carouselEdit.jsp" />
</body>
</html>