<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>게시판</title>
  <script  src="http://code.jquery.com/jquery-latest.min.js"></script>
  <link href="https://fonts.googleapis.com/css?family=Noto+Sans+KR:400,500,700,900&display=swap&subset=korean" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.1/css/all.min.css">
  <link rel="stylesheet" href="../css/style.css">
  <link rel="stylesheet" href="../css/notice_list.css">
  <script>
	  //로그인 성공만 실행됨.
	  if("${flag}"=="1"){
	  	alert("게시글이 등록되었습니다.");
	  	location.href="/board/blist";
	  }else if("${flag}"=="2"){
		alert("게시글이 삭제되었습니다.");
		location.href="/board/blist";  
	  }else if("${flag}"=="3"){
		alert("게시글이 수정되었습니다.");
		location.href="/board/blist";  
	  }
  </script>
</head>
<body>
  <header>
    <ul>
      <c:if test="${session_id == null }">
		<li><a href="/member/join01">회원가입</a></li><span>|</span>
		<li><a href="/member/login">로그인</a></li><span>|</span>
	  </c:if>
	  <c:if test="${session_id != null }">
		<li><a href="/member/mupdate">${session_name} 님</a></li><span>|</span>
		<li><a onclick="logoutBtn()">로그아웃</a></li><span>|</span>
	  </c:if>
	  <li><a href="/board/blist">고객행복센터</a></li><span>|</span>
      <li>배송지역검색</li> <span>|</span>
      <li>기프트카드 등록</li>
    </ul>
  </header>

  <nav>
    <a href="/"><div class="logo"></div></a>

    <div id="search">
      <div class="search"></div><br>
      <span>메뉴찾기</span>
    </div>

    <div id="cart">
      <div class="cart"></div><br>
      <span>장바구니</span>
    </div>

    <div class="nav-menu">
      <ul>
        <li>COOKIT소개</li>
        <li>COOKIT 메뉴</li>
        <li>리뷰</li>
        <li>이벤트</li>
        <li>MY쿡킷</li>
      </ul>  
    </div>
  </nav>
  <script>
     function searchBtn(){
    	 console.log("category: "+$("#category").val());
    	 console.log("search: "+$("#search-word").val());
    	 if($("#search-word").val().length<1) {
    		 alert("검색어를 입력하셔야 검색이 가능합니다.");
    		 $("#search-word").focus();
    		 return;
    	 }
    	 searchFrm.submit();
     }
  </script>

  <section>
    <h1>NOTICE</h1>
    <div class="wrapper">
      <form action="/board/bsearch" name="searchFrm" method="get">
        <select name="category" id="category">
          <option value="all">전체</option>
          <option value="btitle">제목</option>
          <option value="bcontent">내용</option>
        </select>

        <div class="title">
          <input type="text" size="16" name="search" id="search-word">
        </div>
  
        <button type="button" onclick="searchBtn()"><i class="fas fa-search"></i></button>
      </form>
    </div>

    <table>
      <colgroup>
        <col width="15%">
        <col width="40%">
        <col width="15%">
        <col width="15%">
        <col width="15%">
      </colgroup>
      <tr>
        <th>No.</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회수</th>
      </tr>
      <c:forEach var="board" items="${map.list}">
      <tr>
        <td>${board.bno}</td>
        <td class="table-title">
          <c:forEach begin="1" end="${board.bindent}" step="1">▶</c:forEach>
          <a href="/board/bview?bno=${board.bno}">${board.btitle}</a>
        </td>
        <td>${board.id}</td>
        <td>
          <fmt:formatDate value="${board.bdate}" pattern="yyyy-MM-dd"/>
        </td>
        <td>${board.bhit}</td>
      </tr>
      </c:forEach>
      
    </table>

    <ul class="page-num">
      <c:if test="${map.page != 1}">
	      <a href="/board/blist?page=${nowpage}"><li class="first"></li></a>
      </c:if>
      <c:if test="${map.page == 1}">
	      <li class="first"></li>
      </c:if>
      <c:if test="${map.page>1}">
	      <a href="/board/blist?page=${map.page-1}"><li class="prev"></li></a>
      </c:if>
      <c:if test="${map.page<=1}">
	      <li class="prev"></li>
      </c:if>
      
      	<c:forEach var="nowpage" begin="${map.startPage}" end="${map.endPage}" step="1">
	      <c:if test="${map.page == nowpage}">
	      	<li class="num on"><div>${nowpage}</div></li>
	      </c:if>
	      <c:if test="${map.page != nowpage}">
	      	<a href="/board/blist?page=${nowpage}">
		      	<li class="num"><div>${nowpage}</div></li>
	      	</a>
	      </c:if>
      	</c:forEach>
   	<c:if test="${map.page<map.maxPage}">
       <a href="/board/blist?page=${map.page+1}"><li class="next"></li></a>
   	</c:if>
   	<c:if test="${map.page==map.maxPage}">
       <li class="next"></li>
   	</c:if>
      <c:if test="${map.page<map.maxPage}">
      <a href="/board/blist?page=${map.maxPage}"><li class="last"></li></a>
      </c:if>
      <c:if test="${map.page==map.maxPage}">
      <li class="last"></li>
      </c:if>
      
    </ul>

    <a href="/board/bwrite">
	    <div class="write">글쓰기</div>
    </a>
  </section>

  <footer>
    <div class="wrapper">
      <div class="footer-left">
        <div class="footer-logo"></div>
        <div class="copyright">© COOKIT ALL RIGHTS RESERVED</div>
      </div>
  
      <div class="footer-center">
        <ul class="footer-nav">
          <li class="first-list">이용약관</li>
          <li class="green">개인정보처리 방침</li>
          <li>법적고지</li>
          <li>사업자정보 확인</li>
        </ul>
  
        <ul class="footer-info">
          <li class="first-list">씨제이제일제당(주)</li>
          <li>대표이사 : 손경식,강신호,신현재</li>
          <li>사업자등록번호 : 104-86-09535</li>
          <li class="first-list">주소 : 서울 중구 동호로 330 CJ제일제당 센터 (우) 04560</li>
          <li>통신판매업신고 중구 제 07767호</li>
          <li class="first-list">개인정보보호책임자 : 조영민</li>
          <li>이메일 : cjon@cj.net</li>
          <li>호스팅제공자 : CJ올리브네트웍스㈜</li>
        </ul>
  
        <div id="check">고객님은 안전거래를 위해 현금등으로 결제시 LG U+ 전자 결제의 매매보호(에스크로) 서비스를 이용하실 수 있습니다. <span class="check">가입 사실 확인</span></div>
      </div>
  
      <div class="footer-right">
        <div id="shortcut">
          <span>CJ그룹계열사 바로가기</span>
          <div class="shortcut"></div>
        </div>
  
        <div class="call">고객행복센터 1668-1920</div>
        <div class="inquery">1:1 문의</div>
      </div>
  
    </div>
  </footer>
</body>
</html>