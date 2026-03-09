package com.java.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginCheckInterceptor())
                .addPathPatterns(
                        "/boards/*/write",
                        "/boards/*/edit",
                        "/boards/*/delete"
                )
                .excludePathPatterns(
                        "/login",
                        "/signup",
                        "/logout",
                        "/api/**",        // 중복체크 API 인터셉터 제외
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/h2-console/**"  // H2 콘솔 인터셉터 제외
                );
    }
}
