package com.hiutoluen.leave_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.AccessScope;

public interface AccessScopeRepository extends JpaRepository<AccessScope, Integer> {
}