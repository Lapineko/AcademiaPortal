<%@ page contentType="text/html;charset=UTF-8" %>
<div id="carouselEditModal" class="modal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <span id="carouselModalTitle">新增轮播图</span>
            <span class="close" onclick="closeCarouselModal()">×</span>
        </div>
        <div class="modal-body">
            <form id="carouselEditForm" method="post" enctype="multipart/form-data">
                <div class="form-item">
                    <label>标题</label>
                    <label for="carouselTitle"></label><input type="text" id="carouselTitle" name="title" required>
                </div>
                <div class="form-item">
                    <label>图片</label>
                    <input type="file" id="carouselImage" name="imageUrl" accept="image/*" required>
                </div>
                <div class="form-item">
                    <label>排序</label>
                    <label for="carouselSortOrder"></label><input type="number" id="carouselSortOrder" name="sortOrder" value="0" min="0">
                </div>
                <div class="form-item">
                    <label>状态</label>
                    <label for="carouselIsActive"></label><select id="carouselIsActive" name="isActive">
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