package com.hiutoluen.leave_management.service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hiutoluen.leave_management.model.Agenda;
import com.hiutoluen.leave_management.repository.AgendaRepository;

@Service
public class AgendaService {

    private final AgendaRepository agendaRepository;

    public AgendaService(AgendaRepository agendaRepository) {
        this.agendaRepository = agendaRepository;
    }

    @Transactional
    public Agenda createAgenda(Agenda agenda) {
        return agendaRepository.save(agenda);
    }

    @Transactional
    public Agenda updateAgenda(Agenda agenda) {
        return agendaRepository.save(agenda);
    }

    @Transactional
    public void deleteAgenda(int agendaId) {
        agendaRepository.deleteById(agendaId);
    }

    public Agenda getAgendaById(int agendaId) {
        return agendaRepository.findById(agendaId).orElse(null);
    }

    public List<Agenda> getAgendasByUserId(int userId) {
        return agendaRepository.findByUserId(userId);
    }

    public List<Agenda> getUpcomingAgendas(int userId) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date today = calendar.getTime();

        return agendaRepository.findUpcomingAgendas(userId, today);
    }

    public List<Agenda> getAgendasByDateRange(int userId, Date startDate, Date endDate) {
        return agendaRepository.findByUserIdAndDateBetween(userId, startDate, endDate);
    }

    public List<Agenda> getAgendasByStatus(int userId, String status) {
        return agendaRepository.findByUserIdAndStatus(userId, status);
    }

    public List<Agenda> getThisWeekAgendas(int userId) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, calendar.getFirstDayOfWeek());
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date weekStart = calendar.getTime();

        calendar.add(Calendar.DAY_OF_WEEK, 6);
        Date weekEnd = calendar.getTime();

        return agendaRepository.findByUserIdAndDateBetween(userId, weekStart, weekEnd);
    }

    public List<Agenda> getThisMonthAgendas(int userId) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date monthStart = calendar.getTime();

        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
        Date monthEnd = calendar.getTime();

        return agendaRepository.findByUserIdAndDateBetween(userId, monthStart, monthEnd);
    }
}