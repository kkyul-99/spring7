package com.java.controller;

import org.springframework.stereotype.Service;


public class TV implements Product {

	@Override
	public String getName() {
		String name = "삼성TV 버전 1";
		return name;
	}

}
