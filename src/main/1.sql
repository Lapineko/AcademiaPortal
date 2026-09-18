-- 新闻表
create table news
(
    id             bigint auto_increment
        primary key,
    title          varchar(255)                          not null,
    content        longtext                              not null,
    imageUrl       varchar(255)                          null,
    publishDate    timestamp   default CURRENT_TIMESTAMP not null,
    viewCount      int         default 0                 null,
    publisher      varchar(50) default 'admin'           not null,
    newsType       varchar(20) default 'collegeNews'     not null,
    isTop          tinyint(1)  default 0                 null comment '是否置顶：0-否，1-是',
    topOrder       int         default 0                 null comment '置顶排序，数字越大越靠前',
    viewPermission varchar(50) default 'public'          null
);

-- 新闻附件表
CREATE TABLE NewsAttachment
(
    id         BIGINT                              NOT NULL AUTO_INCREMENT,
    newsId     BIGINT                              NOT NULL,
    fileName   VARCHAR(255)                        NOT NULL,
    fileUrl    VARCHAR(500)                        NOT NULL,
    fileSize   BIGINT                              NOT NULL,
    fileType   VARCHAR(50),
    uploadTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id),
    KEY idx_newsId (newsId),
    FOREIGN KEY (newsId) REFERENCES News (id) ON DELETE CASCADE
);

-- 轮播图表
CREATE TABLE Carousel
(
    id         BIGINT                               NOT NULL AUTO_INCREMENT,
    title      VARCHAR(100)                         NOT NULL,
    imageUrl   VARCHAR(255)                         NOT NULL,
    sortOrder  INT        DEFAULT 0,
    isActive   TINYINT(1) DEFAULT 1,
    publisher  VARCHAR(50),
    createTime TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE news
    AUTO_INCREMENT = 1;
ALTER TABLE carousel
    AUTO_INCREMENT = 1;
ALTER TABLE NewsAttachment
    AUTO_INCREMENT = 1;
