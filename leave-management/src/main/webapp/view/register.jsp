<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Register</title>
            </head>

            <body>
                <h2>Register</h2>
                <form:form modelAttribute="user" method="post" action="/register">
                    <div>
                        <label>Username:</label>
                        <form:input path="username" />
                        <form:errors path="username" cssStyle="color: red;" />
                    </div>
                    <div>
                        <label>Password:</label>
                        <form:input path="password" type="password" />
                        <form:errors path="password" cssStyle="color: red;" />
                    </div>
                    <div>
                        <label>Full Name:</label>
                        <form:input path="fullName" />
                        <form:errors path="fullName" cssStyle="color: red;" />
                    </div>
                    <div>
                        <label>Email:</label>
                        <form:input path="email" />
                        <form:errors path="email" cssStyle="color: red;" />
                    </div>
                    <div>
                        <label>Department:</label>
                        <form:select path="departmentId">
                            <form:options items="${departments}" itemValue="departmentId" itemLabel="departmentName" />
                        </form:select>
                        <form:errors path="departmentId" cssStyle="color: red;" />
                    </div>
                    <input type="submit" value="Register">
                    <p style="color: red">${error}</p>
                </form:form>
            </body>

            </html>