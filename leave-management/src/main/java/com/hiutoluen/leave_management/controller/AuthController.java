package com.hiutoluen.leave_management.controller;

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
import com.hiutoluen.leave_management.model.Role;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {

    private final DepartmentRepository departmentRepository;
    private final UserService userService;

    public AuthController(UserService userService, DepartmentRepository departmentRepository) {
        this.userService = userService;
        this.departmentRepository = departmentRepository;
    }

    @GetMapping("/admin/users")
    public String adminUsersPage(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) Integer departmentId,
            @RequestParam(required = false) Integer roleId,
            Model model, HttpSession session) {
        // Đảm bảo đồng bộ lại managerId trước khi hiển thị
        userService.validateManagerAssignments();
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/users")) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        List<User> users = userService.searchUsers(username, fullName, email, departmentId, roleId)
                .stream().filter(u -> !("admin".equalsIgnoreCase(u.getUsername()))).collect(Collectors.toList());
        List<Department> departments = departmentRepository.findAll();
        Map<Integer, String> managerNames = new HashMap<>();
        for (User u : userService.findAllUsersForAdmin()) {
            managerNames.put(u.getUserId(), u.getFullName());
        }
        model.addAttribute("users", users);
        model.addAttribute("departments", departments);
        model.addAttribute("managerNames", managerNames);
        model.addAttribute("username", username);
        model.addAttribute("fullName", fullName);
        model.addAttribute("email", email);
        model.addAttribute("departmentId", departmentId);
        model.addAttribute("roleId", roleId);
        return "admin-users";
    }

    @GetMapping("/admin/users/update/{userId}")
    public String showUpdateUserForm(@PathVariable int userId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/users/update/" + userId)) {
            throw new SecurityException("You do not have permission to access this feature");
        }

        User u = userService.findById(userId);
        if (u == null) {
            return "redirect:/admin/users";
        }

        List<Department> departments = departmentRepository.findAll();
        Map<Integer, String> managerNames = new HashMap<>();
        for (User use : userService.findAllUsers()) {
            managerNames.put(use.getUserId(), use.getFullName());
        }
        model.addAttribute("user", u);
        model.addAttribute("departments", departments);
        model.addAttribute("managerNames", managerNames);
        return "update-user";
    }

    @PostMapping("/admin/users/update")
    public String updateUser(@ModelAttribute User user,
            @RequestParam("roleId") Integer roleId,
            HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        if (!userService.hasPermission(currentUser.getUsername(), "/admin/users/update")) {
            throw new SecurityException("You do not have permission to access this feature");
        }

        User existingUser = userService.findById(user.getUserId());
        if (existingUser == null || "admin".equalsIgnoreCase(existingUser.getUsername())) {
            return "redirect:/admin/users";
        }

        existingUser.setFullName(user.getFullName());
        existingUser.setEmail(user.getEmail());
        existingUser.setDepartmentId(user.getDepartmentId());
        existingUser.setManagerId(user.getManagerId());
        userService.updateUser(existingUser, roleId, currentUser.getUserId());
        return "redirect:/admin/users";
    }

    @GetMapping("/admin/users/update-manager/{userId}")
    public String showUpdateManagerForm(@PathVariable int userId, Model model, HttpSession session) {
        User user = userService.findById(userId);
        Role mainRole = userService.getMainRole(user.getUserId());
        boolean isDirector = mainRole != null && mainRole.getRoleName().equalsIgnoreCase("Director");

        Map<Integer, String> managerNames = new HashMap<>();
        if (!isDirector) {
            for (User u : userService.findAllUsersForAdmin()) {
                if (u.getUserId() == user.getUserId())
                    continue;
                if ("admin".equalsIgnoreCase(u.getUsername()))
                    continue;
                Role uRole = userService.getMainRole(u.getUserId());
                if (uRole == null)
                    continue;
                String roleName = uRole.getRoleName();
                // Only allow Director (any department) or Manager/Department Manager in the
                // same department
                if (("Director".equalsIgnoreCase(roleName)) ||
                        (("Manager".equalsIgnoreCase(roleName) || "Department Manager".equalsIgnoreCase(roleName))
                                && u.getDepartmentId() == user.getDepartmentId())) {
                    managerNames.put(u.getUserId(), u.getFullName());
                }
            }
        }
        // If Director, no manager

        model.addAttribute("user", user);
        model.addAttribute("managerNames", managerNames);
        model.addAttribute("isDirector", isDirector);
        return "update-manager";
    }

    @PostMapping("/admin/users/update-manager")
    public String updateUserManager(@RequestParam("userId") Integer userId,
            @RequestParam("managerId") Integer managerId,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        if (!userService.hasPermission(currentUser.getUsername(), "/admin/users/update")) {
            throw new SecurityException("You do not have permission to access this feature");
        }

        System.out.println("DEBUG: Updating manager for user ID: " + userId + " to manager ID: " + managerId);

        User existingUser = userService.findById(userId);
        if (existingUser == null || "admin".equalsIgnoreCase(existingUser.getUsername())) {
            return "redirect:/admin/users";
        }

        System.out.println("DEBUG: Current manager ID: " + existingUser.getManagerId());

        // Update only manager
        existingUser.setManagerId(managerId);
        userService.updateUserManager(existingUser, currentUser.getUserId());

        System.out.println("DEBUG: After update, manager ID: " + existingUser.getManagerId());

        return "redirect:/admin/users";
    }

    @GetMapping("/admin/users/delete/{userId}")
    public String deleteUser(@PathVariable int userId, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/users/delete/" + userId)) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        userService.deleteUserById(userId);
        return "redirect:/admin/users";
    }
}