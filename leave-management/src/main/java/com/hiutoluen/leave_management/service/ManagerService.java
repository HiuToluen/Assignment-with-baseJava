package com.hiutoluen.leave_management.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hiutoluen.leave_management.model.Department;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.model.UserRole;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.repository.RoleRepository;
import com.hiutoluen.leave_management.repository.UserRepository;
import com.hiutoluen.leave_management.repository.UserRoleRepository;

@Service
public class ManagerService {

    private final UserRepository userRepository;
    private final DepartmentRepository departmentRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;

    private static final int EMPLOYEE_ROLE_ID = 1;
    private static final int MANAGER_ROLE_ID = 2;
    private static final int DEPARTMENT_MANAGER_ROLE_ID = 3;
    private static final int DIRECTOR_ROLE_ID = 4;

    public ManagerService(UserRepository userRepository,
            DepartmentRepository departmentRepository,
            RoleRepository roleRepository,
            UserRoleRepository userRoleRepository) {
        this.userRepository = userRepository;
        this.departmentRepository = departmentRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
    }

    @Transactional
    public void determineAndSetManager(User user) {
        List<UserRole> userRoles = userRoleRepository.findByUser_UserId(user.getUserId());

        if (userRoles.isEmpty()) {
            return;
        }

        boolean isDirector = userRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == DIRECTOR_ROLE_ID);

        if (isDirector) {
            user.setManagerId(null);
            userRepository.save(user);
            return;
        }

        boolean isDepartmentManager = userRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == DEPARTMENT_MANAGER_ROLE_ID);

        if (isDepartmentManager) {
            setManagerForDepartmentManager(user);
        } else {
            boolean isManager = userRoles.stream()
                    .anyMatch(ur -> ur.getRole().getRoleId() == MANAGER_ROLE_ID);

            if (isManager) {
                setManagerForManager(user);
            } else {
                setManagerForEmployee(user);
            }
        }
    }

    private void setManagerForDepartmentManager(User user) {
        List<UserRole> directorRoles = userRoleRepository.findByRole_RoleId(DIRECTOR_ROLE_ID);

        if (!directorRoles.isEmpty()) {
            User director = directorRoles.get(0).getUser();
            if (director.getUserId() != user.getUserId()) {
                user.setManagerId(director.getUserId());
                userRepository.save(user);
                return;
            }
        }

        user.setManagerId(null);
        userRepository.save(user);
    }

    private void setManagerForManager(User user) {
        Department department = departmentRepository.findById(user.getDepartmentId()).orElse(null);

        if (department != null && department.getIdManager() != null) {
            User departmentManager = userRepository.findById(department.getIdManager()).orElse(null);
            if (departmentManager != null && isUserDepartmentManager(departmentManager) &&
                    departmentManager.getUserId() != user.getUserId()) {
                user.setManagerId(department.getIdManager());
                userRepository.save(user);
                return;
            }
        }

        List<UserRole> directorRoles = userRoleRepository.findByRole_RoleId(DIRECTOR_ROLE_ID);
        if (!directorRoles.isEmpty()) {
            User director = directorRoles.get(0).getUser();
            if (director.getUserId() != user.getUserId()) {
                user.setManagerId(director.getUserId());
                userRepository.save(user);
                return;
            }
        }

        user.setManagerId(null);
        userRepository.save(user);
    }

    private void setManagerForEmployee(User user) {
        Department department = departmentRepository.findById(user.getDepartmentId()).orElse(null);

        if (department != null && department.getIdManager() != null) {
            User departmentManager = userRepository.findById(department.getIdManager()).orElse(null);
            if (departmentManager != null && isUserDepartmentManager(departmentManager) &&
                    departmentManager.getUserId() != user.getUserId()) {
                user.setManagerId(department.getIdManager());
                userRepository.save(user);
                return;
            }
        }

        List<UserRole> directorRoles = userRoleRepository.findByRole_RoleId(DIRECTOR_ROLE_ID);
        if (!directorRoles.isEmpty()) {
            User director = directorRoles.get(0).getUser();
            if (director.getUserId() != user.getUserId()) {
                user.setManagerId(director.getUserId());
                userRepository.save(user);
                return;
            }
        }

        user.setManagerId(null);
        userRepository.save(user);
    }

    private boolean isUserManager(User user) {
        List<UserRole> userRoles = userRoleRepository.findByUser_UserId(user.getUserId());
        return userRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == MANAGER_ROLE_ID);
    }

    private boolean isUserDepartmentManager(User user) {
        List<UserRole> userRoles = userRoleRepository.findByUser_UserId(user.getUserId());
        return userRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == DEPARTMENT_MANAGER_ROLE_ID);
    }

    @Transactional
    public void updateDepartmentManager(User user, int newDepartmentId) {
        Department oldDepartment = departmentRepository.findById(user.getDepartmentId()).orElse(null);
        if (oldDepartment != null && oldDepartment.getIdManager() != null &&
                oldDepartment.getIdManager() == user.getUserId()) {
            oldDepartment.setIdManager(null);
            departmentRepository.save(oldDepartment);
        }

        Department newDepartment = departmentRepository.findById(newDepartmentId).orElse(null);
        if (newDepartment != null) {
            newDepartment.setIdManager(user.getUserId());
            departmentRepository.save(newDepartment);
        }
    }

    @Transactional
    public void validateAndUpdateAllManagers() {
        List<User> allUsers = userRepository.findAll();

        for (User user : allUsers) {
            if ("admin".equalsIgnoreCase(user.getUsername())) {
                continue;
            }

            if (user.getManagerId() != null) {
                User currentManager = userRepository.findById(user.getManagerId()).orElse(null);
                if (currentManager == null || !isManagerValidForUser(user, currentManager)) {
                    determineAndSetManager(user);
                }
            } else {
                determineAndSetManager(user);
            }
        }
    }

    private boolean isManagerValidForUser(User user, User manager) {
        List<UserRole> userRoles = userRoleRepository.findByUser_UserId(user.getUserId());
        List<UserRole> managerRoles = userRoleRepository.findByUser_UserId(manager.getUserId());

        boolean managerIsDirector = managerRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == DIRECTOR_ROLE_ID);

        if (managerIsDirector) {
            return true;
        }

        boolean managerIsDepartmentManager = managerRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == DEPARTMENT_MANAGER_ROLE_ID);

        if (managerIsDepartmentManager) {
            return user.getDepartmentId() == manager.getDepartmentId();
        }

        boolean managerIsManager = managerRoles.stream()
                .anyMatch(ur -> ur.getRole().getRoleId() == MANAGER_ROLE_ID);

        if (managerIsManager) {
            return user.getDepartmentId() == manager.getDepartmentId();
        }

        return false;
    }

    @Transactional
    public void handleRoleChange(User user, int newRoleId) {
        if (newRoleId == DEPARTMENT_MANAGER_ROLE_ID) {
            updateDepartmentManager(user, user.getDepartmentId());
        } else if (newRoleId == DIRECTOR_ROLE_ID) {
            Department department = departmentRepository.findById(user.getDepartmentId()).orElse(null);
            if (department != null && department.getIdManager() != null &&
                    department.getIdManager() == user.getUserId()) {
                department.setIdManager(null);
                departmentRepository.save(department);
            }
        }

        determineAndSetManager(user);
    }
}