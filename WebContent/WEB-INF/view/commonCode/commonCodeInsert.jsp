<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>commonCodeInsert</title>
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script> -->
<script
  src="https://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script type="text/javascript">
let isNewCheck = false;
let newRow = 0;//최대3행만 crud 가능	
window.onload = function(){
	
}

$(function(){
	//전체 제어 체크박스 
	$("#allCheck").change(function(event){
		if(event.target.checked){
			let flag = false;
			$("input:checkbox[name='selectRow']").each(function(index,item){
				if($(item).attr('checked') == 'checked'){
					$(item).trigger('click');
					flag = true;
				}else{
					$(item).attr('checked', true);
				}
			});
			if(flag){
				$("input:checkbox[name='selectRow']").attr('checked',false);
			}
		}else{
			//$("input:checkbox[name='selectRow']").attr('checked', false);
			$("input:checkbox[name='selectRow']").trigger('click');
		}
	});
	//각각 row 체크박스
	$("input:checkbox[name='selectRow']").change(function(e){
		let tr = $(this).closest('tr');
		let dcode 		= 	tr.children().eq(1).text();
		let dcodeName 	= 	tr.children().eq(2).text() == "" ? 
							tr.children().eq(2).children().val()
							:
							tr.children().eq(2).text();
							
		let useYN 		= 	tr.children().eq(3).text() == "YN" ?
							tr.children().eq(3).find("input:checked").val()
							:
							tr.children().eq(3).text();
							
		console.log('체크된것:',dcode,dcodeName,useYN);
		//체크박스를 체크하는경우
		if(e.target.checked){
			console.log('e.target',e.target);
			isNewCheck = true;
			
		//체크박스 체크해제하는 경우
		}else{
			console.log('e.target',e.target);
			isNewCheck = false;
			
		}
	});
});

