package com.hiutoluen.leave_management.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ErrorController {

    @GetMapping("/error/403")
    public String error403(@RequestParam(required = false) String errorMessage, Model model) {
        model.addAttribute("errorMessage",
                errorMessage != null ? errorMessage : "You do not have permission to access this feature");
        return "error/403";
    }

    @GetMapping("/error")
    public String generalError(@RequestParam(required = false) String errorMessage, Model model) {
        model.addAttribute("errorMessage",
                errorMessage != null ? errorMessage : "An unexpected error occurred. Please try again.");
        return "error/500";
    }

    @GetMapping("/error/500")
    public String error500(@RequestParam(required = false) String errorMessage, Model model) {
        model.addAttribute("errorMessage",
                errorMessage != null ? errorMessage : "Internal server error. Please try again later.");
        return "error/500";
    }

    @GetMapping("/error/404")
    public String error404(@RequestParam(required = false) String errorMessage, Model model) {
        model.addAttribute("errorMessage",
                errorMessage != null ? errorMessage
                        : "The page you are looking for does not exist or you do not have access.");
        return "error/404";
    }
}