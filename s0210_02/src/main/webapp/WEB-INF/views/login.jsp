<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그인페이지</title>
		<script>
			if("${flag}"==2) {
				alert("아이디 또는 패스워드가 일치하지 않습니다.\n다시 로그인해주세요.")
			}
		</script>
	</head>
	<body>
		<h2>로그인페이지</h2>
		<form action="/login" method="post">
			<input type="text" name="id" placeholder="아이디를 입력하세요."><br>
			<input type="text" name="pw" placeholder="비밀번호를 입력하세요."><br>
			<input type="submit" value="로그인">
		</form>
		<ul>
			<li><a href="/">홈으로</a></li>
		</ul>
	</body>
</html>