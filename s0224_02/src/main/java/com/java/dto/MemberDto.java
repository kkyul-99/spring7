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

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class MemberDto {
	
	@Id //primary key 설정
	@Column(length = 50) //varcahr2(50)
	private String id;
	@Column(length = 100, nullable = false) //not null
	private String pw;
	@Column(length = 100, nullable = false)
	private String name;
	@Column(length = 13)
	private String phone;
	@Column(length = 30)
	private String email;
	@Column(length = 6)
	@ColumnDefault(" '남자' ") //숫자는 "1", 문자는 " '남자' "(문자는 홑따옴표 한번 더 씀)
	private String gender;
	@Column(length = 100)
	private String hobby;
	@CreationTimestamp
	private Timestamp mdate;

}
