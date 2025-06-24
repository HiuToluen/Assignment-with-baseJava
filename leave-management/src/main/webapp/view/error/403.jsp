<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>403 - Access Denied</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body>
            <div class="container mt-5">
                <div class="alert alert-danger text-center" role="alert">
                    <h1>403 - Access Denied</h1>
                    <c:choose>
                        <c:when test="${errorMessage == 'You have not yet authenticated'}">
                            <p>You must log in.</p>
                        </c:when>
                        <c:when test="${errorMessage == 'You do not have permission to access this feature'}">
                            <p>You do not have permission to access this page.</p>
                        </c:when>
                        <c:otherwise>
                            <p>Access denied.</p>
                        </c:otherwise>
                    </c:choose>
                    <a href="/login" class="btn btn-primary">Back to Login</a>
                </div>
            </div>
        </body>

        </html>