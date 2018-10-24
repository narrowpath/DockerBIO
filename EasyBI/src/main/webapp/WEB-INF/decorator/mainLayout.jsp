<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><sitemesh:write property='title'/></title>
	<!-- header -->

    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
	<sec:csrfMetaTags/>

	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script type="text/javascript" src="/html/js/user.js?version=<spring:message code="common.jsVersion" />"></script>

    <!-- Bootstrap Core -->
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
	
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/html/css/2-col-portfolio.css">
    <link rel="stylesheet" href="/html/css/user.css?version=<spring:message code="common.cssVersion" />">

	<!-- Bootstrap Core JavaScript -->
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery-backstretch/2.0.4/jquery.backstretch.min.js"></script>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/twbs-pagination/1.4.1/jquery.twbsPagination.js"></script>
	
    <sitemesh:write property='head' />
    <spring:eval expression="@project['config.log']" var="logLevel" />
    <c:if test="${logLevel ne 'DEBUG' }">
    <script>
    $( document ).ready(function() {
	    console.log = function() {};
	});
    </script>
    </c:if>
</head>
<body>
	<!-- Navigation -->
	<%@ include file="/WEB-INF/include/nav.jsp" %>

	<!-- Page Content -->
	<div class="container">
		<sitemesh:write property='body'/>
	</div>
	<!-- /.container -->
<sitemesh:write property="footerScript"/>
<%@include file="/WEB-INF/include/loginCheck.jsp" %>
</body>

</html>
