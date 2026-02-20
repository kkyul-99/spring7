package com.java.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.java.dto.MemberDto;

@Mapper
public interface MemberDao {
	
	List<MemberDto> selectAll();

}
