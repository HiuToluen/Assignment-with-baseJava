<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Update User - Leave Management</title>

                <!-- Bootstrap + stylesheet đang dùng chung -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="/css/style.css" />
            </head>

            <body class="login-body">
                <div class="container">
                    <div class="row justify-content-center">
                        <div class="col-md-6 login-container">
                            <h2 class="text-center mb-4">Update User</h2>

                            <form:form modelAttribute="user" method="post" action="/admin/users/update">

                                <!-- ID & Username chung một hàng -->
                                <div class="row mb-3">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label class="form-label" for="userId">ID</label>
                                        <form:input path="userId" id="userId" class="form-control" readonly="true" />
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="username">Username</label>
                                        <form:input path="username" id="username" class="form-control"
                                            readonly="true" />
                                    </div>
                                </div>

                                <!-- Full Name -->
                                <div class="form-group mb-3">
                                    <c:set var="errorFullName">
                                        <form:errors path="fullName" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label class="form-label" for="fullName">Full Name</label>
                                    <form:input path="fullName" id="fullName"
                                        class="form-control ${not empty errorFullName ? 'is-invalid' : ''}" />
                                    ${errorFullName}
                                </div>

                                <!-- Email -->
                                <div class="form-group mb-3">
                                    <c:set var="errorEmail">
                                        <form:errors path="email" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label class="form-label" for="email">Email</label>
                                    <form:input path="email" id="email"
                                        class="form-control ${not empty errorEmail ? 'is-invalid' : ''}" />
                                    ${errorEmail}
                                </div>

                                <!-- Department -->
                                <div class="form-group mb-3">
                                    <label class="form-label" for="departmentId">Department</label>
                                    <form:select path="departmentId" id="departmentId" class="form-select"
                                        required="true">
                                        <form:options items="${departments}" itemValue="departmentId"
                                            itemLabel="departmentName" />
                                    </form:select>
                                    <c:set var="errorDepartment">
                                        <form:errors path="departmentId" cssClass="invalid-feedback" />
                                    </c:set>
                                    ${errorDepartment}
                                </div>

                                <!-- Manager & Role chung một hàng, GIỮ NGUYÊN LOGIC GỐC -->
                                <div class="row mb-4">
                                    <!-- Manager (vẫn là form:select như ban đầu) -->
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label class="form-label" for="managerId">Manager</label>
                                        <form:select path="managerId" id="managerId" class="form-select"
                                            required="true">
                                            <c:set var="defaultManagerId" value="${user.managerId}" />
                                            <c:if test="${empty user.managerId}">
                                                <c:forEach var="department" items="${departments}">
                                                    <c:if test="${user.departmentId == department.departmentId}">
                                                        <c:set var="defaultManagerId" value="${department.idManager}" />
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                            <form:option value="${defaultManagerId}"
                                                label="${managerNames[defaultManagerId] != null ? managerNames[defaultManagerId] : 'Select Manager'}" />
                                            <form:options items="${managerNames}" />
                                        </form:select>
                                    </div>

                                    <!-- Role (giữ nguyên là <select> thuần) -->
                                    <div class="col-md-6">
                                        <label class="form-label" for="roleId">Role</label>
                                        <c:set var="currentRoleId" value="0" />
                                        <c:if test="${not empty user.userRoles}">
                                            <c:forEach var="userRole" items="${user.userRoles}">
                                                <c:set var="currentRoleId" value="${userRole.role.roleId}" />
                                            </c:forEach>
                                        </c:if>
                                        <select name="roleId" id="roleId" class="form-select" required>
                                            <option value="1" ${currentRoleId==1 ? 'selected' : '' }>Employee</option>
                                            <option value="2" ${currentRoleId==2 ? 'selected' : '' }>Manager</option>
                                            <option value="3" ${currentRoleId==3 ? 'selected' : '' }>Department Manager
                                            </option>
                                            <option value="4" ${currentRoleId==4 ? 'selected' : '' }>Director</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Submit -->
                                <button type="submit" class="btn btn-custom w-100">Update</button>
                            </form:form>

                            <!-- Back -->
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-custom">Back</a>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>