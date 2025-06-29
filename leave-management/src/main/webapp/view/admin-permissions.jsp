<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Permission Management - Admin Panel</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="/css/style.css">
            <link rel="stylesheet" href="/css/admin/styles.css">
        </head>

        <body class="admin-container">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark admin-navbar mb-4">
                <div class="container">
                    <a class="navbar-brand d-flex align-items-center"
                        href="${pageContext.request.contextPath}/admin/users">
                        <i class="fa-solid fa-key me-2"></i> Permission Management
                    </a>
                    <div class="ms-auto">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-light me-2">
                            <i class="fa-solid fa-users me-1"></i> Users
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/features" class="btn btn-outline-light me-2">
                            <i class="fa-solid fa-cogs me-1"></i> Features
                        </a>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light"
                            onclick="return confirm('Are you sure?')">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
                        </a>
                    </div>
                </div>
            </nav>

            <div class="container">
                <!-- Stats Row -->
                <div class="row mb-4 fade-in">
                    <div class="col-md-3">
                        <div class="card stats-card admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-users fa-2x mb-2"></i>
                                <h4 class="mb-0">${roles.size()}</h4>
                                <p class="mb-0">Total Roles</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-list-check fa-2x mb-2"></i>
                                <h4 class="mb-0">${features.size()}</h4>
                                <p class="mb-0">Total Features</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-link fa-2x mb-2"></i>
                                <h4 class="mb-0">${roleFeatures.size()}</h4>
                                <p class="mb-0">Active Permissions</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-dark admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-plus-circle fa-2x mb-2"></i>
                                <h4 class="mb-0">Assign</h4>
                                <p class="mb-0">New Permission</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Assign Permission Form -->
                    <div class="col-lg-4 mb-4 slide-in-left">
                        <div class="card form-card admin-card">
                            <div class="card-header bg-transparent border-0">
                                <h5 class="mb-0">
                                    <i class="fa-solid fa-plus-circle me-2"></i>Assign Permission
                                </h5>
                            </div>
                            <div class="card-body">
                                <form action="/admin/permissions/assign" method="post">
                                    <div class="mb-3">
                                        <label for="roleId" class="form-label">Role</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa-solid fa-user-tag"></i>
                                            </span>
                                            <select class="form-control" id="roleId" name="roleId" required>
                                                <option value="">Select Role</option>
                                                <c:forEach var="role" items="${roles}">
                                                    <option value="${role.roleId}">${role.roleName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="featureId" class="form-label">Feature</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa-solid fa-cog"></i>
                                            </span>
                                            <select class="form-control" id="featureId" name="featureId" required>
                                                <option value="">Select Feature</option>
                                                <c:forEach var="feature" items="${features}">
                                                    <option value="${feature.featureId}">${feature.featureName}
                                                        (${feature.entrypoint})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-light w-100">
                                        <i class="fa-solid fa-plus me-1"></i>Assign Permission
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Current Permissions -->
                    <div class="col-lg-8 slide-in-right">
                        <div class="card admin-card">
                            <div class="card-header bg-transparent border-0">
                                <h5 class="mb-0">
                                    <i class="fa-solid fa-list me-2"></i>Current Permissions
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover"
                                        style="color:#333;background:white;--bs-table-color:#333;--bs-table-bg:white;">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-user-tag me-1"></i>Role</th>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-cog me-1"></i>Feature</th>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-link me-1"></i>Entrypoint</th>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-cogs me-1"></i>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="roleFeature" items="${roleFeatures}">
                                                <tr class="feature-card">
                                                    <td style="color:#333;background:white;">
                                                        <span class="badge bg-primary"
                                                            style="color:#fff;">${roleFeature.role.roleName}</span>
                                                    </td>
                                                    <td style="color:#333;background:white;">
                                                        <strong
                                                            style="color:#333;">${roleFeature.feature.featureName}</strong>
                                                    </td>
                                                    <td style="color:#333;background:white;">
                                                        <code
                                                            style="color:#007bff;background:white;">${roleFeature.feature.entrypoint}</code>
                                                    </td>
                                                    <td style="color:#333;background:white;">
                                                        <a href="/admin/permissions/revoke?roleId=${roleFeature.role.roleId}&featureId=${roleFeature.feature.featureId}"
                                                            class="btn btn-danger btn-sm admin-btn"
                                                            onclick="return confirm('Are you sure you want to revoke this permission?')">
                                                            <i class="fa-solid fa-times me-1"></i>Revoke
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${empty roleFeatures}">
                                    <div class="empty-state">
                                        <i class="fa-solid fa-key fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No permissions found</h5>
                                        <p class="text-muted">Start by assigning permissions using the form on the left.
                                        </p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Permission Matrix -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card permission-matrix admin-card">
                            <div class="card-header"
                                style="background: linear-gradient(90deg, #4e73df 0%, #36b9cc 100%); color: #fff;">
                                <h5 class="mb-0">
                                    <i class="fa-solid fa-table me-2"></i>Permission Matrix
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-bordered mb-0" style="background: #f8fafd;">
                                        <thead
                                            style="background: linear-gradient(90deg, #6ea8fe 0%, #a7c7e7 100%); color: #222;">
                                            <tr>
                                                <th class="text-center">Role</th>
                                                <c:forEach var="feature" items="${features}">
                                                    <th class="text-center">${feature.featureName}</th>
                                                </c:forEach>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="role" items="${roles}">
                                                <tr>
                                                    <td class="fw-bold text-center"
                                                        style="background: #eaf1fb; color: #222;">${role.roleName}</td>
                                                    <c:forEach var="feature" items="${features}">
                                                        <td class="text-center" style="background: #fff;">
                                                            <c:set var="hasPermission" value="false" />
                                                            <c:forEach var="roleFeature" items="${roleFeatures}">
                                                                <c:if
                                                                    test="${roleFeature.role.roleId == role.roleId && roleFeature.feature.featureId == feature.featureId}">
                                                                    <c:set var="hasPermission" value="true" />
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:choose>
                                                                <c:when test="${hasPermission}">
                                                                    <span class="badge bg-success"
                                                                        style="font-size:1.1rem;">&#10003;</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-light text-secondary"
                                                                        style="font-size:1.1rem;">&#10007;</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </c:forEach>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Navigation Footer -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary admin-btn">
                                <i class="fa-solid fa-house me-1"></i>Back to Home
                            </a>
                            <div>
                                <a href="${pageContext.request.contextPath}/admin/users"
                                    class="btn btn-primary me-2 admin-btn">
                                    <i class="fa-solid fa-users me-1"></i>Manage Users
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/features"
                                    class="btn btn-info admin-btn">
                                    <i class="fa-solid fa-cogs me-1"></i>Manage Features
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>