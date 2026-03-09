package com.java.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "MEMBER", uniqueConstraints = {
		@UniqueConstraint(name = "uk_member_mid", columnNames = "mid"),
		@UniqueConstraint(name = "uk_member_email", columnNames = "email"),
		@UniqueConstraint(name = "uk_member_nickname", columnNames = "nickname")
})
@SequenceGenerator(
		name = "member_seq_generator",
		sequenceName = "MEMBER_SEQ",
		allocationSize = 1
)
public class Member {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "member_seq_generator")
	private Long mno;

	@Column(nullable = false, length = 50)
	private String mid;

	@Column(nullable = false, length = 100)
	private String mpw;

	@Column(nullable = false, length = 50)
	private String mname;

	@Column(nullable = false, length = 50)
	private String nickname;

	@Column(nullable = false, length = 120)
	private String email;

	@Column(length = 30)
	private String phone;

	@Column(length = 255)
	private String address;

	@Column(name = "address_detail", length = 255)
	private String addressDetail;

	@Column(length = 20)
	private String jumin;

	@Column(name = "PROFILE_IMAGE", length = 255)
	private String profileImage;

	@Column(name = "created_at", nullable = false)
	private LocalDateTime createdAt;

	@PrePersist
	void onCreate() {
		if (createdAt == null) createdAt = LocalDateTime.now();
	}

	public Long getMno() { return mno; }
	public void setMno(Long mno) { this.mno = mno; }

	public String getMid() { return mid; }
	public void setMid(String mid) { this.mid = mid; }

	public String getMpw() { return mpw; }
	public void setMpw(String mpw) { this.mpw = mpw; }

	public String getMname() { return mname; }
	public void setMname(String mname) { this.mname = mname; }

	public String getNickname() { return nickname; }
	public void setNickname(String nickname) { this.nickname = nickname; }

	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }

	public String getPhone() { return phone; }
	public void setPhone(String phone) { this.phone = phone; }

	public String getAddress() { return address; }
	public void setAddress(String address) { this.address = address; }

	public String getAddressDetail() { return addressDetail; }
	public void setAddressDetail(String addressDetail) { this.addressDetail = addressDetail; }

	public String getJumin() { return jumin; }
	public void setJumin(String jumin) { this.jumin = jumin; }

	public String getProfileImage() { return profileImage; }
	public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

	public LocalDateTime getCreatedAt() { return createdAt; }
	public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

	public String getCreatedAtStr() {
		return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : "";
	}

	public String getCreatedAtDay() {
		return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("MM/dd")) : "";
	}
}