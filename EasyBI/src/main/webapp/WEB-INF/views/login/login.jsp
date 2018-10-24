<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/taglib.jsp" %>
<html>
	<head>
		<title>DockerBIO</title>
	</head>
<body>
	<div class="row">
		<div class="col-sm-6 col-sm-offset-3 form-box">
			<div class="form-top">
				<div class="form-top-left">
					<h3>Authentication</h3>
					<p>sign in:</p>
				</div>
				<div class="form-top-right">
					<i class="fa fa-key"></i>
				</div>
			</div>
			<div class="form-bottom">
				<c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
					<div style="height:100px;color: red" id="messageDiv">
						<spring:message code="login.badCredentials"></spring:message>
					</div>
				</c:if>

				<form action="/web/login/process" method="post" class="login-form" data-toggle="validator" role="form">
					<div class="form-group">
						<sec:csrfInput/>
						<label class="sr-only" for="email">email</label> 
						<input
							type="text" name="email" placeholder="email..."
							class="form-control" id="email"
							data-error="올바른 이메일 주소를 입력하세요" required
							pattern="^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$">
						<div class="help-block with-errors"></div>
					</div>
					<div class="form-group">
						<label class="sr-only" for="password">Password</label> 
						<input
							type="password" name="password" placeholder="Password..."
							class="form-control" id="password"
							data-error="암호를 입력하세요" required>
						<div class="help-block with-errors"></div>
					</div>
					<div class="form-group">
						<button type="submit" class="btn">Sign in!</button>
					</div>
					<div class="form-group">
						<button type="button" class="btn btn-warning" onclick="location.href='/web/login/join'">Join in!</button>
					</div>
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
	});
	</script>
</footerScript>
</html>
