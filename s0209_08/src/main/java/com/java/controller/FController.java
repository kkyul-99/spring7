package com.java.controller;

import java.util.Arrays;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class FController {

	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@GetMapping("/list")
	public String list() {
		return "list";
	}
	
	
	
	@GetMapping("/member/member")
	public String member() {
		
		return "member";
	}
	
	@PostMapping("/member/member") //오버로딩:메소드명 같고, 매개변수개수,타입이 다른것
	public ModelAndView member(HttpServletRequest request) {
		//데이터 받기
		String id = request.getParameter("id");
		System.out.println("넘어온 데이터 id : "+id);
		
		//데이터 보내기
		ModelAndView mv = new ModelAndView();
		mv.addObject("id",id);
		mv.setViewName("memberOk");
		return mv;
	}
	
//	// Model model 방식
//	@PostMapping("/member/member") //오버로딩:메소드명 같고, 매개변수개수,타입이 다른것
//	public String member(HttpServletRequest request,Model model) {
//		//데이터 받기
//		String id = request.getParameter("id");
//		System.out.println("넘어온 데이터 id : "+id);
//		//데이터 보내기
//		model.addAttribute("id",id);
//		return "memberOk";
//	}
	
	
	
	@GetMapping("/member/login")
	public String login() {
		return "login";
	}
	
	@PostMapping("/member/loginOk")
	public String loginOk(HttpServletRequest request,Model model) {
		// 데이터 받기
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		// checkbox -> getParameterValues();
		System.out.println("넘어온데이터 : "+id+","+pw);
		//데이터 보내기
		model.addAttribute("id",id);
		model.addAttribute("pw",pw);
		return "loginOk";
	}//
	
	@GetMapping("/member/membership")
	public String membership() {
		return "membership";
	}//
	
	@PostMapping("/member/membershipOk")
	public String membershipOk(HttpServletRequest request,
			HttpServletResponse response,Model model) {
		// 데이터 받기
		String id = request.getParameter("id");
		String pw = request.getParameter("pw");
		String name = request.getParameter("name");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String gender = request.getParameter("gender");
		String[] hobbys = request.getParameterValues("hobby");
		String hobby = Arrays.toString(hobbys);
		// checkbox -> getParameterValues();
		System.out.println("넘어온데이터 : "+name+","+phone);
		//데이터 보내기
		model.addAttribute("id",id);
		model.addAttribute("pw",pw);
		model.addAttribute("name",name);
		model.addAttribute("phone",phone);
		model.addAttribute("email",email);
		model.addAttribute("gender",gender);
		model.addAttribute("hobby",hobby);
		return "membershipOk";
	}//
	
	
}
