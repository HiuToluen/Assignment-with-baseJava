<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>403 - Access Denied · Leave Management</title>

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Font Awesome for icons -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error/styles.css" />
        </head>

        <body>
            <div class="error-container fade-in">
                <!-- Error Icon -->
                <div class="error-icon">
                    <i class="fa-solid fa-ban"></i>
                </div>

                <!-- Error Code -->
                <div class="error-code">403</div>

                <!-- Error Title -->
                <h1 class="error-title">Access Denied</h1>

                <!-- Error Message -->
                <div class="error-message">
                    <c:choose>
                        <c:when test="${errorMessage == 'You have not yet authenticated'}">
                            <p><i class="fa-solid fa-exclamation-triangle me-2"></i>You must log in to access this page.
                            </p>
                            <p class="small text-muted">Please authenticate with your credentials to continue.</p>
                        </c:when>
                        <c:when test="${errorMessage == 'You do not have permission to access this feature'}">
                            <p><i class="fa-solid fa-lock me-2"></i>You do not have permission to access this feature.
                            </p>
                            <p class="small text-muted">Contact your administrator if you believe this is an error.</p>
                        </c:when>
                        <c:otherwise>
                            <p><i class="fa-solid fa-shield-halved me-2"></i>Access to this resource is forbidden.</p>
                            <p class="small text-muted">You may not have the required permissions for this action.</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons slide-up">
                    <c:choose>
                        <c:when test="${empty sessionScope.currentUser}">
                            <a href="${pageContext.request.contextPath}/login" class="btn-primary">
                                <i class="fa-solid fa-sign-in-alt me-2"></i>Login
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/home" class="btn-home">
                                <i class="fa-solid fa-home me-2"></i>Go Home
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn-secondary">
                                <i class="fa-solid fa-sign-in-alt me-2"></i>Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Additional Help -->
                <div class="mt-4">
                    <p class="small text-muted">
                        <i class="fa-solid fa-info-circle me-1"></i>
                        Need help? Contact support at
                        <a href="mailto:support@company.com" class="text-decoration-none">support@company.com</a>
                    </p>
                </div>
            </div>

            <!-- Bootstrap Bundle JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Custom JavaScript -->
            <script>
                // Add loading animation to buttons
                document.querySelectorAll('.btn-primary, .btn-secondary, .btn-home').forEach(button => {
                    button.addEventListener('click', function (e) {
                        const originalText = this.innerHTML;
                        this.innerHTML = '<span class="loading-spinner me-2"></span>Loading...';
                        this.disabled = true;

                        // Reset after 3 seconds if navigation doesn't happen
                        setTimeout(() => {
                            this.innerHTML = originalText;
                            this.disabled = false;
                        }, 3000);
                    });
                });

                // Add some interactive effects
                document.addEventListener('DOMContentLoaded', function () {
                    const container = document.querySelector('.error-container');

                    // Add hover effect
                    container.addEventListener('mouseenter', function () {
                        this.style.transform = 'scale(1.02)';
                    });

                    container.addEventListener('mouseleave', function () {
                        this.style.transform = 'scale(1)';
                    });
                });
            </script>
        </body>

        </html>