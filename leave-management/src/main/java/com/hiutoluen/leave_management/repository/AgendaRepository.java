package com.hiutoluen.leave_management.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hiutoluen.leave_management.model.Agenda;

public interface AgendaRepository extends JpaRepository<Agenda, Integer> {

    List<Agenda> findByUserId(int userId);

    List<Agenda> findByUserIdAndDateBetween(int userId, Date startDate, Date endDate);

    @Query("SELECT a FROM Agenda a WHERE a.userId = :userId AND a.date >= :startDate ORDER BY a.date ASC")
    List<Agenda> findUpcomingAgendas(@Param("userId") int userId, @Param("startDate") Date startDate);

    @Query("SELECT a FROM Agenda a WHERE a.userId = :userId AND a.status = :status ORDER BY a.date ASC")
    List<Agenda> findByUserIdAndStatus(@Param("userId") int userId, @Param("status") String status);
}