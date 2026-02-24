package com.java.service;

import com.java.dto.MemberDto;

public interface MemberService {

	//로그인
	MemberDto findByIdAndPw(MemberDto mdto);

	//로그인2
	MemberDto selectLogin(MemberDto mdto);

	//회원가입저장
	void save(MemberDto mdto);

}
