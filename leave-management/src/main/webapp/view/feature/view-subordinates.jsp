<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>View Subordinate Requests</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature/styles.css" />
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
                <style>
                    .status-badge {
                        font-size: 0.8rem;
                        padding: 0.25rem 0.5rem;
                    }

                    .status-inprogress {
                        background-color: #ffc107;
                        color: #000;
                    }

                    .status-approved {
                        background-color: #198754;
                        color: #fff;
                    }

                    .status-rejected {
                        background-color: #dc3545;
                        color: #fff;
                    }

                    .action-buttons {
                        display: flex;
                        gap: 0.5rem;
                        flex-wrap: wrap;
                    }

                    .btn-sm {
                        font-size: 0.75rem;
                        padding: 0.25rem 0.5rem;
                    }

                    .modal-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }
                </style>
            </head>

            <body>
                <div class="feature-container">
                    <div class="feature-card" style="max-width: 1200px; width: 100%;">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1>Subordinate Leave Requests</h1>
                            <div>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary">
                                    <i class="fas fa-home"></i> Back to Home
                                </a>
                                <span class="text-muted ms-3">
                                    <i class="fas fa-users"></i>
                                    ${directSubordinates.size()} direct subordinates
                                </span>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty subordinateRequests}">
                                <div class="text-center text-muted py-5">
                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                    <h4>No Subordinate Requests</h4>
                                    <p>There are currently no leave requests from your subordinates.</p>
                                    <div class="mt-3">
                                        <small class="text-muted">
                                            <c:if test="${empty allSubordinates}">
                                                You don't have any subordinates assigned.
                                            </c:if>
                                            <c:if test="${not empty allSubordinates}">
                                                You have ${allSubordinates.size()} subordinates but no leave requests.
                                            </c:if>
                                        </small>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover table-bordered align-middle">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Title</th>
                                                <th>From</th>
                                                <th>To</th>
                                                <th>Created By</th>
                                                <th>Status</th>
                                                <th>Processed By</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="req" items="${subordinateRequests}">
                                                <tr>
                                                    <td>
                                                        <a
                                                            href="${pageContext.request.contextPath}/feature/request/detail?requestId=${req.requestId}&source=subordinates">
                                                            <c:out value="${req.title}" />
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${req.startDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${req.endDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <c:out value="${userMap[req.userId].fullName}" />
                                                    </td>
                                                    <td>
                                                        <span
                                                            class="badge status-badge status-${req.status.toLowerCase()}">
                                                            ${req.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${req.processedBy != null}">
                                                            <c:out value="${userMap[req.processedBy].fullName}" />
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Approve Modal -->
                <div class="modal fade" id="approveModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-check-circle"></i> Approve Leave Request
                                </h5>
                                <button type="button" class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="approveReason" class="form-label">Approval Reason (Optional)</label>
                                    <textarea class="form-control" id="approveReason" rows="3"
                                        placeholder="Enter approval reason..."></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-success" onclick="approveRequest()">
                                    <i class="fas fa-check"></i> Approve Request
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Reject Modal -->
                <div class="modal fade" id="rejectModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas fa-times-circle"></i> Reject Leave Request
                                </h5>
                                <button type="button" class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="rejectReason" class="form-label">Rejection Reason <span
                                            class="text-danger">*</span></label>
                                    <textarea class="form-control" id="rejectReason" rows="3"
                                        placeholder="Please provide a reason for rejection..." required></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-danger" onclick="rejectRequest()">
                                    <i class="fas fa-times"></i> Reject Request
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/js/all.min.js"></script>
                <script>
                    let currentRequestId = null;

                    function showApproveModal(button) {
                        currentRequestId = button.getAttribute('data-request-id');
                        document.getElementById('approveReason').value = '';
                        new bootstrap.Modal(document.getElementById('approveModal')).show();
                    }

                    function showRejectModal(button) {
                        currentRequestId = button.getAttribute('data-request-id');
                        document.getElementById('rejectReason').value = '';
                        new bootstrap.Modal(document.getElementById('rejectModal')).show();
                    }

                    function approveRequest() {
                        const reason = document.getElementById('approveReason').value;
                        if (!currentRequestId) {
                            alert('Request ID is missing!');
                            return;
                        }
                        const url = window.location.pathname + '?action=approve&requestId=' + currentRequestId + '&reason=' + encodeURIComponent(reason);
                        window.location.href = url;
                    }

                    function rejectRequest() {
                        const reason = document.getElementById('rejectReason').value;
                        if (!reason.trim()) {
                            alert('Please provide a rejection reason.');
                            return;
                        }
                        if (!currentRequestId) {
                            alert('Request ID is missing!');
                            return;
                        }
                        const url = window.location.pathname + '?action=reject&requestId=' + currentRequestId + '&reason=' + encodeURIComponent(reason);
                        window.location.href = url;
                    }
                </script>
            </body>

            </html>