package com.java.controller;

import java.util.Date;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class FController {
	
	@GetMapping({"/","/index"}) // {} -> 주소 여러개 가능
	public String index(Integer flag,Model model) {
		System.out.println("flag: "+flag);
		model.addAttribute("flag",flag);
		model.addAttribute("now",new Date());
		return "index";
	}

}
