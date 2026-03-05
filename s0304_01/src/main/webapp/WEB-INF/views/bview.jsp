<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <script src="http://code.jquery.com/jquery-latest.min.js"></script>
  <title>VLAST Shop - 게시글 상세보기</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      background: #fff;
      color: #1a1a1a;
    }
    /* Header */
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

    /* Detail Container */
    .detail-container {
      max-width: 800px;
      margin: 80px auto;
      padding: 0 20px;
      box-sizing: border-box;
    }
    .detail-title {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 20px;
      text-align: center;
    }
    .detail-info {
      display: flex;
      justify-content: space-between;
      color: #888;
      font-size: 13px;
      margin-bottom: 30px;
      border-bottom: 1px solid #e0e0e0;
      padding-bottom: 10px;
    }
    .detail-content {
      font-size: 15px;
      line-height: 1.6;
      color: #1a1a1a;
      white-space: pre-wrap; /* 줄바꿈 유지 */
      margin-bottom: 40px;
      border-bottom: 1px solid #e0e0e0;
      padding-bottom: 20px;
    }

    /* Buttons */
    .detail-buttons {
      display: flex;
      justify-content: flex-end;
      gap: 15px;
    }
    .detail-buttons a,
    .detail-buttons button {
      text-decoration: none;
      padding: 8px 18px;
      font-size: 14px;
      color: white;
      background-color: #035fe0;
      border-radius: 4px;
      border: none;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    .detail-buttons a:hover,
    .detail-buttons button:hover {
      background-color: #0046b3;
    }

	/* 이전글 / 다음글 */
	.prev-next {
	  margin-top: 40px;
	  border-top: 1px solid #e0e0e0;
	  padding-top: 20px;
	}
	
	.prev-next div {
	  display: flex;
	  gap: 15px;
	  padding: 8px 0;
	  font-size: 14px;
	}
	
	.prev-next span {
	  width: 70px;
	  color: #888;
	  font-weight: bold;
	}
	
	.prev-next a {
	  text-decoration: none;
	  color: #1a1a1a;
	}
	
	.prev-next a:hover {
	  color: #035fe0;
	}

    /* Footer */
    footer {
      border-top: 1px solid #ccc;
      padding: 30px;
      text-align: center;
      font-size: 13px;
      color: #A0A0A0;
    }

    /* Modal Styles */
    .modal-overlay {
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.5);
      display: none; /* 숨김 */
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal {
      background: #fff;
      padding: 25px 30px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      max-width: 400px;
      width: 100%;
      text-align: center;
    }
    .modal p {
      font-size: 16px;
      margin-bottom: 25px;
      color: #1a1a1a;
    }
    .modal-buttons {
      display: flex;
      justify-content: center;
      gap: 20px;
    }
    .modal-buttons button {
      padding: 8px 22px;
      border-radius: 4px;
      border: none;
      font-size: 14px;
      cursor: pointer;
    }
    .modal-buttons .confirm {
      background-color: #d9534f;
      color: white;
      transition: background-color 0.3s;
    }
    .modal-buttons .confirm:hover {
      background-color: #c9302c;
    }
    .modal-buttons .cancel {
      background-color: #6c757d;
      color: white;
      transition: background-color 0.3s;
    }
    .modal-buttons .cancel:hover {
      background-color: #5a6268;
    }

    /* 댓글 영역 */
    #commentsSection {
      max-width: 800px;
      margin: 40px auto 100px;
      padding: 0 20px;
      box-sizing: border-box;
      border-top: 1px solid #e0e0e0;
    }
    #commentsSection h3 {
      font-size: 22px;
      margin-bottom: 15px;
      font-weight: bold;
    }
    #commentForm {
      display: flex;
      gap: 10px;
      margin-bottom: 30px;
    }
    #commentForm input[type="text"] {
      flex: 0 0 150px;
      padding: 8px 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    #commentForm textarea {
      flex: 1;
      padding: 8px 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
      resize: vertical;
      min-height: 40px;
    }
    #commentForm button {
      padding: 8px 18px;
      background-color: #035fe0;
      border: none;
      border-radius: 4px;
      color: white;
      font-size: 14px;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    #commentForm button:hover {
      background-color: #0046b3;
    }
    #commentsList .comment {
      padding: 12px 15px;
      border-bottom: 1px solid #e0e0e0;
    }
    #commentsList .comment strong {
      font-weight: bold;
    }
    #commentsList .comment span {
      color: #888;
      font-size: 12px;
      margin-left: 8px;
    }
    #commentsList .comment p {
      margin: 8px 0 0 0;
      white-space: pre-wrap;
      font-size: 14px;
      color: #1a1a1a;
    }
    /* 댓글 버튼 스타일 */
    .comment-buttons {
      margin-top: 8px;
    }
    .comment-buttons button {
      padding: 4px 10px;
      margin-right: 8px;
      font-size: 12px;
      border: none;
      border-radius: 3px;
      cursor: pointer;
      background-color: #035fe0;
      color: white;
      transition: background-color 0.3s;
    }
    .comment-buttons button:hover {
      background-color: #0046b3;
    }
  </style>
  <script src="https://kit.fontawesome.com/yourcode.js" crossorigin="anonymous"></script>
