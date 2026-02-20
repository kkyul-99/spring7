package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class FController {

	@GetMapping({"/","/index"})
	public String index(
			@RequestParam(name="flag",required = false) String flag,
			Model model) {
		System.out.println("flag : "+flag);
		model.addAttribute("flag",flag);
		return "index";
	}
}
