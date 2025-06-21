package com.hiutoluen.leave_management.controller;

import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;

/**
 * Controller to handle leave request functionalities.
 */
@Controller
@RequestMapping("/request")
public class RequestController extends BaseRBACController {

    /**
     * Constructs a new RequestController with the required dependency.
     *
     * @param userService The service to handle user-related business logic
     */
    public RequestController(UserService userService) {
        super(userService);
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
        model.addAttribute("user", getCurrentUser(session));
        return "create-request";
    }

    @Override
    protected void processGetInternal(HttpSession session, Object... args) {
    }

    @Override
    protected void processPostInternal(HttpSession session, Object... args) {
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
        model.addAttribute("subordinates", userService.findAllUsers().stream()
                .filter(u -> u.getManagerId() != null && u.getManagerId() == getCurrentUser(session).getUserId())
                .collect(Collectors.toList()));
        return "view-subordinates";
    }
}