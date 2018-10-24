<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/taglib.jsp" %>
<html lang="ko">
<head>
	<title><sitemesh:write property='title'/></title>
	<sec:csrfMetaTags/>
	<!-- header -->
    <decorator:head />
    <!-- //header -->
	<script src="//code.jquery.com/jquery-3.2.1.min.js"></script>
    
    <!-- Bootstrap -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

	<!-- jquery.backstretch -->
	<script src="/html/js/jquery.backstretch.min.js"></script>
	<script src="/html/js/bootstrap-tooltip.js"></script>

	<script src="/html/js/user.js"></script>

    <!-- Custom CSS -->
    <link href="/html/css/2-col-portfolio.css" rel="stylesheet">
	<link rel="stylesheet" href="//fonts.googleapis.com/css?family=Roboto:400,100,300,500">
	<link rel="stylesheet" href="/html/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="/html/css/login/form-elements.css">
	<link rel="stylesheet" href="/html/css/login/style.css">
	<link rel="stylesheet" href="/html/css/user.css">
</head>
<body>
	<!-- Navigation -->
	<%@ include file="/WEB-INF/include/nav.jsp" %>

	<!-- Page Content -->
	<div class="container">
		<div class="inner-bg">
			<div class="container">
				<sitemesh:write property='body'/>
			</div>
		</div>

		<!-- Footer -->
		<jsp:include page="/WEB-INF/include/footer.jsp"></jsp:include>
	</div>
	
	<div class="backstretch" />
</body>


<sitemesh:write property="footerScript"/>
</html>