function update(){
	let checkeds = $("input:checkbox[name='selectRow']:checked");
	let uncheckeds = $("input:checkbox[name='selectRow']:not(:checked)");
	let changeFlag = false;

	if(isNewCheck){
		//체크>수정 클릭> class:update 
		$(checkeds).each(function(index,item){
			if($(item).prop('class') == ''){
				$(item).prop('class','update');
				changeFlag = true;
			}
		});
	}else{
		if($("input:checkbox:not(:checked)").is(".update")){
			console.log("언체크> 수정 클릭> class:''");
			let flag = true;
			$(uncheckeds).each(function(index,item){
				if($(item).prop('class') == 'update' ){
					$(item).removeAttr('class');
					$(item).closest('form').remove();
					console.log('uncheckeds,remove실행함');
				}
			});
		}else{
			console.log('신규체크 없고, 기존체크된 것',$.find(".updateForm").length);
			if($.find(".updateForm").length > 0){
				$(checkeds).each(function(index,item){
					console.log('[uncheckeds]',item.id )
					if($(item).prop('class') == 'update' ){
						console.log('removeAttr실행',$(item).prop('class') );
						$(item).removeAttr('class');
						$('.updateForm').remove();
						changeFlag = false;
					}
				});
			}else{
				console.log('체크 > 수정 클릭> class:update');
				$(checkeds).each(function(index,item){
					if($(item).prop('class') == ''){
						$(item).prop('class','update');
						changeFlag = true;
					}
				});
			}
		}
	}
	console.log('changeFlag',changeFlag);
	$("td.editable").closest('tr').find(":nth(1)").each(function(index,item){
		console.log("item.dcodeName",$(item).closest('tr').children().eq(2).children().val())
		console.log("item.useYN",$(item).closest('tr').children().eq(3).find(":radio:checked").val())
		console.log('item.class>', $(item).prop('class'));
		let dcode = $(item).val();
		//let dcodeName = $("td.editable").closest('tr').find(":nth(4)").eq(index).val();
		let dcodeName = $(item).closest('tr').children().eq(2).children().val();
		
		//let useYN = $("td.editable").closest('tr').find(":radio:checked").eq(index).val();
		let useYN = $(item).closest('tr').children().eq(3).find(":radio:checked").val();
		
		if( $(item).prop('class') == ""){
			console.log(dcode,dcodeName,useYN);
			//$("td.editable").closest('tr').find(":nth(2)").eq(index).html()
			$("tr."+dcode+" td:nth(2)").empty();
			$("tr."+dcode+" td:nth(3)").empty();
			$("tr."+dcode+" td:nth(2)").text(dcodeName);
			$("tr."+dcode+" td:nth(3)").text(useYN);
			$("tr."+dcode+" td:nth(2)").removeAttr("class");
		}
	}); 
	6t
	checkeds = $("input:checkbox.update");
	let updateCode = '';
	for(let i=0; i < checkeds.length ; i++ ){
		let dcode = checkeds[i].value;
		
		let dcodeName = $("tr."+dcode+" td:nth(2)").text() == "" ?
						$("tr."+dcode+" td:nth(2)").children().val()
						:	 
						$("tr."+dcode+" td:nth(2)").text();
		
		console.log(dcode+"검사1", $("tr."+dcode+" td:nth(3)").text() )
		console.log(dcode+"검사2", $("tr."+dcode+" input[type='radio']:checked").val() )
		let useYN = $("tr."+dcode+" td:nth(3)").text() == "YN" ?
					$("tr."+dcode+" input[type='radio']:checked").val() 
					:
					$("tr."+dcode+" td:nth(3)").text();

		console.log('update호출됨newRow:',newRow,dcode,dcodeName,useYN);


		updateCode += "<form id='updateForm"+i+"' class='updateForm'>";
		updateCode += 	"<input type='text' name='CODE'  value='${param.code}' size='10'>";
		updateCode += 	"<input type='text' name='DCODE' value='"+dcode+"'     size='10'>";
		updateCode += 	"<input type='text' name='DCODE_NAME' value='"+dcodeName+"'>";
		updateCode += 	"<input type='text' name='USE_YN"+i+"' value='"+useYN+"' size='1'>";
		updateCode += 	"<input type='text' name='dataFlag' value='update' size='5' >";
		updateCode += "</form>";
	
		console.log('for문>changeFlag',changeFlag);
		let htmlCode = "<input type='text' name='DCODE_NAME' value="+dcodeName+">"
		console.log('dcodeName>', $("tr."+dcode+" td:nth(2)").html() );
		//dcodeName 
		$("tr."+dcode+" td:nth(2)").html(htmlCode);
		$("tr."+dcode+" td:nth(2)").prop('class','editable');
		
		if(useYN == 'Y'){
			htmlCode =  "Y<input type='radio' name='USE_YN"+i+"' value='Y' checked='checked'>";
			htmlCode +=	"N<input type='radio' name='USE_YN"+i+"' value='N'>";
		}else{
			htmlCode =  "Y<input type='radio' name='USE_YN"+i+"' value='Y'>";
			htmlCode +=	"N<input type='radio' name='USE_YN"+i+"' value='N' checked='checked'>";
		}
		//useYN
		$("tr."+dcode+" td:nth(3)").html(htmlCode);

		//수정된 dcodeName 값을 히든폼에 셋팅 
		$("tr."+dcode+" td:nth(2)").on("keyup", function(){
			console.log("수정값", $("tr."+dcode+" td:nth(2) input").val())
			var editDcodeName = $("tr."+dcode+" td:nth(2) input").val();
			$("#updateForm"+i+" input[name='DCODE_NAME']").val(editDcodeName);
		});
		//수정된 useYN 값을 히든폼에 셋팅
		$("tr."+dcode+" td:nth(3)").on("change", function(){
			console.log("수정값YN", $("tr."+dcode+" td:nth(3) input:checked").val())
			var editUseYN = $("tr."+dcode+" td:nth(3) input:checked").val();
			$("#updateForm"+i+" input[name='USE_YN"+i+"']").val(editUseYN);
		});
	
	
		
		
	}

	$("div.updateDIV").empty();
	$("div.updateDIV").append(updateCode);
	isNewCheck = false;
	htmlCode = "";

}

