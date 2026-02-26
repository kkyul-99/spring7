package com.java.dto;

import java.sql.Timestamp;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//@GeneratedValue(strategy = GenerationType.SEQUENCE,
//generator = "boardDto_seq_generater") // oracle 시퀀스
@SequenceGenerator( //boarddto 100개 게시글을 할당
		name="boardDto_seq_generater", //generator 이름
		sequenceName = "boardDto_seq", // 오라클테이블에서 시퀀스이름		
		initialValue = 101,             // 시작번호
		allocationSize = 1            //메모리 할당범위
		)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class BoardDto {
//	@GeneratedValue(strategy = GenerationType.IDENTITY) //db 시퀀스
	@GeneratedValue(generator="boardDto_seq_generater")
	@Id
	private Integer bno;
	@Column(length = 1000,nullable = false)
	private String btitle;
	@Lob //대용량데이터 - CLOB
	private String bcontent;
	
//	private String id; //member Primary Key -> Foreign Key 사용
//	@ManyToMany // 여러명 회원이 여러개의 글을 작성할수 있음. - 하단댓글
//	@OneToMany // 1개 게시글은 여러명이 소유함.
	// 연관관계가 형성이 됨. - Foreign Key를 구성하게 됨.
	@ManyToOne(fetch = FetchType.EAGER) //1명 회원은 여러개 게시글을 작성할수 있음
	@JoinColumn(name="id") //db에 저장되는 컬럼은 id
	private MemberDto memberDto;
	@Column
	private int bgroup;
	@ColumnDefault("0")
	private int bstep;
	@ColumnDefault("0")
	private int bindent;
	@ColumnDefault("0")
	private int bhit;
	@Column(length = 100)
	private String bfile;
	@CreationTimestamp
	private Timestamp bdate;
}
