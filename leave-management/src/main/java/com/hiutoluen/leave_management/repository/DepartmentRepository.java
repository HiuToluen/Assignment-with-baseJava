package com.hiutoluen.leave_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.Department;

public interface DepartmentRepository extends JpaRepository<Department, Integer> {
}