function deleteRow(){
	let checkeds = $("input:checkbox[name='selectRow']:checked");
	let uncheckeds = $("input:checkbox[name='selectRow']:not(:checked)");
	let trTag = $(checkeds).closest('tr');
	//$.find("input:checkbox");
	console.log("isNewCheck",isNewCheck, "uncheckeds",uncheckeds);
	//신규체크 > 삭제
	if(isNewCheck){
		//체크 > 삭제 클릭> class:delete 
		$(checkeds).each(function(index,item){
			if($(item).prop('class') == ''){
				$(item).prop('class','delete');
				$(item).closest('tr').css('color','red');
			}
		});
	}else{
		//console.log('체크해제된것이 있을때');
		if($("input:checkbox:not(:checked)").is(".delete")){
			let flag = true;
			//언체크> 삭제 클릭> class:''
			$(uncheckeds).each(function(index,item){
				if($(item).prop('class') == 'delete' ){
					$(item).removeAttr('class');
					$(item).closest('tr').css('color','');
					$(item).closest('form').remove();
					//console.log('uncheckeds,remove실행함');
				}
			});
		
		}else{
			//console.log('신규체크 없고, 기존체크된 것',$.find(".deleteForm").length);
			if($.find(".deleteForm").length > 0){
				$(checkeds).each(function(index,item){
					//console.log('[uncheckeds]',item.id )
					if($(item).prop('class') == 'delete' ){
						//console.log('removeAttr실행',$(item).prop('class') );
						$(item).removeAttr('class');
						$(item).closest('tr').css('color','');
						$('.deleteForm').remove();
					}
				});
			}else{
				//체크 > 삭제 클릭> class:delete 
				$(checkeds).each(function(index,item){
					if($(item).prop('class') == ''){
						$(item).prop('class','delete');
						$(item).closest('tr').css('color','red');
					}
				});
			}
		}
	}

	checkeds = $("input:checkbox.delete");
	let htmlCode = "";
	for(var i=0; i<checkeds.length; i++){
		console.log('.delete',checkeds[i]);
		trTag = $(checkeds[i]).closest('tr');
		let dcode = trTag.children().eq(1).text();
		
		htmlCode += "<form id='deleteForm"+i+"' class='deleteForm'>";
		htmlCode += 	"<input type='text' name='CODE' value='${param.code}'>";
		htmlCode += 	"<input type='text' name='DCODE' value='"+dcode+"'>";
		htmlCode += 	"<input type='text' name='dataFlag' value='delete'>";
		htmlCode += "</form>";
	}
	$("div.deleteDIV").empty();
	$("div.deleteDIV").append(htmlCode);
	isNewCheck = false;
	htmlCode = "";
}


//serializeObject
jQuery.fn.serializeObject = function() {
	var objArr = [];
    var obj = null;
    try {
        if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
            var arr = this.serializeArray();
            if (arr) {
                console.log('arr',arr);
                jQuery.each(arr, function(index) {
                    console.log("makeObj",arr[index].name)
                    if(arr[index].name == 'CODE' ){
						obj = {};
                    }
                    //USE_YN0, USE_YN1 => USE_YN
                    if( (arr[index].name).includes('USE_YN') ){
	                    obj['USE_YN'] = this.value;
                    }
                    if( arr[index].name=== 'dataFlag'){
	                    obj['dataFlag'] = this.value;
                    	objArr.push(obj);
                    }else{
                    	obj[this.name] = this.value;
                    }
                });
                
                console.log('objArr',objArr);
            }//if ( arr ) {
        }//if
    } catch (e) {
        alert(e.message);
    } finally {
    }
    return objArr;
};

