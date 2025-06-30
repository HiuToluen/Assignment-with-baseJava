package com.hiutoluen.leave_management.controller.filter;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.method.HandlerMethod;

import com.hiutoluen.leave_management.model.User;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthenticationInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        // Only check authentication for mapped controller methods
        if (handler instanceof HandlerMethod) {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("currentUser");
            if (user == null) {
                request.setAttribute("errorMessage", "You have not yet authenticated");
                request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                return false;
            }
        }
        // If not a controller method, let it through (so 404 can be handled)
        return true;
    }
}