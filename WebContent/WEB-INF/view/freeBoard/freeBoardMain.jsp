<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript">
let backURLFlag = true;
$(function(){
	
	/* 검색시 검색폼의 값 유지 */
	var searchColumn = getParameterByName("searchColumn");
	$("option[value='"+searchColumn+"']").attr("selected","selected");
	$("input[name='searchWord']").val(getParameterByName("searchWord"));

	/*검색폼 변경시 input 타입 변경*/
	adaptSearchFrmType();
	$("select[name='searchColumn']").change(function(){
		adaptSearchFrmType();
	});

	console.log("searchWord:",getParameterByName("searchWord"));
	console.log("searchColumn:",getParameterByName("searchColumn"));
	console.log("curPage:",getParameterByName("curPage"));
	//브라우저의 앞뒤로 이동 버튼 클릭시 변경된 url을 적용하여 테이블을 변경함 
	window.addEventListener('popstate', function (event) {
		console.log("popstate이벤트 호출됨");
		if(window.location.pathname === '/mavenBoard/main.ino'){
			console.log('pathname',window.location.pathname );
			console.log("backURLFlag",backURLFlag);
			backURLFlag = true;
			getSearchAjax(getParameterByName("curPage"));
			backURLFlag = false;
		}
	});
	
});
	
//파라미터값 리턴
function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function adaptSearchFrmType(){
	var searchFrmSel = $("select[name='searchColumn'] option:selected");
	if(searchFrmSel.val() == "DCOM1"){
		$("input[name='searchWord']").prop("type","number");
	}else{
		$("input[name='searchWord']").prop("type","text");
	}
}
function getSearchAjax(curPage) {
	var searchColumn = $("select[name='searchColumn'] option:selected").val();
	var searchWord = $("input[name='searchWord']").val();
	$.ajax({
		url : './mainSearch.ino',
		dataType : 'json',
		type : 'get',
		data : $("form[name='searchFrm']").serialize()+"&curPage="+curPage,
		success : function(result) {
			var htmlStr = "";
			var pagingHtml = "";
			console.log("getSearchAjax:success:",result.list);
			if(result.list.length != 0){
				$.each(result.list,function(key,value){
					htmlStr += "<tr>";
					htmlStr += 		"<td style='width: 50px; padding-left: 30px;' align='center'>"+value.codeType+"</td>";
					htmlStr += 		"<td style='width: 50px; padding-left: 10px;' align='center'>"+value.num+"</td>";
					htmlStr += 		"<td style='width: 200px;' align='center'><a href='./freeBoardDetail.ino?num="+value.num
										+"&searchColumn="+result.searchColumn+"&searchWord="+result.searchWord+"&curPage="+curPage+"'>"+value.title+"</a></td>";
					htmlStr += 		"<td style='width: 80px; padding-left: 10px;' align='center'>"+value.name+"</td>";
					htmlStr += 		"<td style='width: 80px; padding-left: 30px;' align='center'>"+value.regdate+"</td>";
					htmlStr += "</tr>";
				});

				//처음
				if(result.pagination.curRange != 1)
					pagingHtml += "<a onclick='getSearchAjax(1)'>처음</a>";
				//이전
				if(result.pagination.curPage != 1)
					pagingHtml += "<a onclick='getSearchAjax("+result.pagination.prevPage+")'>이전</a>";
				//페이지버튼
				for(var i=result.pagination.startPage; i<= result.pagination.endPage; i++){
					if(i == result.pagination.curPage)
						pagingHtml += " <span style='font-weight: bold;color: blue;'><a onclick='getSearchAjax("+i+")'>"+i+"</a></span>";
					else
						pagingHtml += "<a onclick='getSearchAjax("+i+")'>"+i+"</a>";
				}
				//다음
				if(result.pagination.curPage != result.pagination.pageCnt 
						&& result.pagination.pageCnt > 0)
					pagingHtml += "<a onclick='getSearchAjax("+result.pagination.nextPage+")'>다음</a>";
				//끝
				if(result.pagination.curPage != result.pagination.rangeCnt 
						&&result.pagination.curRange < result.pagination.rangeCnt)
					pagingHtml += "<a onclick='getSearchAjax("+result.pagination.pageCnt+")'>끝</a>";


				//뒤로가기페이지 셋팅
				console.log("backURL추가여부:",backURLFlag);
				if(backURLFlag){
					history.pushState(null, null, "./main.ino?curPage="+curPage+"&searchColumn="+searchColumn+"&searchWord="+searchWord);					
				}
				
			}else{
				htmlStr += "<tr>";
				htmlStr += 		"<td style='width: 600px;text-align: center;' colspan='5'>검색결과가 없습니다.</td>";
				htmlStr += "</tr>";
			}
			$("tbody").empty();
			$("tbody").append(htmlStr);
			$("#pagingDIV").empty();
			$("#pagingDIV").append(pagingHtml);
		},
		error : function(request, status, error){
			console.log(request, status, error);
		}
	});

}
//페이징버튼 ajax 안쓸때
function pagingFn(page){
	location.href="./main.ino?curPage="+page+
		"&searchColumn="+getParameterByName("searchColumn")+
		"&searchWord="+getParameterByName("searchWord");
}
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{2})+(?!\d))/g, ".");
}

