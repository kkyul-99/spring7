package com.java.dto;

import java.sql.Timestamp;

public class EventDto {
	private Integer eno;          // 이벤트 번호 - int eno
    private String etitle;         // 제목
    private String econtent;       // 내용

    private Timestamp startDate;  // 이벤트 시작일
    private Timestamp endDate;    // 이벤트 종료일

    private String imageUrl;      // 이미지 경로(배너)
    private String imageUrl2;      // 이미지 경로(컨텐츠이미지)

    private Timestamp crdate; // 작성일
    private Timestamp update; // 수정일

    private int ehit;        // 조회수
    private String status;      // 진행상태 (예: 예정, 진행중, 종료)
}
