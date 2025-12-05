<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Agenda Management</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature/styles.css" />
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
            </head>

            <body>
                <div class="feature-container">
                    <div class="feature-card" style="max-width: 1400px; width: 100%;">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1><i class="fas fa-calendar-alt"></i> Department Agenda Overview</h1>
                            <div>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary">
                                    <i class="fas fa-home"></i> Back to Home
                                </a>
                            </div>
                        </div>
                        <!-- Filter Form -->
                        <form method="get" class="row g-3 mb-4 align-items-end">
                            <div class="col-auto">
                                <label for="startDate" class="form-label">From</label>
                                <input type="date" class="form-control" id="startDate" name="startDate"
                                    value="<fmt:formatDate value='${startDate}' pattern='yyyy-MM-dd'/>" required />
                            </div>
                            <div class="col-auto">
                                <label for="endDate" class="form-label">To</label>
                                <input type="date" class="form-control" id="endDate" name="endDate"
                                    value="<fmt:formatDate value='${endDate}' pattern='yyyy-MM-dd'/>" required />
                            </div>
                            <div class="col-auto">
                                <label for="searchName" class="form-label">Search Employee</label>
                                <input type="text" class="form-control" id="searchName" name="searchName"
                                    value="${searchName}" placeholder="Enter employee name..." />
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i>
                                    Search</button>
                            </div>
                        </form>
                        <!-- Agenda Table(s) -->
                        <c:choose>
                            <c:when test="${isDirector}">
                                <c:forEach var="deptId" items="${departmentUsersMap.keySet()}">
                                    <c:set var="dept" value="${departmentMap[deptId]}" />
                                    <div class="mb-5">
                                        <h4 class="mb-3">Department:
                                            <c:out value="${dept.departmentName}" />
                                        </h4>
                                        <div class="table-responsive">
                                            <table class="table table-bordered agenda-table">
                                                <thead>
                                                    <tr>
                                                        <th>Employee</th>
                                                        <c:forEach var="date" items="${dateList}">
                                                            <th>
                                                                <fmt:formatDate value="${date}" pattern="dd/MM" />
                                                                <c:if test="${holidayMap[date.time]}">
                                                                    <span
                                                                        style="color: #e67e22; font-size: 0.9em; font-weight: bold;">
                                                                        (Holiday)</span>
                                                                </c:if>
                                                            </th>
                                                        </c:forEach>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="emp" items="${departmentUsersMap[deptId]}">
                                                        <tr>
                                                            <td>
                                                                <c:out value="${emp.fullName}" />
                                                            </td>
                                                            <c:forEach var="date" items="${dateList}">
                                                                <c:set var="isOnLeave"
                                                                    value="${departmentUserLeaveMap[deptId][emp.userId][date.time]}" />
                                                                <td
                                                                    style="background-color: ${holidayMap[date.time] ? '#ffeaa7' : (isOnLeave ? '#e74c3c' : '#7bed9f')}; color: ${holidayMap[date.time] ? '#d35400' : '#222'}; text-align: center; font-weight: bold;">
                                                                    <c:choose>
                                                                        <c:when test="${holidayMap[date.time]}">Holiday
                                                                        </c:when>
                                                                        <c:when test="${isOnLeave}">Leave</c:when>
                                                                        <c:otherwise>Work</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </c:forEach>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:set var="deptId" value="${user.departmentId}" />
                                <c:set var="dept" value="${departmentMap[deptId]}" />
                                <div class="mb-5">
                                    <h4 class="mb-3">Department:
                                        <c:out value="${dept.departmentName}" />
                                    </h4>
                                    <div class="table-responsive">
                                        <table class="table table-bordered agenda-table">
                                            <thead>
                                                <tr>
                                                    <th>Employee</th>
                                                    <c:forEach var="date" items="${dateList}">
                                                        <th>
                                                            <fmt:formatDate value="${date}" pattern="dd/MM" />
                                                            <c:if test="${holidayMap[date.time]}">
                                                                <span
                                                                    style="color: #e67e22; font-size: 0.9em; font-weight: bold;">
                                                                    (Holiday)</span>
                                                            </c:if>
                                                        </th>
                                                    </c:forEach>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="emp" items="${departmentUsersMap[deptId]}">
                                                    <tr>
                                                        <td>
                                                            <c:out value="${emp.fullName}" />
                                                        </td>
                                                        <c:forEach var="date" items="${dateList}">
                                                            <c:set var="isOnLeave"
                                                                value="${departmentUserLeaveMap[deptId][emp.userId][date.time]}" />
                                                            <td
                                                                style="background-color: ${holidayMap[date.time] ? '#ffeaa7' : (isOnLeave ? '#e74c3c' : '#7bed9f')}; color: ${holidayMap[date.time] ? '#d35400' : '#222'}; text-align: center; font-weight: bold;">
                                                                <c:choose>
                                                                    <c:when test="${holidayMap[date.time]}">Holiday
                                                                    </c:when>
                                                                    <c:when test="${isOnLeave}">Leave</c:when>
                                                                    <c:otherwise>Work</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </c:forEach>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
            </body>

            </html>