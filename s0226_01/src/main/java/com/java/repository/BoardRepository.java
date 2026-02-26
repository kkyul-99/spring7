package com.java.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.java.dto.BoardDto;

public interface BoardRepository extends JpaRepository<BoardDto, Integer> {

}
