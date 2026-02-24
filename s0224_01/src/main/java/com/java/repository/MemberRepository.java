package com.java.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.dto.MemberDto;

//@Repository //JpaRepository 상속받으면 생략 가능
// JpaRepository<entity 객체, primary key 타입>
// find, save, delete - CRUD 작업에 필요한 기본 메소드가 만들어져 있음.
// fintAll(), findById(), delete(), deleteById(), count()
public interface MemberRepository extends JpaRepository<MemberDto, String> {
	
	//로그인 확인: 1개 select할 때 타입 -> Optional
	Optional<MemberDto> findByIdAndPw(String id, String pw);

	//기존 상속에 포함되어 있는 메소드, 생략가능
	//void deleteById(String id);

}
