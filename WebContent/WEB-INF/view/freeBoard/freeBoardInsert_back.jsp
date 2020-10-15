<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script>
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
			return true;
		}
	}
</script>
</head>
<body>
	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="./main.ino">리스트로</a>
	</div>
	<hr style="width: 600px">

	<form name="insertForm" action="./freeBoardInsertPro.ino" accept-charset="utf-8"
		onsubmit="return validation()"
	>

		<table border="1">
			<tbody>
				<tr>
					<td style="width: 150px;" align="center">타입 :</td>
					<td style="width: 400px;">
						<select name="codeType">
							<option value="01">자유</option>
							<option value="02">익명</option>
							<option value="03">QnA</option>
						</select>
					</td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">이름 :</td>
					<td style="width: 400px;"><input type="text" name="name"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">제목 :</td>
					<td style="width: 400px;"><input type="text" name="title"/></td>
				</tr>
				<tr>
					<td style="width: 150px;"align="center">내용 :</td>
					<td style="width: 400px;"><textarea name="content" rows="25" cols="65" ></textarea></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td></td>
					<td align="right">
					<input type="submit" value="글쓰기">
					<input type="button" value="다시쓰기" onclick="reset()">
					<input type="button" value="취소" onclick="">
					&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</tfoot>
		</table>
	</form> 
</body>
</html>