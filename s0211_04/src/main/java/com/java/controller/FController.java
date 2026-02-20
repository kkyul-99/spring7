package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FController {
	
	// 메인페이지
	@GetMapping("/")
	public String index(String flag,Model model) {
		model.addAttribute("flag",flag);
		return "index";
	}

}
