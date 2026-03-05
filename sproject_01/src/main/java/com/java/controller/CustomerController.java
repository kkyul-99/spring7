package com.java.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.java.service.CustomerService;

@Controller
public class CustomerController {
	
	@Autowired CustomerService customerService;
	
	//01. 게시판 리스트
	@GetMapping("/customer/customer")
	public String customer(
			@RequestParam(name="page",defaultValue="1") int page,
			@RequestParam(name="category",required=false) String category,
			@RequestParam(name="search",required=false) String search,
			Model model) {
		Map<String, Object> map = customerService.findAll(page, category, search);
		model.addAttribute("map", map);
		return "customer/customer";
	}
	
	//02. 게시글 쓰기
	@GetMapping("/customer/customerWrite")
	public String customerWrite() {
		return "customer/customerWrite";
	}

}
