package com.hiutoluen.leave_management.model;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
@Table(name = "Access_Scope")
public class AccessScope {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "access_id")
    private int accessId;

    @Column(name = "accessor_id", nullable = false)
    private int accessorId;

    @Column(name = "target_user_id")
    private Integer targetUserId;

    @Column(name = "target_department_id")
    private Integer targetDepartmentId;

    @Column(name = "permission_type", nullable = false)
    private String permissionType;

    @Column(name = "expiry_date")
    @Temporal(TemporalType.DATE)
    private Date expiryDate;

    // Default constructor
    public AccessScope() {
    }

    // Getters and Setters
    public int getAccessId() {
        return accessId;
    }

    public void setAccessId(int accessId) {
        this.accessId = accessId;
    }

    public int getAccessorId() {
        return accessorId;
    }

    public void setAccessorId(int accessorId) {
        this.accessorId = accessorId;
    }

    public Integer getTargetUserId() {
        return targetUserId;
    }

    public void setTargetUserId(Integer targetUserId) {
        this.targetUserId = targetUserId;
    }

    public Integer getTargetDepartmentId() {
        return targetDepartmentId;
    }

    public void setTargetDepartmentId(Integer targetDepartmentId) {
        this.targetDepartmentId = targetDepartmentId;
    }

    public String getPermissionType() {
        return permissionType;
    }

    public void setPermissionType(String permissionType) {
        this.permissionType = permissionType;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
}