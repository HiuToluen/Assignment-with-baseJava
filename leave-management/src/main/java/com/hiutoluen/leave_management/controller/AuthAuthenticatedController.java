package com.hiutoluen.leave_management.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.hiutoluen.leave_management.model.Department;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthAuthenticatedController extends BaseAuthenticationController {

    private final DepartmentRepository departmentRepository;
    private final UserService userService;

    public AuthAuthenticatedController(UserService userService, DepartmentRepository departmentRepository) {
        super(userService);
        this.userService = userService;
        this.departmentRepository = departmentRepository;
    }

    @GetMapping("/home")
    public String homePage(Model model, HttpSession session) {
        User user = getCurrentUser(session);
        model.addAttribute("user", user);
        List<Department> departments = departmentRepository.findAll();
        if (departments == null) {
            departments = List.of();
        }
        Map<Integer, String> managerNames = new HashMap<>();
        for (User u : userService.findAllUsers()) {
            managerNames.put(u.getUserId(), u.getFullName());
        }
        model.addAttribute("departments", departments);
        model.addAttribute("managerNames", managerNames);
        model.addAttribute("canCreateRequest", true);
        model.addAttribute("canViewSubordinates", false);
        model.addAttribute("canViewAgenda", true);
        model.addAttribute("canManageUsers", false);
        return "home";
    }

    @Override
    protected void processGet(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'processGet'");
    }

    @Override
    protected void processPost(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'processPost'");
    }
}