package com.hiutoluen.leave_management.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hiutoluen.leave_management.model.Department;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController extends BaseRBACController {

    private final DepartmentRepository departmentRepository;

    public AuthController(UserService userService, DepartmentRepository departmentRepository) {
        super(userService);
        this.departmentRepository = departmentRepository;
    }

    @GetMapping("/admin/**")
    public String handleGet(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        checkAndProcess(request, session);
        return null;
    }

    @PostMapping("/admin/**")
    public String handlePost(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        checkAndProcess(request, session);
        return null;
    }

    @GetMapping("/admin/users")
    public String adminUsersPage(Model model, HttpSession session, HttpServletRequest request) throws IOException {
        checkAndProcess(request, session);
        processGetInternal(session);
        List<User> allUsers = userService.findAllUsers();
        List<Department> departments = departmentRepository.findAll();
        List<User> users = allUsers.stream()
                .filter(user -> !("admin".equalsIgnoreCase(user.getUsername())))
                .collect(Collectors.toList());
        Map<Integer, String> managerNames = new HashMap<>();
        for (User user : allUsers) {
            managerNames.put(user.getUserId(), user.getFullName());
        }
        model.addAttribute("users", users);
        model.addAttribute("departments", departments);
        model.addAttribute("managerNames", managerNames);
        return "admin-users";
    }

    @GetMapping("/admin/users/update/{userId}")
    public String showUpdateUserForm(@PathVariable int userId, Model model, HttpSession session,
            HttpServletRequest request) throws IOException {
        checkAndProcess(request, session);
        processGetInternal(session);
        User user = userService.findByUsername(userService.findAllUsers().stream()
                .filter(u -> u.getUserId() == userId)
                .findFirst()
                .map(User::getUsername)
                .orElse(null));
        if (user == null) {
            return "redirect:/admin/users";
        }
        List<Department> departments = departmentRepository.findAll();
        Map<Integer, String> managerNames = new HashMap<>();
        for (User u : userService.findAllUsers()) {
            managerNames.put(u.getUserId(), u.getFullName());
        }
        model.addAttribute("user", user);
        model.addAttribute("departments", departments);
        model.addAttribute("managerNames", managerNames);
        return "update-user";
    }

    @PostMapping("/admin/users/update")
    public String updateUser(@ModelAttribute User user,
            @RequestParam("roleId") Integer roleId,
            @RequestParam("departmentId") Integer departmentId,
            @RequestParam("managerId") Integer managerId,
            HttpSession session, HttpServletRequest request) throws IOException {
        checkAndProcess(request, session);
        processPostInternal(session);
        User existingUser = userService.findByUsername(user.getUsername());
        if (existingUser == null || "admin".equalsIgnoreCase(existingUser.getUsername())) {
            return "redirect:/admin/users";
        }
        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setDepartmentId(departmentId);
        existingUser.setManagerId(managerId);
        userService.updateUser(existingUser, roleId);
        return "redirect:/admin/users";
    }

    @GetMapping("/admin/users/delete/{userId}")
    public String deleteUser(@PathVariable int userId, HttpSession session, HttpServletRequest request)
            throws IOException {
        checkAndProcess(request, session);
        processGetInternal(session);
        userService.deleteUserById(userId);
        return "redirect:/admin/users";
    }

    @Override
    protected void processGetInternal(HttpSession session, Object... args) {
    }

    @Override
    protected void processPostInternal(HttpSession session, Object... args) {
    }
}