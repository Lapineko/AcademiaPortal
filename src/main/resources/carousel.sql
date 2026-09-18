CREATE TABLE Carousel (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    title      VARCHAR(100)                         NOT NULL,
    imageUrl   VARCHAR(255)                         NOT NULL,
    sortOrder  INT        DEFAULT 0                 NULL,
    isActive   TINYINT(1) DEFAULT 1                 NULL,
    publisher  VARCHAR(50)                          NOT NULL,
    createTime TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL
); 