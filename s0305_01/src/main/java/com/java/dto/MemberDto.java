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
	
	@Column(length = 50)
	@Id
	private String id;
	@Column(length = 100,nullable = false)
	private String pw;
	@Column(length = 50,nullable = false)
	private String name;
	@Column(length = 13)
	private String phone;
	@Column(length = 50)
	private String email;
	@Column(length = 6)
	@ColumnDefault("'남자'")
	private String gender;
	@Column(length = 50)
	private String hobby;
	@CreationTimestamp
	private Timestamp mdate;
	

}
