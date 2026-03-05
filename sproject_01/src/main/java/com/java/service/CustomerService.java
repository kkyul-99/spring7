package com.java.service;

import java.util.Map;

public interface CustomerService {
	
	//01. 게시판 리스트
	Map<String, Object> findAll(int page, String category, String search);

}
