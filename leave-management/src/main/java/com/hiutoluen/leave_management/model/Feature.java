package com.hiutoluen.leave_management.model;

import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "Features")
public class Feature {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "feature_id")
    private int featureId;

    @Column(name = "feature_name", nullable = false)
    private String featureName;

    @Column(name = "entrypoint")
    private String entrypoint;

    @OneToMany(mappedBy = "feature", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<RoleFeature> roleFeatures = new HashSet<>();

    // Default constructor
    public Feature() {
    }

    // Getters and Setters
    public int getFeatureId() {
        return featureId;
    }

    public void setFeatureId(int featureId) {
        this.featureId = featureId;
    }

    public String getFeatureName() {
        return featureName;
    }

    public void setFeatureName(String featureName) {
        this.featureName = featureName;
    }

    public String getEntrypoint() {
        return entrypoint;
    }

    public void setEntrypoint(String entrypoint) {
        this.entrypoint = entrypoint;
    }

    public Set<RoleFeature> getRoleFeatures() {
        return roleFeatures;
    }

    public void setRoleFeatures(Set<RoleFeature> roleFeatures) {
        this.roleFeatures = roleFeatures;
    }

    public Set<Role> getRoles() {
        Set<Role> roles = new HashSet<>();
        for (RoleFeature rf : roleFeatures) {
            if (rf.getRole() != null)
                roles.add(rf.getRole());
        }
        return roles;
    }
}