<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Update Manager · Leave Management</title>

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Font Awesome for icons -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/styles.css" />
        </head>

        <body>
            <div class="auth-container update-form fade-in">
                <!-- Auth Header -->
                <div class="auth-header">
                    <div class="auth-icon">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <h1 class="auth-title">Update Manager</h1>
                    <p class="auth-subtitle">Assign a new manager for this user</p>
                </div>

                <!-- Update Manager Form -->
                <form id="managerForm" method="post"
                    action="${pageContext.request.contextPath}/admin/users/update-manager" class="slide-up">
                    <!-- User Info -->
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fa-solid fa-user me-2"></i>User
                        </label>
                        <input type="text" class="form-control" readonly value="${user.fullName} (${user.username})" />
                        <input type="hidden" name="userId" value="${user.userId}" />
                    </div>

                    <!-- Current Manager -->
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fa-solid fa-user-tie me-2"></i>Current Manager
                        </label>
                        <c:choose>
                            <c:when test="${not empty user.managerId}">
                                <c:set var="currentManagerName" value="Unknown" />
                                <c:forEach var="entry" items="${managerNames}">
                                    <c:if test="${entry.key == user.managerId}">
                                        <c:set var="currentManagerName" value="${entry.value}" />
                                    </c:if>
                                </c:forEach>
                                <input type="text" class="form-control" readonly value="${currentManagerName}" />
                            </c:when>
                            <c:otherwise>
                                <input type="text" class="form-control" readonly value="No manager assigned" />
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- New Manager -->
                    <div class="form-group">
                        <label for="managerId" class="form-label">
                            <i class="fa-solid fa-user-plus me-2"></i>New Manager
                        </label>
                        <select name="managerId" id="managerId" class="form-select" required>
                            <option value="">Select New Manager</option>
                            <c:forEach var="entry" items="${managerNames}">
                                <option value="${entry.key}" ${user.managerId==entry.key ? 'selected' : '' }>
                                    ${entry.value}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn-primary" id="updateBtn">
                        <i class="fa-solid fa-save me-2"></i>Update Manager
                    </button>
                </form>

                <!-- Back Button -->
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn-secondary">
                        <i class="fa-solid fa-arrow-left me-2"></i>Back to Users
                    </a>
                </div>
            </div>

            <!-- Bootstrap Bundle JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Custom JavaScript -->
            <script>
                // Add loading animation to update button
                document.addEventListener('DOMContentLoaded', function () {
                    const updateBtn = document.getElementById('updateBtn');
                    const form = document.getElementById('managerForm');

                    form.addEventListener('submit', function () {
                        // Show loading animation when form is actually submitting
                        const originalText = updateBtn.innerHTML;
                        updateBtn.innerHTML = '<span class="loading-spinner me-2"></span>Updating...';
                        updateBtn.disabled = true;

                        // Reset after 5 seconds if something goes wrong
                        setTimeout(() => {
                            updateBtn.innerHTML = originalText;
                            updateBtn.disabled = false;
                        }, 5000);
                    });

                    // Add some interactive effects
                    const container = document.querySelector('.auth-container');

                    // Add hover effect
                    container.addEventListener('mouseenter', function () {
                        this.style.transform = 'scale(1.02)';
                    });

                    container.addEventListener('mouseleave', function () {
                        this.style.transform = 'scale(1)';
                    });

                    // Add focus effects to form inputs
                    const inputs = document.querySelectorAll('.form-control, .form-select');
                    inputs.forEach(input => {
                        if (!input.readOnly) {
                            input.addEventListener('focus', function () {
                                this.parentElement.style.transform = 'translateX(5px)';
                            });

                            input.addEventListener('blur', function () {
                                this.parentElement.style.transform = 'translateX(0)';
                            });
                        }
                    });
                });
            </script>
        </body>

        </html>