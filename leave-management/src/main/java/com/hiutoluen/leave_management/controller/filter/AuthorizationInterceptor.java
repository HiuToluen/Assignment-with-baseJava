package com.hiutoluen.leave_management.controller.filter;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.HandlerInterceptor;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthorizationInterceptor implements HandlerInterceptor {

    @Value("${security.protected.paths}")
    private String protectedPaths;

    private final UserService userService;

    public AuthorizationInterceptor(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
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
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("currentUser");
            if (user != null && !userService.hasPermission(user.getUsername(), request.getServletPath())) {
                throw new SecurityException("You do not have permission to access this feature");
            }
        }
        return true;
    }
}