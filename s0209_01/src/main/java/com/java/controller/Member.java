package com.java.controller;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor //전체생성자
@NoArgsConstructor  //기본생성자
@Data  //getter,setter
public class Member {
	
	private String id;
	private String pw;
	private String name;

	
}
