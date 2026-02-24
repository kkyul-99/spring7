package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.java.service.MemberService;

@Controller
public class MemberController {
	
	@Autowired MemberService memberService;
	
	@GetMapping("/member/mlist")
	public String mlist() {
		return "mlist";
	}
	
	@GetMapping("/member/login")
	public String login() {
		return "login";
	}
	
	@PostMapping("/member/login")
	public String dologin() {
		return "login";
	}

}
