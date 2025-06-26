package com.hiutoluen.leave_management.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.hiutoluen.leave_management.model.UserRole;

public interface UserRoleRepository extends JpaRepository<UserRole, Integer> {
    @Modifying
    @Transactional
    @Query("DELETE FROM UserRole ur WHERE ur.user.id = ?1")
    void deleteByUserId(int userId);

    List<UserRole> findByUser_UserId(int userId);

    // Find user roles by role ID
    List<UserRole> findByRole_RoleId(int roleId);
}