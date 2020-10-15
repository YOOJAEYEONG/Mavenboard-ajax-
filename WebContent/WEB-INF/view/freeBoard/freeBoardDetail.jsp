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
$(function(){
	//검색결과 출력시 선택했던 select>option 값 유지
	var codeType = "${freeBoardDto.codeType}";
	$("option[value='"+codeType+"']").attr("selected","selected");
});
//유효성 검사
function validation(){
	var name = document.insertForm.name.value;
	name = name.replace(/( |\n)/g, "");
	var content = document.insertForm.content.value;
	content = content.replace(/( |\n)/g, "");
	var title = document.insertForm.title.value;
	title = title.replace(/( |\n)/g, "");


	if( (document.insertForm.name.value).includes(" ") ){
		alert("이름에 공백이있습니다");
		return false;
	}else if(name==""){
		alert("이름입력필요");
		document.insertForm.name.focus();
		return false;
	}else if(title==""){
		alert("제목입력필요");
		document.insertForm.title.focus();
		return false;
	}else if(content==""){
		alert("내용입력필요");
		document.insertForm.content.focus();
		return false;
	}else{
		modifyAjax();
	}
}
	function deleteAjax(){
		var num = ${freeBoardDto.num };
		$.ajax({
			url : './freeBoardDeleteAjax.ino',
			dataType : 'json',
			type : 'post',
			data : { "num" : num },
			contentType : "application/x-www-form-urlencoded;charset:utf-8;",
			success : function(result) {
				console.log("result",result);
				if(result==1){
					alert("삭제완료");
					location.href="./main.ino";
				}
				else
					alert("삭제실패");
			},
			error : function(request, status, error){
				console.log(request, status, error);
			}
		});
	}

	function modifyAjax(){
		$.ajax({
			url : './freeBoardModifyAjax.ino',
			dataType : 'json',
			type : 'post',
			data : $("form[name='insertForm']").serialize(),
			contentType : "application/x-www-form-urlencoded;charset:utf-8;",
			success : function(result) {
				console.log("result",result.msg);
				alert(result.msg);
				if(result.msg=="글수정 성공"){
					location.href="./main.ino";
				}
				
			},
			error : function(request, status, error){
				console.log(request, status, error);
			}
		});
	}
	
	//파라미터값 리턴
	function getParameterByName(name) {
	    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
	            results = regex.exec(location.search);
	    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}
</script>
</head>
<body>

	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="./main.ino?searchColumn=${param.searchColumn }&searchWord=${param.searchWord }&curPage=${param.curPage}">리스트로</a>
	</div>
	<hr style="width: 600px">

	<form name="insertForm" onsubmit="return validation()" action="./freeBoardModify.ino" method="post">
		<input type="hidden" name="num" value="${freeBoardDto.num }" />
		<table border="1">
			<tbody>
				<tr>
					<td style="width: 150px;" align="center">타입 :</td>
					<td style="width: 400px;">
						<select name="codeType" style="hig">
							<option value="01">자유</option>
							<option value="02">익명</option>
							<option value="03">QnA</option>
						</select>
					</td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">이름 :</td>
					<td style="width: 400px;"><input type="text" name="name" value="${freeBoardDto.name }"  readonly/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">제목 :</td>
					<td style="width: 400px;"><input type="text" name="title"  value="${freeBoardDto.title }"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">내용 :</td>
					<td style="width: 400px;"><textarea name="content" rows="25" cols="65"  >${freeBoardDto.content }</textarea></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td align="right">
					<input type="button" value="수정" onclick="validation()">
					<%--<input type="button" value="삭제" onclick="location.href='./freeBoardDelete.ino?num=${freeBoardDto.num }'"> --%>
					<input type="button" value="삭제" onclick="deleteAjax()">
					<input type="button" value="취소" onclick="location.href='./main.ino'">
					&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</tfoot>
		</table>

	</form>
	


<%-- 	<input type="hidden" name="num" value="${freeBoardDto.num }" />

		<div style="width: 150px; float: left;">이름 :</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" name="name" value="${freeBoardDto.name }" readonly/></div>

		<div style="width: 150px; float: left;">제목 :</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" name="title"  value="${freeBoardDto.title }"/></div>

		<div style="width: 150px; float: left;">작성날자</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" name="regdate"  value="${freeBoardDto.regdate }"/></div>

		<div style="width: 150px; float: left;">내용 :</div>
		<div style="width: 500px; float: left;" align="left"><textarea name="content" rows="25" cols="65"  >${freeBoardDto.content }</textarea></div>
		<div align="right">
		<input type="button" value="수정" onclick="modify()">
		<input type="button" value="삭제" onclick="location.href='./freeBoardDelete.ino?num=${freeBoardDto.num }'">

		<input type="button" value="취소" onclick="location.href='./main.ino'">
		&nbsp;&nbsp;&nbsp;
		</div> --%>

</body>

</html>