<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Login · Leave Management</title>

                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">

                    <!-- Font Awesome for icons -->
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
                        rel="stylesheet">

                    <!-- Custom CSS -->
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/styles.css" />
                </head>

                <body>
                    <div class="auth-container fade-in">
                        <!-- Auth Header -->
                        <div class="auth-header">
                            <div class="auth-icon">
                                <i class="fa-solid fa-user-lock"></i>
                            </div>
                            <h1 class="auth-title">Welcome Back</h1>
                            <p class="auth-subtitle">Sign in to your account to continue</p>
                        </div>

                        <!-- Login Form -->
                        <form:form modelAttribute="user" method="post" action="${pageContext.request.contextPath}/login"
                            class="slide-up">
                            <div class="form-group">
                                <label for="username" class="form-label">
                                    <i class="fa-solid fa-user me-2"></i>Username
                                </label>
                                <form:input path="username" class="form-control" id="username"
                                    placeholder="Enter your username" />
                            </div>

                            <div class="form-group">
                                <label for="password" class="form-label">
                                    <i class="fa-solid fa-lock me-2"></i>Password
                                </label>
                                <form:input path="password" type="password" class="form-control" id="password"
                                    placeholder="Enter your password" />
                                <c:if test="${not empty loginError && fn:trim(loginError) != ''}">
                                    <div class="text-danger"
                                        style="margin-bottom: 1.5rem; font-size: 1.1em; background: rgba(231,76,59,0.1); border-radius: 10px; border: 1px solid rgba(231,76,59,0.2); padding: 0.75rem; text-align: center; font-weight: 600;">
                                        <i class="fa-solid fa-exclamation-triangle me-2"></i>
                                        <c:out value="${loginError}" />
                                    </div>
                                </c:if>
                            </div>

                            <!-- Submit Button -->
                            <button type="submit" class="btn-primary" id="loginBtn">
                                <i class="fa-solid fa-sign-in-alt me-2"></i>Sign In
                            </button>
                        </form:form>

                        <!-- Divider -->
                        <div class="text-center my-3">
                            <span class="text-muted">or</span>
                        </div>

                        <!-- Google Login -->
                        <a href="${pageContext.request.contextPath}/oauth2/google" class="btn-google">
                            <i class="fa-brands fa-google me-2"></i>Continue with Google
                        </a>

                        <!-- Register Link -->
                        <div class="text-center mt-3">
                            <p class="mb-0">
                                Don't have an account?
                                <a href="${pageContext.request.contextPath}/register" class="auth-link">
                                    <i class="fa-solid fa-user-plus me-1"></i>Register here
                                </a>
                            </p>
                        </div>
                    </div>

                    <!-- Bootstrap Bundle JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>