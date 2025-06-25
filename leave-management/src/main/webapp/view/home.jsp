<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Home · Leave Management</title>

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Font Awesome for icons -->
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link rel="stylesheet" href="/css/style.css" />
        </head>

        <body>

            <!-- ======= Navbar ======= -->
            <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                <div class="container">
                    <a class="navbar-brand d-flex align-items-center" href="#">
                        <i class="fa-solid fa-plane-departure me-2"></i> Leave Management
                    </a>
                    <span class="navbar-text ms-auto text-white">
                        Welcome, <strong>${currentUser.fullName}</strong>
                    </span>
                </div>
            </nav>

            <!-- ======= Main Content ======= -->
            <div class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-lg-6 col-md-8">
                        <div class="card shadow-sm">
                            <!-- Header with gradient -->
                            <div class="card-header text-center header-gradient">
                                <h3 class="mb-1">Welcome, ${currentUser.fullName}</h3>
                                <p class="small">What would you like to do?</p>
                            </div>

                            <!-- Navigation options -->
                            <div class="card-body p-0">
                                <div class="list-group list-group-flush">
                                    <c:forEach var="feature" items="${features}">
                                        <a href="${pageContext.request.contextPath}${feature.entrypoint}"
                                            class="list-group-item list-group-item-action">
                                            <i class="fa-solid fa-arrow-right me-2"></i>
                                            ${feature.featureName}
                                        </a>
                                    </c:forEach>
                                </div>

                                <!-- Logout Button -->
                                <div class="text-center py-4 border-top">
                                    <a href="${pageContext.request.contextPath}/logout"
                                        class="btn btn-outline-danger px-4"
                                        onclick="return confirm('Are you sure you want to logout?');">
                                        <i class="fa-solid fa-right-from-bracket me-2"></i> Logout
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap Bundle JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>