<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% /* <script>console.log = function() {}</script> */ %>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<div class="container top-content">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">DockerBIO</a>
			</div>
			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<sec:authorize var="loggedIn" access="isAuthenticated()" />
					<c:choose>
						<c:when test="${loggedIn}">
					<li><a href="/web/login/logout">Logout [ <%= request.getUserPrincipal().getName() %> ]</a></li>
					<li><a href="/web/helix/" data-popover="popover" data-trigger="hover" data-placement="bottom" title="notice" data-content="Docker run for BI Tools">Run Docker</a></li>
					<li><a href="/web/helix/singleJob" data-popover="popover" data-trigger="hover" data-placement="bottom" title="notice" data-content="Docker Registe for New Docker Job">Register Docker</a></li>
					<li><a href="/web/helix/myFile" data-popover="popover" data-trigger="hover" data-placement="bottom" title="notice" data-content="User File Manager">My Files</a></li>
					    </c:when>
					    <c:otherwise>
					<li><a href="/web/login/login">Login</a></li>
					<li><a href="/web/login/join">Join</a></li>
					    </c:otherwise>
					</c:choose>
					<li><a href="/web/helix/manual" data-popover="popover" data-trigger="hover" data-placement="bottom" title="notice" data-content="User Manual">User Manual</a></li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</div>
		<!-- /.container -->
	</nav>