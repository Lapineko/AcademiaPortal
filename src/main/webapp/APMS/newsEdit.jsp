<%@ page contentType="text/html;charset=UTF-8" %>
<div class="edit-container">
    <form id="newsForm" method="post" action="${pageContext.request.contextPath}/news?type=add" enctype="multipart/form-data">
        <div class="form-group">
            <label for="title">标题：</label>
            <input type="text" id="title" name="title" class="form-control" required>
        </div>
        
        <div class="form-group">
            <label for="newsType">类型：</label>
            <select id="newsType" name="newsType" class="form-control" required onchange="toggleCoverImageField()">
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
        </div>
        
        <div class="form-group" id="coverImageGroup">
            <label for="coverImage">封面图片：</label>
            <input type="file" id="coverImage" name="coverImage" class="form-control" accept="image/*">
        </div>
        
        <div class="form-group">
            <label>附件：</label>
            <div id="attachments-container">
                <div class="attachment-group">
                    <input type="file" name="attachments" class="form-control attachment-input">
                    <button type="button" class="remove-attachment" onclick="removeAttachment(this)">×</button>
                </div>
            </div>
            <button type="button" class="btn btn-secondary" onclick="addAttachmentField()">添加附件</button>
        </div>
        
        <div class="form-group">
            <label for="isTop">是否置顶：</label>
            <select id="isTop" name="isTop" class="form-control">
                <option value="false">否</option>
                <option value="true">是</option>
            </select>
        </div>

        <div class="form-group" id="topOrderGroup" style="display: none;">
            <label for="topOrder">置顶排序：</label>
            <input type="number" id="topOrder" name="topOrder" class="form-control" min="1" max="10" value="1">
            <div>
                <small class="form-text" style="color: red; margin-top: 5px;">请选择1-10之间的数字，数字越大越靠前</small>
            </div>
        </div>
        
        <div class="form-group">
            <label for="viewPermission">查看权限：</label>
            <select id="viewPermission" name="viewPermission" class="form-control">
                <option value="public">公开</option>
                <option value="allStudents">全部学生</option>
                <option value="undergraduate">本科生</option>
                <option value="graduate">研究生</option>
                <option value="teacher">教师</option>
            </select>
        </div>
        
        <input type="hidden" name="content" id="content" />
        
        <div class="page-container">
            <div class="page-right">
                <div style="border: 1px solid #ccc; width: 100%">
                    <div id="editor-toolbar" style="border-bottom: 1px solid #ccc;"></div>
                    <div id="editor-text-area" style="height: 400px;"></div>
                </div>
            </div>
        </div>
        
        <div class="btn-group">
            <button type="submit" class="btn btn-primary" onclick="return submitNews(event)">
                <i class="fas fa-save"></i> 发布
            </button>
            <button type="button" class="btn btn-secondary" onclick="closeNewsModal()">
                <i class="fas fa-times"></i> 取消
            </button>
        </div>
    </form>
</div>

