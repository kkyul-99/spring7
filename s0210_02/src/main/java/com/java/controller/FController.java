package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FController {
	
	@GetMapping("/")
	public String index(Integer flag,Model model) {
		System.out.println("flag: "+flag);
		model.addAttribute("flag",flag);
		return "index";
	}

}
