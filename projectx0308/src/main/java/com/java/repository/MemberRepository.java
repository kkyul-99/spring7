package com.java.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.entity.Member;

public interface MemberRepository extends JpaRepository<Member, Long> {
	Optional<Member> findByMid(String mid);

	boolean existsByMid(String mid);

	boolean existsByEmail(String email);

	boolean existsByNickname(String nickname);

	/* 아이디 찾기: 이름 + 이메일로 조회 */
	Optional<Member> findByMnameAndEmail(String mname, String email);

	/* 비밀번호 재설정: 아이디 + 이름 + 이메일로 조회 */
	Optional<Member> findByMidAndMnameAndEmail(String mid, String mname, String email);
}
