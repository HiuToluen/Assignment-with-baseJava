<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin - Manage Users · Leave Management</title>

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Font Awesome for icons -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/styles.css" />
        </head>

        <body>
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg">
                <div class="container">
                    <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-user-gear me-2"></i> Admin Panel
                    </a>
                    <div class="ms-auto">
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout"
                            onclick="return confirm('Are you sure you want to logout?')">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
                        </a>
                    </div>
                </div>
            </nav>

            <!-- Main Content -->
            <div class="container main-container">
                <div class="admin-card fade-in">
                    <!-- Header -->
                    <div class="admin-card-header">
                        <h2><i class="fa-solid fa-users me-2"></i>Manage Users</h2>
                    </div>

                    <!-- Body -->
                    <div class="admin-card-body">
                        <!-- Search Form -->
                        <form method="get" action="${pageContext.request.contextPath}/admin/users"
                            class="search-form slide-up">
                            <div class="row g-3">
                                <div class="col-md-2">
                                    <input type="text" name="username" class="form-control" placeholder="Username"
                                        value="${username}">
                                </div>
                                <div class="col-md-2">
                                    <input type="text" name="fullName" class="form-control" placeholder="Full Name"
                                        value="${fullName}">
                                </div>
                                <div class="col-md-2">
                                    <input type="text" name="email" class="form-control" placeholder="Email"
                                        value="${email}">
                                </div>
                                <div class="col-md-2">
                                    <select name="departmentId" class="form-select">
                                        <option value="">All Departments</option>
                                        <c:forEach var="dept" items="${departments}">
                                            <option value="${dept.departmentId}" ${departmentId==dept.departmentId
                                                ? 'selected' : '' }>
                                                ${dept.departmentName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select name="roleId" class="form-select">
                                        <option value="">All Roles</option>
                                        <option value="1" ${roleId==1 ? 'selected' : '' }>Employee</option>
                                        <option value="2" ${roleId==2 ? 'selected' : '' }>Manager</option>
                                        <option value="3" ${roleId==3 ? 'selected' : '' }>Department Manager</option>
                                        <option value="4" ${roleId==4 ? 'selected' : '' }>Director</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="search-btn w-100">
                                        <i class="fa-solid fa-search me-1"></i> Search
                                    </button>
                                </div>
                            </div>
                        </form>

                        <!-- Users Table -->
                        <div class="table-container">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><i class="fa-solid fa-id-badge me-1"></i>ID</th>
                                            <th><i class="fa-solid fa-user me-1"></i>Username</th>
                                            <th><i class="fa-solid fa-id-card me-1"></i>Full Name</th>
                                            <th><i class="fa-solid fa-envelope me-1"></i>Email</th>
                                            <th><i class="fa-solid fa-building me-1"></i>Department</th>
                                            <th><i class="fa-solid fa-user-tie me-1"></i>Manager</th>
                                            <th><i class="fa-solid fa-shield-halved me-1"></i>Role</th>
                                            <th><i class="fa-solid fa-cogs me-1"></i>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty users}">
                                                <tr>
                                                    <td colspan="8">
                                                        <div class="empty-state">
                                                            <i class="fa-solid fa-users-slash"></i>
                                                            <h3>No Users Found</h3>
                                                            <p>Try adjusting your search criteria</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="user" items="${users}" varStatus="loop">
                                                    <tr class="slide-up" style="animation-delay: ${loop.index * 0.1}s;">
                                                        <td>
                                                            <strong>
                                                                <c:out value="${user.userId}" />
                                                            </strong>
                                                        </td>
                                                        <td>
                                                            <c:out value="${user.username}" />
                                                        </td>
                                                        <td>
                                                            <c:out value="${user.fullName}" />
                                                        </td>
                                                        <td>
                                                            <c:out value="${user.email}" />
                                                        </td>
                                                        <td>
                                                            <c:forEach var="department" items="${departments}">
                                                                <c:if
                                                                    test="${user.departmentId == department.departmentId}">
                                                                    <c:out value="${department.departmentName}" />
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>
                                                        <td>
                                                            <c:set var="currentRoleId" value="0" />
                                                            <c:if test="${not empty user.userRoles}">
                                                                <c:forEach var="userRole" items="${user.userRoles}">
                                                                    <c:set var="currentRoleId"
                                                                        value="${userRole.role.roleId}" />
                                                                </c:forEach>
                                                            </c:if>
                                                            <c:choose>
                                                                <c:when
                                                                    test="${currentRoleId == 1 && user.managerId == null}">
                                                                    <c:set var="deptManagerId" value="0" />
                                                                    <c:forEach var="department" items="${departments}">
                                                                        <c:if
                                                                            test="${user.departmentId == department.departmentId}">
                                                                            <c:set var="deptManagerId"
                                                                                value="${department.idManager}" />
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <c:out
                                                                        value="${managerNames[deptManagerId] != null ? managerNames[deptManagerId] : 'N/A'}" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:out
                                                                        value="${managerNames[user.managerId] != null ? managerNames[user.managerId] : 'N/A'}" />
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:set var="currentRoleId" value="0" />
                                                            <c:if test="${not empty user.userRoles}">
                                                                <c:forEach var="userRole" items="${user.userRoles}">
                                                                    <c:set var="currentRoleId"
                                                                        value="${userRole.role.roleId}" />
                                                                </c:forEach>
                                                            </c:if>
                                                            <span class="badge
                                                                <c:choose>
                                                                    <c:when test='${currentRoleId == 1}'>badge-employee</c:when>
                                                                    <c:when test='${currentRoleId == 2}'>badge-manager</c:when>
                                                                    <c:when test='${currentRoleId == 3}'>badge-dept-manager</c:when>
                                                                    <c:when test='${currentRoleId == 4}'>badge-director</c:when>
                                                                    <c:otherwise>badge-employee</c:otherwise>
                                                                </c:choose>">
                                                                <c:choose>
                                                                    <c:when test="${currentRoleId == 1}">Employee
                                                                    </c:when>
                                                                    <c:when test="${currentRoleId == 2}">Manager
                                                                    </c:when>
                                                                    <c:when test="${currentRoleId == 3}">Dept Manager
                                                                    </c:when>
                                                                    <c:when test="${currentRoleId == 4}">Director
                                                                    </c:when>
                                                                    <c:otherwise>Unknown</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <a href="${pageContext.request.contextPath}/admin/users/update/${user.userId}"
                                                                    class="btn-update">
                                                                    <i class="fa-solid fa-pen-to-square"></i> Edit
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/users/delete/${user.userId}"
                                                                    class="btn-delete"
                                                                    onclick="return confirm('Are you sure you want to delete this user?')">
                                                                    <i class="fa-solid fa-trash"></i> Delete
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Footer Actions -->
                        <div class="footer-actions">
                            <a href="${pageContext.request.contextPath}/home" class="btn-home">
                                <i class="fa-solid fa-house me-2"></i>Back to Home
                            </a>
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/admin/features" class="btn-features">
                                    <i class="fa-solid fa-cogs me-2"></i>Manage Features
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/permissions" class="btn-permissions">
                                    <i class="fa-solid fa-key me-2"></i>Manage Permissions
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap Bundle JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <!-- Custom JavaScript -->
            <script>
                // Add loading animation to action buttons
                document.querySelectorAll('.btn-update, .btn-delete').forEach(button => {
                    button.addEventListener('click', function (e) {
                        const originalText = this.innerHTML;
                        this.innerHTML = '<span class="loading-spinner me-2"></span>Loading...';
                        this.disabled = true;

                        // Reset after 3 seconds if action doesn't happen
                        setTimeout(() => {
                            this.innerHTML = originalText;
                            this.disabled = false;
                        }, 3000);
                    });
                });

                // Add some interactive effects
                document.addEventListener('DOMContentLoaded', function () {
                    // Add hover effect to table rows
                    const tableRows = document.querySelectorAll('tbody tr');
                    tableRows.forEach(row => {
                        row.addEventListener('mouseenter', function () {
                            this.style.transform = 'scale(1.01)';
                        });

                        row.addEventListener('mouseleave', function () {
                            this.style.transform = 'scale(1)';
                        });
                    });

                    // Add focus effects to search inputs
                    const searchInputs = document.querySelectorAll('.search-form .form-control, .search-form .form-select');
                    searchInputs.forEach(input => {
                        input.addEventListener('focus', function () {
                            this.parentElement.style.transform = 'translateY(-2px)';
                        });

                        input.addEventListener('blur', function () {
                            this.parentElement.style.transform = 'translateY(0)';
                        });
                    });
                });
            </script>
        </body>

        </html>