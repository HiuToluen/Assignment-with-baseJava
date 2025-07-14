<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Leave Requests</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature/styles.css" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
        </head>

        <body>
            <div class="feature-container">
                <div class="feature-card" style="max-width:900px;width:100%;">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1>My Leave Requests</h1>
                    </div>
                    <c:choose>
                        <c:when test="${myLeaveRequests.totalElements == 0}">
                            <div class="text-center text-muted py-4">
                                <i class="fa-solid fa-folder-open fa-2x mb-2"></i>
                                <div>No leave requests found.</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered align-middle mt-3">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Title</th>
                                            <th>Start Date</th>
                                            <th>End Date</th>
                                            <th>Status</th>
                                            <th>Reason</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="req" items="${myLeaveRequests.content}">
                                            <tr>
                                                <td>
                                                    <a
                                                        href="${pageContext.request.contextPath}/feature/request/detail?requestId=${req.requestId}&source=mylr">
                                                        <c:out value="${req.title}" />
                                                    </a>
                                                </td>
                                                <td>
                                                    <c:out value="${req.startDate}" />
                                                </td>
                                                <td>
                                                    <c:out value="${req.endDate}" />
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary">
                                                        <c:out value="${req.status}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:out value="${req.reason}" />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <!-- Pagination Controls -->
                            <nav aria-label="Leave request pagination" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${myLeaveRequests.totalPages > 1}">
                                        <li class="page-item ${myLeaveRequests.first ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${myLeaveRequests.number - 1}&size=${myLeaveRequests.size}"
                                                tabindex="-1">Previous</a>
                                        </li>
                                        <c:forEach begin="0" end="${myLeaveRequests.totalPages - 1}" var="i">
                                            <li class="page-item ${myLeaveRequests.number == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&size=${myLeaveRequests.size}">${i
                                                    + 1}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${myLeaveRequests.last ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?page=${myLeaveRequests.number + 1}&size=${myLeaveRequests.size}">Next</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:otherwise>
                    </c:choose>
                    <div class="mt-5 text-center">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary w-50">
                            <i class="fas fa-home"></i> Back to Home
                        </a>
                    </div>
                </div>
            </div>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
        </body>

        </html>