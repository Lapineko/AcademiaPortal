<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/APMS/styles/carouselManage.css">
</head>
<div class="carousel-list-container">
    <table class="data-table">
        <thead>
            <tr>
                <th style="width: 60px">序号</th>
                <th>标题</th>
                <th style="width: 200px">预览图</th>
                <th style="width: 100px">排序</th>
                <th style="width: 100px">状态</th>
                <th style="width: 100px">发布者</th>
                <th style="width: 160px">操作</th>
            </tr>
        </thead>
        <tbody id="carouselListBody">
            <c:if test="${empty carouselList}">
                <tr>
                    <td colspan="7" class="text-center">暂无轮播图数据</td>
                </tr>
            </c:if>
            <c:forEach items="${carouselList}" var="carousel" varStatus="status">
                <tr>
                    <td>${startIndex + status.index}</td>
                    <td>${carousel.title}</td>
                    <td>
                        <img src="${pageContext.request.contextPath}/${carousel.imageUrl}" 
                             alt="${carousel.title}" 
                             style="max-width: 100px; max-height: 60px;">
                    </td>
                    <td>${carousel.sortOrder}</td>
                    <td>
                        <span class="${carousel.isActive ? 'status-active' : 'status-inactive'}">
                            ${carousel.isActive ? '启用' : '禁用'}
                        </span>
                    </td>
                    <td>${carousel.publisher}</td>
                    <td>
                        <div class="button-container">
                            <button class="btn-edit" onclick="editCarousel(${carousel.id})">
                                <i class="fas fa-edit"></i> 编辑
                            </button>
                            <button class="btn-delete" onclick="confirmDeleteCarousel(${carousel.id}, event)">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <!-- 添加分页控件 -->
    <div class="pagination">
        <span class="pagination-item ${currentPage == 1 ? 'disabled' : ''}" 
              onclick="goToCarouselPage(${currentPage - 1})">
            &lt;
        </span>
        
        <c:choose>
            <c:when test="${totalPages <= 7}">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                          onclick="goToCarouselPage(${i})">
                        ${i}
                    </span>
                </c:forEach>
            </c:when>
            
            <c:otherwise>
                <!-- 第一页 -->
                <span class="pagination-item ${currentPage == 1 ? 'active' : ''}" 
                      onclick="goToCarouselPage(1)">1</span>
                
                <!-- 当前页靠近开始位置 -->
                <c:if test="${currentPage <= 4}">
                    <c:forEach begin="2" end="5" var="i">
                        <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                              onclick="goToCarouselPage(${i})">${i}</span>
                    </c:forEach>
                    <span class="pagination-item disabled">...</span>
                </c:if>
                
                <!-- 当前页在中间位置 -->
                <c:if test="${currentPage > 4 && currentPage < totalPages - 3}">
                    <span class="pagination-item disabled">...</span>
                    <c:forEach begin="${currentPage - 2}" end="${currentPage + 2}" var="i">
                        <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                              onclick="goToCarouselPage(${i})">${i}</span>
                    </c:forEach>
                    <span class="pagination-item disabled">...</span>
                </c:if>
                
                <!-- 当前页靠近结束位置 -->
                <c:if test="${currentPage >= totalPages - 3}">
                    <span class="pagination-item disabled">...</span>
                    <c:forEach begin="${totalPages - 4}" end="${totalPages - 1}" var="i">
                        <span class="pagination-item ${currentPage == i ? 'active' : ''}" 
                              onclick="goToCarouselPage(${i})">${i}</span>
                    </c:forEach>
                </c:if>
                
                <!-- 最后一页 -->
                <span class="pagination-item ${currentPage == totalPages ? 'active' : ''}" 
                      onclick="goToCarouselPage(${totalPages})">${totalPages}</span>
            </c:otherwise>
        </c:choose>
        
        <span class="pagination-item ${currentPage == totalPages ? 'disabled' : ''}" 
              onclick="goToCarouselPage(${currentPage + 1})">
            &gt;
        </span>
    </div>
</div>

<!-- 轮播图编辑模态框 -->
<div id="carouselModal" class="modal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <span id="modalTitle">新增轮播图</span>
            <span class="close" onclick="closeCarouselModal()">×</span>
        </div>
        <div class="modal-body">
            <form id="carouselForm" method="post" enctype="multipart/form-data">
                <div class="form-item">
                    <label>标题</label>
                    <input type="text" id="title" name="title" required>
                </div>
                <div class="form-item">
                    <label>图片</label>
                    <input type="file" id="imageUrl" name="imageUrl" accept="image/*" required>
                </div>
                <div class="form-item">
                    <label>排序</label>
                    <input type="number" id="sortOrder" name="sortOrder" value="0" min="0">
                </div>
                <div class="form-item">
                    <label>状态</label>
                    <select id="isActive" name="isActive">
                        <option value="1">启用</option>
                        <option value="0">禁用</option>
                    </select>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button class="btn-cancel" onclick="closeCarouselModal()">取消</button>
            <button class="btn-submit" onclick="submitCarousel()">保存</button>
        </div>
    </div>
</div>

<script>
// 轮播图管理相关JavaScript代码
window.carouselManagement = {
    confirmDelete: function(id, event) {
        if (confirm('确定要删除这个轮播图吗？')) {
            const button = event.target.closest('.btn-delete');
            button.disabled = true;
            button.innerHTML = '删除中...';
            
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/carousel?type=delete&id=' + id, true);
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        if (xhr.responseText === 'success') {
                            loadCarouselList();
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
};

function editCarousel(id) {
    openCarouselModal(id);
}

function openCarouselModal(id = null) {
    const modal = document.getElementById('carouselEditModal');
    const modalTitle = document.getElementById('modalTitle');
    const form = document.getElementById('carouselForm');
    const imageInput = document.getElementById('imageUrl');
    
    modalTitle.textContent = id ? '编辑轮播图' : '新增轮播图';
    form.reset();
    
    // 编辑时图片不是必填
    imageInput.required = !id;
    
    if (id) {
        // 加载轮播图数据
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '${pageContext.request.contextPath}/carousel?type=get&id=' + id, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const data = xhr.responseText.split('|');
                document.getElementById('title').value = data[0];
                document.getElementById('sortOrder').value = data[2];
                document.getElementById('isActive').value = data[3];
                form.setAttribute('data-edit-id', id);
            }
        };
        xhr.send();
    } else {
        form.removeAttribute('data-edit-id');
    }
    
    modal.style.display = 'block';
}

function closeCarouselModal() {
    document.getElementById('carouselEditModal').style.display = 'none';
}

function submitCarousel() {
    const form = document.getElementById('carouselForm');
    const formData = new FormData(form);
    const editId = form.getAttribute('data-edit-id');
    
    if (!formData.get('title')) {
        alert('请输入标题');
        return;
    }
    
    if (!editId && !formData.get('imageUrl').size) {
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
                    loadCarouselList();
                    closeCarouselModal();
                } else {
                    alert(editId ? '更新失败：' + xhr.responseText : '添加失败：' + xhr.responseText);
                }
            } else {
                alert(editId ? '更新失败' : '添加失败');
            }
        }
    };
    
    xhr.send(formData);
}

// 添加分页跳转函数
function goToCarouselPage(page) {
    if (page < 1 || page > ${totalPages}) return;
    
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/carousel?type=list&page=' + page, true);
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            document.getElementById('content-main').innerHTML = xhr.responseText;
        }
    };
    
    xhr.send();
}
</script>

