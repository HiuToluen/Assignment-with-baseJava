<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Leave Request Detail</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature/styles.css" />
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
            </head>

            <body>
                <div class="feature-container">
                    <div class="feature-card"
                        style="max-width: 500px; width: 100%; background: #e3f0ff; border: 1px solid #b3c6e7; text-align: left;">
                        <h4 class="mb-3">${leaveRequest.title}</h4>
                        <div class="mb-2">
                            <b>Processed by:</b>
                            <c:choose>
                                <c:when test="${processedBy != null}">
                                    ${processedBy.fullName}, Role: ${processedRole.roleName}
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Not processed yet</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-2"><b>Created by:</b> ${createdBy.fullName}</div>
                        <div class="mb-2"><b>Role:</b>
                            <c:out value="${role.roleName}" />
                        </div>
                        <c:if test="${!isDirector}">
                            <div class="mb-2"><b>Department:</b>
                                <c:out value="${department != null ? department.departmentName : ''}" />
                            </div>
                        </c:if>
                        <div class="mb-2"><b>From date:</b>
                            <fmt:formatDate value="${leaveRequest.startDate}" pattern="dd/MM/yyyy" />
                        </div>
                        <div class="mb-2"><b>To date:</b>
                            <fmt:formatDate value="${leaveRequest.endDate}" pattern="dd/MM/yyyy" />
                        </div>
                        <div class="mb-2"><b>Created at:</b>
                            <fmt:formatDate value="${leaveRequest.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                        <c:if test="${leaveRequest.updatedAt != null && leaveRequest.status != 'Inprogress'}">
                            <div class="mb-2"><b>Processed at:</b>
                                <fmt:formatDate value="${leaveRequest.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                        </c:if>
                        <div class="mb-2"><b>Reason:</b></div>
                        <div class="mb-3">
                            <textarea class="form-control" readonly
                                style="background:#f5f5f5;">${leaveRequest.reason}</textarea>
                        </div>
                        <div class="mb-2"><b>Status:</b> <span
                                class="badge status-badge status-${leaveRequest.status.toLowerCase()}">${leaveRequest.status}</span>
                        </div>
                        <c:if test="${leaveRequest.processedReason != null}">
                            <div class="mb-2"><b>Process note:</b> ${leaveRequest.processedReason}</div>
                        </c:if>
                        <c:if test="${isManager && leaveRequest.status == 'Inprogress'}">
                            <form action="${pageContext.request.contextPath}/feature/request/detail" method="post"
                                class="mt-3">
                                <input type="hidden" name="requestId" value="${leaveRequest.requestId}" />
                                <div class="mb-2">
                                    <label for="processReason" class="form-label">Process note:</label>
                                    <textarea class="form-control" id="processReason" name="processReason"
                                        required></textarea>
                                </div>
                                <div class="d-flex gap-2 justify-content-end">
                                    <button type="submit" name="action" value="reject"
                                        class="btn btn-primary">Reject</button>
                                    <button type="submit" name="action" value="approve"
                                        class="btn btn-primary">Approve</button>
                                </div>
                            </form>
                        </c:if>
                        <div class="mt-4 text-center">
                            <c:choose>
                                <c:when test="${param.source == 'mylr'}">
                                    <a href="${pageContext.request.contextPath}/feature/request/mylr"
                                        class="btn btn-outline-primary w-50">
                                        <i class="fas fa-arrow-left"></i> Back to list
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/feature/request/view-subordinates"
                                        class="btn btn-outline-primary w-50">
                                        <i class="fas fa-arrow-left"></i> Back to list
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>