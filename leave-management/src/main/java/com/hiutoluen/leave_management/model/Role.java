package com.hiutoluen.leave_management.model;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "Roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id")
    private int roleId;

    @Column(name = "role_name", nullable = false)
    private String roleName;

    @OneToMany(mappedBy = "role", fetch = FetchType.EAGER)
    private Set<UserRole> userRoles = new HashSet<>();

    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<RoleFeature> roleFeatures = new HashSet<>();

    // Default constructor
    public Role() {
    }

    // Getters and Setters
    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public Set<UserRole> getUserRoles() {
        return userRoles;
    }

    public void setUserRoles(Set<UserRole> userRoles) {
        this.userRoles = userRoles;
    }

    public Set<RoleFeature> getRoleFeatures() {
        return roleFeatures;
    }

    public void setRoleFeatures(Set<RoleFeature> roleFeatures) {
        this.roleFeatures = roleFeatures;
    }

    public Set<Feature> getFeatures() {
        Set<Feature> features = new HashSet<>();
        for (RoleFeature rf : roleFeatures) {
            if (rf.getFeature() != null)
                features.add(rf.getFeature());
        }
        return features;
    }
}