<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/include/taglib.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>DockerBIO</title>
	<script type="text/javascript" src="/html/js/clone-form.js"></script>
	<script type="text/javascript" src="/html/js/formatter.js"></script>
	
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.css">

	<!-- Latest compiled and minified JavaScript -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.js"></script>
	
	<!-- Latest compiled and minified Locales -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/locale/bootstrap-table-en-US.js"></script>

	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-confirmation/1.0.5/bootstrap-confirmation.min.js"></script>
</head>
<body>
	<!-- Page Header -->
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">
				Register Docker
			</h1>
		</div>
	</div>
	<!-- /.row -->

	<!-- Projects Row -->
	<div class="row">
		<div class="col-md-12 portfolio-item">
			<a href="#"> <img class="img-responsive" src="/html/image/single.png" alt=""> </a>
			<div class="form-inline" style="padding:5px;"></div>
			<div class="panel panel-primary">
				<div class="panel-body">
					<div style="float: left;">
						<h4 class="panel-title">
							<a href="#collapseJRH" class="" role="button"
								data-toggle="collapse" aria-expanded="true"
								aria-controls="collapseJRH"> Docker LIST </a>
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-dockerList btn_tip_align"></button>
						</h4>
					</div>
					<div style="float: right;">
						<span class="headerButtons">
							<i class="glyphicon glyphicon-minus btn-xs btn-success expandCollapse" aria-hidden="false"></i>
						</span>
					</div>
				</div>
				<div id="collapseJRH" class="panel-footer panel-collapse collapse in" aria-expanded="true">
					<table id="sjInsertGrid" data-classes="table table-striped table-hover table-condensed" data-striped="true" 
						data-row-style="rowStyle" data-height="270" data-pagination="true" data-page-size="5">
						<thead>
							<tr>
								<th data-field="noJob" data-visible="false">noJob</th>
								<th data-field="noUser" data-visible="false">noUser</th>
								<th data-field="db" data-visible="false">db</th>
								<th data-field="refDb" data-visible="false">refDb</th>
								<th data-field="dtReg" data-formatter="dateFormatter" data-align="center">reg date</th>
								<th data-field="nmJob">Job Name</th>
								<th data-field="idDocker">Docker ID</th>
								<th data-field="argument" data-width="250" data-popover="popover" data-trigger="hover" data-class="colNoWrap">whole param</th>
								<th data-field="outputArgument" data-align="center" data-visible="false">output</th>
								<th data-field="successCondition" data-visible="false">success cond</th>
								<th data-field="ynRefDb" data-align="center">ref</th>
								<th data-field="argumentRefDb" data-visible="false" data-align="center">ref-DB param</th>
								<th data-field="ynDb" data-align="center">db</th>
								<sec:authorize access="hasRole('ROLE_ADMIN')">
								<th data-field="ynPublic" data-visible="false">ynPublic</th>
								</sec:authorize>
								<th data-field="argumentDb" data-visible="false">db param</th>
								<th data-field="argumentUserDb" data-visible="false">user param</th>
								<th data-field="action" data-align="center" data-events="sjEvent" data-formatter="sjFormat">Action</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="panel panel-danger">
				<div class="panel-body">
					<h4 class="panel-title">
						Docker Info Register
						<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-dockerRegister btn_tip_align"></button>
					</h4>
				</div>
				<div class="panel-footer">
					<form method="post" data-toggle="validator" role="form" id="singleJobForm" name="singleJobForm" data-disable="false">
						<input type="hidden" id="noJob" name="noJob">
						<input type="hidden" id="noUser" name="noUser">
						<input type="hidden" id="mode" name="mode">
						<input type="hidden" id="argumentUserDb" name="argumentUserDb">
						<div class="form-inline">
							<div class="input_line_height">
								<span class="label label-default label100">Docker ID</span> 
								<input type="text" class="form-control input-tiny w200" id="idDocker" name="idDocker" placeholder="click Search Docker ID" data-error="<spring:message code="form.singleJob.search_dockerID" />" required readonly>&nbsp;
								<a href="#" onclick="javascript:$('#dockerSearchModal').modal('show');"><button type="button" class="btn-xs glyphicon glyphicon-search"> Search-Docker-ID</button></a>
								<a href="#" onclick="javascript:dockerLink()"><button type="button" class="btn-xs glyphicon glyphicon-link"> Docker Link</button></a>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-idDocker"></button>
							</div>
						</div>
						<div class="form-inline">
							<div class="input_line_height">
								<span class="label label-default label100">Docker Name</span> 
								<input type="text" class="form-control input-tiny w200" id="nmJob" name="nmJob" placeholder="HelixDocker annotate" required>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-nmJob"></button>
								<span class="label label-default label100">Tags</span> 
								<select id="tag" name="tag" required></select>
								<sec:authorize access="hasRole('ROLE_MANAGER')">
								<span class="label label-default label100">Publish</span> 
								<select id="ynPublic" name="ynPublic" required>
									<option value="N">N</option>
									<option value="Y">Y</option>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-successCondition"></button>
								</sec:authorize>
							</div>
						</div>
						<div class="form-inline">
							<div class="input_line_height">
								<span class="label label-default label100">output TYPE</span> 
								<select id="outputArgument" name="outputArgument" required>
									<option value="">SELECT</option>
									<option value="LOG">LOG</option>
									<option value="FILE">FILE</option>
									<option value="DIR">DIR</option>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-outputArgument"></button>
								<span id="divOutputExt" class="hidden">
									<span class="label label-default label100">output Ext</span> 
									<select id="outputExt" name="outputExt" required>
										<option value="">==OUTPUT EXT==</option>
									</select>
									<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-outputExt"></button>
								</span>
								<span class="label label-default label100">success condition</span> 
								<select id="successCondition" name="successCondition" required>
									<option value="filesize">file size</option>
									<option value="logfile">log file</option>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-successCondition"></button>
							</div>
						</div>
						<div id="panelRefDb" class="panel panel-success panel-horizontal" data-toggle="collapse" aria-expanded="true" aria-controls="collapseRefDb">
							<div class="panel-heading w200">
								<span class="label label-default label90">Reference DB</span> 
								<select id="ynRefDb" name="ynRefDb" required>
									<option value="N">N</option>
									<option value="1">1</option>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-ynRefDb"></button>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-plus-sign tip-RequestRefDb" title="request new Reference DB"></button>
							</div>
							<div id="collapseRefDb" class="panel-body form-inline panel-collapse collapse hidden" aria-expanded="true">
								<div id="divRefDbOri">
									<span class="label label-default label50">param</span> 
									<input type="text" class="form-control input-tiny w50" id="argumentRefDb" name="argumentRefDb">
									<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argumentRefDb"></button>
									<span class="label label-default label50">RefDB</span> 
									<select id="refDb" name="refDb" data-error="<spring:message code="form.singleJob.search_refDb" />">
										<option value=''>==REF-DB==</option>
										<c:forEach items="${refDbFileNameList}" var="list"  varStatus="listIndex"><option value="${list}">${ufn:fileNameTruncate(list,30)}</option></c:forEach>
									</select>
								</div>
								<div id="divRefDbClone">
								</div>
							</div>
						</div>
						<div id="panelDb" class="panel panel-danger panel-horizontal" data-toggle="collapse" aria-expanded="true" aria-controls="collapseDb">
							<div class="panel-heading w200">
								<span class="label label-default label90">dbSNP</span> 
								<select id="ynDb" name="ynDb" required>
									<option value="N">N</option>									
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
								</select>						
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-ynDb"></button>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-plus-sign tip-RequestDb" title="request new dbSNP"></button>		
							</div>
							<div id="collapseDb" class="panel-body form-inline panel-collapse collapse hidden" aria-expanded="true">
								<div id="divDbOri">
									<span class="label label-default label50">param</span> 
									<input type="text" class="form-control input-tiny w50" id="argumentDb" name="argumentDb">
									<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argumentDb"></button>
									<span class="label label-default label50">dbSNP</span> 
									<select id="db" name="db" data-error="<spring:message code="form.singleJob.search_db" />">
										<option value=''>==DB==</option>
										<c:forEach items="${dbFileList}" var="list"  varStatus="listIndex"><option value="${list.name}">${ufn:fileNameTruncate(list.name,20)}</option></c:forEach>
									</select>
								</div>
								<div id="divDbClone">
								</div>
							</div>
						</div>
						<div class="form-inline">
							<span class="label label-default label100">Options</span> 
							<input type="text" class="form-control input-tiny w500" id="argument" name="argument" required>
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argument"></button>
						</div>
						<div id="divCheckDockerCommand" class="form-inline" id="divCheckDockerCommand">
							<span class="label label-default label100">Check Command</span>
							<textarea id="commandTest" name="commandTest" class="form-control textAreaCss" rows="2" readonly></textarea>
						</div>						
						<div class="input_line_height" align="center">
							<button type="submit" class="btn btn-info" value="check" onclick="$('#singleJobForm #mode').val(this.value);">Check Docker Command</button>
							<button id="btnCreate" type="submit" class="btn btn-primary" value="create" onclick="$('#singleJobForm #mode').val(this.value);" >Create</button>
							<button id="btnUpdate" type="submit" class="btn btn-warning" value="update" onclick="$('#singleJobForm #mode').val(this.value);" >Update</button>
							<button id="btnDelete" type="submit" class="btn btn-danger disabled" value="delete" onclick="$('#singleJobForm #mode').val(this.value);">Delete</button>
						</div>
						<div class="form-inline" style="padding:5px;"></div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- /.row -->
	
	<!-- Modal -->
	<div id="dockerSearchModal" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Docker Search</h4>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-5">
							<form id="dockerSearchForm" name="dockerSearchForm" data-toggle="validator">
								<div class="form-inline" style="padding:5px;">
									<input type="text" id="q" name="q" class="form-control input-tiny w150" placeholder="input docker id for searching" required>
									<input type="hidden" id="page" name="page" value="1">
									<%/* 
									<select id="select" name="select">
										<option value="d" selected="selected">Downloads</option>
										<option value="s">Star</option>
										<option value="o">Official</option>
									</select>
									*/%>
									<input type="submit" value="search">
								</div>
							</form>
						</div>
						<div class="col-sm-7" align="right">
							<ul id="divDockerGridPage" class="pagination-sm" style="margin:0px"></ul>
						</div>
					</div>
					<table id="dockerGrid" data-classes="table table-striped table-hover table-condensed" data-striped="true" data-row-style="rowStyle" >
						<thead>
							<tr>
								<th data-field="repo_name" data-align="center">name</th>
								<th data-field="short_description">description</th>
								<th data-field="star_count" data-align="center">star</th>
								<th data-field="is_official" data-align="center">official</th>
								<th data-field="pull_count" data-align="center">downloads</th>
								<th data-field="dockerSelect" data-events="dsEvents" data-formatter="dsFormatter" data-align="center">select</th>
							</tr>
						</thead>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>
	<div id="simModal" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Simulate</h4>
				</div>
				<div class="modal-body">
					<div id="simContent"></div>
				</div>
			</div>

		</div>
	</div>
	<div id="requestDbModal" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">New DB Request</h4>
				</div>
				<div class="modal-body">
						<form id="requestDbForm" data-toggle="validator" data-disable="false">
						<div class="form-group">
							<div class="form-inline" style="padding:5px;">
								<span class="label label-default label200" >REPLY EMAIL</span>
							</div>
							<div class="form-inline" style="padding:5px;">
								 <input type="text" name="email" placeholder="email..." class="form-control" id="email" data-error="올바른 이메일 주소를 입력하세요" required="" pattern="^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$">
							</div>
						</div>
						<div class="form-group">
							<div class="form-inline" style="padding:5px;">
								<span class="label label-default label200">DB TYPE</span> 
							</div>
							<div class="form-inline" style="padding:5px;">
								<select id="dbType" name="dbType" required>
									<option value="refDb">refrence DB</option>									
									<option value="dbSnp">SnpDB</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<div class="form-inline" style="padding:5px;">
								<span class="label label-default label200" >DB URL</span>
							</div>
							<div class="form-inline" style="padding:5px;">
								 <input type="text" class="form-control wAll" id="dbUrl" name="dbUrl" placeholder="ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh38p7/VCF/All_20170710.vcf.gz" required>
							</div>
						</div>
						<div class="form-group">
							<div class="form-inline" style="padding:5px;">
								<span class="label label-default label200">DB DESCRIPTION</span>
							</div>
							<div class="form-inline" style="padding:5px;">
								<textarea class="form-control wAll"  rows="3" id="desc" name="desc" placeholder="human_9606_b150_GRCh38p7 2017/1/1 version" required></textarea>
							</div>
						</div>
						<div class="form-group">
							<div class="form-inline" align="center">
								<button id="btnCreate" type="submit" class="btn btn-primary" >Create</button>
								<button id="btnUpdate" type="button" class="btn btn-warning" onclick="$('#requestDbModal').modal('toggle');" >Cancel</button>
							</div>
						</div>
						</form>
				</div>
			</div>

		</div>
	</div>
	<div id="tipModal" class="modal fade" role="dialog">
		<div class="modal-dialog modal-default">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Tip</h4>
				</div>
				<div class="modal-body">
					<div id="tipContent">Tip Content</div>
				</div>
			</div>

		</div>
	</div>
	<!-- /.Modal -->

	<!-- Footer -->
	<footer>
		<div class="row">
			<div class="col-lg-12">
				<p>Copyright &copy; My Genome Box 2017</p>
			</div>
		</div>
	</footer>
	<!-- /.Footer -->
