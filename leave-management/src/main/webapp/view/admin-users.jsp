<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <link rel="stylesheet" href="/css/style.css" />
            <title>Admin - Manage Users</title>
        </head>

        <body>
            <h2>Manage Users</h2>
            <table border="1">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Department</th>
                    <th>Manager Full Name</th>
                    <th>Role ID</th>
                    <th>Action</th>
                </tr>
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
                                <c:if test="${user.departmentId == department.departmentId}">
                                    <c:out value="${department.departmentName}" />
                                </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <c:set var="currentRoleId" value="0" />
                            <c:if test="${not empty user.userRoles}">
                                <c:forEach var="userRole" items="${user.userRoles}">
                                    <c:set var="currentRoleId" value="${userRole.role.roleId}" />
                                </c:forEach>
                            </c:if>
                            <c:choose>
                                <c:when test="${currentRoleId == 1 && user.managerId == null}">
                                    <c:set var="deptManagerId" value="0" />
                                    <c:forEach var="department" items="${departments}">
                                        <c:if test="${user.departmentId == department.departmentId}">
                                            <c:set var="deptManagerId" value="${department.idManager}" />
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
                                    <c:set var="currentRoleId" value="${userRole.role.roleId}" />
                                </c:forEach>
                            </c:if>
                            <c:choose>
                                <c:when test="${currentRoleId == 1}">Employee</c:when>
                                <c:when test="${currentRoleId == 2}">Manager</c:when>
                                <c:when test="${currentRoleId == 3}">Department Manager</c:when>
                                <c:when test="${currentRoleId == 4}">Director</c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="/admin/users/update/${user.userId}">Update</a> |
                            <a href="/admin/users/delete/${user.userId}"
                                onclick="return confirm('Are you sure?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>

            <a href="${pageContext.request.contextPath}/home">Back to Home</a>
            <a href="${pageContext.request.contextPath}/logout" onclick="return confirm('Are you sure?')">Logout</a>

        </body>

        </html>