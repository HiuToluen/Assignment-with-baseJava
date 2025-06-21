package com.hiutoluen.leave_management.controller;

import java.io.IOException;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Base controller to enforce authentication for all requests except /login and
 * /register.
 */
@Controller
public abstract class BaseAuthenticationController {

    protected final UserService userService;

    protected BaseAuthenticationController(UserService userService) {
        this.userService = userService;
    }

    @ModelAttribute("currentUser")
    public User getCurrentUser(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            throw new SecurityException("You have not yet authenticated");
        }
        return user;
    }

    @ExceptionHandler(SecurityException.class)
    public String handleSecurityException(SecurityException ex, HttpServletRequest request) {
        return "redirect:/login?error=" + ex.getMessage();
    }

    protected abstract void processGet(HttpServletRequest request, HttpSession session, Object... args)
            throws IOException;

    protected abstract void processPost(HttpServletRequest request, HttpSession session, Object... args)
            throws IOException;

    @GetMapping("/**")
    public String handleGet(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        String requestURI = request.getRequestURI();
        if (!requestURI.equals("/login") && !requestURI.equals("/register")) {
            getCurrentUser(session);
        }
        processGet(request, session, args);
        return null;
    }

    @PostMapping("/**")
    public String handlePost(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        String requestURI = request.getRequestURI();
        if (!requestURI.equals("/login") && !requestURI.equals("/register")) {
            getCurrentUser(session);
        }
        processPost(request, session, args);
        return null;
    }
}