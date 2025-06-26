<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Admin - Manage Users</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="/css/style.css" />
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        </head>

        <body>
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
                <div class="container">
                    <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
                        <i class="fa-solid fa-user-gear me-2"></i> Admin Panel
                    </a>
                    <div class="ms-auto">
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light"
                            onclick="return confirm('Are you sure?')">
                            <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
                        </a>
                    </div>
                </div>
            </nav>
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-12">
                        <div class="card shadow-sm">
                            <div class="card-header bg-primary text-white text-center">
                                <h2 class="mb-0">Manage Users</h2>
                            </div>
                            <div class="card-body">
                                <!-- Search Form -->
                                <form method="get" action="${pageContext.request.contextPath}/admin/users"
                                    class="row g-2 mb-3">
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
                                                    ? 'selected' : '' }>${dept.departmentName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <select name="roleId" class="form-select">
                                            <option value="">All Roles</option>
                                            <option value="1" ${roleId==1 ? 'selected' : '' }>Employee</option>
                                            <option value="2" ${roleId==2 ? 'selected' : '' }>Manager</option>
                                            <option value="3" ${roleId==3 ? 'selected' : '' }>Department Manager
                                            </option>
                                            <option value="4" ${roleId==4 ? 'selected' : '' }>Director</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100"><i class="fa fa-search"></i>
                                            Search</button>
                                    </div>
                                </form>
                                <!-- End Search Form -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover align-middle">
                                        <thead class="table-primary">
                                            <tr>
                                                <th>ID</th>
                                                <th>Username</th>
                                                <th>Full Name</th>
                                                <th>Email</th>
                                                <th>Department</th>
                                                <th>Manager Full Name</th>
                                                <th>Role</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${users}" varStatus="loop">
                                                <tr>
                                                    <td>
                                                        <c:out value="${user.userId}" />
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
                                                                <c:when test='${currentRoleId == 1}'>bg-secondary</c:when>
                                                                <c:when test='${currentRoleId == 2}'>bg-info text-dark</c:when>
                                                                <c:when test='${currentRoleId == 3}'>bg-warning text-dark</c:when>
                                                                <c:when test='${currentRoleId == 4}'>bg-success</c:when>
                                                                <c:otherwise>bg-light text-dark</c:otherwise>
                                                            </c:choose>'">
                                                            <c:choose>
                                                                <c:when test="${currentRoleId == 1}">Employee</c:when>
                                                                <c:when test="${currentRoleId == 2}">Manager</c:when>
                                                                <c:when test="${currentRoleId == 3}">Department Manager
                                                                </c:when>
                                                                <c:when test="${currentRoleId == 4}">Director</c:when>
                                                                <c:otherwise>Unknown</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="/admin/users/update/${user.userId}"
                                                            class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="fa-solid fa-pen-to-square"></i> Update
                                                        </a>
                                                        <a href="/admin/users/delete/${user.userId}"
                                                            class="btn btn-sm btn-outline-danger"
                                                            onclick="return confirm('Are you sure?')">
                                                            <i class="fa-solid fa-trash"></i> Delete
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="d-flex justify-content-between mt-4">
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                                        <i class="fa-solid fa-house"></i> Back to Home
                                    </a>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/admin/features"
                                            class="btn btn-info me-2">
                                            <i class="fa-solid fa-cogs"></i> Manage Features
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/permissions"
                                            class="btn btn-warning me-2">
                                            <i class="fa-solid fa-key"></i> Manage Permissions
                                        </a>
                                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger"
                                            onclick="return confirm('Are you sure?')">
                                            <i class="fa-solid fa-right-from-bracket"></i> Logout
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>