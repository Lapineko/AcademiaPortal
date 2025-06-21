# AcademiaPortal 学术门户网站

## 项目简介 | Project Introduction

[English](#english-version) | [中文](#chinese-version)

---

<a name="english-version"></a>
## English Version

### AcademiaPortal

AcademiaPortal is a comprehensive web application designed for academic institutions to manage and publish news, information, and resources. It provides a platform for administrators to update carousels, manage news articles with attachments, and control user access through role-based authentication.

### Technology Stack

- **Backend**: Java EE (Servlet, JSP, JSTL)
- **Database**: MySQL
- **Frontend**: HTML, CSS, JavaScript
- **Build Tool**: Maven
- **Server**: Compatible with any servlet container (e.g., Tomcat)

### Features

- **User Authentication**: Secure login system with role-based access control
- **News Management**: Create, edit, delete, and publish news articles
- **File Attachments**: Upload and manage attachments for news articles
- **Carousel Management**: Dynamic carousel display for homepage
- **Responsive Design**: User-friendly interface for various devices

### Installation & Setup

1. Clone the repository:
   ```
   git clone https://github.com/Lapineko/AcademiaPortal.git
   ```

2. Configure your database settings in appropriate configuration files

3. Build the project using Maven:
   ```
   mvn clean install
   ```

4. Deploy the project:
   - Deploy the generated WAR file to your servlet container, or
   - Use the IDE's war_exploded deployment for development

5. Access the application through your browser:
   ```
   http://localhost:8080/AcademiaPortal
   ```
   or if using war_exploded in development:
   ```
   http://localhost:8080/AcademiaPortal_war_exploded
   ```

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<a name="chinese-version"></a>
## 中文版本

### 学术门户网站

学术门户网站是一个为学术机构设计的综合性网络应用程序，用于管理和发布新闻、信息和资源。它为管理员提供了更新轮播图、管理新闻文章及其附件、并通过基于角色的身份验证控制用户访问的平台。

### 技术栈

- **后端**: Java EE (Servlet, JSP, JSTL)
- **数据库**: MySQL
- **前端**: HTML, CSS, JavaScript
- **构建工具**: Maven
- **服务器**: 兼容任何servlet容器（如Tomcat）

### 功能特点

- **用户认证**: 安全的登录系统，基于角色的访问控制
- **新闻管理**: 创建、编辑、删除和发布新闻文章
- **文件附件**: 上传和管理新闻文章的附件
- **轮播图管理**: 主页上的动态轮播图显示
- **响应式设计**: 适用于各种设备的用户友好界面

### 安装与设置

1. 克隆仓库:
   ```
   git clone https://github.com/Lapineko/AcademiaPortal.git
   ```

2. 在相应的配置文件中配置数据库设置

3. 使用Maven构建项目:
   ```
   mvn clean install
   ```

4. 部署项目:
   - 将生成的WAR文件部署到你的servlet容器中，或者
   - 在开发环境中使用IDE的war_exploded部署方式

5. 通过浏览器访问应用程序:
   ```
   http://localhost:8080/AcademiaPortal
   ```
   或者使用war_exploded方式部署时:
   ```
   http://localhost:8080/AcademiaPortal_war_exploded
   ```

### 贡献指南

欢迎贡献！请随时提交 Pull Request。

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开一个 Pull Request

### 许可证

本项目使用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件。 