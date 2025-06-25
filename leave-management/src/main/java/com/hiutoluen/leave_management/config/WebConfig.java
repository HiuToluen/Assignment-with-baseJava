package com.hiutoluen.leave_management.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.hiutoluen.leave_management.controller.filter.AuthenticationInterceptor;
import com.hiutoluen.leave_management.controller.filter.AuthorizationInterceptor;
import com.hiutoluen.leave_management.service.UserService;

@Configuration
public class WebConfig implements WebMvcConfigurer {

        private final UserService userService;

        public WebConfig(UserService userService) {
                this.userService = userService;
        }

        @Bean
        public AuthorizationInterceptor authorizationInterceptor() {
                return new AuthorizationInterceptor(userService);
        }

        @Bean
        public AuthenticationInterceptor authenticationInterceptor() {
                return new AuthenticationInterceptor();
        }

        @Override
        public void addInterceptors(InterceptorRegistry registry) {
                registry.addInterceptor(authenticationInterceptor())
                                .addPathPatterns("/**")
                                .excludePathPatterns(
                                                "/", "/login", "/register", "/oauth2/google", "/oauth2/callback",
                                                "/css/**", "/js/**", "/images/**", "/webjars/**");

                registry.addInterceptor(authorizationInterceptor())
                                .addPathPatterns("/**")
                                .excludePathPatterns(
                                                "/", "/login", "/register", "/oauth2/google", "/oauth2/callback",
                                                "/css/**", "/js/**", "/images/**", "/webjars/**");
        }
}