# Module Leave Management System

## 📝 Giới thiệu / Introduction

**Tiếng Việt:**
Hệ thống Quản lý Nghỉ phép là một ứng dụng web giúp doanh nghiệp quản lý đơn xin nghỉ phép, phê duyệt, phân quyền và theo dõi lịch làm việc của nhân viên. Hệ thống hỗ trợ đăng nhập truyền thống và đăng nhập qua Google OAuth2.

**English:**
Leave Management System is a web application for managing leave requests, approvals, role-based permissions, and employee work schedules. The system supports both traditional login and Google OAuth2 login.

---

## 🚀 Tính năng chính / Main Features

- Đăng nhập/Đăng ký tài khoản, đăng nhập qua Google / Login/Register, Google OAuth2 login
- Quản lý đơn xin nghỉ phép (tạo, xem, duyệt, từ chối) / Leave request management (create, view, approve, reject)
- Quản lý lịch làm việc phòng ban / Department agenda overview
- Quản lý người dùng, phân quyền, vai trò (Admin) / User, role, and permission management (Admin)
- Phân quyền truy cập theo vai trò / Role-based access control
- Giao diện hiện đại, responsive / Modern, responsive UI
- Trang lỗi thân thiện (403, 404, 500) / Friendly error pages (403, 404, 500)

---

## 🛠️ Công nghệ sử dụng / Technologies Used

- Java 17, Spring Boot 3.x (Web, Data JPA, Validation)
- JSP, JSTL, Bootstrap 5, FontAwesome
- Microsoft SQL Server (JDBC)
- Google OAuth2 Client, BCrypt
- Maven (WAR packaging)

---

## 📁 Cấu trúc thư mục / Project Structure

```
leave-management/
├── src/main/java/com/hiutoluen/leave_management/
│   ├── controller/         # Controllers (Auth, Feature, Admin, ...)
│   ├── model/              # Entity models (User, Role, LeaveRequest, ...)
│   ├── repository/         # Spring Data JPA repositories
│   ├── service/            # Business logic services
│   └── config/             # Web configuration, interceptors
├── src/main/webapp/view/   # JSP views (login, register, home, admin, ...)
├── src/main/resources/static/css/ # CSS (auth, admin, feature, ...)
├── src/main/resources/application.properties # App & DB config
├── pom.xml                 # Maven dependencies
└── README.md               # Project documentation
```

---

## ⚙️ Hướng dẫn cài đặt & chạy / Setup & Run

### 1. Yêu cầu / Requirements

- Java 17+
- Maven 3.6+
- Microsoft SQL Server (hoặc chỉnh sửa cấu hình DB)

### 2. Cài đặt / Installation

```bash
# Clone project
$ git clone <repo-url>
$ cd leave-management

# Cấu hình database trong src/main/resources/application.properties
# Configure DB in src/main/resources/application.properties
# (Mặc định dùng SQL Server, user: sa, pass: sa, db: LeaveManagement)

# Build project
$ mvn clean package

# Chạy ứng dụng / Run the app
$ mvn spring-boot:run
# or
$ java -jar target/leave-management-*.war
```

### 3. Truy cập / Access

- Mặc định chạy tại: [http://localhost:8081](http://localhost:8081)

---

## 🔑 Đăng nhập Google OAuth2 / Google OAuth2 Login

- Để sử dụng đăng nhập Google, cấu hình các biến sau trong `application.properties`:
  ```
  google.oauth2.client-id=...
  google.oauth2.client-secret=...
  google.oauth2.redirect-uri=http://localhost:8081/oauth2/callback
  google.oauth2.auth-uri=https://accounts.google.com/o/oauth2/auth
  google.oauth2.token-uri=https://oauth2.googleapis.com/token
  google.oauth2.userinfo-uri=https://www.googleapis.com/oauth2/v3/userinfo
  ```
- Đăng ký ứng dụng Google Cloud, lấy client id/secret, thêm redirect URI.
- Người dùng có thể bấm "Continue with Google" trên trang đăng nhập.

---

## 🖼️ Giao diện / Screenshots

- Trang đăng nhập / Login page (username/password & Google)
- Trang đăng ký / Register page
- Trang chủ / Home (dashboard, feature grid)
- Quản lý đơn nghỉ phép / Leave request management
- Quản lý người dùng, vai trò, phân quyền (Admin) / Admin: user, role, permission management
- Trang lịch phòng ban / Department agenda
- Trang lỗi / Error pages (403, 404, 500)

> Xem thêm trong thư mục `src/main/webapp/view/` và `static/css/`.

---

## 📜 Bản quyền / License

- Project này dành cho mục đích học tập, nghiên cứu. Không sử dụng cho mục đích thương mại nếu chưa xin phép tác giả.
- This project is for educational and research purposes only. Do not use for commercial purposes without permission.
