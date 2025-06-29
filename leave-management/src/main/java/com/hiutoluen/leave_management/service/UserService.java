package com.hiutoluen.leave_management.service;

import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hiutoluen.leave_management.model.Department;
import com.hiutoluen.leave_management.model.Feature;
import com.hiutoluen.leave_management.model.Role;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.model.UserRole;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.repository.RoleRepository;
import com.hiutoluen.leave_management.repository.UserRepository;
import com.hiutoluen.leave_management.repository.UserRoleRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final ManagerService managerService;
    private final DepartmentRepository departmentRepository;

    @PersistenceContext
    private EntityManager entityManager;

    public UserService(UserRepository userRepository, RoleRepository roleRepository,
            UserRoleRepository userRoleRepository, ManagerService managerService,
            DepartmentRepository departmentRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
        this.managerService = managerService;
        this.departmentRepository = departmentRepository;
    }

    public User findByUsername(String username) {
        User user = userRepository.findByUsername(username);
        if (user != null && !"admin".equalsIgnoreCase(user.getUsername())) {
            managerService.determineAndSetManager(user);
        }
        return user;
    }

    public User findByEmail(String email) {
        User user = userRepository.findByEmail(email);
        if (user != null && !"admin".equalsIgnoreCase(user.getUsername())) {
            managerService.determineAndSetManager(user);
        }
        return user;
    }

    @Transactional
    public User registerUser(User user) {
        if ("admin".equalsIgnoreCase(user.getUsername())) {
            throw new IllegalArgumentException("Username 'admin' is reserved.");
        }
        String fixedSalt = "$2a$12$abcdefghijklmnopqrstuv";
        user.setPassword(BCrypt.hashpw(user.getPassword(), fixedSalt));
        User savedUser = userRepository.save(user);
        Role role = roleRepository.findById(1).orElseThrow(() -> new RuntimeException("Role not found"));
        UserRole userRole = new UserRole();
        userRole.setUser(savedUser);
        userRole.setRole(role);
        userRole.setAssignedBy(1);
        userRole.setAssignedAt(new Date());
        userRoleRepository.save(userRole);

        managerService.determineAndSetManager(savedUser);

        return savedUser;
    }

    public boolean hasPermission(String username, String featureName) {
        User user = findByUsername(username);
        if (user == null)
            return false;
        if ("admin".equalsIgnoreCase(user.getUsername())) {
            return true;
        }
        if (user.getUserRoles() == null || user.getUserRoles().isEmpty()) {
            List<UserRole> roles = userRoleRepository.findByUser_UserId(user.getUserId());
            if (roles != null && !roles.isEmpty()) {
                user.setUserRoles(new HashSet<>(roles));
            }
        }

        List<UserRole> userRolesWithFeatures = entityManager.createQuery(
                "SELECT ur FROM UserRole ur " +
                        "JOIN FETCH ur.role r " +
                        "LEFT JOIN FETCH r.roleFeatures rf " +
                        "LEFT JOIN FETCH rf.feature " +
                        "WHERE ur.user = :user",
                UserRole.class)
                .setParameter("user", user)
                .getResultList();

        return userRolesWithFeatures.stream()
                .flatMap(ur -> ur.getRole().getFeatures().stream())
                .anyMatch(feature -> {
                    String entry = feature.getEntrypoint();
                    if (entry != null && !entry.startsWith("/feature/") && !entry.startsWith("/admin/")) {
                        entry = "/feature" + entry;
                    }
                    return entry != null && entry.equals(featureName);
                });
    }

    public List<User> findAllUsers() {
        List<User> users = userRepository.findAll();
        for (User user : users) {
            if (!"admin".equalsIgnoreCase(user.getUsername())) {
                managerService.determineAndSetManager(user);
            }
        }
        return users;
    }

    public void validateInputLists(List<User> users, List<Integer> roleIds) {
        if (users != null && roleIds != null && users.size() != roleIds.size()) {
            throw new IllegalArgumentException("Number of users and role IDs must match");
        }
    }

    public void updateUserInformation(User existingUser, User user) {
        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setDepartmentId(user.getDepartmentId());
        existingUser.setManagerId(user.getManagerId());
        userRepository.save(existingUser);
    }

    public void deleteExistingRoles(int userId) {
        userRoleRepository.deleteByUserId(userId);
    }

    public void assignNewRole(User existingUser, Integer roleId, int adminId) {
        if (roleId != null) {
            Role role = roleRepository.findById(roleId)
                    .orElseThrow(() -> new RuntimeException("Role not found with ID: " + roleId));
            UserRole userRole = new UserRole();
            userRole.setUser(existingUser);
            userRole.setRole(role);
            userRole.setAssignedBy(adminId);
            userRole.setAssignedAt(new Date());
            userRoleRepository.save(userRole);
        }
    }

    @Transactional
    public void deleteUserById(int userId) {
        User user = userRepository.getReferenceById(userId);
        if (!"admin".equalsIgnoreCase(user.getUsername())) {
            deleteExistingRoles(userId);
            entityManager.flush();
            entityManager.clear();
            userRepository.deleteById(userId);
        }
    }

    @Transactional
    public User updateUser(User user, Integer roleId) {
        User existingUser = userRepository.findById(user.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + user.getUserId()));
        if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
            throw new IllegalArgumentException("Cannot update admin user.");
        }

        int oldDepartmentId = existingUser.getDepartmentId();
        List<UserRole> oldUserRoles = userRoleRepository.findByUser_UserId(existingUser.getUserId());
        Integer oldRoleId = oldUserRoles.isEmpty() ? null : oldUserRoles.get(0).getRole().getRoleId();

        updateUserInformation(existingUser, user);
        deleteExistingRoles(existingUser.getUserId());
        assignNewRole(existingUser, roleId, 1);

        if (roleId != null && !roleId.equals(oldRoleId)) {
            if (roleId == 3) {
                managerService.updateDepartmentManager(existingUser, user.getDepartmentId());
            } else if (oldRoleId != null && oldRoleId == 3) {
                Department oldDept = departmentRepository.findById(oldDepartmentId).orElse(null);
                if (oldDept != null && oldDept.getIdManager() != null &&
                        oldDept.getIdManager() == existingUser.getUserId()) {
                    oldDept.setIdManager(null);
                    departmentRepository.save(oldDept);
                }
            }
            managerService.handleRoleChange(existingUser, roleId);
        } else if (user.getDepartmentId() != oldDepartmentId) {
            if (oldRoleId != null && oldRoleId == 3) {
                Department oldDept = departmentRepository.findById(oldDepartmentId).orElse(null);
                if (oldDept != null && oldDept.getIdManager() != null &&
                        oldDept.getIdManager() == existingUser.getUserId()) {
                    oldDept.setIdManager(null);
                    departmentRepository.save(oldDept);
                }
            }
            if (roleId != null && roleId == 3) {
                managerService.updateDepartmentManager(existingUser, user.getDepartmentId());
            }
            managerService.determineAndSetManager(existingUser);
        }

        return existingUser;
    }

    public String generateRandomPassword() {
        String randomBase = "google" + System.currentTimeMillis();
        String fixedSalt = "$2a$12$abcdefghijklmnopqrstuv";
        return BCrypt.hashpw(randomBase, fixedSalt);
    }

    @Transactional
    public void saveUserUpdates(List<User> users, List<Integer> roleIds, int adminId) {
        validateInputLists(users, roleIds);
        if (users != null) {
            for (int i = 0; i < users.size(); i++) {
                User user = users.get(i);
                if (user.getUserId() == 0 || user == null)
                    continue;
                User existingUser = userRepository.findById(user.getUserId())
                        .orElseThrow(() -> new RuntimeException("User not found with ID: " + user.getUserId()));
                if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
                    continue;
                }
                updateUserInformation(existingUser, user);
                deleteExistingRoles(existingUser.getUserId());
                assignNewRole(existingUser, roleIds != null ? roleIds.get(i) : null, adminId);
            }
        }
    }

    /**
     * Lấy danh sách feature (menu) động mà user được phép truy cập
     */
    @Transactional
    public Set<Feature> getFeaturesForUser(User user) {
        Set<Feature> features = new HashSet<>();
        if (user == null)
            return features;
        if ("admin".equalsIgnoreCase(user.getUsername())) {
            List<Role> allRoles = entityManager.createQuery(
                    "SELECT r FROM Role r " +
                            "LEFT JOIN FETCH r.roleFeatures rf " +
                            "LEFT JOIN FETCH rf.feature",
                    Role.class)
                    .getResultList();
            for (Role role : allRoles) {
                features.addAll(role.getFeatures());
            }
            return features;
        }

        List<UserRole> userRolesWithFeatures = entityManager.createQuery(
                "SELECT ur FROM UserRole ur " +
                        "JOIN FETCH ur.role r " +
                        "LEFT JOIN FETCH r.roleFeatures rf " +
                        "LEFT JOIN FETCH rf.feature " +
                        "WHERE ur.user = :user",
                UserRole.class)
                .setParameter("user", user)
                .getResultList();

        for (UserRole ur : userRolesWithFeatures) {
            features.addAll(ur.getRole().getFeatures());
        }
        return features;
    }

    public List<User> searchUsers(String username, String fullName, String email, Integer departmentId,
            Integer roleId) {
        List<User> users = userRepository.searchUsers(
                (username == null || username.isBlank()) ? null : username,
                (fullName == null || fullName.isBlank()) ? null : fullName,
                (email == null || email.isBlank()) ? null : email,
                departmentId,
                roleId);

        for (User user : users) {
            if (!"admin".equalsIgnoreCase(user.getUsername())) {
                managerService.determineAndSetManager(user);
            }
        }
        return users;
    }

    /**
     * Validate and update manager assignments for all users
     * This method should be called when loading data or periodically
     */
    @Transactional
    public void validateManagerAssignments() {
        managerService.validateAndUpdateAllManagers();
    }

    /**
     * Get user with validated manager assignment
     *
     * @param username The username to find
     * @return User with validated manager
     */
    public User findByUsernameWithValidatedManager(String username) {
        User user = findByUsername(username);
        if (user != null && !"admin".equalsIgnoreCase(user.getUsername())) {
            managerService.determineAndSetManager(user);
        }
        return user;
    }

    @Transactional
    public void refreshAllManagerAssignments() {
        List<User> allUsers = userRepository.findAll();
        for (User user : allUsers) {
            if (!"admin".equalsIgnoreCase(user.getUsername())) {
                managerService.determineAndSetManager(user);
            }
        }
    }

    public User findById(int userId) {
        return userRepository.findById(userId).orElse(null);
    }

    public Department getDepartmentById(int departmentId) {
        return departmentRepository.findById(departmentId).orElse(null);
    }

    public Role getMainRole(int userId) {
        List<UserRole> userRoles = userRoleRepository.findByUser_UserId(userId);
        if (userRoles != null && !userRoles.isEmpty()) {
            return userRoles.get(0).getRole();
        }
        return null;
    }

    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }
}