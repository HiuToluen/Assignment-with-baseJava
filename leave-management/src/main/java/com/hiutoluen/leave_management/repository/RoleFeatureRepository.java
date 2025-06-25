package com.hiutoluen.leave_management.repository;

import com.hiutoluen.leave_management.model.RoleFeature;
import com.hiutoluen.leave_management.model.RoleFeatureId;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface RoleFeatureRepository extends JpaRepository<RoleFeature, RoleFeatureId> {
    List<RoleFeature> findByRoleRoleId(Integer roleId);

    List<RoleFeature> findByFeatureFeatureId(Integer featureId);
}