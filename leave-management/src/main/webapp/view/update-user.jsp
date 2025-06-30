<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Update User · Leave Management</title>

                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Font Awesome for icons -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/styles.css" />
            </head>

            <body>
                <div class="auth-container update-form fade-in">
                    <!-- Auth Header -->
                    <div class="auth-header">
                        <div class="auth-icon">
                            <i class="fa-solid fa-user-edit"></i>
                        </div>
                        <h1 class="auth-title">Update User</h1>
                        <p class="auth-subtitle">Modify user information and permissions</p>
                    </div>

                    <!-- Update Form -->
                    <form id="user" method="post" action="${pageContext.request.contextPath}/admin/users/update"
                        class="slide-up">
                        <!-- ID & Username Row -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="userId" class="form-label">
                                        <i class="fa-solid fa-id-badge me-2"></i>User ID
                                    </label>
                                    <input type="hidden" name="userId" value="${user.userId}" />
                                    <input type="text" id="userId" class="form-control" readonly
                                        value="${user.userId}" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username" class="form-label">
                                        <i class="fa-solid fa-user me-2"></i>Username
                                    </label>
                                    <input type="hidden" name="username" value="${user.username}" />
                                    <input type="text" id="username" class="form-control" readonly
                                        value="${user.username}" />
                                </div>
                            </div>
                        </div>

                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullName" class="form-label">
                                <i class="fa-solid fa-id-card me-2"></i>Full Name
                            </label>
                            <input type="text" name="fullName" id="fullName" class="form-control"
                                placeholder="Enter full name" value="${user.fullName}" required />
                        </div>

                        <!-- Email -->
                        <div class="form-group">
                            <label for="email" class="form-label">
                                <i class="fa-solid fa-envelope me-2"></i>Email Address
                            </label>
                            <input type="email" name="email" id="email" class="form-control"
                                placeholder="Enter email address" value="${user.email}" required />
                        </div>

                        <!-- Department -->
                        <div class="form-group" id="departmentGroup">
                            <label for="departmentId" class="form-label">
                                <i class="fa-solid fa-building me-2"></i>Department
                            </label>
                            <select name="departmentId" id="departmentId" class="form-select" required>
                                <option value="">Select department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.departmentId}" ${user.departmentId==dept.departmentId
                                        ? 'selected' : '' }>
                                        ${dept.departmentName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Manager & Role Row -->
                        <div class="row">
                            <!-- Manager field removed -->
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="roleId" class="form-label">
                                        <i class="fa-solid fa-shield-halved me-2"></i>Role
                                    </label>
                                    <c:set var="currentRoleId" value="0" />
                                    <c:if test="${not empty user.userRoles}">
                                        <c:forEach var="userRole" items="${user.userRoles}">
                                            <c:set var="currentRoleId" value="${userRole.role.roleId}" />
                                        </c:forEach>
                                    </c:if>
                                    <select name="roleId" id="roleId" class="form-select" required
                                        data-current-role="${currentRoleId}" style="width:100%;">
                                        <option value="">Select Role</option>
                                        <option value="1" ${currentRoleId==1 ? 'selected' : '' }>Employee</option>
                                        <option value="2" ${currentRoleId==2 ? 'selected' : '' }>Manager</option>
                                        <option value="3" ${currentRoleId==3 ? 'selected' : '' }>Department Manager
                                        </option>
                                        <option value="4" ${currentRoleId==4 ? 'selected' : '' }>Director</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn-primary" id="updateBtn">
                            <i class="fa-solid fa-save me-2"></i>Update User
                        </button>
                    </form>

                    <!-- Back Button -->
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn-secondary">
                            <i class="fa-solid fa-arrow-left me-2"></i>Back to Users
                        </a>
                    </div>
                </div>

                <!-- Bootstrap Bundle JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <!-- Custom JavaScript -->
                <script>
                    // Add some interactive effects
                    document.addEventListener('DOMContentLoaded', function () {
                        const container = document.querySelector('.auth-container');

                        // Add hover effect
                        container.addEventListener('mouseenter', function () {
                            this.style.transform = 'scale(1.02)';
                        });

                        container.addEventListener('mouseleave', function () {
                            this.style.transform = 'scale(1)';
                        });

                        // Add focus effects to form inputs
                        const inputs = document.querySelectorAll('.form-control, .form-select');
                        inputs.forEach(input => {
                            if (!input.readOnly) {
                                input.addEventListener('focus', function () {
                                    this.parentElement.style.transform = 'translateX(5px)';
                                });

                                input.addEventListener('blur', function () {
                                    this.parentElement.style.transform = 'translateX(0)';
                                });
                            }
                        });

                        // Role change effect
                        const roleSelect = document.getElementById('roleId');
                        const departmentGroup = document.getElementById('departmentGroup');
                        const departmentSelect = document.getElementById('departmentId');

                        function handleRoleChange() {
                            const selectedRole = roleSelect.value;
                            if (selectedRole === '4') { // Director
                                departmentGroup.style.display = 'none';
                                departmentSelect.value = '';
                                departmentSelect.required = false;
                            } else {
                                departmentGroup.style.display = 'block';
                                departmentSelect.required = true;
                            }
                        }

                        // Initial check: nếu là Director thì ẩn luôn
                        const initialRole = roleSelect.getAttribute('data-current-role');
                        if (initialRole === '4') {
                            departmentGroup.style.display = 'none';
                            departmentSelect.value = '';
                            departmentSelect.required = false;
                        } else {
                            departmentGroup.style.display = 'block';
                            departmentSelect.required = true;
                        }

                        roleSelect.addEventListener('change', function () {
                            const selectedOption = this.options[this.selectedIndex];
                            const roleText = selectedOption.text;

                            // Add visual feedback
                            this.style.borderColor = '#28a745';
                            this.style.boxShadow = '0 0 0 0.2rem rgba(40, 167, 69, 0.25)';

                            setTimeout(() => {
                                this.style.borderColor = '#e3e6f0';
                                this.style.boxShadow = 'none';
                            }, 2000);

                            // Handle role-specific logic
                            handleRoleChange();
                        });

                        // Add loading animation to update button (FIXED - won't prevent submit)
                        const updateBtn = document.getElementById('updateBtn');
                        const form = document.getElementById('user');

                        form.addEventListener('submit', function () {
                            // Show loading animation when form is actually submitting
                            const originalText = updateBtn.innerHTML;
                            updateBtn.innerHTML = '<span class="loading-spinner me-2"></span>Updating...';
                            updateBtn.disabled = true;

                            // Reset after 5 seconds if something goes wrong
                            setTimeout(() => {
                                updateBtn.innerHTML = originalText;
                                updateBtn.disabled = false;
                            }, 5000);
                        });
                    });
                </script>
            </body>

            </html>