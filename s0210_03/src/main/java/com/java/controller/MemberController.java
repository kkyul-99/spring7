package com.java.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	
	@Autowired // IOC container에서 시작할 때 객체를 주입(생성)해줌
	HttpSession session;
	
	@GetMapping("/member/login")
	public String login(Integer flag,Model model) {
		System.out.println("flag: "+flag);
		model.addAttribute("flag",flag);
		return "login";
	}// login
	
	@GetMapping("/member/logout")
	public String logout() {
		session.invalidate(); // 세션 초기화
		return "redirect:/";
	}// logout
	
	@PostMapping("/member/login")
	public String login(String id, String pw) {
		if(id.equals("aaa") && pw.equals("1111")) {
			session.setAttribute("session_id",id);
			return "redirect:/?flag=1";
		}else {
			return "redirect:/member/login?flag=2";
		}
	}// login

}
