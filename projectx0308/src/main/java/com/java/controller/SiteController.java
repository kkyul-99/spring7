package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SiteController {


    @GetMapping("/notice")
    public String notice() {
        return "redirect:/boards/notice";
    }

    @GetMapping("/guide")
    public String guide() {
        return "pages/guide";
    }

    @GetMapping("/board")
    public String board() {
        return "redirect:/boards/free";
    }

    @GetMapping("/report")
    public String report() {
        return "redirect:/boards/report";
    }

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

    @GetMapping("/signup")
    public String signup() {
        return "auth/signup";
    }
}
