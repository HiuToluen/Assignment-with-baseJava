<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Register - Leave Management</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="/css/style.css" />
            </head>

            <body class="login-body">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-6 login-container">
                            <h2 class="text-center mb-4">Register</h2>
                            <form:form modelAttribute="user" method="post" action="/register">
                                <div class="form-group mb-3">
                                    <c:set var="errorUsername">
                                        <form:errors path="username" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label for="username" class="form-label">Username:</label>
                                    <form:input path="username"
                                        class="form-control ${not empty errorUsername ? 'is-invalid' : ''}"
                                        id="username" />
                                    ${errorUsername}
                                </div>
                                <div class="form-group mb-3">
                                    <c:set var="errorPassword">
                                        <form:errors path="password" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label class="form-label">Password</label>
                                    <form:input type="password"
                                        class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                        path="password" />
                                    ${errorPassword}
                                </div>
                                <div class="form-group mb-3">
                                    <c:set var="errorFullName">
                                        <form:errors path="fullName" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label class="form-label">Full Name</label>
                                    <form:input type="text"
                                        class="form-control ${not empty errorFullName ? 'is-invalid' : ''}"
                                        path="fullName" />
                                    ${errorFullName}
                                </div>
                                <div class="form-group mb-3">
                                    <c:set var="errorEmail">
                                        <form:errors path="email" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label class="form-label">Email address</label>
                                    <form:input type="email"
                                        class="form-control ${not empty errorEmail ? 'is-invalid' : ''}" path="email" />
                                    ${errorEmail}
                                </div>
                                <div class="form-group mb-3">
                                    <label for="departmentId" class="form-label">Department:</label>
                                    <form:select path="departmentId" class="form-select" id="departmentId">
                                        <form:options items="${departments}" itemValue="departmentId"
                                            itemLabel="departmentName" />
                                    </form:select>
                                    <c:set var="errorDepartmentId">
                                        <form:errors path="departmentId" cssClass="invalid-feedback" />
                                    </c:set>
                                    ${errorDepartmentId}
                                </div>
                                <button type="submit" class="btn btn-custom w-100">Register</button>
                                <p class="text-danger mt-3">${error}</p>
                            </form:form>
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-custom">Back to
                                    Login</a>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>