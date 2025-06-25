package com.hiutoluen.leave_management.controller;

import java.util.Collections;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.AuthorizationCodeTokenRequest;
import com.google.api.client.auth.oauth2.ClientParametersAuthentication;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.HttpResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonObjectParser;
import com.google.api.client.json.gson.GsonFactory;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.DepartmentRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class AuthPublicController {

    private final UserService userService;
    private final DepartmentRepository departmentRepository;

    @Value("${google.oauth2.client-id}")
    private String clientId;

    @Value("${google.oauth2.client-secret}")
    private String clientSecret;

    @Value("${google.oauth2.redirect-uri}")
    private String redirectUri;

    @Value("${google.oauth2.auth-uri}")
    private String authUri;

    @Value("${google.oauth2.token-uri}")
    private String tokenUri;

    @Value("${google.oauth2.userinfo-uri}")
    private String userInfoUri;

    public AuthPublicController(UserService userService, DepartmentRepository departmentRepository) {
        this.userService = userService;
        this.departmentRepository = departmentRepository;
    }

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage(Model model, HttpSession session) {
        String error = (String) session.getAttribute("error");
        model.addAttribute("user", new User());
        model.addAttribute("error", error != null ? error : "");
        session.removeAttribute("error");
        return "login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute("user") User user, Model model, HttpSession session) {
        User existingUser = userService.findByUsername(user.getUsername());
        if (existingUser != null && BCrypt.checkpw(user.getPassword(), existingUser.getPassword())) {
            session.setAttribute("currentUser", existingUser);
            System.out.println("Logged in user: " + existingUser.getUsername());
            if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
                return "redirect:/admin/users";
            }
            return "redirect:/home";
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
            User existingUser = userService.findByUsername(user.getUsername());
            if (existingUser != null) {
                model.addAttribute("departments", departmentRepository.findAll());
                model.addAttribute("error", "Username already exists");
                return "register";
            }
            User registeredUser = userService.registerUser(user);
            session.setAttribute("currentUser", registeredUser);
            System.out.println("Registered user: " + registeredUser.getUsername() + ", Session ID: " + session.getId());
            return "redirect:/login";
        } catch (Exception e) {
            model.addAttribute("departments", departmentRepository.findAll());
            model.addAttribute("error", "Registration failed. Please try again");
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/oauth2/google")
    public String googleLogin() {
        AuthorizationCodeRequestUrl authUrl = new AuthorizationCodeRequestUrl(authUri, clientId)
                .setRedirectUri(redirectUri)
                .setScopes(Collections.singletonList("email profile"));
        return "redirect:" + authUrl.build();
    }

    @GetMapping("/oauth2/callback")
    public String googleCallback(@RequestParam("code") String code, HttpSession session) {
        try {
            NetHttpTransport httpTransport = GoogleNetHttpTransport.newTrustedTransport();
            GsonFactory jsonFactory = GsonFactory.getDefaultInstance();
            if (code == null || code.isEmpty()) {
                session.setAttribute("error", "Missing authorization code");
                return "redirect:/login";
            }
            AuthorizationCodeTokenRequest tokenRequest = new AuthorizationCodeTokenRequest(
                    httpTransport, jsonFactory, new GenericUrl(tokenUri), code)
                    .setClientAuthentication(new ClientParametersAuthentication(clientId, clientSecret))
                    .setRedirectUri(redirectUri);
            TokenResponse tokenResponse = tokenRequest.execute();
            HttpRequestInitializer requestInitializer = request -> request.setParser(new JsonObjectParser(jsonFactory));
            HttpRequest userInfoRequest = httpTransport.createRequestFactory(requestInitializer)
                    .buildGetRequest(new GenericUrl(userInfoUri + "?access_token=" + tokenResponse.getAccessToken()));
            HttpResponse userInfoResponse = userInfoRequest.execute();
            String jsonResponse = userInfoResponse.parseAsString();
            com.google.gson.JsonObject userInfo = com.google.gson.JsonParser.parseString(jsonResponse)
                    .getAsJsonObject();
            String email = userInfo.get("email").getAsString();
            String name = userInfo.get("name").getAsString();
            User existingUser = userService.findByEmail(email);
            if (existingUser != null) {
                session.setAttribute("currentUser", existingUser);
                System.out.println(
                        "Google login user: " + existingUser.getUsername() + ", Session ID: " + session.getId());
                if ("admin".equalsIgnoreCase(existingUser.getUsername())) {
                    return "redirect:/admin/users";
                }
                return "redirect:/home";
            }
            User newUser = new User();
            newUser.setUsername(email.split("@")[0]);
            newUser.setFullName(name);
            newUser.setEmail(email);
            newUser.setDepartmentId(1);
            String fixedSalt = "$2a$12$abcdefghijklmnopqrstuv";
            newUser.setPassword(BCrypt.hashpw("google" + System.currentTimeMillis(), fixedSalt));
            User savedUser = userService.registerUser(newUser);
            session.setAttribute("currentUser", savedUser);
            System.out.println(
                    "New Google user registered: " + savedUser.getUsername() + ", Session ID: " + session.getId());
            if ("admin".equalsIgnoreCase(savedUser.getUsername())) {
                return "redirect:/admin/users";
            }
            return "redirect:/home";
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Google login failed: " + e.getMessage());
            return "redirect:/login";
        }
    }
}