package com.java.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder            // 부분생성자
@AllArgsConstructor // 전체생성자
@NoArgsConstructor  // 기본생성자
@Data // getter, setter 둘 다 생성
//@Getter - getter만 생성
//@Setter - setter만 생성
public class MemberDto {
	
	private String id;
	private String pw;
	private String name;
	private String phone;
	private String email;
	private String gender;
	private String hobby;
	
}
