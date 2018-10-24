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

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/validate.js/0.12.0/validate.min.js"></script>
	<script src="/html/js/user.js?version=<spring:message code="common.jsVersion" />"></script>

    <!-- Bootstrap Core -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link href="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.2/css/bootstrapValidator.min.css"/>
	<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.2/js/bootstrapValidator.min.js"></script>
	
    <!-- Custom CSS -->
    <link href="/html/css/2-col-portfolio.css" rel="stylesheet">
    <link rel="stylesheet" href="/html/css/user.css?version=<spring:message code="common.cssVersion" />">

	<!-- Bootstrap Core JavaScript -->
	<script src="/html/js/jquery.backstretch.min.js"></script>
	
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
	<%@ include file="/WEB-INF/include/navAdmin.jsp" %>

	<!-- Page Content -->
	<div class="container">
		<sitemesh:write property='body'/>
	</div>
	<!-- /.container -->
</body>

<sitemesh:write property="footerScript"/>
</html>
