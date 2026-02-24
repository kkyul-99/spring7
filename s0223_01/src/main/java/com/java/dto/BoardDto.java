package com.java.dto;

import java.sql.Timestamp;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity     //jpa로 테이블생성
public class BoardDto {
	
	@Id  //primary key등록
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int bno;
	@Column(nullable = false,length = 100)
	private String btitle;
	@Lob                     //대용량문자열 - clob
	private String bcontent;
	
	//private String id;
	// @OneToMany, @ManyToMany
	@ManyToOne   //한명의 user가 여러개의 게시글 등록가능
	@JoinColumn(name="id")
	private MemberDto member;
	@ColumnDefault("0")
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