</body>
<footerScript>
<script>	
<%@include file="/WEB-INF/include/tip.jsp" %>
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var jobList, isLoad;
	
	var resetGrid = function () {
		$('#sjInsertGrid').bootstrapTable();
		$('#dockerGrid').bootstrapTable();
		
	    $(window).resize(function () {
	        $('#sjInsertGrid').bootstrapTable('resetView');
	        $('#dockerGrid').bootstrapTable('resetView');
	    });
	}
	
	$(document).ready(function() {
		//findToolTip();
		resetGrid();
		//$('#sjInsertGrid').bootstrapTable({data:{}});
		//$('#dockerGrid').bootstrapTable({data:{}});
		getJobList();

		$('#dockerSearchModal').on('shown.bs.modal', function () {
			console.log('model shown');
			//search box init
			$('#dockerSearchForm #q').focus();
		})
		$('#dockerSearchModal').on('hidden.bs.modal', function () {
			console.log('model hidden');
			//search box init
			$('#dockerSearchForm #q').val("");
			$('#dockerSearchForm #page').val("1");
			$('#divDockerGridPage').twbsPagination('destroy');
			$('#dockerGrid').bootstrapTable('removeAll');
		})
		
		$('#simModal').on('hidden.bs.modal', function () {
			$("#simContent").empty();
		})

		$('#ynRefDb').on('change', function (event, obj) {
			optionText = $("#ynRefDb option:selected").text();
			console.log('text:'+optionText);
			//search box init
			$("#divRefDbClone").empty();
			if(optionText != 'N'){
				$("#collapseRefDb").removeClass("hidden");
				$("#divRefDbOri :input").attr("disabled", false);
				for(i=0; i<optionText-1; i++) cloneObj('divRefDbOri','divRefDbClone',true)
			}else{
				$("#collapseRefDb").addClass("hidden");
				$("#divRefDbOri :input").attr("disabled", true);
			}
			modifyArgument(isLoad)
		})

		$('#ynDb').on('change', function (event, obj) {
			optionText = $("#ynDb option:selected").text();
			console.log('text:'+optionText);
			//search box init
			$("#divDbClone").empty();
			if(optionText != 'N'){
				$("#collapseDb").removeClass("hidden");
				$("#divDbOri :input").attr("disabled", false);
				for(i=0; i<optionText-1; i++) cloneObj('divDbOri','divDbClone',true)
			}else{
				$("#collapseDb").addClass("hidden");
				$("#divDbOri :input").attr("disabled", true);
			}
			modifyArgument(isLoad)
		})

		$('#outputArgument').on('change', function (event, obj) {
			optionText = $("#outputArgument option:selected").val();
			console.log('text:'+optionText);
			if(optionText=='LOG' || optionText=='FILE'){
				$("#divOutputExt").removeClass('hidden')
				$("#singleJobForm #divOutputExt :input").attr("disabled", false);
			}else{
				$("#divOutputExt").addClass('hidden')
				$("#singleJobForm #divOutputExt :input").attr("disabled", true);
			}
		})
		
		initForm();
	});

	var modifyArgument = function() {
		if (isLoad)
			return false;
		if ($("#noJob").val() && !confirm("<spring:message code="form.singleJob.confirm_update_whole_param" />"))
			return false;
		var refDbOpt = ($("#ynRefDb option:selected").val() == 'N') ? "" : " [REFDB_OPT]";
		var dbOpt = ($("#ynDb option:selected").val() == 'N') ? "" : " [DB_OPT]";

		if ($("#idDocker").val()) {
			$("#argument").val("command" + refDbOpt + dbOpt + " [USER_OPT] [RESULT_OPT]");
			//$("#argument").attr('readonly',false);
		} else {
			//$("#argument").attr('readonly',true);
		}
	}

	var cloneObj = function(targetObjName, destObjName, isAdd) {
		if (isAdd) {
			$('#' + targetObjName).clone().prependTo('#' + destObjName);
		} else {
		}
	}

	var dockerLink = function() {
		if ($("#idDocker").val().trim() == "") {
			alert("<spring:message code="form.singleJob.search_docker_id_first_error" />");
			return;
		}
		var win = window.open('https://hub.docker.com/r/' + $("#idDocker").val(), '_blank');
	}

	var getJobList = function() {
		console.log('getJobList');

		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		$.ajax({
			type : "POST",
			url : "/web/helix/api/jobList",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(msg) {
				//console.log('msg:' + msg);
				jobList = JSON.parse(msg);
				console.log("jobList:" + jobList);

				$('#sjInsertGrid').bootstrapTable('load', jobList);
				tooltipInit();
			},
			error : function(xhr, option, error) {
				alert('<spring:message code="common.error" />');
				console.log(xhr.status); //오류코드
				console.log(error); //오류내용
			}
		});
	}

	function sjFormat(value, row, index) {
		return [
				'<a class="sjCog" href="javascript:void(0)" data-popover="popover" data-trigger="hover" data-placement="left" data-title="Action" data-content="Edit this Docker"><input type="button" class="btn btn-xs btn-info" value="EDIT"></a>  ',
				'<a class="sjPlay" href="javascript:console.log(0)" data-popover="popover" data-trigger="hover" data-placement="left" data-title="Action" data-content="Test this Docker"><input type="button" class="btn btn-xs btn-danger" value="TEST"></a>  ']
				.join('');
	}

	window.sjEvent = {
		'click .sjCog' : function(e, value, row, index) {
			if(loginCheck()){
				console.log('sjCog:' + value + ',' + row.noJob + ',' + index)
				sigleJobEdit(row);
			}
		},
		'click .sjPlay' : function(e, value, row, index) {
			if(loginCheck()){
				console.log('sjPlay:' + value + ',' + row.noJob + ',' + index)
				$("#simContent").load("/web/helix/simulate?noJob=" + row.noJob)
				javascript : $('#simModal').modal('show');
			}
		}
	}

	var sigleJobEdit = function(row) {
		isLoad = true;
		$("#singleJobForm #btnDelete").removeClass("disabled");
		$("#singleJobForm #btnDelete").attr("disabled", false);
		$("#singleJobForm #noJob").val(row.noJob);
		$("#singleJobForm #noUser").val(row.noUser);
		$("#singleJobForm #nmJob").val(row.nmJob);
		$("#singleJobForm #idDocker").val(row.idDocker);
		$("#singleJobForm #argument").val(row.argument);
		$("#singleJobForm #outputArgument").val(row.outputArgument).trigger('change');
		$("#singleJobForm #outputExt").val(row.outputExt);
		$("#singleJobForm #successCondition").val(row.successCondition);
		//$("#argumentUserDb").val(row.argumentUserDb);
		$("#singleJobForm #ynDb").val(row.ynDb).trigger('change');
		$("#singleJobForm #ynRefDb").val(row.ynRefDb).trigger('change');
		$("#singleJobForm #ynPublic").val(row.ynPublic);
		//$("#argumentRefDb").val(row.argumentRefDb);
		//$("#argumentDb").val(row.argumentDb);
		$("#singleJobForm #commandTest").val("");

		tagSearch(row.idDocker, row.tag);
		
		//refDb set
		if (row.ynRefDb != 'N' && Number(row.ynDb) > 0 && row.argumentDb && row.argumentDb.replace(",") != '') {
			arrArgumentRefDb = $.trim(row.argumentRefDb).split(",");
			arrRefDb = $.trim(row.refDb).split(",");
			for (var i = 0; i < Number(row.ynRefDb); i++) {
				console.log('argumentDb=' + i + ',' + arrArgumentRefDb[i] + ',' + arrRefDb[i]);
				$("input[name=argumentRefDb]:eq(" + i + ")").val(arrArgumentRefDb[i]);
				$("select[name=refDb]:eq(" + i + ")").val(arrRefDb[i]);
			}
		} else {
			$("input[name=argumentRefDb]:eq(0)").val("");
		}

		if (row.ynDb != 'N' && Number(row.ynDb) > 0 && row.db && row.db.replace(",") != '') {
			arrArgumentDb = $.trim(row.argumentDb).split(",");
			arrDb = $.trim(row.db).split(",");
			for (var i = 0; i < Number(row.ynDb); i++) {
				console.log('argumentDb=' + i + ',' + arrArgumentDb[i] + ',' + arrDb[i]);
				$("input[name=argumentDb]:eq(" + i + ")").val(arrArgumentDb[i]);
				$("select[name=db]:eq(" + i + ")").val(arrDb[i]);
			}
		} else {
			$("input[name=argumentDb]:eq(0)").val("");
		}
		
		isLoad = false;
	}
	
	//tag search
	var tagSearch = function(idDocker, tag){
		console.log('tag search');
		
		if(!tag){tag='latest'}
		
		$.ajax({
			type : "POST",
			url : "/web/helix/searchDockerTag?idDocker="+$("#singleJobForm #idDocker").val(),
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(msg) {
				if (msg.result == 'success') {
					console.log(msg.obj);
					$("#singleJobForm #tag").find("option").remove().end().append("<option>==TAG==</option>");
					//배열 개수 만큼 option 추가
					var patten = "<option value='[TAGS]' [SELECTED]>[TAGS]</option>";
					$.each(msg.obj, function(i) {
						$("#singleJobForm #tag").append(patten.replaceAll('[TAGS]', msg.obj[i]).replaceAll('[SELECTED]', (msg.obj[i]==tag?'selected':'')));
					});
				} else {
					tipCall(msg.message);
				}
			},
			error : function(xhr, option, error) {
				alert('<spring:message code="common.error" />');
				console.log(xhr.status); //오류코드
				console.log(error); //오류내용
			}
		});
	}

	var sigleJobPlay = function(idx) {
		console.log('simulate single job');
		window.open("/web/helix/simulate")
	}

	function dsFormatter(value, row, index) {
		return ['<a class="djOk" href="javascript:void(0)" title="Select"><i class="glyphicon glyphicon-ok-sign"></i></a>'].join('');
	}

	window.dsEvents = {
		'click .djOk' : function(e, value, row, index) {
			console.log('djOk:' + value + ',' + row.noJob + ',' + index)
			dockerSelect(row.repo_name);
			$('#dockerSearchModal').modal('toggle');
		}
	}

	var dockerSelect = function(name) {
		$("#idDocker").val(name);
		if ($("#argument").val().trim() == "") {
			modifyArgument();
		}

		$("#ynRefDb").trigger('change');
		$("#ynDb").trigger('change');
		
		tagSearch(name);
	}

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var initForm = function() {
		<spring:eval expression="@project['config.ext.resultFile']" var="resultExt" />
		var resultExt = "${resultExt}".split(",")
		
		//output exp option add
		$.each(resultExt, function (i, item) { $('#outputExt').append($('<option>', {value: item, text : item })); });
		
		$("#dockerSearchForm").on("submit", function(e) {
			if(loginCheck());
			// if the validator does not prevent form submit
			if (!e.isDefaultPrevented()) {
				console.log('docker search');
				$.ajax({
					type : "POST",
					url : "/web/helix/searchDocker",
					data : $('#dockerSearchForm').serialize(),
					beforeSend : function(xhr) {
						xhr.setRequestHeader(header, token);
					},
					success : function(msg) {
						if (msg.result == 'success') {
							//console.log('scrap:' + JSON.stringify(msg.obj));
							$('#dockerGrid').bootstrapTable('load', JSON.parse(msg.obj).results);
							var totalPages = Math.ceil(Number(JSON.parse(msg.obj).count)/10);
				            //var currentPage = Number(JSON.parse(msg.obj).page==null?1:JSON.parse(msg.obj).page);
				            //console.log('totalPages:'+totalPages+',currentPage:'+currentPage)
				            //$('#divDockerGridPage').twbsPagination('destroy');
				            $('#divDockerGridPage').twbsPagination({
				                //startPage: currentPage,
				                totalPages: totalPages,
				                onPageClick: function (evt, page) {
				                    console.log('Page ' + page);
				                    $("#dockerSearchForm #page").val(page);
				                    $("#dockerSearchForm").submit();
				                }
				            });
						} else {
							tipCall(msg.message);
						}
					},
					error : function(xhr, option, error) {
						alert('<spring:message code="common.error" />');
						console.log(xhr.status); //오류코드
						console.log(error); //오류내용
					}
				});
			} else {
				console.log('else');
			}
			return false;
		});

		$("#requestDbForm").on("submit", function(e) {
			if(loginCheck());
			// if the validator does not prevent form submit
			if (!e.isDefaultPrevented()) {
				console.log('docker search');
				$.ajax({
					type : "POST",
					url : "/web/helix/requestDb",
					data : $('#requestDbForm').serialize(),
					beforeSend : function(xhr) {
						xhr.setRequestHeader(header, token);
					},
					success : function(msg) {
						if (msg.result == 'success') {
							$('#requestDbModal').modal('toggle');
							tipCall('new db request success');
						} else {
							tipCall(msg.message);
						}
					},
					error : function(xhr, option, error) {
						tipCall('<spring:message code="common.error" />');
						console.log(xhr.status); //오류코드
						console.log(error); //오류내용
					}
				});
			} else {
				console.log('else');
			}
			return false;
		});

		$("#ynRefDb").trigger('change');
		$("#ynDb").trigger('change');

		$("#singleJobForm").on("submit", function(e) {
			if(loginCheck());
			//validator does not prevent form submit
			if (!e.isDefaultPrevented()) {
				if ($("#singleJobForm #idDocker").val().trim() == "") {
					tipCall("<spring:message code="form.singleJob.search_docker_id_first_error" />");
					return false;
				}

				if ($("#singleJobForm #argument").val().indexOf("command") == 0) {
					tipCall("<spring:message code="form.singleJob.argument_default_error" />");
					return false;
				}

				if ($("#singleJobForm #mode").val() == "check") {
<%/* docker command simulate for user */%>
					e.preventDefault();
					var argument = $("#singleJobForm #argument").val();
					var refDbArg="", dbArg="", resultOpt="";
					var userOpt= getArrayObj2Array("#singleJobForm #userDb option:selected", "text");
					if(!$("#collapseRefDb").hasClass("hidden")){
						arrArgumentRefDb =getArrayObj2Array("#singleJobForm #argumentRefDb", "val");
						arrRefDb = getArrayObj2Array("#singleJobForm #refDb option:selected", "text");
						for(var i=0; i < arrRefDb.length; i++){
							refDbArg += arrArgumentRefDb[i] + " " + arrRefDb[i] + " "
						}
					}			
					
					if(!$("#collapseDb").hasClass("hidden")){
						arrArgumentDb = getArrayObj2Array("#singleJobForm #argumentDb", "val");
						arrDb = getArrayObj2Array("#singleJobForm #db option:selected", "text");
						for(var i=0; i < arrDb.length; i++){
							dbArg += arrArgumentDb[i] + " " + arrDb[i] + " "
						}
					}
					
					if($("#singleJobForm #outputArgument").val()=="DIR"){
						resultOpt = "/resultFolder "
					}else{
						if($("#singleJobForm #db option:selected").val()=='LOG') resultOpt = ">"
						resultOpt += "/resultFolder/userFile." + $("#singleJobForm #outputExt").val()
					}
					
					argument = argument.replace("[REFDB_OPT]",refDbArg)
									.replace("[DB_OPT]",dbArg)
									.replace("[USER_OPT]","userFile")
									.replace("[RESULT_OPT]",resultOpt);
					console.log(argument)
					$("#singleJobForm #commandTest").val(argument);
					
					return false;
				}
				else{
				<%/* submit singleJobForm */%>
					if($("#singleJobForm #mode").val()=="delete" && !confirm("<spring:message code="form.singleJob.confirm_delete" />")){
						console.log('delete cancel');
						return false;
					}else if($("#singleJobForm #mode").val()!="delete" && !confirm("<spring:message code="form.singleJob.confirm_submit" />")){
						console.log('create/update cancel');
						return false;
					}
					
					if($("#singleJobForm #mode").val()=="create"){
						$("#singleJobForm #noJob").val("");
					}
					$.ajax({
						type : "POST",
						url : "/web/helix/insertSingleJob",
						data : $('#singleJobForm').serialize(),
						beforeSend : function(xhr) {
							xhr.setRequestHeader(header, token);
							console.log($('#singleJobForm').serialize())
						},
						success : function(msg) {
							if (msg.result == 'success') {
								tipCall('success job request');
								//location.href="/web/helix/";
								$('#singleJobForm').clearForm();
								getJobList();
								$("#btnDelete").addClass("disabled");
								$("#btnDelete").attr("disabled", false);
							} else {
								tipCall(msg.message);
							}
						},
						error : function(xhr, option, error) {
							tipCall('<spring:message code="common.error" />');
							console.log(xhr.status); //오류코드
							console.log(error); //오류내용
						}
					});
				}			
			} else {
				console.log('else');
			}
			return false;
		});
		
		$("#singleJobForm #refDb").on('change', function(e) {
			dbSelect($(this).val())
		});
		
		var test ='HG00631.chrom20.ILLUMINA.bwa.CHS.low_coverage.20121211.bam';
		console.log(test + ":" + truncate(test,20));
	}
	
	var requestDB = function(dbType){
		if(loginCheck());
		$("#requestDbForm #dbType").val(dbType);
		$("#requestDbForm #email").val("");
		$("#requestDbForm #dbUrl").val("");
		$("#requestDbForm #desc").val("");
		$('#tipModal').modal('toggle');
		$('#requestDbModal').modal('toggle');
	}
	
	function rowStyle(row, index) {
	    var classes = ['active','warning','active', 'success', 'info', 'warning', 'danger'];
	    
        return {
            classes: classes[index % 2]
        };
	}
	
	var dbSelect = function(refDbVal){
		var db = $("#singleJobForm #db");
		
		var tmp = [];
		if(refDbVal){
			console.log('#singleJobForm #refDb.val'+refDbVal)
			console.log(refDbVal.substring(0,refDbVal.indexOf(".")));
			
			switch(refDbVal.substring(0,refDbVal.indexOf("."))){
				case 'hg18':
					tmp = arrDbsHg[0];
					break;
				case 'hg19':
					tmp = arrDbsHg[1];
					break;
				case 'hg38':
					tmp = arrDbsHg[2];
					break;
				default:
					tmp = null;
			}
			switch(refDbVal.substring(0,refDbVal.indexOf("/"))){
				case 'RNA_hg19':
					tmp = arrDbsHg[3];
					break;
				case 'RNA_hg38':
					tmp = arrDbsHg[4];
					break;
			}
		}
		
		if(tmp == null){
			tmp = tmp.concat(arrDbsHg[0]).concat(arrDbsHg[1]).concat(arrDbsHg[2]).concat(arrDbsHg[3]).concat(arrDbsHg[4]);
		}
		
		console.log(tmp);
		db.find("option").remove().end().append("<option value=''>==dbSNP-SELECT==</option>");
		$.each(tmp, function( index, value ) {
			var patten = "<option value='[DB]'>[DB]</option>";
			db.append(patten.replaceAll('[DB]', value));
		});			
	};
</script>
</footerScript>
</html>
