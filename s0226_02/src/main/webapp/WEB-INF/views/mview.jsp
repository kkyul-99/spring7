<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원정보 상세보기</title>
  <style>
    @font-face {
        font-family: 'Pretendard';
        src: url('https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
        font-weight: 400;
        font-display: swap;
    }
    @font-face {
        font-family: 'Pretendard';
        src: url('https://cdn.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Bold.woff') format('woff');
        font-weight: 700;
        font-display: swap;
    }
    * { font-family: 'Pretendard'; }
    ul, ol { list-style: none; padding: 0; margin: 0; }

    body {
      margin: 0;
      padding: 0;
      background: #fff;
      color: #1a1a1a;
    }

    /* Header (우측 상단 메뉴 + 아이콘) */
    .header {
      width: 100%;
      height: 60px;
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 0 40px;
      box-sizing: border-box;
      border-bottom: 1px solid #f0f0f0;
    }
    .top-menu {
      display: flex;
      gap: 15px;
      font-size: 13px;
      color: #636363;
      margin-right: 20px;
    }
    .top-menu a {
      text-decoration: none;
      color: #636363;
    }
    .top-menu a:hover {
      color: #035fe0;
    }
    .icons {
      display: flex;
      gap: 15px;
      font-size: 18px;
      cursor: pointer;
    }

    .container {
      width: 100%;
      max-width: 720px;
      margin: 0 auto;
      box-sizing: border-box;
    }

    .title {
        margin: 0 auto;
        text-align: center;
        padding: 70px 0;
        font-size: 30px;
        font-weight: bold;
    }

    .orderStep {
        text-align: center;
        padding-bottom: 20px;
        margin-bottom: 10px;
        border-bottom: 1px solid #1a1a1a;
    }

    .orderStep ul {
        display: flex;
        justify-content: center;
        gap: 40px;
    }

    .orderStep li {
      display: inline-block;
      font-size: 14px;
    }

    /* 수정된 부분: 현재 단계 스타일 완전히 적용 */
    .orderStep li .current {
        color: #035fe0;
        font-weight: 700;
        font-size: 15px;
    }

    .form-box {
      margin: 0 auto;
      max-width: 720px;
      box-sizing: border-box;
      padding: 10px 30px;
    }

    .form-box table {
      width: 100%;
      border-collapse: collapse;
    }

    .form-box td {
      padding: 4px 0 12px;
      vertical-align: middle;
    }

    .form-box td:first-child {
      width: 140px;
      font-weight: 700;
      color: #1a1a1a;
    }

    input[type="text"], input[type="password"], input[type="email"], select {
      width: 100%;
      padding: 15px;
      font-size: 15px;
      height: 45px;
      border: 1px solid #ccc;
      box-sizing: border-box;
      background: white;
    }

    input:focus, select:focus {
      outline: 1.5px solid #1a1a1a;
    }

    /* 아이디, 이메일, 인증번호 입력 + 버튼 */
    .id-check-box,
    .email-input,
    .code-input {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .id-check-box input,
    .email-input input,
    .code-input input {
      flex: 1;
    }

    .id-check-box button,
    .email-input button,
    .code-input button {
      width: 110px;
      height: 45px;
      border: 1px solid #035fe0;
      background-color: #035fe0;
      color: #fff;
      cursor: pointer;
      font-size: 15px;
      font-weight: 500;
      flex-shrink: 0;
    }

    /* 휴대전화 입력칸 */
    .phone-input {
      display: flex;
      align-items: center;
      gap: 5px;
    }

    .phone-input select,
    .phone-input input {
      flex: 1;
      height: 45px;
      font-size: 15px;
      border: 1px solid #ccc;
      background: white;
      padding: 0 10px;
      box-sizing: border-box;
    }

    .phone-input span {
      width: 15px;
      text-align: center;
    }

    /* 하단 버튼 */
    .btn-box {
      display: flex;
      justify-content: center;
      gap: 15px;
      padding: 50px 0; /* 버튼 위아래 여백 동일하게 */
      margin: 0;
    }

    .btn-box .btn {
      width: 160px;
      height: 50px;
      font-size: 15px;
      font-weight: 400;
      border: 1px solid #ccc;
      background-color: white;
      color: #1a1a1a;
      cursor: pointer;
      box-sizing: border-box;
      margin: 0;
    }

    .btn-box .btn.submit {
      background-color: #035fe0;
      border: 1px solid #035fe0;
      color: #fff;
      font-weight: 500;
    }

    @media (max-width: 768px) {
      .btn-box {
        flex-direction: column;
        gap: 10px;
      }
      .btn-box .btn {
        width: 100%;
      }
    }
  </style>
</head>
<body>
  <div class="header">
    <div class="top-menu">
      <a href="#">회원가입</a> |
      <a href="#">로그인</a> |
      <a href="#">주문조회</a> |
      <a href="#">최근본상품</a>
    </div>
    <div class="icons">
      <i class="fas fa-search"></i>
      <i class="fas fa-user"></i>
      <i class="fas fa-shopping-bag"></i>
    </div>
  </div>
  <div class="container">
    <div class="steps">
      <div class="title">회원정보 상세보기</div>
      <div class="orderStep">
      </div>
    </div>
    <div class="form-box">
      <table>
        <tr>
          <td>아이디 <span style="color:red"></span></td>
          <td>${member.id}</td>
        </tr>
        <tr>
          <td>비밀번호 <span style="color:red"></span></td>
          <td>${member.pw}</td>
        </tr>
       
        <tr>
          <td>이름</td>
          <td>${member.name}</td>
        </tr>
        <tr>
          <td>휴대전화 <span style="color:red"></span></td>
          <td>${member.phone}</td>
        </tr>
        <tr>
          <td>이메일 <span style="color:red"></span></td>
          <td>${member.email}</td>
        </tr>
        <tr>
          <td>성별 <span style="color:red"></span></td>
          <td>${member.gender}</td>
        </tr>
        <tr>
          <td>취미 <span style="color:red"></span></td>
          <td>${member.hobby}</td>
        </tr>
      </table>
    </div>
    <div class="btn-box">
      <a href="/member/mlist">
        <button class="btn cancel">회원목록</button>
      </a>
      <a href="/member/mupdate?id=${member.id}">
        <button type="button" class="btn submit">회원수정</button>
      </a>
    </div>
    
  </div>
  <footer></footer>
</body>
</html>
