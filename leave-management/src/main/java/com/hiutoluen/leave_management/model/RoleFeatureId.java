package com.hiutoluen.leave_management.model;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public class RoleFeatureId implements Serializable {
    @Column(name = "role_id")
    private Integer roleId;
    @Column(name = "feature_id")
    private Integer featureId;

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public Integer getFeatureId() {
        return featureId;
    }

    public void setFeatureId(Integer featureId) {
        this.featureId = featureId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        RoleFeatureId that = (RoleFeatureId) o;
        return Objects.equals(roleId, that.roleId) && Objects.equals(featureId, that.featureId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(roleId, featureId);
    }
}