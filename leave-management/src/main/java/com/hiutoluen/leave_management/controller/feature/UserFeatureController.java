package com.hiutoluen.leave_management.controller.feature;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hiutoluen.leave_management.model.Agenda;
import com.hiutoluen.leave_management.model.Department;
import com.hiutoluen.leave_management.model.LeaveRequest;
import com.hiutoluen.leave_management.model.Role;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.AgendaService;
import com.hiutoluen.leave_management.service.LeaveRequestService;
import com.hiutoluen.leave_management.service.ManagerService;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/feature")
public class UserFeatureController {
    private final UserService userService;
    private final LeaveRequestService leaveRequestService;
    private final ManagerService managerService;
    private final AgendaService agendaService;

    public UserFeatureController(UserService userService, LeaveRequestService leaveRequestService,
            ManagerService managerService, AgendaService agendaService) {
        this.userService = userService;
        this.leaveRequestService = leaveRequestService;
        this.managerService = managerService;
        this.agendaService = agendaService;
    }

    @GetMapping("/request/create")
    public String createRequestPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        model.addAttribute("user", user);
        model.addAttribute("leaveRequest", new LeaveRequest());
        return "feature/create-request";
    }

    @PostMapping("/request/create")
    public String submitCreateRequest(@Valid @ModelAttribute("leaveRequest") LeaveRequest leaveRequest,
            BindingResult result, Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (result.hasErrors()) {
            model.addAttribute("user", user);
            return "feature/create-request";
        }
        leaveRequest.setUserId(user.getUserId());
        leaveRequest.setStatus("Inprogress");
        leaveRequest.setCreatedAt(new Date());
        leaveRequest.setUpdatedAt(new Date());
        leaveRequestService.createLeaveRequest(leaveRequest);
        return "redirect:/feature/request/mylr";
    }

    @GetMapping("/request/mylr")
    public String myLeaveRequestPage(Model model, HttpSession session,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size) {
        User user = (User) session.getAttribute("currentUser");
        Pageable pageable = PageRequest.of(page, size);
        Page<LeaveRequest> myLeaveRequests = leaveRequestService.getRequestsByUserId(user.getUserId(), pageable);
        model.addAttribute("user", user);
        model.addAttribute("myLeaveRequests", myLeaveRequests);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        return "feature/my-leave-request";
    }

    @GetMapping("/request/view-subordinates")
    public String viewSubordinatesPage(Model model, HttpSession session,
            @RequestParam(value = "action", required = false) String action,
            @RequestParam(value = "requestId", required = false) Integer requestId,
            @RequestParam(value = "reason", required = false) String reason) {

        User user = (User) session.getAttribute("currentUser");

        // Handle approve/reject actions
        if (action != null && requestId != null) {
            if ("approve".equals(action)) {
                leaveRequestService.approveRequest(requestId, reason, user.getUserId());
            } else if ("reject".equals(action)) {
                leaveRequestService.rejectRequest(requestId, reason, user.getUserId());
            }
        }

        // Get all subordinates recursively
        List<User> allSubordinates = managerService.getAllSubordinatesRecursively(user.getUserId());

        // Add current user to map for processedBy (if needed)
        Map<Integer, User> userMap = new HashMap<>();
        for (User u : allSubordinates) {
            userMap.put(u.getUserId(), u);
        }
        userMap.put(user.getUserId(), user);

        // Get direct subordinates
        List<User> directSubordinates = managerService.getDirectSubordinates(user.getUserId());

        // Get subordinates by level
        Map<Integer, List<User>> subordinatesByLevel = managerService.getSubordinatesByLevel(user.getUserId());

        // Get all leave requests of subordinates
        List<LeaveRequest> subordinateRequests = leaveRequestService.getRequestsBySubordinateIds(
                allSubordinates.stream().mapToInt(User::getUserId).toArray());

        // Ensure all processedBy users are in userMap
        for (LeaveRequest req : subordinateRequests) {
            Integer processedById = req.getProcessedBy();
            if (processedById != null && !userMap.containsKey(processedById)) {
                User processedByUser = userService.findById(processedById);
                if (processedByUser != null) {
                    userMap.put(processedById, processedByUser);
                }
            }
        }

        model.addAttribute("user", user);
        model.addAttribute("allSubordinates", allSubordinates);
        model.addAttribute("userMap", userMap);
        model.addAttribute("directSubordinates", directSubordinates);
        model.addAttribute("subordinatesByLevel", subordinatesByLevel);
        model.addAttribute("subordinateRequests", subordinateRequests);

        return "feature/view-subordinates";
    }

    @GetMapping("/agenda")
    public String agendaPage(Model model, HttpSession session,
            @RequestParam(value = "action", required = false) String action,
            @RequestParam(value = "agendaId", required = false) Integer agendaId,
            @RequestParam(value = "startDate", required = false) @org.springframework.format.annotation.DateTimeFormat(pattern = "yyyy-MM-dd") java.util.Date startDate,
            @RequestParam(value = "endDate", required = false) @org.springframework.format.annotation.DateTimeFormat(pattern = "yyyy-MM-dd") java.util.Date endDate,
            @RequestParam(value = "searchName", required = false) String searchName) {

        User user = (User) session.getAttribute("currentUser");

        // Handle delete action
        if ("delete".equals(action) && agendaId != null) {
            agendaService.deleteAgenda(agendaId);
        }

        // Default date range: today to 6 days ahead
        java.util.Calendar cal = java.util.Calendar.getInstance();
        if (startDate == null) {
            startDate = cal.getTime();
        }
        if (endDate == null) {
            cal.setTime(startDate);
            cal.add(java.util.Calendar.DAY_OF_MONTH, 6);
            endDate = cal.getTime();
        }
        // Build list of dates in range, đồng thời tạo map đánh dấu ngày làm việc
        List<java.util.Date> dateList = new java.util.ArrayList<>();
        Map<Long, Boolean> workdayMap = new HashMap<>(); // key: date.getTime(), value: true nếu là ngày làm việc
        cal.setTime(startDate);
        while (!cal.getTime().after(endDate)) {
            int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            boolean isWorkday = (dayOfWeek != Calendar.SATURDAY && dayOfWeek != Calendar.SUNDAY);
            dateList.add(cal.getTime());
            workdayMap.put(cal.getTime().getTime(), isWorkday);
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }

        // Determine if user is director
        boolean isDirector = false;
        Role mainRole = userService.getMainRole(user.getUserId());
        if (mainRole != null && "Director".equalsIgnoreCase(mainRole.getRoleName())) {
            isDirector = true;
        }

        Map<Integer, Department> departmentMap = new HashMap<>();
        Map<Integer, List<User>> departmentUsersMap = new HashMap<>();
        Map<Integer, Map<Integer, Map<Long, Boolean>>> departmentUserLeaveMap = new HashMap<>(); // deptId -> userId ->
                                                                                                 // date(ms) ->
                                                                                                 // isOnLeave

        List<Department> allDepartments = userService.getAllDepartments();
        for (Department dept : allDepartments) {
            departmentMap.put(dept.getDepartmentId(), dept);
        }

        if (isDirector) {
            for (Department dept : allDepartments) {
                List<User> users = userService.searchUsers(null, searchName, null, dept.getDepartmentId(), null);
                departmentUsersMap.put(dept.getDepartmentId(), users);
                Map<Integer, Map<Long, Boolean>> userLeaveMap = new HashMap<>();
                for (User u : users) {
                    List<LeaveRequest> leaves = leaveRequestService.getRequestsByUserId(u.getUserId());
                    Map<Long, Boolean> leaveDays = new HashMap<>();
                    for (java.util.Date d : dateList) {
                        boolean onLeave = leaves.stream().anyMatch(lr -> "Approved".equalsIgnoreCase(lr.getStatus()) &&
                                !d.before(lr.getStartDate()) && !d.after(lr.getEndDate()));
                        leaveDays.put(d.getTime(), onLeave);
                    }
                    userLeaveMap.put(u.getUserId(), leaveDays);
                }
                departmentUserLeaveMap.put(dept.getDepartmentId(), userLeaveMap);
            }
        } else {
            Department dept = userService.getDepartmentById(user.getDepartmentId());
            // Get all subordinates (direct and indirect)
            List<User> allSubordinates = managerService.getAllSubordinatesRecursively(user.getUserId());
            // Filter: only those in the same department, exclude self, Director, Admin
            List<User> users = allSubordinates.stream()
                    .filter(u -> u.getDepartmentId() == user.getDepartmentId())
                    .filter(u -> u.getUserId() != user.getUserId())
                    .filter(u -> {
                        Role r = userService.getMainRole(u.getUserId());
                        return r != null && !"Director".equalsIgnoreCase(r.getRoleName())
                                && !"Admin".equalsIgnoreCase(r.getRoleName());
                    })
                    .collect(Collectors.toList());
            departmentMap.put(dept.getDepartmentId(), dept);
            departmentUsersMap.put(dept.getDepartmentId(), users);
            Map<Integer, Map<Long, Boolean>> userLeaveMap = new HashMap<>();
            for (User u : users) {
                List<LeaveRequest> leaves = leaveRequestService.getRequestsByUserId(u.getUserId());
                Map<Long, Boolean> leaveDays = new HashMap<>();
                for (java.util.Date d : dateList) {
                    boolean onLeave = leaves.stream().anyMatch(lr -> "Approved".equalsIgnoreCase(lr.getStatus()) &&
                            !d.before(lr.getStartDate()) && !d.after(lr.getEndDate()));
                    leaveDays.put(d.getTime(), onLeave);
                }
                userLeaveMap.put(u.getUserId(), leaveDays);
            }
            departmentUserLeaveMap.put(dept.getDepartmentId(), userLeaveMap);
        }

        model.addAttribute("isDirector", isDirector);
        model.addAttribute("departmentMap", departmentMap);
        model.addAttribute("departmentUsersMap", departmentUsersMap);
        model.addAttribute("departmentUserLeaveMap", departmentUserLeaveMap);
        model.addAttribute("dateList", dateList);
        model.addAttribute("searchName", searchName);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("user", user);
        model.addAttribute("workdayMap", workdayMap);
        return "feature/agenda";
    }

    @PostMapping("/agenda/create")
    public String createAgenda(@Valid @ModelAttribute("newAgenda") Agenda agenda,
            BindingResult result, Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");

        if (result.hasErrors()) {
            // Re-populate model data
            List<Agenda> allAgendas = agendaService.getAgendasByUserId(user.getUserId());
            List<Agenda> upcomingAgendas = agendaService.getUpcomingAgendas(user.getUserId());
            List<Agenda> thisWeekAgendas = agendaService.getThisWeekAgendas(user.getUserId());
            List<Agenda> thisMonthAgendas = agendaService.getThisMonthAgendas(user.getUserId());

            model.addAttribute("user", user);
            model.addAttribute("allAgendas", allAgendas);
            model.addAttribute("upcomingAgendas", upcomingAgendas);
            model.addAttribute("thisWeekAgendas", thisWeekAgendas);
            model.addAttribute("thisMonthAgendas", thisMonthAgendas);
            return "feature/agenda";
        }

        agenda.setUserId(user.getUserId());
        agendaService.createAgenda(agenda);

        return "redirect:/feature/agenda";
    }

    @GetMapping("/request/detail")
    public String requestDetailPage(@RequestParam("requestId") int requestId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        LeaveRequest leaveRequest = leaveRequestService.getRequestById(requestId);
        if (leaveRequest == null) {
            model.addAttribute("errorMessage", "Leave request not found.");
            return "error/403";
        }
        List<User> allSubordinates = managerService.getAllSubordinatesRecursively(currentUser.getUserId());
        Set<Integer> subordinateIds = allSubordinates.stream().map(User::getUserId).collect(Collectors.toSet());
        boolean isOwner = leaveRequest.getUserId() == currentUser.getUserId();
        boolean isManager = subordinateIds.contains(leaveRequest.getUserId());
        if (!isOwner && !isManager) {
            model.addAttribute("errorMessage", "You do not have permission to view this leave request.");
            return "error/403";
        }
        User createdBy = userService.findById(leaveRequest.getUserId());
        Department department = null;
        Role role = null;
        boolean isDirector = false;
        if (createdBy != null) {
            role = userService.getMainRole(createdBy.getUserId());
            if (role != null && "Director".equalsIgnoreCase(role.getRoleName())) {
                isDirector = true;
            }
            if (!isDirector) {
                department = userService.getDepartmentById(createdBy.getDepartmentId());
            }
        }
        User processedBy = null;
        Role processedRole = null;
        boolean canEditProcessed = false;
        if (leaveRequest.getProcessedBy() != null) {
            processedBy = userService.findById(leaveRequest.getProcessedBy());
            if (processedBy != null) {
                processedRole = userService.getMainRole(processedBy.getUserId());
                if (currentUser.getUserId() == processedBy.getUserId()) {
                    canEditProcessed = true;
                } else if (subordinateIds.contains(processedBy.getUserId())) {
                    canEditProcessed = true;
                }
            }
        }
        model.addAttribute("leaveRequest", leaveRequest);
        model.addAttribute("createdBy", createdBy);
        model.addAttribute("department", department);
        model.addAttribute("role", role);
        model.addAttribute("isDirector", isDirector);
        model.addAttribute("processedBy", processedBy);
        model.addAttribute("processedRole", processedRole);
        model.addAttribute("isManager", isManager);
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("canEditProcessed", canEditProcessed);
        return "feature/request-detail";
    }

    @PostMapping("/request/detail")
    public String processRequestDetail(@RequestParam("requestId") int requestId,
            @RequestParam("action") String action,
            @RequestParam("processReason") String processReason,
            HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        LeaveRequest leaveRequest = leaveRequestService.getRequestById(requestId);
        if (leaveRequest == null) {
            model.addAttribute("errorMessage", "Leave request not found.");
            return "error/403";
        }
        List<User> allSubordinates = managerService.getAllSubordinatesRecursively(currentUser.getUserId());
        Set<Integer> subordinateIds = allSubordinates.stream().map(User::getUserId).collect(Collectors.toSet());
        boolean isManager = subordinateIds.contains(leaveRequest.getUserId());
        if (!isManager) {
            model.addAttribute("errorMessage", "You do not have permission to process this leave request.");
            return "error/403";
        }
        if ("approve".equals(action)) {
            leaveRequestService.approveRequest(requestId, processReason, currentUser.getUserId());
            model.addAttribute("successMessage", "Leave request approved successfully.");
        } else if ("reject".equals(action)) {
            leaveRequestService.rejectRequest(requestId, processReason, currentUser.getUserId());
            model.addAttribute("successMessage", "Leave request rejected successfully.");
        }
        return "redirect:/feature/request/detail?requestId=" + requestId;
    }
}