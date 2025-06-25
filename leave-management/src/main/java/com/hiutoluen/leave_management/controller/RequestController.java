package com.hiutoluen.leave_management.controller;

import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;

/**
 * Controller to handle leave request functionalities.
 */
@Controller
@RequestMapping("/request")
public class RequestController {

    private final UserService userService;

    /**
     * Constructs a new RequestController with the required dependency.
     *
     * @param userService The service to handle user-related business logic
     */
    public RequestController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Displays the create request page.
     *
     * @param model   The model to add attributes for the view
     * @param session The HTTP session to check the logged-in user
     * @return The view name for the create request page
     */
    @GetMapping("/create")
    public String createRequestPage(Model model, HttpSession session) {
        // Kiểm tra đăng nhập
        Object currentUserObj = session.getAttribute("currentUser");
        if (currentUserObj == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        User user = (User) currentUserObj;
        // Kiểm tra phân quyền
        if (!userService.hasPermission(user.getUsername(), "/request/create")) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        model.addAttribute("user", user);
        return "create-request";
    }

    /**
     * Displays the view subordinate requests page.
     *
     * @param model   The model to add attributes for the view
     * @param session The HTTP session to check the logged-in user
     * @return The view name for the view subordinate requests page
     */
    @GetMapping("/view-subordinates")
    public String viewSubordinatesPage(Model model, HttpSession session) {
        // Kiểm tra đăng nhập
        Object currentUserObj = session.getAttribute("currentUser");
        if (currentUserObj == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        User user = (User) currentUserObj;

        if (!userService.hasPermission(user.getUsername(), "/request/view-subordinates")) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        model.addAttribute("subordinates", userService.findAllUsers().stream()
                .filter(u -> u.getManagerId() != null && u.getManagerId() == user.getUserId())
                .collect(Collectors.toList()));
        return "view-subordinates";
    }
}