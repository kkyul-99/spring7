package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.java.dto.MemberDto;

@Controller
public class MemberController {
	
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	
	@PostMapping("/login")
	public String login(MemberDto mdto,Model model) {
		model.addAttribute("member", mdto);
		return "doLogin";
	}

	@GetMapping("/join")
	public String join() {
		return "join";
	}
	
	@PostMapping("/join")
	public String join(MemberDto mdto,Model model) {
		model.addAttribute("member", mdto);
		return "doJoin";
	}
	
}
