<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- header 부분 -->
<%@ include file="../layout/header.jsp" %>
<!-- header 부분 끝 -->
<jsp:useBean id="now" class="java.util.Date" />

	<!-- container -->
	<div id="container">

		<div id="location">
			<ol>
				<li><a href="#">HOME</a></li>
				<li><a href="#">CUSTOMER</a></li>
				<li class="last">NOTICE</li>
			</ol>
		</div>
		
		<div id="outbox">		
			<div id="left">
				<div id="title2">CUSTOMER<span>고객센터</span></div>
				<ul>	
					<li><a href="#" id="leftNavi1">NOTICE</a></li>
					<li><a href="#" id="leftNavi2">1:1문의</a></li>
					<li><a href="#" id="leftNavi3">FAQ</span></a></li>
					<li class="last"><a href="#" id="leftNavi4">이용안내</a></li>
				</ul>			
			</div><script type="text/javascript">initSubmenu(1,0);</script>


			<!-- contents -->
			<div id="contents">
				<div id="customer">
					<h2><strong>NOTICE</strong><span>쟈뎅샵 소식을 전해드립니다.</span></h2>
					
					<div class="orderDivMt">
						<table summary="NO, 제목, 등록일, 조회수 순으로 공지사항을 조회 하실수 있습니다." class="orderTable2" border="1" cellspacing="0">
							<caption>공지사항 보기</caption>
							<colgroup>
							<col width="10%" class="tnone" />
							<col width="*" />
							<col width="14%" class="tw25" />
							<col width="14%" class="tnone" />
							</colgroup>
							<thead>
								<th scope="col" class="tnone">NO.</th>
								<th scope="col">제목</th>
								<th scope="col">등록일</th>
								<th scope="col" class="tnone">조회수</th>
							</thead>
							<tbody>
								<c:forEach var="c" items="${map.list}">
								<tr>
									<td class="tnone">${c.bno}</td>
									<td class="left">
										<a href="/customer/customerView?bno=${c.bno}&page=${map.page}&category=${map.category}&search=${map.search}">${c.btitle}</a>
										<!-- 등록날짜와 현재날짜 비교해서 1일 이내이면 new 아이콘 생성 -->
										<!-- 날짜를 밀리세컨드로 계산해서 비교 -->
										<c:if test="${c.bdate.time >= now.time-(1000*60*60*24)}">
											<img src="../images/ico/ico_new.gif" alt="NEW" />
										</c:if>
									</td>
									<td><fmt:formatDate value="${c.bdate}" pattern="yyyy-MM-dd"/></td>
									<td class="tnone right">${c.bhit}</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
						
					<div class="btnAreaList">
						<div class="bwright">
							<ul>
								<li><a href="/customer/customerWrite" class="sbtnMini">글쓰기</a></li>
							</ul>
						</div>
					
						<!-- 페이징이동1 -->
						<div class="allPageMoving1">
						<a href="/customer/customer?page=1&category=${map.category}&search=${map.search}" class="n"><img src="../images/btn/btn_pre2.gif" alt="처음으로"/></a>
						<a href="/customer/customer?page=${map.page-1}&category=${map.category}&search=${map.search}" class="pre"><img src="../images/btn/btn_pre1.gif" alt="앞페이지로"/></a>
						<c:forEach var="i" begin="${map.startPage}" end="${map.endPage}" step="1">
							<c:if test="${map.page == i}">
								<strong>${i}</strong>
							</c:if>
							<c:if test="${map.page != i}">
								<a href="/customer/customer?page=${i}&category=${map.category}&search=${map.search}">${i}</a>
							</c:if>
						</c:forEach>
						<a href="/customer/customer?page=${map.page+1}&category=${map.category}&search=${map.search}" class="next"><img src="../images/btn/btn_next1.gif" alt="뒤페이지로"/></a>
						<a href="/customer/customer?page=${map.maxPage}&category=${map.category}&search=${map.search}" class="n"><img src="../images/btn/btn_next2.gif" alt="마지막페이지로"/></a>
						</div>
						<!-- //페이징이동1 -->
					</div>

					<div class="searchWrap">
					<form action="/customer/customer" method="get" name="sFrm">
						<div class="search">
							<ul>
								<li class="web"><img src="../images/txt/txt_search.gif" alt="search" /></li>
								<li class="se">
									<select name="category">
										<option value="all" />전체</option>
										<option value="btitle" />제목</option>
										<option value="bcontent" />내용</option>
									</select>
								</li>
								<li><input type="text" name="search" class="searchInput" /></li>
								<li class="web"><a onclick="searhBtn()"><img src="../images/btn/btn_search.gif" alt="검색" /></a></li>
								<li class="mobile"><a onclick="searhBtn()"><img src="../images/btn/btn_search_m.gif" alt="검색" /></a></li>
							</ul>
						</div>
					</form>
					<script>
						function searchBtn(){
							alert("검색을 시작합니다.");
							sFrm.submit();
						}
					</script>
					</div>
					<!-- //포토 구매후기 -->


				</div>
			</div>
			<!-- //contents -->

		</div>
	</div>
	<!-- //container -->

<!-- footer 부분 -->
<%@ include file="../layout/footer.jsp" %>
<!-- footer 부분 끝 -->
