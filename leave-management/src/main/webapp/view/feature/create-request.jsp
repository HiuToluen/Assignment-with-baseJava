<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Create Leave Request</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature/styles.css" />
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
            </head>

            <body>
                <div class="feature-container">
                    <div class="feature-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1>Create Leave Request</h1>
                        </div>
                        <form:form method="post" modelAttribute="leaveRequest" class="mt-3">
                            <div class="mb-3">
                                <label for="title" class="form-label">Title</label>
                                <form:input path="title" type="text" cssClass="form-control" id="title" maxlength="255"
                                    required="required" />
                                <form:errors path="title" cssClass="invalid-feedback d-block" />
                            </div>
                            <div class="mb-3">
                                <label for="startDate" class="form-label">Start Date</label>
                                <form:input path="startDate" type="date" cssClass="form-control" id="startDate" />
                                <form:errors path="startDate" cssClass="invalid-feedback d-block" />
                            </div>
                            <div class="mb-3">
                                <label for="endDate" class="form-label">End Date</label>
                                <form:input path="endDate" type="date" cssClass="form-control" id="endDate" />
                                <form:errors path="endDate" cssClass="invalid-feedback d-block" />
                            </div>
                            <div class="mb-3">
                                <label for="reason" class="form-label">Reason</label>
                                <form:textarea path="reason" cssClass="form-control" id="reason" rows="3" />
                                <form:errors path="reason" cssClass="invalid-feedback d-block" />
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Submit Request</button>
                        </form:form>
                        <div class="mt-5 text-center">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary w-50">
                                <i class="fas fa-home"></i> Back to Home
                            </a>
                        </div>
                    </div>
                </div>
            </body>

            </html>