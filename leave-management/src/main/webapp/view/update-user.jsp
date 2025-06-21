<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Update User</title>
            </head>

            <body>
                <h2>Update User</h2>
                <form:form modelAttribute="user" method="post" action="/admin/users/update">
                    <table>
                        <tr>
                            <td>ID:</td>
                            <td>
                                <form:input path="userId" readonly="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Username:</td>
                            <td>
                                <form:input path="username" readonly="true" />
                            </td>
                        </tr>
                        <tr>
                            <td>Full Name:</td>
                            <td>
                                <form:input path="fullName" />
                            </td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td>
                                <form:input path="email" />
                            </td>
                        </tr>
                        <tr>
                            <td>Department:</td>
                            <td>
                                <form:select path="departmentId" required="true">
                                    <form:options items="${departments}" itemValue="departmentId"
                                        itemLabel="departmentName" />
                                </form:select>
                            </td>
                        </tr>
                        <tr>
                            <td>Manager:</td>
                            <td>
                                <form:select path="managerId" required="true">
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
                            </td>
                        </tr>
                        <tr>
                            <td>Role:</td>
                            <td>
                                <select name="roleId" required>
                                    <c:set var="currentRoleId" value="0" />
                                    <c:if test="${not empty user.userRoles}">
                                        <c:forEach var="userRole" items="${user.userRoles}">
                                            <c:set var="currentRoleId" value="${userRole.role.roleId}" />
                                        </c:forEach>
                                    </c:if>
                                    <option value="1" ${currentRoleId==1 ? 'selected' : '' }>Employee</option>
                                    <option value="2" ${currentRoleId==2 ? 'selected' : '' }>Manager</option>
                                    <option value="3" ${currentRoleId==3 ? 'selected' : '' }>Department Manager</option>
                                    <option value="4" ${currentRoleId==4 ? 'selected' : '' }>Director</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><input type="submit" value="Update" /></td>
                        </tr>
                    </table>
                </form:form>
                <a href="${pageContext.request.contextPath}/admin/users">Back</a>
            </body>

            </html>