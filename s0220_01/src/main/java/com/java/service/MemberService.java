package com.java.service;

import com.java.dto.MemberDto;

public interface MemberService {

	//로그인확인
	MemberDto selectLogin(MemberDto mdto);

	

}
