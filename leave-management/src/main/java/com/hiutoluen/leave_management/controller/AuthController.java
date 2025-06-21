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
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;

/**
 * Controller to handle authentication, home page, and user management
 * functionalities.
 */
@Controller
public class AuthController extends BaseRBACController {

    private final DepartmentRepository departmentRepository;

    /**
     * Constructs a new AuthController with the required dependencies.
     *
     * @param userService          The service to handle user-related business logic
     * @param departmentRepository The repository to handle department-related data
     */

    public AuthController(UserService userService, DepartmentRepository departmentRepository) {
        super(userService);
        this.departmentRepository = departmentRepository;
    }

    /**
     * Displays the home page with functionalities based on user roles.
     *
     * @param model   The model to add attributes for the view
     * @param session The HTTP session to check the logged-in user
     * @return The view name for the home page
     */
    @GetMapping("/home")
    public String homePage(Model model, HttpSession session) {
        processGetInternal(session);
        List<Department> departments = departmentRepository.findAll();
        if (departments == null) {
            departments = List.of();
        }
        Map<Integer, String> managerNames = new HashMap<>();
        for (User user : userService.findAllUsers()) {
            managerNames.put(user.getUserId(), user.getFullName());
        }
        model.addAttribute("departments", departments);
        model.addAttribute("managerNames", managerNames);

        boolean canCreateRequest = true;
        boolean canViewSubordinates = userService.hasPermission(getCurrentUser(session).getUsername(),
                "/request/view-subordinates");
        boolean canViewAgenda = true;
        boolean canManageUsers = userService.hasPermission(getCurrentUser(session).getUsername(), "/admin/users");

        model.addAttribute("canCreateRequest", canCreateRequest);
        model.addAttribute("canViewSubordinates", canViewSubordinates);
        model.addAttribute("canViewAgenda", canViewAgenda);
        model.addAttribute("canManageUsers", canManageUsers);

        return "home";
    }

    @Override
    protected void processGetInternal(HttpSession session, Object... args) {
    }

    @Override
    protected void processPostInternal(HttpSession session, Object... args) {
    }

    /**
     * Displays the admin users management page.
     *
     * @param model   The model to add attributes for the view
     * @param session The HTTP session to check the logged-in user
     * @return The view name for the admin users page
     */
    @GetMapping("/admin/users")
    public String adminUsersPage(Model model, HttpSession session) {
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

    /**
     * Displays the update user form for a specific user.
     *
     * @param userId The ID of the user to update
     * @param model  The model to add attributes for the view
     * @return The view name for the update user page
     */
    @GetMapping("/admin/users/update/{userId}")
    public String showUpdateUserForm(@PathVariable int userId, Model model, HttpSession session) {
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

    /**
     * Updates a specific user.
     *
     * @param user         The updated user information
     * @param roleId       The role ID to assign
     * @param departmentId The department ID to assign
     * @param managerId    The manager ID to assign
     * @param session      The HTTP session to manage user context
     * @return The redirect URL to the admin users page
     */
    @PostMapping("/admin/users/update")
    public String updateUser(@ModelAttribute User user,
            @RequestParam("roleId") Integer roleId,
            @RequestParam("departmentId") Integer departmentId,
            @RequestParam("managerId") Integer managerId,
            HttpSession session) {
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

    /**
     * Deletes a specific user.
     *
     * @param userId The ID of the user to delete
     * @return The redirect URL to the admin users page
     */
    @GetMapping("/admin/users/delete/{userId}")
    public String deleteUser(@PathVariable int userId, HttpSession session) {
        processGetInternal(session);
        userService.deleteUserById(userId);
        return "redirect:/admin/users";
    }

}