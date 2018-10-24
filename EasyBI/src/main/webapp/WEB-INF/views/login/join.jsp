<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>DockerBIO</title>
</head>
<body>
	<div class="row">
		<div class="col-sm-6 col-sm-offset-3 form-box">
			<div class="form-top">
				<div class="form-top-left">
					<h3>Authentication</h3>
					<p>Join in:</p>
				</div>
				<div class="form-top-right">
					<i class="fa fa-key"></i>
				</div>
			</div>
			
			<div class="form-bottom">
				<div style="height:100px;display:none;" id="messageDiv"></div>
				
				<form method="post" class="login-form" data-toggle="validator" role="form" id="joinForm" data-disable="false">
					<div class="form-group">
						<sec:csrfInput/>
						<label class="sr-only" for="email">email</label> 
						<input
							type="text" name="email" placeholder="email (tester@mygenomebox.com)"
							class="form-control" id="form-email"
							data-error="올바른 이메일 주소를 입력하세요" required
							pattern="^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$">
						<div class="help-block with-errors"></div>
					</div>
					<div class="form-group">
						<label class="sr-only" for="nmUser">Username</label> 
						<input
							type="text" name="nmUser" placeholder="Username (least 6)"
							class="form-username form-control" id="form-nmUser" required
							data-minlength="6">
						<div class="help-block with-errors"></div>
					</div>
					<div class="form-group">
						<label class="sr-only" for="password">Password</label> 
						<input
							type="password" name="password" placeholder="Password (least 8, Cap+lower+Num)"
							class="form-control" id="form-password" value="Qwert12345"
							data-error="암호를 입력하세요" required
							pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}">
						<div class="help-block with-errors"></div>
					</div>
					<div class="form-group">
						<label class="sr-only" for="confirmPassword">confirm Password</label> 
						<input
							type="password" name="confirmPassword" placeholder="Confirm Password..."
							class="form-control" id="form-confirmPassword" value="Qwert12345"
							data-error="암호와 동일하게 입력하세요" required
							data-match="#form-password" data-match-error="암호와 동일하게 입력하세요">
						<div class="help-block with-errors"></div>
					</div>
					<div class="form-group">
						<button id="btnJoin" name="btnJoin" type="submit" class="btn btn-warning">Join in!</button>
					</div
				</form>
			</div>
		</div>
	</div>
</body>
<footerScript>
	<script>
	$(document).ready(function() {
		// Fullscreen background
		$.backstretch("/html/image/login/1.jpg");

		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		$("#joinForm").on("submit", function(e) {
		    // if the validator does not prevent form submit
		    if (!e.isDefaultPrevented()){
		    	$.ajax({
					type : "POST",
					url : "/web/user/insert",
					data : $('#joinForm').serialize(),
					beforeSend: function(xhr) {
			        	xhr.setRequestHeader(header, token);
						console.log($('#joinForm').serialize())
			        },
					success : function(msg) {
						if(msg.result=='success'){
							alert(msg.message);
							location.href = "/web/login/login";							
						}else{
							alert(msg.message);
						}
					},
					error: function(xhr, option, error){
						alert('<spring:message code="common.error" />');
						console.log(xhr.status); //오류코드
						console.log(error); //오류내용
					}
				});
		   	}else{
		   		console.log('else');
		   	}
		    return false;
		});
	});
	</script>
</footerScript>
</html>
