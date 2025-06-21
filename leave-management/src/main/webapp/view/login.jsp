<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Login - Leave Management</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="/css/style.css" />


        </head>

        <body class="login-body">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-6 login-container">
                        <h2 class="text-center mb-4">Login</h2>
                        <form:form modelAttribute="user" method="post" action="/login">
                            <div class="form-group mb-3">
                                <label for="username" class="form-label">Username:</label>
                                <form:input path="username" class="form-control" id="username" />
                            </div>
                            <div class="form-group mb-3">
                                <label for="password" class="form-label">Password:</label>
                                <form:input path="password" type="password" class="form-control" id="password" />
                            </div>
                            <button type="submit" class="btn btn-custom w-100">Login</button>
                            <p class="text-danger mt-3">${error}</p>
                        </form:form>
                        <a href="${pageContext.request.contextPath}/register" class="d-block text-center mt-3">Register
                            a new account</a>
                    </div>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>