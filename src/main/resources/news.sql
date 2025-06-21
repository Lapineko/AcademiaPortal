CREATE TABLE news (
                      id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '新闻ID',
                      title VARCHAR(200) NOT NULL COMMENT '新闻标题',
                      content TEXT NOT NULL COMMENT '新闻内容',
                      image_url VARCHAR(255) COMMENT '新闻图片URL',
                      view_count INT DEFAULT 0 COMMENT '浏览次数',
                      publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '发布日期',
                      INDEX idx_publish_date (publish_date) COMMENT '发布日期索引'
) ;