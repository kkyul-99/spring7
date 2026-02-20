package com.java.controller;

import org.springframework.stereotype.Service;

@Service
public class TV2 implements Product {
	public String getName() {
		String name = "삼성TV 버전 2";
		return name;
	}


}
