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

/**
 * Service class to handle user-related business logic.
 */
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

    /**
     * Finds a user by their username.
     *
     * @param username The username to search for
     * @return The User object if found, null otherwise
     */
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    /**
     * Registers a new user and assigns a default role (Employee) with a fixed salt
     * for password hashing.
     *
     * @param user The user to register
     * @return The saved User object
     * @throws IllegalArgumentException if the username is 'admin'
     */
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

        return savedUser;
    }

    /**
     * Checks if a user has permission to access a specific feature.
     *
     * @param username    The username to check
     * @param featureName The feature name to verify
     * @return True if the user has permission, false otherwise
     */
    public boolean hasPermission(String username, String featureName) {
        User user = findByUsername(username);
        if (user == null)
            return false;

        if ("admin".equalsIgnoreCase(user.getUsername())) {
            return true;
        }

        return user.getUserRoles().stream()
                .anyMatch(ur -> ur.getRole().getFeatures().stream()
                        .anyMatch(f -> f.getFeatureName().equals(featureName)));
    }

    /**
     * Retrieves all users from the database.
     *
     * @return A list of all User objects
     */
    public List<User> findAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Validates the input lists for consistency.
     *
     * @param users   The list of users with updated information
     * @param roleIds The list of role IDs corresponding to each user
     * @throws IllegalArgumentException if the sizes do not match
     */
    public void validateInputLists(List<User> users, List<Integer> roleIds) {
        if (users != null && roleIds != null && users.size() != roleIds.size()) {
            throw new IllegalArgumentException("Number of users and role IDs must match");
        }
    }

    /**
     * Updates the basic information of a user.
     *
     * @param existingUser The existing user to update
     * @param user         The user with updated information
     */
    public void updateUserInformation(User existingUser, User user) {
        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setDepartmentId(user.getDepartmentId());
        existingUser.setManagerId(user.getManagerId());
        userRepository.save(existingUser);
    }

    /**
     * Deletes existing roles for a user.
     *
     * @param userId The ID of the user whose roles are to be deleted
     */
    public void deleteExistingRoles(int userId) {
        userRoleRepository.deleteByUserId(userId);
    }

    /**
     * Assigns a new role to a user.
     *
     * @param existingUser The existing user to assign the role to
     * @param roleId       The ID of the role to assign
     * @param adminId      The ID of the admin performing the update
     */
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

    /**
     * Deletes a user by their ID.
     *
     * @param userId The ID of the user to delete
     */
    @Transactional
    public void deleteUserById(int userId) {
        // Fetch the user with minimal loading
        User user = userRepository.getReferenceById(userId); // Use proxy to avoid EAGER loading
        if (!"admin".equalsIgnoreCase(user.getUsername())) {
            // Delete all related UserRole entities first
            deleteExistingRoles(userId);
            // Flush to ensure UserRole deletions are persisted
            entityManager.flush();
            // Clear the session to remove any transient references
            entityManager.clear();
            // Delete the user
            userRepository.deleteById(userId);
        }
    }

    /**
     * Updates an existing user with new information and role.
     *
     * @param user   The user with updated information
     * @param roleId The ID of the role to assign
     * @return The updated User object
     */
    @Transactional
    public User updateUser(User user, Integer roleId) {
        User existingUser = userRepository.findById(user.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + user.getUserId()));
        if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
            throw new IllegalArgumentException("Cannot update admin user.");
        }

        updateUserInformation(existingUser, user);
        deleteExistingRoles(existingUser.getUserId());
        assignNewRole(existingUser, roleId, 1); // Default admin ID, adjust if needed
        return existingUser;
    }

    public String generateRandomPassword() {
        String randomBase = "random" + System.currentTimeMillis();
        String fixedSalt = "$2a$12$abcdefghijklmnopqrstuv";
        return BCrypt.hashpw(randomBase, fixedSalt);
    }

    /**
     * Saves updates to a list of users, including their information and roles.
     *
     * @param users   The list of users with updated information
     * @param roleIds The list of role IDs corresponding to each user
     * @param adminId The ID of the admin performing the updates
     */
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