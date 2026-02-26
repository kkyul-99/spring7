package com.java.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.dto.MemberDto;

public interface MemberRepository extends JpaRepository<MemberDto, String> {
	
	//로그인 확인
	Optional<MemberDto> findByIdAndPw(String id, String pw);

}
