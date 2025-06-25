package com.hiutoluen.leave_management.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hiutoluen.leave_management.model.User;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findByUsername(String username);

    User findByEmail(String email);

    @Query("SELECT DISTINCT u FROM User u LEFT JOIN u.userRoles ur LEFT JOIN ur.role r " +
            "WHERE (:username IS NULL OR u.username LIKE %:username%) " +
            "AND (:fullName IS NULL OR u.fullName LIKE %:fullName%) " +
            "AND (:email IS NULL OR u.email LIKE %:email%) " +
            "AND (:departmentId IS NULL OR u.departmentId = :departmentId) " +
            "AND (:roleId IS NULL OR r.roleId = :roleId)")
    List<User> searchUsers(@Param("username") String username,
            @Param("fullName") String fullName,
            @Param("email") String email,
            @Param("departmentId") Integer departmentId,
            @Param("roleId") Integer roleId);
}