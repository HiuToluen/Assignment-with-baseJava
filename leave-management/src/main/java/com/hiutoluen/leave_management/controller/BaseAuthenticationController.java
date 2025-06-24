package com.hiutoluen.leave_management.controller;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public abstract class BaseAuthenticationController {

    protected final UserService userService;

    @Value("${security.protected.paths}")
    protected String protectedPaths;

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

    protected abstract void processGet(HttpServletRequest request, HttpSession session, Object... args)
            throws IOException;

    protected abstract void processPost(HttpServletRequest request, HttpSession session, Object... args)
            throws IOException;

    public void checkAndProcess(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        String requestURI = request.getRequestURI();
        List<String> protectedPathsList = Arrays.asList(protectedPaths.split(","));
        boolean isProtected = protectedPathsList.stream().anyMatch(path -> {
            if (path.endsWith("/**")) {
                String basePath = path.substring(0, path.length() - 3);
                return requestURI.startsWith(basePath);
            }
            return requestURI.equals(path);
        });
        if (isProtected) {
            getCurrentUser(session);
            String method = request.getMethod().toUpperCase();
            if ("GET".equals(method)) {
                processGet(request, session, args);
            } else if ("POST".equals(method)) {
                processPost(request, session, args);
            }
        }
    }
}