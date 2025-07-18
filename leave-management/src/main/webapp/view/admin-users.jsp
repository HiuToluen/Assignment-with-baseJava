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
                        <!-- Nút logout -->
                        <a href="#" class="btn-logout" data-bs-toggle="modal" data-bs-target="#logoutModal">
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
                                            <c:when test="${empty userPage.content}">
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
                                                <c:forEach var="user" items="${userPage.content}" varStatus="loop">
                                                    <tr class="slide-up">
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
                                                            <c:set var="isDirector" value="false" />
                                                            <c:if test="${not empty user.userRoles}">
                                                                <c:forEach var="userRole" items="${user.userRoles}">
                                                                    <c:set var="currentRoleId"
                                                                        value="${userRole.role.roleId}" />
                                                                    <c:if test="${userRole.role.roleId == 4}">
                                                                        <c:set var="isDirector" value="true" />
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:if>
                                                            <c:choose>
                                                                <c:when test="${isDirector}">
                                                                    N/A
                                                                </c:when>
                                                                <c:when test="${managerNames[user.managerId] != null}">
                                                                    <c:out value="${managerNames[user.managerId]}" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:set var="foundDeptManager" value="false" />
                                                                    <c:forEach var="u" items="${userPage.content}">
                                                                        <c:if
                                                                            test="${u.departmentId == user.departmentId}">
                                                                            <c:forEach var="ur" items="${u.userRoles}">
                                                                                <c:if test="${ur.role.roleId == 3}">
                                                                                    <c:out value="${u.fullName}" />
                                                                                    <c:set var="foundDeptManager"
                                                                                        value="true" />
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <c:if test="${!foundDeptManager}">
                                                                        <c:set var="foundDirector" value="false" />
                                                                        <c:forEach var="u" items="${userPage.content}">
                                                                            <c:forEach var="ur" items="${u.userRoles}">
                                                                                <c:if test="${ur.role.roleId == 4}">
                                                                                    <c:out value="${u.fullName}" />
                                                                                    <c:set var="foundDirector"
                                                                                        value="true" />
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </c:forEach>
                                                                        <c:if test="${!foundDirector}">
                                                                            N/A
                                                                        </c:if>
                                                                    </c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="badge
                                                                <c:choose>
                                                                    <c:when test='${currentRoleId == 1}'>badge-employee</c:when>
                                                                    <c:when test='${currentRoleId == 2}'>badge-manager</c:when>
                                                                    <c:when test='${currentRoleId == 3}'>badge-dept-manager</c:when>
                                                                    <c:when test='${currentRoleId == 4}'>badge-director</c:when>
                                                                    <c:otherwise>badge-employee</c:otherwise>
                                                                </c:choose>'">
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
                                                            <a href="${pageContext.request.contextPath}/admin/users/update/${user.userId}"
                                                                class="btn btn-sm btn-primary mb-1">
                                                                <i class="fa-solid fa-pen-to-square me-1"></i> Edit
                                                            </a>
                                                            <c:if test="${!isDirector}">
                                                                <a href="${pageContext.request.contextPath}/admin/users/update-manager/${user.userId}"
                                                                    class="btn btn-sm btn-warning mb-1">
                                                                    <i class="fa-solid fa-user-tie me-1"></i> Manager
                                                                </a>
                                                            </c:if>
                                                            <a href="${pageContext.request.contextPath}/admin/users/delete/${user.userId}"
                                                                class="btn btn-sm btn-danger mb-1"
                                                                onclick="return confirm('Are you sure you want to delete this user?');">
                                                                <i class="fa-solid fa-trash me-1"></i> Delete
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Pagination Controls -->
                        <nav aria-label="User pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${userPage.totalPages > 1}">
                                    <li class="page-item ${userPage.first ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${userPage.number - 1}&size=${userPage.size}"
                                            tabindex="-1">Previous</a>
                                    </li>
                                    <c:forEach begin="0" end="${userPage.totalPages - 1}" var="i">
                                        <li class="page-item ${userPage.number == i ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&size=${userPage.size}">${i + 1}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${userPage.last ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="?page=${userPage.number + 1}&size=${userPage.size}">Next</a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>

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

            <!-- Modal xác nhận logout -->
            <div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content" style="border-radius: 1rem;">
                        <div class="modal-header">
                            <h5 class="modal-title" id="logoutModalLabel">
                                <i class="fa-solid fa-sign-out-alt me-2"></i>Confirm Logout
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body text-center">
                            <p style="font-size:1.1em;">Are you sure you want to logout?</p>
                        </div>
                        <div class="modal-footer justify-content-center">
                            <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger px-4">Logout</a>
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