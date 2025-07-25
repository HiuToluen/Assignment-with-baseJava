package com.hiutoluen.leave_management.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.LeaveRequest;

public interface LeaveRequestRepository extends JpaRepository<LeaveRequest, Integer> {
    Page<LeaveRequest> findByUserId(int userId, Pageable pageable);
}