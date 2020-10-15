<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>commonCodeDetail</title>
</head>
<body>
	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="/commonCode.ino">리스트로</a>
	</div>
	<hr style="width: 600px">

	<form action="./commonCodeInsert.ino">
		<div style="width: 150px; float: left;">코드 :</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" name="name"/></div>

		<div style="width: 150px; float: left;">코드명 :</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" name="title"/></div>

		<div style="width: 150px; float: left;">사용유무:</div>
		<div style="width: 500px; float: left;" align="left">
			Y<input type="radio" name="useYN" value="Y"> 
			N<input type="radio" name="useYN" value="N">
		</div>
		<div align="right">
			<input type="submit" value="등록">
			<input type="button" value="다시쓰기" onclick="reset()">
			<input type="button" value="취소" onclick="">
			&nbsp;&nbsp;&nbsp;
		</div>
	</form>
	<hr style="width: 600px">
	<table style="width: 600px">
		<colgroup width="120px" > 
		<colgroup width="*" 	>
		<colgroup width="150px">
		<tr>
			<th align="left">코드</th>
			<th>코드명</th>
			<th>사용유무</th>
		</tr>
	
		<c:forEach var="nRow" items="${list}">
			<tr>
				<td>${nRow.DCODE }</td>
				<td align="center">${nRow.DCODE_NAME }</td>
				<td align="center">${nRow.USE_YN }</td>
			</tr>
		</c:forEach>
	</table>



</body>
</html>