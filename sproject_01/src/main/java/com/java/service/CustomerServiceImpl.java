package com.java.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.java.dto.BoardDto;
import com.java.repository.CustomerRepository;

@Service
public class CustomerServiceImpl implements CustomerService {

	@Autowired CustomerRepository customerRepository;
	
	//01. 게시판 리스트
	@Override
	public Map<String, Object> findAll(int page, String category, String search) {
		int size = 10;
		//정렬
		Sort sort = Sort.by(Sort.Order.desc("bgroup"),
				Sort.Order.asc("bstep"));
		//하단넘버링
		Pageable pageable = PageRequest.of(page-1, size, sort);
		Page<BoardDto> pageList = null;
		
		if(category==null || category=="") {
			pageList = customerRepository.findAll(pageable);
		}else if(category.equals("all")) {
			pageList = customerRepository.findByBtitleContainingOrBcontentContaining(search, search, pageable);
		}else if(category.equals("btitle")) {
			pageList = customerRepository.findByBtitleContaining(search, pageable);
		}else if(category.equals("bcontent")) {
			pageList = customerRepository.findByBcontentContaining(search, pageable);
		}
		
		//Page - content, totalPage
		//list, 현재페이지, 최대페이지, 하단넘버링 시작번호, 하단넘버링 끝번호, 카테고리, 검색어
		//하단넘버링 메서드 호출
		Map<String, Object> map = pageMethod(pageList, page);
		map.put("category", category);
		map.put("search", search);
		return map;
	}
	
	//하단넘버링 메서드
	public Map<String, Object> pageMethod(
			Page<BoardDto> pageList, int page) {
		Map<String, Object> map = new HashMap<>();
		List<BoardDto> list = pageList.getContent();
		int maxPage = pageList.getTotalPages();
		int startPage = ((page-1)/10)*10+1;
		int endPage = Math.min(startPage+10-1, maxPage);
		map.put("list", list);
		map.put("page", page);
		map.put("maxPage", maxPage);
		map.put("startPage", startPage);
		map.put("endPage", endPage);
		return map;
	}
	
}
