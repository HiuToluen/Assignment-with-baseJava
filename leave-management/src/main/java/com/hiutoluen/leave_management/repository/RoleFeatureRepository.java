package com.hiutoluen.leave_management.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.hiutoluen.leave_management.model.RoleFeature;
import com.hiutoluen.leave_management.model.RoleFeatureId;

public interface RoleFeatureRepository extends JpaRepository<RoleFeature, RoleFeatureId> {
    List<RoleFeature> findByRoleRoleId(Integer roleId);

    List<RoleFeature> findByFeatureFeatureId(Integer featureId);

    @Modifying
    @Transactional
    @Query("DELETE FROM RoleFeature rf WHERE rf.role.roleId = ?1 AND rf.feature.featureId = ?2")
    void deleteByRole_RoleIdAndFeature_FeatureId(Integer roleId, Integer featureId);

    Page<RoleFeature> findAll(Pageable pageable);
}