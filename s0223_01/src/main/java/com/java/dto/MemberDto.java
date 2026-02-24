package com.java.dto;

import java.sql.Timestamp;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder             //부분생성자
@AllArgsConstructor  //전체생성자
@NoArgsConstructor   //기본생성자
@Data                //getter,setter
@Entity              //jpa로 테이블생성
public class MemberDto {
	
	@Id                 //primary key등록
	private String id;
	@Column(nullable = false,length=100) //not null,길이100
	private String pw;
	@Column(nullable = false,length=30)
	private String name;
	@Column(length=13)   //010-1111-1111
	private String phone;
	@Column(length=40)
	private String email;
	@ColumnDefault("'남자'")  // 문자열일때 ''넣어줌, 숫자인 경우는 '' 넣지않음
	private String gender;
	@Column(length = 50)
	private String hobby;
	@CreationTimestamp       //시간 자동입력
	private Timestamp mdate;

}
