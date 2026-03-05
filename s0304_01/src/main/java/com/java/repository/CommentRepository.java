package com.java.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.dto.CommentDto;

// <리턴타입,PK키타입>
public interface CommentRepository extends JpaRepository<CommentDto, Integer> {
	
}
