<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>500 - Internal Server Error</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="/css/style.css">
            <style>
                body {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .error-container {
                    background: white;
                    border-radius: 20px;
                    padding: 3rem;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                    text-align: center;
                    max-width: 500px;
                    width: 90%;
                }

                .error-icon {
                    font-size: 5rem;
                    color: #dc3545;
                    margin-bottom: 1rem;
                }

                .error-code {
                    font-size: 3rem;
                    font-weight: bold;
                    color: #333;
                    margin-bottom: 1rem;
                }

                .error-message {
                    color: #666;
                    margin-bottom: 2rem;
                    font-size: 1.1rem;
                }

                .btn-home {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    color: white;
                    padding: 0.75rem 2rem;
                    border-radius: 10px;
                    text-decoration: none;
                    font-weight: 600;
                    transition: all 0.3s ease;
                }

                .btn-home:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
                    color: white;
                }
            </style>
        </head>

        <body>
            <div class="error-container">
                <div class="error-icon">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                </div>
                <div class="error-code">500</div>
                <div class="error-message">
                    <c:if test="${not empty errorMessage}">
                        ${errorMessage}
                    </c:if>
                    <c:if test="${empty errorMessage}">
                        Internal server error. Please try again later.
                    </c:if>
                </div>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-home">
                    <i class="fa-solid fa-home me-2"></i>Back to Home
                </a>
            </div>
        </body>

        </html>