package com.hiutoluen.leave_management.service;

import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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
        // Don't call determineAndSetManager as it will override manually set manager
        // IDs
        // for (User user : users) {
        // if (!"admin".equalsIgnoreCase(user.getUsername())) {
        // managerService.determineAndSetManager(user);
        // }
        // }
        return users;
    }

    /**
     * Load users for admin pages without overriding manually set manager IDs
     */
    public List<User> findAllUsersForAdmin() {
        return userRepository.findAll();
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
    public User updateUser(User user, Integer roleId, int adminUserId) {
        User existingUser = userRepository.findById(user.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + user.getUserId()));
        if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
            throw new IllegalArgumentException("Cannot update admin user.");
        }

        int oldDepartmentId = existingUser.getDepartmentId();
        List<UserRole> oldUserRoles = userRoleRepository.findByUser_UserId(existingUser.getUserId());
        Integer oldRoleId = oldUserRoles.isEmpty() ? null : oldUserRoles.get(0).getRole().getRoleId();

        updateUserInformation(existingUser, user);

        // After updating department, check manager validity
        if (existingUser.getManagerId() != null) {
            User manager = userRepository.findById(existingUser.getManagerId()).orElse(null);
            if (manager != null) {
                Role managerRole = getMainRole(manager.getUserId());
                boolean isManagerDirector = managerRole != null
                        && "Director".equalsIgnoreCase(managerRole.getRoleName());
                boolean isSameDepartment = manager.getDepartmentId() == existingUser.getDepartmentId();
                if (!(isManagerDirector || isSameDepartment)) {
                    existingUser.setManagerId(null);
                }
            } else {
                existingUser.setManagerId(null);
            }
        }

        deleteExistingRoles(existingUser.getUserId());
        assignNewRole(existingUser, roleId, adminUserId);

        boolean departmentChanged = user.getDepartmentId() != oldDepartmentId;
        boolean roleChanged = (roleId != null && !roleId.equals(oldRoleId));

        if (roleChanged) {
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
        } else if (departmentChanged) {
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

        // Update all subordinates' manager assignments if department or role changed
        if (departmentChanged || roleChanged) {
            managerService.updateSubordinatesManagerAssignments(existingUser.getUserId());
        }

        return existingUser;
    }

    @Transactional
    public User updateUserManager(User user, int adminUserId) {
        User existingUser = userRepository.findById(user.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + user.getUserId()));
        if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
            throw new IllegalArgumentException("Cannot update admin user.");
        }

        System.out.println("DEBUG: UserService - Before update, manager ID: " + existingUser.getManagerId());
        System.out.println("DEBUG: UserService - New manager ID to set: " + user.getManagerId());

        // Update only manager
        existingUser.setManagerId(user.getManagerId());
        User savedUser = userRepository.save(existingUser);

        System.out.println("DEBUG: UserService - After save, manager ID: " + savedUser.getManagerId());

        // Don't call determineAndSetManager as it will override the manually set
        // managerId
        // managerService.determineAndSetManager(existingUser);

        return savedUser;
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

        // Don't call determineAndSetManager as it will override manually set manager
        // IDs
        // for (User user : users) {
        // if (!"admin".equalsIgnoreCase(user.getUsername())) {
        // managerService.determineAndSetManager(user);
        // }
        // }
        return users;
    }

    public Page<User> searchUsers(String username, String fullName, String email, Integer departmentId, Integer roleId,
            Pageable pageable) {
        return userRepository.searchUsers(
                (username == null || username.isBlank()) ? null : username,
                (fullName == null || fullName.isBlank()) ? null : fullName,
                (email == null || email.isBlank()) ? null : email,
                departmentId,
                roleId,
                pageable);
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

    public Page<User> getUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    /**
     * Find the current Department Manager for a given department.
     * 
     * @param departmentId the department ID
     * @return the User who is the Department Manager, or null if none
     */
    public User findCurrentDepartmentManager(int departmentId) {
        Department dept = departmentRepository.findById(departmentId).orElse(null);
        if (dept != null && dept.getIdManager() != null) {
            return userRepository.findById(dept.getIdManager()).orElse(null);
        }
        List<UserRole> managers = userRoleRepository.findByRole_RoleId(3); // 3 = Department Manager
        for (UserRole ur : managers) {
            if (ur.getUser().getDepartmentId() == departmentId) {
                return ur.getUser();
            }
        }
        return null;
    }

    /**
     * Find the current Director in the system.
     * 
     * @return the User who is the Director, or null if none
     */
    public User findCurrentDirector() {
        List<UserRole> directors = userRoleRepository.findByRole_RoleId(4); // 4 = Director
        if (!directors.isEmpty()) {
            return directors.get(0).getUser();
        }
        return null;
    }
}