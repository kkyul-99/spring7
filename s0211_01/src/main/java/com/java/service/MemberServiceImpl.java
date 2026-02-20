package com.java.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.java.dao.MemberDao;
import com.java.dto.MemberDto;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired MemberDao MemberDao;
	
	@Override
	public List<MemberDto> selectAll() {
		List<MemberDto> list = MemberDao.selectAll();
		return list;
	}

}
