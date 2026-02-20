<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
	<html>
		<head>
			<meta charset="UTF-8">
			<title>회원가입</title>
		</head>
	<body>
	   <h2>회원가입</h2>
	   <form action="/member/membershipOk" method="post" name="frm">
	     <input type="text" name="id" placeholder="아이디를 입력하세요."><br>
	     <input type="text" name="pw" placeholder="비밀번호를 입력하세요."><br>
	     <input type="text" name="name" placeholder="이름을 입력하세요."><br>
	     <input type="text" name="phone" placeholder="전화번호를 입력하세요."><br>
	     <input type="text" name="email" placeholder="이메일를 입력하세요."><br>
	     <label>성별</label><br>
	     <input type="radio" id="male" name="gender" value="남자" >
	     <label for="male">남자</label>
	     <input type="radio" id="female" name="gender" value="여자" >
	     <label for="female">여자</label><br>
	     <label>취미</label><br>
	     <input type="checkbox" id="game" name="hobby" value="게임" >
	     <label for="game">게임</label>
	     <input type="checkbox" id="golf" name="hobby" value="골프" >
	     <label for="golf">골프</label>
	     <input type="checkbox" id="swim" name="hobby" value="수영" >
	     <label for="swim">수영</label>
	     <input type="checkbox" id="run" name="hobby" value="조깅" >
	     <label for="run">조깅</label>
	     <input type="checkbox" id="book" name="hobby" value="독서" >
	     <label for="book">독서</label>
	     <br>
	     <input type="submit" value="회원가입">
	   </form>
	
	</body>
</html>