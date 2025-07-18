<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Home · Leave Management</title>

                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome for icons -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home/styles.css" />
            </head>

            <body>
                <!-- Header với nút Logout đẹp -->
                <div class="d-flex justify-content-between align-items-center p-3"
                    style="background: #fff; border-bottom: 1px solid #e3e3e3;">
                    <div>
                        <span style="font-size:1.5rem;font-weight:600;color:#4e73df;"><i
                                class="fa-solid fa-plane-departure me-2"></i>Leave Management</span>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="me-3">Welcome, <b>${currentUser.fullName}</b></span>
                        <a href="#" class="btn btn-outline-danger btn-sm ms-2" data-bs-toggle="modal"
                            data-bs-target="#logoutModal">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
                        </a>
                    </div>
                </div>

                <!-- ======= Main Content ======= -->
                <div class="container main-container">
                    <!-- Welcome Section -->
                    <div class="welcome-section fade-in">
                        <div class="welcome-icon">
                            <i class="fa-solid fa-home"></i>
                        </div>
                        <h1 class="welcome-title">Welcome Back!</h1>
                        <p class="welcome-subtitle">Choose an action to get started with your leave management</p>
                    </div>

                    <!-- Features Grid -->
                    <div class="features-grid slide-up">
                        <c:forEach var="feature" items="${features}">
                            <c:if test="${!fn:contains(feature.entrypoint, '/detail')}">
                                <c:set var="entrypoint" value="${feature.entrypoint}" />
                                <c:choose>
                                    <c:when test="${entrypoint == '/request/create'}">
                                        <c:set var="entrypoint" value="/feature/request/create" />
                                    </c:when>
                                    <c:when test="${entrypoint == '/request/view-subordinates'}">
                                        <c:set var="entrypoint" value="/feature/request/view-subordinates" />
                                    </c:when>
                                    <c:when test="${entrypoint == '/agenda'}">
                                        <c:set var="entrypoint" value="/feature/agenda" />
                                    </c:when>
                                    <c:when test="${entrypoint == '/request/mylr'}">
                                        <c:set var="entrypoint" value="/feature/request/mylr" />
                                    </c:when>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}${entrypoint}" class="feature-card">
                                    <div class="feature-icon">
                                        <c:choose>
                                            <c:when test="${fn:contains(feature.featureName, 'Request')}">
                                                <i class="fa-solid fa-file-circle-plus"></i>
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'View')}">
                                                <i class="fa-solid fa-list-check"></i>
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Profile')}">
                                                <i class="fa-solid fa-user-circle"></i>
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Admin')}">
                                                <i class="fa-solid fa-shield-halved"></i>
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'User')}">
                                                <i class="fa-solid fa-users"></i>
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Feature')}">
                                                <i class="fa-solid fa-gear"></i>
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Permission')}">
                                                <i class="fa-solid fa-key"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fa-solid fa-arrow-right"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h3 class="feature-title">
                                        <c:out value="${feature.featureName}" />
                                    </h3>
                                    <p class="feature-description">
                                        <c:choose>
                                            <c:when test="${fn:contains(feature.featureName, 'Request')}">
                                                Submit a new leave request for approval
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'View')}">
                                                View and manage your existing leave requests
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Profile')}">
                                                Update your personal information and settings
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Admin')}">
                                                Access administrative functions and controls
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'User')}">
                                                Manage user accounts and permissions
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Feature')}">
                                                Configure system features and modules
                                            </c:when>
                                            <c:when test="${fn:contains(feature.featureName, 'Permission')}">
                                                Set up role-based access controls
                                            </c:when>
                                            <c:otherwise>
                                                Access this feature to manage your workflow
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>

                    <!-- Modal xác nhận logout -->
                    <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content" style="border-radius: 1rem;">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="logoutModalLabel">
                                        <i class="fa-solid fa-sign-out-alt me-2"></i>Confirm Logout
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body text-center">
                                    <p style="font-size:1.1em;">Are you sure you want to logout?</p>
                                </div>
                                <div class="modal-footer justify-content-center">
                                    <button type="button" class="btn btn-secondary px-4"
                                        data-bs-dismiss="modal">Cancel</button>
                                    <a href="${pageContext.request.contextPath}/logout"
                                        class="btn btn-danger px-4">Logout</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bootstrap Bundle JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                    <!-- Custom JavaScript for animations -->
                    <script>
                        // Add staggered animation to feature cards
                        document.addEventListener('DOMContentLoaded', function () {
                            const cards = document.querySelectorAll('.feature-card');
                            cards.forEach((card, index) => {
                                card.style.animationDelay = `${index * 0.1}s`;
                                card.classList.add('slide-up');
                            });
                        });
                    </script>
            </body>

            </html>