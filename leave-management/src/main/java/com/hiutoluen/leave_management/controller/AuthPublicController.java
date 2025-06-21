package com.hiutoluen.leave_management.controller;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

/**
 * Controller to handle public authentication requests (login and register).
 */
@Controller
public class AuthPublicController {

    private final UserService userService;
    private final DepartmentRepository departmentRepository;

    public AuthPublicController(UserService userService, DepartmentRepository departmentRepository) {
        this.userService = userService;
        this.departmentRepository = departmentRepository;
    }

    @GetMapping("/login")
    public String loginPage(Model model, HttpSession session) {
        String error = (String) session.getAttribute("error");
        model.addAttribute("user", new User());
        model.addAttribute("error", error);
        session.removeAttribute("error");
        return "login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute("user") User user, Model model, HttpSession session) {
        User existingUser = userService.findByUsername(user.getUsername());
        if (existingUser != null && BCrypt.checkpw(user.getPassword(), existingUser.getPassword())) {
            session.setAttribute("currentUser", existingUser);
            if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
                return "redirect:/admin/users";
            } else {
                return "redirect:/home";
            }
        } else {
            session.setAttribute("error", "Invalid credentials");
            return "redirect:/login";
        }
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("departments", departmentRepository.findAll());
        return "register";
    }

    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("user") User user, BindingResult result, Model model,
            HttpSession session) {
        if (result.hasErrors()) {
            model.addAttribute("departments", departmentRepository.findAll());
            return "register";
        }
        try {
            User registeredUser = userService.registerUser(user);
            session.setAttribute("currentUser", registeredUser);
            return "redirect:/login";
        } catch (Exception e) {
            System.out.println("Registration failed: " + e.getMessage()); // Log lỗi ra console
            model.addAttribute("departments", departmentRepository.findAll());
            model.addAttribute("error", "Registration failed. Please try again."); // Thông báo chung
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}