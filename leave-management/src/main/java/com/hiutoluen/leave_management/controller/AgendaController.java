package com.hiutoluen.leave_management.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;

/**
 * Controller to handle agenda functionalities.
 */
@Controller
@RequestMapping("/agenda")
public class AgendaController {

    private final UserService userService;

    /**
     * Constructs a new AgendaController with the required dependency.
     *
     * @param userService The service to handle user-related business logic
     */
    public AgendaController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Displays the agenda page.
     *
     * @param model   The model to add attributes for the view
     * @param session The HTTP session to check the logged-in user
     * @return The view name for the agenda page
     */
    @GetMapping
    public String agendaPage(Model model, HttpSession session) {
        // Kiểm tra đăng nhập
        Object currentUserObj = session.getAttribute("currentUser");
        if (currentUserObj == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        User user = (User) currentUserObj;
        // Kiểm tra phân quyền
        if (!userService.hasPermission(user.getUsername(), "/agenda")) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        model.addAttribute("user", user);
        return "agenda";
    }
}