</head>
<body>

  <!-- Header -->
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

  <!-- Detail View -->
  <div class="detail-container">
    <div class="detail-title">${board.btitle}</div>
    <div class="detail-info">
      <div>작성자: ${board.memberDto.name}</div>
      <div>작성일: <fmt:formatDate value="${board.bdate}" pattern="yyyy-MM-dd"/></div>
      <div>조회수: ${board.bhit}</div>
      
    </div>
    <div class="detail-content">
     ${board.bcontent }
	    <div>
	        <c:if test="${board.bfile !=null }">
	          <img style="width:80%;" src="/upload/${board.bfile}" />
	        </c:if>
	        <c:if test="${board.bfile ==null }">
	          <strong>해당 이미지가 없습니다.</strong>
	        </c:if>
	    </div>
    </div>
    <div class="detail-buttons">
      <a href="/board/breply?bno=${board.bno}">답변달기</a>
      <a href="/board/blist?page=${page}&category=${category}&search=${search}">목록으로</a>
      <a href="/board/bupdate?bno=${board.bno}">수정</a>
      <button id="deleteBtn">삭제</button>
    </div>
    
    <!-- 이전글 / 다음글 -->
	<div class="prev-next">
	  <div class="prev-post">
	    <span>이전글</span>
	    <c:if test="${preBoard == null }">해당 게시글이 없습니다.</c:if>
	    <c:if test="${preBoard != null }">
	    <a href="/board/bview/${preBoard.bno}">${preBoard.btitle }</a>
	    </c:if>
	  </div>
	  <div class="next-post">
	    <span>다음글</span>
	    <c:if test="${nextBoard == null }">해당 게시글이 없습니다.</c:if>
	    <c:if test="${nextBoard != null }">
	    <a href="/board/bview/${nextBoard.bno}">${nextBoard.btitle }</a>
	    </c:if>
	  </div>
	</div>
    
  </div>

  <!-- 댓글 섹션 -->
  <div id="commentsSection">
    <h3>댓글</h3>
    <form id="commentForm">
      <input type="text" id="commentName" value=${session_name} readOnly placeholder="이름" maxlength="20" />
      <textarea id="commentText" placeholder="댓글을 입력하세요." maxlength="200"></textarea>
      <button type="button" id="commentBtn">등록</button>
    </form>
    <div id="commentsList">
      <c:forEach var="c" items="${board.commentList}">
	      <div class="comment" id=${c.cno}>
	        <strong>${c.memberDto.name}</strong> <span>(
	        <fmt:formatDate value="${c.cdate}" pattern="yyyy-MM-dd HH:mm"/>
	        )</span>
	        <p>${c.ccontent }</p>
	        <div class="comment-buttons">
	          <button class="edit-btn">수정</button>
	          <button class="delete-btn">삭제</button>
	        </div>
	      </div>
      </c:forEach>
    </div>
  </div>

  <!-- Modal : 게시글삭제 -->
  <div class="modal-overlay" id="modalOverlay">
    <div class="modal">
      <p>삭제하시겠습니까?</p>
      <div class="modal-buttons">
        <button class="confirm" id="confirmDelete">삭제</button>
        <button class="cancel" id="cancelDelete">취소</button>
      </div>
    </div>
  </div>

  <!-- Footer -->
  <footer>
    Copyright © VLAST Shop. All rights reserved.
  </footer>

  <script>
    const deleteBtn = document.getElementById('deleteBtn');
    const modalOverlay = document.getElementById('modalOverlay');
    const confirmDelete = document.getElementById('confirmDelete');
    const cancelDelete = document.getElementById('cancelDelete');

    deleteBtn.addEventListener('click', () => {
      modalOverlay.style.display = 'flex';
    });

    cancelDelete.addEventListener('click', () => {
      modalOverlay.style.display = 'none';
    });

    confirmDelete.addEventListener('click', () => {
      modalOverlay.style.display = 'none';
      // 실제 삭제 로직 삽입 위치
      $.ajax({
    	 url:"/board/bdelete",
    	 type:"delete", //get,post,put,delete
    	 data:{"bno":${board.bno}},  //jstl,el의 태그에서 사용하는 변수
    	 dataType:"text",
    	 success:function(data){console.log(data);},
    	 error:function(){alert("실패");}
      });
      
      alert('게시글이 삭제되었습니다.');
      // 예: 목록 페이지로 이동
      window.location.href = '/board/blist';
    });

    // 모달 바깥 클릭 시 닫기
    modalOverlay.addEventListener('click', (e) => {
      if(e.target === modalOverlay) {
        modalOverlay.style.display = 'none';
      }
    });

    // ----------------------------------------------------------------
    // 댓글 기능
    // ----------------------------------------------------------------
    $(function(){
    	
    	//01. 댓글추가
    	$(document).on("click","#commentBtn",function(){
    	    const name = $('#commentName').val().trim();
    	    const text = $('#commentText').val().trim();
    	    if (!text) {
    	        alert('댓글 내용을 입력해주세요.');
    	        $('#commentText').focus();
    	        return;
    	    }
    	    
    		alert("댓글을 추가합니다.");
    		let html_data = ``;
    		//ajax
    		$.ajax({
    			url:"/comment/save",
    			type:"post",
    			dataType:"json", //text,json,xml
    			data:{"ccontent":text,"bno":${board.bno}},
    			success:function(data){
    				console.log(data); //1차 출력
    			},
    			error:function(){alert("실패");}
    		});//ajax
    		//input 리셋
    	    $('#commentText').val("");
    	});//commentBtn
    	
    	//02.댓글삭제
    	// 동적이벤트
    	$(document).on("click",".delete-btn",function(){
    		console.log("this closest : ",$(this).closest($(".comment")));
    		const cno = $(this).closest($(".comment")).attr("id")
    		console.log("cno : ",cno);
    		if (confirm('이 댓글을 삭제하시겠습니까?')) {
    	        //ajax - db삭제  
	    		$.ajax({
	    			url:"/comment/delete",
	    			type:"delete",
	    			dataType:"text", //text,json,xml
	    			data:{"cno": cno },
	    			success:function(data){
	    				console.log(data); //1차 출력
	    			},
	    			error:function(){alert("실패");}
	    		});//ajax
    			
    			$(this).closest($(".comment")).remove();
    	    }
    	});
    	
    	   	
    	
    });//jquery
    

    // XSS 방지용 간단 함수
    function escapeHtml(text) {
      return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
    }
  </script>
</body>
</html>
