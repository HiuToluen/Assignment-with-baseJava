<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Register · Leave Management</title>

                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome for icons -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/styles.css" />
            </head>

            <body>
                <div class="auth-container fade-in">
                    <!-- Auth Header -->
                    <div class="auth-header">
                        <div class="auth-icon">
                            <i class="fa-solid fa-user-plus"></i>
                        </div>
                        <h1 class="auth-title">Create Account</h1>
                        <p class="auth-subtitle">Join our leave management system</p>
                    </div>

                    <!-- Register Form -->
                    <form:form modelAttribute="user" method="post" action="${pageContext.request.contextPath}/register"
                        class="slide-up">
                        <div class="form-group">
                            <c:set var="errorUsername">
                                <form:errors path="username" cssClass="invalid-feedback" />
                            </c:set>
                            <label for="username" class="form-label">
                                <i class="fa-solid fa-user me-2"></i>Username
                            </label>
                            <form:input path="username"
                                class="form-control ${not empty errorUsername ? 'is-invalid' : ''}" id="username"
                                placeholder="Choose a username" />
                            ${errorUsername}
                        </div>

                        <div class="form-group">
                            <c:set var="errorPassword">
                                <form:errors path="password" cssClass="invalid-feedback" />
                            </c:set>
                            <label for="password" class="form-label">
                                <i class="fa-solid fa-lock me-2"></i>Password
                            </label>
                            <form:input type="password"
                                class="form-control ${not empty errorPassword ? 'is-invalid' : ''}" path="password"
                                id="password" placeholder="Create a strong password" />
                            ${errorPassword}
                        </div>

                        <div class="form-group">
                            <c:set var="errorFullName">
                                <form:errors path="fullName" cssClass="invalid-feedback" />
                            </c:set>
                            <label for="fullName" class="form-label">
                                <i class="fa-solid fa-id-card me-2"></i>Full Name
                            </label>
                            <form:input type="text" class="form-control ${not empty errorFullName ? 'is-invalid' : ''}"
                                path="fullName" id="fullName" placeholder="Enter your full name" />
                            ${errorFullName}
                        </div>

                        <div class="form-group">
                            <c:set var="errorEmail">
                                <form:errors path="email" cssClass="invalid-feedback" />
                            </c:set>
                            <label for="email" class="form-label">
                                <i class="fa-solid fa-envelope me-2"></i>Email Address
                            </label>
                            <form:input type="email" class="form-control ${not empty errorEmail ? 'is-invalid' : ''}"
                                path="email" id="email" placeholder="Enter your email address" />
                            ${errorEmail}
                        </div>

                        <div class="form-group">
                            <label for="departmentId" class="form-label">
                                <i class="fa-solid fa-building me-2"></i>Department
                            </label>
                            <form:select path="departmentId" class="form-select" id="departmentId">
                                <form:options items="${departments}" itemValue="departmentId"
                                    itemLabel="departmentName" />
                            </form:select>
                            <c:set var="errorDepartmentId">
                                <form:errors path="departmentId" cssClass="invalid-feedback" />
                            </c:set>
                            ${errorDepartmentId}
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="text-danger">
                                <i class="fa-solid fa-exclamation-triangle me-2"></i>
                                <c:out value="${error}" />
                            </div>
                        </c:if>

                        <!-- Submit Button -->
                        <button type="submit" class="btn-primary" id="registerBtn">
                            <i class="fa-solid fa-user-plus me-2"></i>Create Account
                        </button>
                    </form:form>

                    <!-- Back to Login -->
                    <div class="text-center mt-3">
                        <p class="mb-0">
                            Already have an account?
                            <a href="${pageContext.request.contextPath}/login" class="auth-link">
                                <i class="fa-solid fa-sign-in-alt me-1"></i>Sign in here
                            </a>
                        </p>
                    </div>
                </div>

                <!-- Bootstrap Bundle JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>