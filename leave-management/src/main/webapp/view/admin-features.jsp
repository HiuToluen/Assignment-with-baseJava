<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Feature Management - Admin Panel</title>
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
                        <i class="fa-solid fa-cogs me-2"></i> Feature Management
                    </a>
                    <div class="ms-auto">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-light me-2">
                            <i class="fa-solid fa-users me-1"></i> Users
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/permissions"
                            class="btn btn-outline-light me-2">
                            <i class="fa-solid fa-key me-1"></i> Permissions
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
                    <div class="col-md-4">
                        <div class="card stats-card admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-list-check fa-2x mb-2"></i>
                                <h4 class="mb-0">${features.size()}</h4>
                                <p class="mb-0">Total Features</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-success text-white admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-check-circle fa-2x mb-2"></i>
                                <h4 class="mb-0">Active</h4>
                                <p class="mb-0">Features Status</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card bg-info text-white admin-card">
                            <div class="card-body text-center">
                                <i class="fa-solid fa-plus-circle fa-2x mb-2"></i>
                                <h4 class="mb-0">Add New</h4>
                                <p class="mb-0">Create Feature</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Add Feature Form -->
                    <div class="col-lg-4 mb-4 slide-in-left">
                        <div class="card form-card admin-card">
                            <div class="card-header bg-transparent border-0">
                                <h5 class="mb-0">
                                    <i class="fa-solid fa-plus-circle me-2"></i>Add New Feature
                                </h5>
                            </div>
                            <div class="card-body">
                                <form action="/admin/features/add" method="post">
                                    <div class="mb-3">
                                        <label for="featureName" class="form-label">Feature Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa-solid fa-tag"></i>
                                            </span>
                                            <input type="text" class="form-control" id="featureName" name="featureName"
                                                placeholder="Enter feature name" required>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="entrypoint" class="form-label">Entrypoint (URL)</label>
                                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="fa-solid fa-link"></i>
                                            </span>
                                            <input type="text" class="form-control" id="entrypoint" name="entrypoint"
                                                placeholder="/path/to/feature" required>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-light w-100">
                                        <i class="fa-solid fa-plus me-1"></i>Add Feature
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Features Table -->
                    <div class="col-lg-8 slide-in-right">
                        <div class="card table-card admin-card feature-table">
                            <div class="card-header bg-transparent border-0">
                                <h5 class="mb-0">
                                    <i class="fa-solid fa-list me-2"></i>Existing Features
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-hashtag me-1"></i>ID</th>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-tag me-1"></i>Feature Name</th>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-link me-1"></i>Entrypoint</th>
                                                <th style="color:#333;background:white;"><i
                                                        class="fa-solid fa-cogs me-1"></i>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="feature" items="${features}">
                                                <tr class="feature-card">
                                                    <td style="color:#333;background:white;">
                                                        <span class="badge bg-primary"
                                                            style="color:#fff;">${feature.featureId}</span>
                                                    </td>
                                                    <td style="color:#333;background:white;">
                                                        <strong style="color:#333;">${feature.featureName}</strong>
                                                    </td>
                                                    <td style="color:#333;background:white;">
                                                        <code
                                                            style="color:#007bff;background:white;">${feature.entrypoint}</code>
                                                    </td>
                                                    <td style="color:#333;background:white;">
                                                        <a href="/admin/features/delete/${feature.featureId}"
                                                            class="btn btn-danger btn-sm admin-btn"
                                                            onclick="return confirm('Are you sure you want to delete this feature? This action cannot be undone.')">
                                                            <i class="fa-solid fa-trash me-1"></i>Delete
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${empty features}">
                                    <div class="empty-state">
                                        <i class="fa-solid fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No features found</h5>
                                        <p class="text-muted">Start by adding your first feature using the form on the
                                            left.</p>
                                    </div>
                                </c:if>
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
                                <a href="${pageContext.request.contextPath}/admin/permissions"
                                    class="btn btn-warning admin-btn">
                                    <i class="fa-solid fa-key me-1"></i>Manage Permissions
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>