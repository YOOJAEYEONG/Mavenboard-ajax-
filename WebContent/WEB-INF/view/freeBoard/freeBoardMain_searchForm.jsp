<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>

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
	if(searchFrmSel.val() == "searchNum"){
		$("input[name='searchWord']").prop("type","number");
	}else{
		$("input[name='searchWord']").prop("type","text");
	}
}
function getSearchAjax() {
	var searchData = {
			"searchColumn"  : $("select[name='searchColumn'] option:selected").val(),
			"searchWord" 	: $("input[name='searchWord']").val()
		}
	$.ajax({
		url : './main.ino',
		dataType : 'json',
		type : 'POST',
		data : JSON.stringify(searchData),
		contentType : 'application/json; charset=UTF-8',
		success : function(result) {
			console.log(result);
		},
		error : function(request, status, error){
			console.log(request, status, error);
		}

	});
}}
</script>
</head>
<body>

	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<form action="./main.ino" accept-charset="utf-8">
			<span style="margin-right: 10%;">
					<select name="searchColumn">
						<option value="searchNum">글번호</option>
						<option value="searchTitle">제목</option>
					</select>
					<input type="text" name="searchWord" required>
					<button type="submit" >검색</button>
			</span>
			<a href="./freeBoardInsert.ino">글쓰기</a>
		</form>
	</div>
	<hr style="width: 600px;">
	<div style="padding-bottom: 10px;">
		<table border="1">
			<thead>
				<tr>
					<td style="width: 55px; padding-left: 30px;" align="center">타입</td>
					<td style="width: 50px; padding-left: 10px;" align="center">글번호</td>
					<td style="width: 125px;" align="center">글제목</td>
					<td style="width: 48px; padding-left: 50px;" align="center">글쓴이</td>
					<td style="width: 100px; padding-left: 95px;" align="center">작성일시</td>
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
						<td style="width: 125px;" align="center"><a href="./freeBoardDetail.ino?num=${dto.num }">${dto.title }</a></td>
						<td style="width: 48px; padding-left: 50px;" align="center">${dto.name }</td>
						<td style="width: 100px; padding-left: 95px;" align="center">${dto.regdate }</td>
					<tr>
					</c:forEach>
					
			</tbody>
		</table>
	</div>
	
	<!-- 페이지버튼 -->
	${paganation }

</body>

</html>