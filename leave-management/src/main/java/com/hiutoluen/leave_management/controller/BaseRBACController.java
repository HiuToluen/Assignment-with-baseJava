package com.hiutoluen.leave_management.controller;

import java.io.IOException;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public abstract class BaseRBACController extends BaseAuthenticationController {

    protected BaseRBACController(UserService userService) {
        super(userService);
    }

    protected void processGet(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        User user = getCurrentUser(session);
        String entrypoint = request.getServletPath();
        if (!userService.hasPermission(user.getUsername(), entrypoint)) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        processGetInternal(session, args);
    }

    protected void processPost(HttpServletRequest request, HttpSession session, Object... args) throws IOException {
        User user = getCurrentUser(session);
        String entrypoint = request.getServletPath();
        if (!userService.hasPermission(user.getUsername(), entrypoint)) {
            throw new SecurityException("You do not have permission to access this feature");
        }
        processPostInternal(session, args);
    }

    protected abstract void processGetInternal(HttpSession session, Object... args) throws IOException;

    protected abstract void processPostInternal(HttpSession session, Object... args) throws IOException;
}