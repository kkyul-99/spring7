package com.java.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.java.dto.BoardDto;
import com.java.dto.MemberDto;
import com.java.service.BoardService;
import com.java.service.MemberService;

import jakarta.servlet.http.HttpSession;

//@RestController //데이터전달
@Controller
public class BoardController {
	
	@Autowired BoardService boardService;
	@Autowired MemberService memberService;
	@Autowired HttpSession session;
	
	//게시글 답변달기페이지
	@GetMapping("/board/breply")
	public String breply(
			@RequestParam(name="bno", required = false) Integer bno, 
			Model model) {
		System.out.println("controller bno : "+bno);
		//db에서 가져오기
		Map<String, Object> map = boardService.findById(bno);
		model.addAttribute("board",map.get("boardDto"));
		return "breply";   
	}//
	
	//게시글 답변달기 저장
	@PostMapping("/board/breply")
	public String breply(BoardDto bdto,
			@RequestPart("file") MultipartFile files,
			Model model) {
		
		System.out.println("controller bgroup : "+bdto.getBgroup());
		
		//파일이름 저장 - 파일첨부가 있을경우
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s", time,fName);
			System.out.println("파일이름 : "+fName);
			System.out.println("파일변경이름 : "+refName);
			String fileUploadUrl = "c:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			} catch (Exception e) {e.printStackTrace();} 
		}
		
		String id = (String) session.getAttribute("session_id");
		// MemberDto객체를 검색해서 저장
		MemberDto mdto = memberService.findById(id);
		bdto.setMemberDto(mdto);
		//답변달기 저장
		boardService.reply(bdto);	
		
		return "redirect:/board/blist";   
	}//
	
	//게시글 수정저장
	@PostMapping("/board/bupdate")
	public String bupdate(BoardDto bdto,
			@RequestPart("file") MultipartFile files,
			Model model) {
		System.out.println("controller bno : "+bdto.getBno());
		System.out.println("controller bfile : "+bdto.getBfile());
		
		//파일이름 저장 - 파일첨부가 있을경우
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s", time,fName);
			System.out.println("파일이름 : "+fName);
			System.out.println("파일변경이름 : "+refName);
			String fileUploadUrl = "c:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			} catch (Exception e) {e.printStackTrace();} 
		}
		
		//String id = (String) session.getAttribute("session_id");
		// MemberDto객체를 검색해서 저장
		//MemberDto mdto = memberService.findById(id);
		//bdto.setMemberDto(mdto);
		//글쓰기 저장
		boardService.update(bdto);	
		
		return "redirect:/board/blist";   
	}
	
	//게시글 수정페이지
	@GetMapping("/board/bupdate")
	public String bupdate(
			@RequestParam(name="bno", required = false) Integer bno, 
			Model model) {
		System.out.println("controller bno : "+bno);
		//db에서 가져오기
		Map<String, Object> map = boardService.findById(bno);
		model.addAttribute("board",map.get("boardDto"));
		return "bupdate";   
	}
	
	//게시글삭제
	@ResponseBody //데이터전달을 해줌.
	@DeleteMapping("/board/bdelete")
	public String bdelete(
			@RequestParam(name="bno", required = false) Integer bno, 
			Model model) {
		System.out.println("controller bno : "+bno);
		boardService.deleteById(bno);
		return "성공";   //bview.jsp
	}
	
	//상세보기페이지
	@GetMapping("/board/bview/{bno}")
	public String bview(
			@PathVariable(name="bno", required = false) Integer bno, 
			@RequestParam(name="page", defaultValue = "1") int page, 
			@RequestParam(name="category",required = false) String category,
			@RequestParam(name="search",required = false) String search,
			Model model) {
		System.out.println("controller bno : "+bno);
		Map<String, Object> map = boardService.findById(bno);
		model.addAttribute("board",map.get("boardDto"));
		model.addAttribute("preBoard",map.get("preDto"));
		model.addAttribute("nextBoard",map.get("nextDto"));
		model.addAttribute("page",page);
		model.addAttribute("category",category);
		model.addAttribute("search",search);
		return "bview";
	}
	
	//글쓰기페이지
	@GetMapping("/board/bwrite")
	public String bwrite(Model model) {
		return "bwrite";
	}
	
	//글쓰기 저장
	@PostMapping("/board/bwrite")
	public String bwrite(BoardDto bdto, 
			@RequestPart("file") MultipartFile files,
			Model model) {
		System.out.println("controller bdto : "+bdto.getBtitle());
		//파일이름 저장
		if(!files.isEmpty()) {
			String fName = files.getOriginalFilename();
			long time = System.currentTimeMillis();
			String refName = String.format("%s_%s", time,fName);
			System.out.println("파일이름 : "+fName);
			System.out.println("파일변경이름 : "+refName);
			String fileUploadUrl = "c:/upload/";
			File f = new File(fileUploadUrl+refName);
			try {
				files.transferTo(f);
				bdto.setBfile(refName); //변경된 파일이름을 저장
			} catch (Exception e) {e.printStackTrace();} 
		}
		
		String id = (String) session.getAttribute("session_id");
		
		// MemberDto객체를 검색해서 저장
		MemberDto mdto = memberService.findById(id);
		bdto.setMemberDto(mdto);
		//글쓰기 저장
		boardService.save(bdto);
		return "redirect:/board/blist";
	}
	
	//전체게시글리스트 - 하단넘버링 (현재페이지,페이지당 개수)
	@GetMapping("/board/blist")
	public String blist(
			@RequestParam(name="category",required = false) String category,
			@RequestParam(name="search",required = false) String search,
			@RequestParam(name="page",defaultValue = "1") int page,
			@RequestParam(name="size",defaultValue = "10") int size,
			Model model) {
		System.out.println("controller category : "+category+","+search);
		
		//하단넘버링에 필요한 현재페이지,페이지당 개수 전달
		Map<String, Object> map = boardService.findAll(page,size,category,search);
		System.out.println("controller list : "+((List)map.get("list")).size());
		model.addAttribute("map",map);
		return "blist";
	}

}
