<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>게시판</title>
	</head>
	<body>
		<h2>게시판</h2>
		<form action="/board" method="post">
			<input type="text" name="bno" placeholder="게시글 번호를 입력하세요."><br>
			<input type="text" name="id" placeholder="작성자를 입력하세요."><br>
			<input type="text" name="btitle" placeholder="제목을 입력하세요."><br>
			<input type="text" name="bcontent" placeholder="내용을 입력하세요."><br>
			<br>
			<input type="submit" value="글쓰기"><br>
		</form>
		<ul>
			<li><a href="/">홈으로</a></li>
		</ul>
	</body>
</html>