function validation(to){
	//to => startDate	or endDate
	var selector = $("#"+to);
	var dateVal = $("#"+to).val();
	var length = dateVal.length;
	console.log("변경전:",dateVal);
	console.log("event.key:",event.key);
	console.log("event.keyCode",event.keyCode);
	
	//숫자가 아니면 입력된 값을 지움
	if( !(event.keyCode >= 48 && event.keyCode <= 57) ){
		//backSpace,tab 등 기능키 인경우 메시지를 띄우지 않음
		if( !(event.keyCode <= 47)) {
			$("#validationMsg").text("숫자만 입력가능");
		}
		var setValue = dateVal.substring(0, length-1);
		console.log('setValue',setValue);
		selector.val(setValue);
		return;
	}

	
	var intValue = dateVal.replaceAll(".","");
	var arrVal = dateVal.split("");
	console.log("arrVal",arrVal); 
	for(var i=0; i<arrVal.length; i++){
		//["1", "2", ".", "1", "1", ".", "1", "1"]
		if(i==2 || i==5){
			console.log("arrVal["+i+"]",arrVal[i]);
			if(arrVal[i] != "."){
				var pop = arrVal.pop();
				arrVal.push(".");
				arrVal.push(pop) ;
			}
		}
		console.log("join",arrVal.join(''));
		dateVal = arrVal.join('');
		selector.val(dateVal);
	}
	//입력한숫자길이가 짝수일때마다 .을 찍음
	if(intValue.length > 0 && intValue.length % 2 == 0 && intValue.length < 6 && event.key != "Backspace"){
		dateVal = dateVal+".";
		selector.val(dateVal);
	}

	

	//과거 2010년까지만 검색할수있도록 강제
	if(length == 2 && dateVal < 10 ){
		$("#validationMsg").text("2010년 부터 조회가능");
		selector.val("10.");
		return;
	}
	if(length == 2 && (20+dateVal > new Date().getFullYear()) ){
		$("#validationMsg").text("2020년 까지 조회가능");
		selector.val("10.");
		return;
	}
	//범위외 월 입력시
	if(length == 5 && (dateVal.substring(3,5)>12 || dateVal.substring(3,5) < 1) ){
		$("#validationMsg").text("12월까지만 입력가능");
		var value = dateVal.substring(0, 3);//20.34.
		selector.val( value );
		return;
	}
	if(length == 8){		
		console.log("년>>"+dateVal.substring(0,2));
		console.log("월>>"+dateVal.substring(3,5));
		console.log("일>>"+dateVal.substring(6));
		//날짜에 0일을 입력한경우
		if(dateVal.substring(6) < 1 ){
			$("#validationMsg").text("1일 부터 입력가능");
			var value = dateVal.substring(0, 6);
			selector.val( value );
			return;
		}
		
		let lastDate = new Date("20"+dateVal.substring(0,2),  dateVal.substring(3,5),  0 );
		if(dateVal.substring(6) > lastDate.getDate()){
			//msg>해당월의 말일까지 입력가능합니다
			$("#validationMsg").text( lastDate.getDate()+"일까지만 입력가능");
			var value = dateVal.substring(0, 6);
			selector.val( value );
			return;
		}

		let DOMDate  = new Date("20"+dateVal.substring(0,2),  dateVal.substring(3,5),  dateVal.substring(6));
		console.log("DOMDate입력값:",   DOMDate.toLocaleString() );
		console.log("lastDate입력값:", lastDate.toLocaleString() );

		var sysdate = new Date();
		if(DOMDate.getFullYear() > sysdate.getFullYear()  ||
				DOMDate.getMonth() > sysdate.getMonth()+1 ||
				DOMDate.getDate() > sysdate.getDate() ){
			$("#validationMsg").text('과거시간만 조회가능');
			selector.val('');
			$("#searchBtn").prop("disabled","disabled");
			return;
		}
		
		//시작,종료 중 한쪽만 입력한 경우
		if($("#startDate").val().length < 8){
			$("#validationMsg").text('시작일 입력필요');
			$("#startDate").focus();
			return;
		}else if($("#endDate").val().length < 8){
			$("#validationMsg").text('종료일 입력필요');
			$("#endDate").focus();
			return;
		}
		
		selector.css("color","");
		$("#searchBtn").removeProp("disabled");
		$("#validationMsg").text('');
	}else if(length < 8){
		$("#searchBtn").prop("disabled","disabled");
	}
	//시작일,종료일 둘다 입력해야 검색버튼 활성화
	if(($("#startDate").val().length == 8 && $("#endDate").val().length == 8)
			|| ($("#startDate").val().length == 0 && $("#endDate").val().length == 0) ){
		//시작일보다 종료일의 시간이 과거일수 없음
		var startDate = $("#startDate").val();
		startDate = new Date("20"+startDate.substring(0,2), 
				startDate.substring(3,5), 
				startDate.substring(6,8));
		var endDate = $("#endDate").val();
		endDate = new Date("20"+endDate.substring(0,2), 
				endDate.substring(3,5), 
				endDate.substring(6,8));
		if(startDate.getTime() > endDate.getTime() ){
			$("#validationMsg").text("시작일보다 종료일이 적음");
			$("#searchBtn").prop("disabled","disabled");
			selector.val('');
			return;
		}
		$("#searchBtn").removeProp("disabled");
	}else{
		$("#searchBtn").prop("disabled","disabled");
	}
	
	selector.val(dateVal.replace("..","."));
}



