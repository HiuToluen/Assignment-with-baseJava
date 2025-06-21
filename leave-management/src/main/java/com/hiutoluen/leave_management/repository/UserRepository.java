package com.hiutoluen.leave_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.User;

public interface UserRepository extends JpaRepository<User, Integer> {
    User findByUsername(String username);
}