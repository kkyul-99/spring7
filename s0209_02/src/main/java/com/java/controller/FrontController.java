package com.java.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class FrontController {

	@GetMapping("/")
	public String index() {
		
		Mdto mdto = new Mdto();
		mdto.setName("홍길동");
		System.out.println(mdto.getName());
		return "index";
	}
}
