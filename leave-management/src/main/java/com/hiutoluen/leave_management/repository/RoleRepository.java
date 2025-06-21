package com.hiutoluen.leave_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.Role;

public interface RoleRepository extends JpaRepository<Role, Integer> {
}