</script>
<style type="text/css">
a:hover{cursor: pointer;}
a{margin: 0px 5px 0px 5px;}
</style>
</head>
<body>

	<div>
		<h1>자유게시판</h1>${searchWord }
	</div>
	<div id="board">
		<div>
			<form name="searchFrm">
				
					<select name="searchColumn" >
						<!-- 
						<option value="searchNum">글번호</option>
						<option value="searchTitle">제목</option> 
						-->
						<c:forEach var="item" items="${searchOptions}">
							<c:if test="${item.CODE eq 'COM1'}">
								<option value="${item.DCODE}">${item.DCODE_NAME}</option>								
							</c:if>
						</c:forEach> 
					</select>
					<input type="text" name="searchWord" tabindex="1">
					<button type="button" id="searchBtn" onclick="getSearchAjax(1)">검색</button>
					<span id="validationMsg" style="color: red;"></span>
					
				
				<div>
					시작일<input id="startDate" name="startDate" type="text" placeholder="00.00.00" 
					maxlength="8" tabindex="2" autocomplete="off" onkeyup="validation('startDate');"/> ~
					종료일<input id="endDate" name="endDate" type="text" placeholder="00.00.00" 
					maxlength="8" tabindex="3" autocomplete="off" onkeyup="validation('endDate');"/>
				</div>
			</form>
		</div>
		<div style="width:650px;" align="right">
			<a href="./freeBoardInsert.ino">글쓰기</a>
		</div>
		<hr style="width: 600px;">
		<div style="padding-bottom: 10px;">
			<table border="1">
				<thead>
					<tr>
						<td style="width: 50px; padding-left: 30px;" align="center">타입</td>
						<td style="width: 50px; padding-left: 10px;" align="center">글번호</td>
						<td style="width: 200px;" align="center">글제목</td>
						<td style="width: 80px; padding-left: 10px;" align="center">글쓴이</td>
						<td style="width: 80px; padding-left: 30px;" align="center">작성일시</td>
					</tr>
				</thead>
			</table>
		</div>
		<hr style="width: 600px;">
	
		<div>
			<table border="1">
				<tbody>
						<c:if test="${empty freeBoardList }">
							<tr>
								<td style="width: 600px;text-align: center;" colspan="5">검색결과가 없습니다.</td>
							</tr>
						</c:if>
						<c:forEach var="dto" items="${freeBoardList }">
						<tr>
							<td style="width: 50px; padding-left: 30px;" align="center">${dto.codeType }</td>
							<td style="width: 50px; padding-left: 10px;" align="center">${dto.num }</td>
							<td style="width: 200px;" align="center"><a href="./freeBoardDetail.ino?num=${dto.num }&searchColumn=${param.searchColumn}&searchWord=${param.searchWord}&curPage=${param.curPage}">${dto.title }</a></td>
							<td style="width: 80px; padding-left: 10px;" align="center">${dto.name }</td>
							<td style="width: 80px; padding-left: 30px;" align="center">${dto.regdate }</td>
						<tr>
						</c:forEach>
						
				</tbody>
			</table>
		</div>
	
		<div id="pagingDIV">
	        <c:if test="${pagination.curRange ne 1 }">
	            <a onclick="getSearchAjax(1)">처음</a> 
	        </c:if>
	        <c:if test="${pagination.curPage ne 1}">
	            <a onclick="getSearchAjax(${pagination.prevPage })">이전</a> 
	        </c:if>
	        <c:forEach var="pageNum" begin="${pagination.startPage }" end="${pagination.endPage }">
	            <c:choose>
	                <c:when test="${pageNum eq pagination.curPage}">
	                    <span style="font-weight: bold;color: blue;"><a onclick="pagingFn(${pageNum})">${pageNum }</a></span> 
	                </c:when>
	                <c:otherwise>
	                    <a onclick="getSearchAjax(${pageNum})">${pageNum }</a> 
	                </c:otherwise>
	            </c:choose>
	        </c:forEach>
	        <c:if test="${pagination.curPage ne pagination.pageCnt && pagination.pageCnt > 0}">
	            <a onclick="getSearchAjax(${pagination.nextPage})">다음</a> 
	        </c:if>
	        <c:if test="${pagination.curRange ne pagination.rangeCnt && pagination.rangeCnt > 1}">
	            <a onclick="getSearchAjax(${pagination.pageCnt})">끝</a> 
	        </c:if>
	    </div>
	</div>

</body>

</html>