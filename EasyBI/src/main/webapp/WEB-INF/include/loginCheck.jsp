<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
var loginCheck = function() {
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var isLoginSuccess=false;
	$.ajax({
		type : "POST",
		url : "/web/loginCheck",
		async: false,
		beforeSend : function(xhr) {
			xhr.setRequestHeader(header, token);
		},
		success : function(msg) {
			isLoginSuccess = true;
			console.log('end ajax')
		},
		error : function(xhr, option, error) {
			if(xhr.status=="403"){
				tipCall('<spring:message code="login.loginNeeded" />');
				top.location.href="/web/login/login";
			}else{
				tipCall('<spring:message code="common.error" />');
				console.log(xhr.status); //오류코드
				console.log(error); //오류내용
			}
			console.log('end ajax')
		}
	});
	console.log("isLoginSuccess:"+isLoginSuccess)
	return isLoginSuccess;
}
</script>