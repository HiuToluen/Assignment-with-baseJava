package com.hiutoluen.leave_management.service;

import java.util.Date;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hiutoluen.leave_management.model.Role;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.model.UserRole;
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

    @PersistenceContext
    private EntityManager entityManager;

    public UserService(UserRepository userRepository, RoleRepository roleRepository,
            UserRoleRepository userRoleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.userRoleRepository = userRoleRepository;
    }

    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Transactional
    public User registerUser(User user) {
        if ("admin".equalsIgnoreCase(user.getUsername())) {
            throw new IllegalArgumentException("Username 'admin' is reserved.");
        }
        String fixedSalt = "$2a$12$abcdefghijklmnopqrstuv";
        user.setPassword(BCrypt.hashpw(user.getPassword(), fixedSalt));
        User savedUser = userRepository.save(user);

        // Gán vai trò mặc định (ví dụ: Employee, ID 1)
        Role role = roleRepository.findById(1).orElseThrow(() -> new RuntimeException("Role not found"));
        UserRole userRole = new UserRole();
        userRole.setUser(savedUser);
        userRole.setRole(role);
        userRole.setAssignedBy(1);
        userRole.setAssignedAt(new Date());
        userRoleRepository.save(userRole);

        return savedUser;
    }

    public boolean hasPermission(String username, String featureName) {
        User user = findByUsername(username);
        if (user == null)
            return false;

        // Kiểm tra nếu là admin
        if ("admin".equalsIgnoreCase(user.getUsername())) {
            return true;
        }

        // Kiểm tra quyền dựa trên vai trò
        return user.getUserRoles().stream()
                .flatMap(ur -> ur.getRole().getFeatures().stream())
                .anyMatch(feature -> feature.getFeatureName().equals(featureName));
    }

    public List<User> findAllUsers() {
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
    public User updateUser(User user, Integer roleId) {
        User existingUser = userRepository.findById(user.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + user.getUserId()));
        if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
            throw new IllegalArgumentException("Cannot update admin user.");
        }

        updateUserInformation(existingUser, user);
        deleteExistingRoles(existingUser.getUserId());
        assignNewRole(existingUser, roleId, 1);
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
}