//입력폼 추가
function addRow(){
	if(++newRow <= 3){
		
			let htmlStr ="<form class='insertFrm' name='commonCodeFrm"+newRow+"'>";
			htmlStr += `
				<input type="hidden" name="CODE" value="${param.code }">
				<input type="hidden" name="dataFlag" value="insert">
				<table style="width: 600px">
					<colgroup width="120px"> 
					<colgroup width="*">
					<colgroup width="150px">
					<tr>
						<td align='center'><input type='text' name='DCODE' value=''/></td>
						<td align='center'><input type='text' name='DCODE_NAME' value=''/></td>
						<td align='center'>`;
			htmlStr +=		"Y<input type='radio' name='USE_YN"+newRow+"' value='Y' checked>"; 
			htmlStr +=		"N<input type='radio' name='USE_YN"+newRow+"' value='N'>";
			htmlStr += `</td>	
					</tr>
				</form>`;
		$("#addRow").append(htmlStr);
		//$("thead").append(htmlStr);
		console.log("addRow종료됨:newRow:",newRow);
	}else{
		alert('최대 3개 까지 동시입력가능');
	}
	
}
//저장버튼
function saveFn(){
	var serializeData = $('form').serializeObject();
	console.log('JSON.stringify(serializeData)',JSON.stringify(serializeData));
	$.ajax({
		url : './commonCodeInsertPro.ino',
		dataType : 'json',
		type : 'POST',
		data : JSON.stringify(serializeData),
		contentType : 'application/json; charset=UTF-8',
		success : function(result) {
			console.log("result:",JSON.stringify(result));
			if(result[0].errorMsg == undefined){
				var listRow = "";
				for(var i=0;i<result.length; i++){
					listRow += 
						"<tr class="+result[i].DCODE+">"
							+"<td><input type='checkbox' name='selectRow' value="+result[i].DCODE+" /></td>"
							+"<td align='center'>"+result[i].DCODE+"</td>"
							+"<td align='center'>"+result[i].DCODE_NAME+"</td>"
							+"<td align='center'>"+result[i].USE_YN+"</td>"
						+"</tr>";
				}
				$(".tbody").empty();
				$(".tbody").append(listRow);
				$('form').remove();
				newRow = 0;
				alert('저장완료');
			}else{
				console.log("errorMsg:::",result[0].errorMsg);
				alert(result[0].errorMsg);
			}
		},
		error : function(request, status, error){
			console.log(request, status, error);
		}
	});
}
</script>

</head>
<body>
	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<div align="right">
			<input type="button" value="추가" onclick="addRow();">
			<input type="button" value="수정" onclick="update()">
			<input type="button" value="삭제" onclick="deleteRow()">
			<input type="submit" value="저장" onclick="saveFn();">
		</div>
	</div>
	<hr style="width: 600px">
	<table id="headTable" style="width: 600px">
		<colgroup width="10px" > 
		<colgroup width="120px" > 
		<colgroup width="*" 	>
		<colgroup width="150px">
		<thead>
			<tr>
				<th><input type="checkbox" id="allCheck" /></th>
				<th align="center">코드</th>
				<th>코드명</th>
				<th>사용유무</th>
			</tr>
		</thead>
	</table>
	<div id="addRow"></div>
	<table style="width: 600px">
		<colgroup width="10px" > 
		<colgroup width="120px" > 
		<colgroup width="*" 	>
		<colgroup width="150px">
		
		<tbody class="tbody">
			<c:forEach var="nRow" items="${list}" varStatus="status">
				<tr class="${nRow.DCODE }">
					<td><input id="${status.index}" type="checkbox" name="selectRow" value="${nRow.DCODE }"/></td>
					<td align="center">${nRow.DCODE }</td>
					<td align="center">${nRow.DCODE_NAME }</td>
					<td align="center">${nRow.USE_YN }</td>
				</tr>
			</c:forEach>
		</tbody>	
	</table>
	<hr style="width: 600px">

	<div style="visibility: visible;" class="updateDIV"></div>
	<div style="visibility: visible;" class="deleteDIV"></div>


</body>
</html>