<script>
    const E = window.wangEditor;
    const LANG = 'zh-CN';
    E.i18nChangeLanguage(LANG);

    window.editor = null;

    function initEditor() {
        if (window.editor) {
            window.editor.destroy();
            window.editor = null;
        }
        
        window.editor = E.createEditor({
            selector: '#editor-text-area',
            html: '<p><br></p>',
            config: {
                placeholder: '请输入新闻内容...',
                MENU_CONF: {
                    uploadImage: {
                        server: '${pageContext.request.contextPath}/upload',
                        fieldName: 'upload',
                        maxFileSize: 10 * 1024 * 1024
                    }
                },
                onChange(editor) {
                    document.getElementById('content').value = editor.getHtml();
                }
            }
        });

        window.toolbar = E.createToolbar({
            editor: window.editor,
            selector: '#editor-toolbar',
            config: {}
        });

        return window.editor;
    }

    function toggleCoverImageField() {
        const newsType = document.getElementById('newsType').value;
        const coverImageGroup = document.getElementById('coverImageGroup');
        const coverImage = document.getElementById('coverImage');
        
        if (newsType === 'collegeNews') {
            coverImageGroup.style.display = 'block';
            coverImage.required = true;
        } else {
            coverImageGroup.style.display = 'none';
            coverImage.required = false;
            coverImage.value = ''; // 清空已选择的文件
        }
    }

    function initTopOrderHandling() {
        const isTop = document.getElementById('isTop');
        const topOrderGroup = document.getElementById('topOrderGroup');
        const topOrder = document.getElementById('topOrder');

        // 重置状态为不置顶
        topOrderGroup.style.display = 'none';
        isTop.value = 'false';
        topOrder.value = '0';
    }

    // 在页面加载时添加事件监听器（只添加一次）
    document.addEventListener('DOMContentLoaded', function() {
        initEditor();
        toggleCoverImageField();
        initTopOrderHandling();
        
        // 为置顶选择添加事件监听器
        document.getElementById('isTop').addEventListener('change', function() {
            const topOrderGroup = document.getElementById('topOrderGroup');
            const topOrder = document.getElementById('topOrder');
            
            if (this.value === 'true') {
                topOrderGroup.style.display = 'block';
                topOrder.value = '1';
                topOrder.min = '1';
                topOrder.max = '10';
            } else {
                topOrderGroup.style.display = 'none';
                topOrder.value = '0';
            }
        });
        
        // 为排序输入框添加事件监听器
        document.getElementById('topOrder').addEventListener('input', function() {
            let value = parseInt(this.value);
            if (isNaN(value) || value < 1) {
                this.value = '1';
            } else if (value > 10) {
                this.value = '10';
            }
        });
    });

    function addAttachmentField() {
        const container = document.getElementById('attachments-container');
        const newGroup = document.createElement('div');
        newGroup.className = 'attachment-group';
        newGroup.innerHTML = `
            <input type="file" name="attachments" class="form-control attachment-input">
            <button type="button" class="remove-attachment" onclick="removeAttachment(this)">×</button>
        `;
        container.appendChild(newGroup);
    }

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

    function submitNews(event) {
        event.preventDefault();
        
        const content = document.getElementById('content').value;
        if (!content) {
            alert('请输入内容');
            return false;
        }
        
        const newsType = document.getElementById('newsType').value;
        const coverImage = document.getElementById('coverImage');
        
        if (newsType === 'collegeNews' && !coverImage.files[0]) {
            alert('请选择封面图片');
            return false;
        }
        
        // 获取表单数据
        const form = document.getElementById('newsForm');
        const formData = new FormData(form);
        
        // 添加置顶相关信息
        const isTop = document.getElementById('isTop').value === 'true';
        const topOrder = isTop ? parseInt(document.getElementById('topOrder').value) : 0;
        
        formData.append('isTop', isTop);
        formData.append('topOrder', topOrder);
        
        // 判断是新增还是编辑
        const editId = form.getAttribute('data-edit-id');
        const actionType = editId ? 'update' : 'add';
        formData.append('type', actionType);
        
        if (editId) {
            formData.append('id', editId);
        }
        
        // 使用 AJAX 提交表单
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '${pageContext.request.contextPath}/news', true);
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200 && xhr.responseText === 'success') {
                    alert(editId ? '更新成功！' : '发布成功！');
                    
                    // 重要：先销毁编辑器
                    if (window.editor) {
                        window.editor.destroy();
                        window.editor = null;
                    }
                    
                    // 关闭模态框并重置表单
                    closeNewsModal();
                    
                    // 重新加载新闻列表
                    if (typeof loadNewsList === 'function') {
                        loadNewsList();
                    }
                    
                    // 重新初始化编辑器
                    setTimeout(() => {
                        initEditor();
                    }, 100);
                } else {
                    alert('操作失败，请重试');
                }
            }
        };
        
        xhr.send(formData);
        return false;
    }

    function editNews(id) {
        const modal = document.getElementById('newsModal');
        modal.style.display = 'block';
        
        modal.querySelector('.modal-header span:first-child').textContent = '编辑新闻';
        
        if (window.editor) {
            window.editor.destroy();
            window.editor = null;
        }
        
        initEditor();
        
        setTimeout(() => {
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
                    
                    if (window.editor && news[2]) {
                        window.editor.setHtml(news[2]);
                    }
                    
                    // 设置置顶状态
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
                        attachments.forEach(attachment => {
                            const [attachmentId, fileName] = attachment.split(',').map(item => item.trim());
                            if (!attachmentId || !fileName) return;
                            
                            const attachmentGroup = document.createElement('div');
                            attachmentGroup.className = 'attachment-group';
                            attachmentGroup.innerHTML = `
                                <div class="existing-attachment">
                                    <span>${fileName}</span>
                                    <input type="hidden" name="existingAttachments" value="${attachmentId}">
                                    <button type="button" class="remove-attachment" onclick="removeAttachment(this)">×</button>
                                </div>
                            `;
                            attachmentsContainer.appendChild(attachmentGroup);
                        });
                    }
                    
                    // 添加新的附件输入框
                    const newAttachmentGroup = document.createElement('div');
                    newAttachmentGroup.className = 'attachment-group';
                    newAttachmentGroup.innerHTML = `
                        <input type="file" name="attachments" class="form-control attachment-input">
                        <button type="button" class="remove-attachment" onclick="removeAttachment(this)">×</button>
                    `;
                    attachmentsContainer.appendChild(newAttachmentGroup);
                    
                    document.getElementById('newsForm').setAttribute('data-edit-id', id);
                    toggleCoverImageField();
                }
            };
            
            xhr.send(formData);
        }, 100);
    }

    function closeNewsModal() {
        const modal = document.getElementById('newsModal');
        modal.style.display = 'none';
        
        // 重置表单
        const form = document.getElementById('newsForm');
        form.reset();
        
        // 重置所有字段到初始状态
        document.getElementById('title').value = '';
        
        // 重置置顶相关字段
        initTopOrderHandling();
        
        // 重要：确保编辑器被正确重置
        if (window.editor) {
            window.editor.destroy();
            window.editor = null;
            setTimeout(() => {
                initEditor();
            }, 100);
        }
        
        form.removeAttribute('data-edit-id');
        
        // 重置附件区域
        document.getElementById('attachments-container').innerHTML = `
            <div class="attachment-group">
                <input type="file" name="attachments" class="form-control attachment-input">
                <button type="button" class="remove-attachment" onclick="removeAttachment(this)">×</button>
            </div>
        `;
    }
</script> 