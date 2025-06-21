<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Home - Leave Management</title>
        </head>

        <body>
            <h2>Welcome, ${currentUser.fullName}</h2>
            <c:if test="${canCreateRequest}">
                <a href="${pageContext.request.contextPath}/request/create">Create Leave Request</a><br>
            </c:if>
            <c:if test="${canViewSubordinates}">
                <a href="${pageContext.request.contextPath}/request/view-subordinates">View Subordinate Requests</a><br>
            </c:if>
            <c:if test="${canViewAgenda}">
                <a href="${pageContext.request.contextPath}/agenda">View Agenda</a><br>
            </c:if>
            <c:if test="${canManageUsers}">
                <a href="${pageContext.request.contextPath}/admin/users">Manage Users</a><br>
            </c:if>
            <a href="${pageContext.request.contextPath}/logout" onclick="return confirm('Are you sure?')">Logout</a>
        </body>

        </html>