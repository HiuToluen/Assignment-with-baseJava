<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Role Change Confirmation · Leave Management</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Font Awesome for icons -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
            <!-- Custom CSS (reuse auth styles for consistency) -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/styles.css" />
            <style>
                .confirm-container {
                    max-width: 480px;
                    margin: 60px auto;
                    background: #fff;
                    border-radius: 18px;
                    box-shadow: 0 4px 32px rgba(0, 0, 0, 0.10);
                    padding: 2.5rem 2rem 2rem 2rem;
                    text-align: center;
                    animation: fadeIn 0.7s;
                }

                .confirm-icon {
                    font-size: 3.5rem;
                    color: #dc3545;
                    margin-bottom: 1rem;
                }

                .confirm-title {
                    font-size: 2rem;
                    font-weight: 700;
                    margin-bottom: 0.5rem;
                }

                .confirm-message {
                    font-size: 1.1rem;
                    color: #333;
                    margin-bottom: 2rem;
                }

                .btn-confirm {
                    background: #dc3545;
                    color: #fff;
                    font-weight: 600;
                    border-radius: 6px;
                    padding: 0.6rem 1.5rem;
                    margin-right: 0.7rem;
                    border: none;
                }

                .btn-confirm:hover {
                    background: #b52a37;
                }

                .btn-cancel {
                    background: #e3e6f0;
                    color: #333;
                    font-weight: 500;
                    border-radius: 6px;
                    padding: 0.6rem 1.5rem;
                    border: none;
                }

                .btn-cancel:hover {
                    background: #cfd2da;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            </style>
        </head>

        <body style="background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 50%, #fbc2eb 100%); min-height: 100vh;">
            <div class="confirm-container">
                <div class="confirm-icon">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div class="confirm-title">Role Change Confirmation</div>
                <div class="confirm-message">${confirmMessage}</div>
                <form method="post" action="${pageContext.request.contextPath}/admin/users/update">
                    <input type="hidden" name="userId" value="${user.userId}" />
                    <input type="hidden" name="username" value="${user.username}" />
                    <input type="hidden" name="fullName" value="${user.fullName}" />
                    <input type="hidden" name="email" value="${user.email}" />
                    <input type="hidden" name="departmentId" value="${user.departmentId}" />
                    <input type="hidden" name="managerId" value="${user.managerId}" />
                    <input type="hidden" name="roleId" value="${roleId}" />
                    <input type="hidden" name="newPassword" value="${newPassword}" />
                    <input type="hidden" name="confirm" value="true" />
                    <button type="submit" class="btn btn-confirm"><i class="fa-solid fa-check me-2"></i>Yes,
                        replace</button>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-cancel"><i
                            class="fa-solid fa-xmark me-2"></i>Cancel</a>
                </form>
            </div>
        </body>

        </html>