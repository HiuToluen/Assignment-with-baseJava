<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>404 Not Found</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error/styles.css" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        </head>

        <body>
            <div class="error-container">
                <div class="error-emoji">😢</div>
                <div class="error-code">404</div>
                <div class="error-title">Oops! The page you are looking for cannot be found.</div>
                <div class="error-desc">
                    It might have been moved or deleted, or you may not have permission.<br />
                    <c:if test="${not empty errorMessage}">
                        <span style="color:#888;font-size:0.98rem;">(${errorMessage})</span>
                    </c:if>
                </div>

                <!-- Check if user is logged in -->
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <!-- User is logged in - show Home button -->
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-home">
                            <i class="fas fa-home me-2"></i>Back to Home
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- User is not logged in - show Login button -->
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-login">
                            <i class="fas fa-sign-in-alt me-2"></i>Go to Login
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </body>

        </html>