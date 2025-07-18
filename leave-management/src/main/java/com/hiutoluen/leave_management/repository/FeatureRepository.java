package com.hiutoluen.leave_management.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.Feature;

public interface FeatureRepository extends JpaRepository<Feature, Integer> {
    Page<Feature> findAll(Pageable pageable);
}