package com.java.dao;

import org.apache.ibatis.annotations.Mapper;

import com.java.dto.MemberDto;

@Mapper  //Mybatis설치
public interface MemberMapper {

	//로그인확인
	MemberDto selectLogin(MemberDto mdto);

	

}
