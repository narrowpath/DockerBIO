<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>DockerBIO</title>
	<!-- dropzone.js -->
	<script type="text/javascript" src="/html/js/clone-form.js"></script>
	<script type="text/javascript" src="/html/js/dropzone.js"></script>
	<link rel="stylesheet" href="/html/css/dropzone.css">
	<script type="text/javascript" src="/html/js/formatter.js"></script>
	
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.11.1/bootstrap-table.min.css">

	<!-- Latest compiled and minified JavaScript -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.11.1/bootstrap-table.min.js"></script>
	
	<!-- Latest compiled and minified Locales -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.11.1/locale/bootstrap-table-ko-KR.min.js"></script>
	
	<!-- file download -->
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.fileDownload/1.4.2/jquery.fileDownload.min.js"></script>
	
</head>
<body>
	<!-- Page Header -->
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">DB REQUEST</h1>			
		</div>
	</div>
	<!-- /.row -->

	<!-- Projects Row -->
	<div class="row">
		<div id="collapseJRH" class="panel-footer panel-collapse collapse in" aria-expanded="true">
			<table id="dbRequestGrid" data-classes="table table-striped table-hover table-condensed" data-striped="true" 
				data-row-style="rowStyle" data-height="270" data-pagination="true" data-page-size="5">
				<thead>
					<tr>
						<th data-field="noUser" data-visible="false">noUser</th>
						<th data-field="noUser">no User</th>
						<th data-field="email">email</th>
						<th data-field="dbType">db Type</th>
						<th data-field="dbUrl">db url</th>
						<th data-field="desc">desc</th>
						<th data-field="ynAccept">admin Accept</th>
						<th data-field="descAccept">admin desc</th>
						<th data-field="action" data-align="center" data-events="sjEvent" data-formatter="sjFormat">Action</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>

	<!-- Footer -->
	<footer>
		<div class="row">
			<div class="col-lg-12">
				<p>Copyright &copy; My Genome Box 2017</p>
			</div>
		</div>
		<!-- /.row -->
	</footer>
</body>
<footerScript> 
<script>	
<c:if test="${ynSimulate ne 'Y'}">
<%@include file="/WEB-INF/include/tip.jsp" %>
</c:if>
	var resetGrid = function () {
		$('#dbRequestGrid').bootstrapTable();
	    $(window).resize(function () {
	        $('#dbRequestGrid').bootstrapTable('resetView');
	    });
	}
	
	$(document).ready(function() {
		resetGrid();
		getRequestDbList();
	});
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var getRequestDbList = function() {
		console.log('getRequestDbList');

		$.ajax({
			type : "POST",
			url : "/web/adminTools/api/requestDbList",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(msg) {
				//console.log('msg:' + msg);
				jobList = JSON.parse(msg);
				//console.log("jobList:" + jobList);

				selectboxUpdate('jobSelect', jobList)
			},
			error : function(xhr, option, error) {
				alert('<spring:message code="common.error" />');
				console.log(xhr.status); //오류코드
				console.log(error); //오류내용
			}
		});
	}

</script>
</footerScript>
</html>
