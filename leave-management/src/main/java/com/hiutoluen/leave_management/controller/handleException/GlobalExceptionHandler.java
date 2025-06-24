package com.hiutoluen.leave_management.controller.handleException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.ResponseStatus;

import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ModelAttribute("errorMessage")
    public String setErrorMessage(HttpServletRequest request) {
        String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
        logger.debug("Error message from request attribute: {}", errorMessage);
        if (errorMessage == null) {
            errorMessage = "Access denied due to unknown error";
            logger.warn("No error message found in request attribute");
        }
        return errorMessage;
    }

    @ExceptionHandler(SecurityException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public String handleSecurityException(SecurityException ex, HttpServletRequest request) {
        String errorMessage = ex.getMessage();
        logger.debug("Security exception caught with message: {}", errorMessage);
        request.setAttribute("jakarta.servlet.error.message", errorMessage);
        return "error/403";
    }
}