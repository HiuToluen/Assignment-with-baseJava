package com.hiutoluen.leave_management.service;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.hiutoluen.leave_management.model.LeaveRequest;
import com.hiutoluen.leave_management.repository.LeaveRequestRepository;

@Service
public class LeaveRequestService {
    private final LeaveRequestRepository leaveRequestRepository;

    public LeaveRequestService(LeaveRequestRepository leaveRequestRepository) {
        this.leaveRequestRepository = leaveRequestRepository;
    }

    public LeaveRequest createLeaveRequest(LeaveRequest leaveRequest) {
        return leaveRequestRepository.save(leaveRequest);
    }

    public List<LeaveRequest> getRequestsByUserId(int userId) {
        return leaveRequestRepository.findAll()
                .stream()
                .filter(r -> r.getUserId() == userId)
                .toList();
    }

    /**
     * Update leave request status (approve/reject)
     */
    public LeaveRequest updateRequestStatus(int requestId, String status, int processedBy, String processedReason) {
        try {
            LeaveRequest request = leaveRequestRepository.findById(requestId).orElse(null);
            if (request != null) {
                request.setStatus(status);
                request.setProcessedBy(processedBy);
                request.setProcessedReason(processedReason);
                request.setUpdatedAt(new Date());
                return leaveRequestRepository.save(request);
            }
            return null;
        } catch (Exception e) {
            System.err.println("Error updating request status: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Approve a leave request
     */
    public LeaveRequest approveRequest(Integer requestId, String reason, int processedBy) {
        return updateRequestStatus(requestId, "Approved", processedBy, reason);
    }

    /**
     * Reject a leave request
     */
    public LeaveRequest rejectRequest(Integer requestId, String reason, int processedBy) {
        return updateRequestStatus(requestId, "Rejected", processedBy, reason);
    }

    /**
     * Get leave requests by subordinate IDs
     */
    public List<LeaveRequest> getRequestsBySubordinateIds(int[] subordinateIds) {
        return leaveRequestRepository.findAll()
                .stream()
                .filter(request -> {
                    for (int id : subordinateIds) {
                        if (request.getUserId() == id) {
                            return true;
                        }
                    }
                    return false;
                })
                .toList();
    }

    public LeaveRequest getRequestById(int requestId) {
        return leaveRequestRepository.findById(requestId).orElse(null);
    }
}