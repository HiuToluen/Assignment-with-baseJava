package com.hiutoluen.leave_management.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hiutoluen.leave_management.model.Agenda;

public interface AgendaRepository extends JpaRepository<Agenda, Integer> {
}