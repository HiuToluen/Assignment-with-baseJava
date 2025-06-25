package com.hiutoluen.leave_management.controller;

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

import jakarta.servlet.http.HttpSession;

@Controller
public class AuthAuthenticatedController {

    private final DepartmentRepository departmentRepository;
    private final UserService userService;

    public AuthAuthenticatedController(UserService userService, DepartmentRepository departmentRepository) {
        this.userService = userService;
        this.departmentRepository = departmentRepository;
    }

    @GetMapping("/home")
    public String homePage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            model.addAttribute("errorMessage", "You have not yet authenticated");
            return "error/403";
        }
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
        model.addAttribute("features", userService.getFeaturesForUser(user));
        return "home";
    }
}