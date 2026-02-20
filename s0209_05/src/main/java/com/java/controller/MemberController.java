package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/member")
public class MemberController {

	@GetMapping("/login")
	public String login() {
		return "member/login";
	}
	
	@PostMapping("/doLogin")
	public String doLogin(HttpServletRequest request, Model model) {
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		System.out.println("넘어온 데이터 : "+id+","+pw);
		model.addAttribute("id",id);
		model.addAttribute("pw",pw);
		return "member/doLogin";
	}
	
	@GetMapping("/logout")
	public String logout() {
		return "member/logout";
	}
}
