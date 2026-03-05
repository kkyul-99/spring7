package com.java.service;

import com.java.dto.MemberDto;

public interface MemberService {
	
	//02. 로그인 확인
	MemberDto findByIdAndPw(MemberDto mdto);

}
