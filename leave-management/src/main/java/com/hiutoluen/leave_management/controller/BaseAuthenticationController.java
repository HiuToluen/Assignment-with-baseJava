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

    // Chỉ áp dụng cho các endpoint động, không bao gồm tài nguyên tĩnh
    @GetMapping(value = "/{path:[^\\.]*}")
    public String handleGet(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        getCurrentUser(session);
        processGet(request, session, args);
        return null;
    }

    @PostMapping(value = "/{path:[^\\.]*}")
    public String handlePost(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        getCurrentUser(session);
        processPost(request, session, args);
        return null;
    }
}