package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping("/")
	public String index() {
		return "redirect:/main";
	}

	@GetMapping("/main")
	public String mainPage(Model model) {
		return "main";
	}
}
