<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>title:::::<decorator:title /></title>
	<!-- header -->
    <decorator:head />
    <!-- //header -->
	<jsp:include page="/WEB-INF/include/head.jsp"></jsp:include>
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Roboto:400,100,300,500">
	<link rel="stylesheet" href="/html/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="/html/css/login/form-elements.css">
	<link rel="stylesheet" href="/html/css/login/style.css">
</head>
<body>
	<!-- Navigation -->
	<%@ include file="/WEB-INF/include/nav.jsp" %>

	<!-- Page Content -->
	<div class="container">
		<div class="inner-bg">
			<div class="container">
				<decorator:body />
			</div>
		</div>

		<!-- Footer -->
		<jsp:include page="/WEB-INF/include/footer.jsp"></jsp:include>
	</div>
	
	<div class="backstretch" style="left: 0px; top: 0px; overflow: hidden; margin: 0px; padding: 0px; height: 920px; width: 1019px; z-index: -999999; position: fixed;">
		<img src="/html/image/login/1.jpg" style="position: absolute; margin: 0px; padding: 0px; border: none; width: 1380px; height: 920px; max-height: none; max-width: none; z-index: -999999; left: -180.5px; top: 0px;">
	</div>

	<!-- jQuery -->
	<script src="/html/js/jquery.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="/html/js/bootstrap.min.js"></script>
	
	<sitemesh:write property="footerScript"/>
</body>

</html>

