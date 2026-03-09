package com.java.game.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;

@Entity
@Table(name = "TRAINEE")
@SequenceGenerator(
		name = "trainee_seq_generator",
		sequenceName = "TRAINEE_SEQ",
		allocationSize = 1
)
public class Trainee {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "trainee_seq_generator")
	@Column(name = "ID")
	private Long id;

	@Column(name = "NAME")
	private String name;

	@Enumerated(EnumType.STRING)
	@Column(name = "GENDER")
	private Gender gender;

	@Enumerated(EnumType.STRING)
	@Column(name = "GRADE")
	private Grade grade;

	@Column(name = "VOCAL")
	private int vocal;

	@Column(name = "DANCE")
	private int dance;

	@Column(name = "STAR")
	private int star;

	@Column(name = "MENTAL")
	private int mental;

	@Column(name = "TEAMWORK")
	private int teamwork;

	@Column(name = "IMAGE_PATH")
	private String imagePath;

	/* ── 추가 프로필 필드 ── */
	@Column(name = "AGE")
	private Integer age; // 나이

	@Column(name = "HEIGHT")
	private Integer height; // 키 (cm)

	@Column(name = "WEIGHT")
	private Integer weight; // 몸무게 (kg)

	@Column(name = "HOBBY")
	private String hobby; // 취미

	@Column(name = "MOTTO")
	private String motto; // 좌우명

	@Column(name = "INSTAGRAM")
	private String instagram; // 인스타그램 아이디

	protected Trainee() {
	}

	/* 기존 생성자 유지 */
	public Trainee(String name, Gender gender, Grade grade, int vocal, int dance, int star, int mental, int teamwork,
			String imagePath) {
		this.name = name;
		this.gender = gender;
		this.grade = grade;
		this.vocal = vocal;
		this.dance = dance;
		this.star = star;
		this.mental = mental;
		this.teamwork = teamwork;
		this.imagePath = imagePath;
	}

	/* 기존 getter */
	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Gender getGender() {
		return gender;
	}

	public Grade getGrade() {
		return grade;
	}

	public int getVocal() {
		return vocal;
	}

	public int getDance() {
		return dance;
	}

	public int getStar() {
		return star;
	}

	public int getMental() {
		return mental;
	}

	public int getTeamwork() {
		return teamwork;
	}

	public String getImagePath() {
		return imagePath;
	}

	/* 추가 프로필 getter */
	public Integer getAge() {
		return age;
	}

	public Integer getHeight() {
		return height;
	}

	public Integer getWeight() {
		return weight;
	}

	public String getHobby() {
		return hobby;
	}

	public String getMotto() {
		return motto;
	}

	public String getInstagram() {
		return instagram;
	}

	/* 기본 정보 setter (어드민 수정용) */
	public void setName(String name) {
		this.name = name;
	}

	public void setGrade(Grade grade) {
		this.grade = grade;
	}

	public void setVocal(int vocal) {
		this.vocal = vocal;
	}

	public void setDance(int dance) {
		this.dance = dance;
	}

	public void setStar(int star) {
		this.star = star;
	}

	public void setMental(int mental) {
		this.mental = mental;
	}

	public void setTeamwork(int teamwork) {
		this.teamwork = teamwork;
	}

	/* 추가 프로필 setter */
	public void setAge(Integer age) {
		this.age = age;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	public void setWeight(Integer weight) {
		this.weight = weight;
	}

	public void setHobby(String hobby) {
		this.hobby = hobby;
	}

	public void setMotto(String motto) {
		this.motto = motto;
	}

	public void setInstagram(String instagram) {
		this.instagram = instagram;
	}

	/* ── 스탯 변경 (1~100 범위 클램프) ── */
	public void applyVocal(int delta) {
		this.vocal = clamp(this.vocal + delta);
	}

	public void applyDance(int delta) {
		this.dance = clamp(this.dance + delta);
	}

	public void applyStar(int delta) {
		this.star = clamp(this.star + delta);
	}

	public void applyMental(int delta) {
		this.mental = clamp(this.mental + delta);
	}

	public void applyTeamwork(int delta) {
		this.teamwork = clamp(this.teamwork + delta);
	}

	private static int clamp(int v) {
		return Math.max(1, Math.min(100, v));
	}
}
