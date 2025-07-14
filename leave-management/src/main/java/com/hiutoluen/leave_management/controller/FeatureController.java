package com.hiutoluen.leave_management.controller;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hiutoluen.leave_management.model.Feature;
import com.hiutoluen.leave_management.model.Role;
import com.hiutoluen.leave_management.model.RoleFeature;
import com.hiutoluen.leave_management.model.RoleFeatureId;
import com.hiutoluen.leave_management.model.User;
import com.hiutoluen.leave_management.repository.FeatureRepository;
import com.hiutoluen.leave_management.repository.RoleFeatureRepository;
import com.hiutoluen.leave_management.repository.RoleRepository;
import com.hiutoluen.leave_management.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
public class FeatureController {

    private final FeatureRepository featureRepository;
    private final RoleRepository roleRepository;
    private final RoleFeatureRepository roleFeatureRepository;
    private final UserService userService;

    public FeatureController(FeatureRepository featureRepository,
            RoleRepository roleRepository,
            RoleFeatureRepository roleFeatureRepository,
            UserService userService) {
        this.featureRepository = featureRepository;
        this.roleRepository = roleRepository;
        this.roleFeatureRepository = roleFeatureRepository;
        this.userService = userService;
    }

    @GetMapping("/admin/features")
    public String featuresPage(Model model, HttpSession session,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/features")) {
            return "redirect:/error/403";
        }
        Pageable pageable = PageRequest.of(page, size);
        Page<Feature> featurePage = featureRepository.findAll(pageable);
        model.addAttribute("featurePage", featurePage);
        model.addAttribute("newFeature", new Feature());
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        return "admin-features";
    }

    @PostMapping("/admin/features/add")
    public String addFeature(@ModelAttribute Feature feature, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/features/add")) {
            return "redirect:/error/403";
        }

        featureRepository.save(feature);
        return "redirect:/admin/features";
    }

    @GetMapping("/admin/features/delete/{featureId}")
    public String deleteFeature(@RequestParam int featureId, HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/features/delete")) {
            return "redirect:/error/403";
        }

        featureRepository.deleteById(featureId);
        return "redirect:/admin/features";
    }

    @GetMapping("/admin/permissions")
    public String permissionsPage(Model model, HttpSession session,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "8") int size) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/permissions")) {
            return "redirect:/error/403";
        }
        Pageable pageable = PageRequest.of(page, size);
        List<Role> roles = roleRepository.findAll();
        List<Feature> features = featureRepository.findAll();
        Page<RoleFeature> roleFeaturePage = roleFeatureRepository.findAll(pageable);
        model.addAttribute("roles", roles);
        model.addAttribute("features", features);
        model.addAttribute("roleFeaturePage", roleFeaturePage);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        return "admin-permissions";
    }

    @PostMapping("/admin/permissions/assign")
    public String assignPermission(@RequestParam int roleId,
            @RequestParam int featureId,
            HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/permissions/assign")) {
            return "redirect:/error/403";
        }

        RoleFeature roleFeature = new RoleFeature();

        // Create and set the composite key
        RoleFeatureId id = new RoleFeatureId();
        id.setRoleId(roleId);
        id.setFeatureId(featureId);
        roleFeature.setId(id);

        // Set the related entities
        roleFeature.setRole(roleRepository.findById(roleId).orElse(null));
        roleFeature.setFeature(featureRepository.findById(featureId).orElse(null));

        if (roleFeature.getRole() != null && roleFeature.getFeature() != null) {
            roleFeatureRepository.save(roleFeature);
        }

        return "redirect:/admin/permissions";
    }

    @GetMapping("/admin/permissions/revoke")
    public String revokePermission(@RequestParam int roleId,
            @RequestParam int featureId,
            HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        if (!userService.hasPermission(user.getUsername(), "/admin/permissions/revoke")) {
            return "redirect:/error/403";
        }

        roleFeatureRepository.deleteByRole_RoleIdAndFeature_FeatureId(roleId, featureId);
        return "redirect:/admin/permissions";
    }
}