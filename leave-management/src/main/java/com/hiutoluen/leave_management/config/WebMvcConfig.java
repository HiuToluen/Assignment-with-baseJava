package com.hiutoluen.leave_management.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/", "classpath:/public/css/", "classpath:/resources/css/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/", "classpath:/public/js/", "classpath:/resources/js/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/", "classpath:/public/images/",
                        "classpath:/resources/images/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/client/**")
                .addResourceLocations("classpath:/static/client/", "classpath:/public/client/",
                        "classpath:/resources/client/")
                .setCachePeriod(3600);
    }

}