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
	<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.css">

	<!-- Latest compiled and minified JavaScript -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.js"></script>
	
	<!-- Latest compiled and minified Locales -->
	<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/locale/bootstrap-table-en-US.js"></script>
	
	<!-- file download -->
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.fileDownload/1.4.2/jquery.fileDownload.min.js"></script>
	
	<style>
	.table.table-ellipsis tbody td {
		max-width: 100px;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap
	}
	
	.dropzone{
		padding: 5px !important;
		height: 120px !important;
		vertical-align: middle;
		text-align: center;
		min-height: 120px !important;
	}
	
	.dropzone .dz-preview {
      margin:5px !important;
    }
	
	.dropzone .dz-preview .dz-image {
      width: 100px;
      height: 100px;
    }
	
	.dropzone .dz-preview .dz-image .dz-detail {
      padding:5px !important;
    }
	
	.dropzone .dz-default{
		display: table;
		height: 100%;
		margin: 0 auto;
	}
	
	.dropzone .dz-default span{
    	display: table-cell;
    	vertical-align:middle;
	}
	</style>
</head>
<body>
	<!-- Page Header -->
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header" <c:if test="${ynSimulate eq 'Y'}">style="margin:0px !important;"</c:if>>
				<c:if test="${ynSimulate ne 'Y'}">RUN</c:if><c:if test="${ynSimulate eq 'Y'}">SIMULATE</c:if> Docker
		</div>
	</div>
	<!-- /.row -->

	<!-- Projects Row -->
	<div class="row">
		<div class="col-md-12 portfolio-item">
			<c:if test="${ynSimulate ne 'Y'}">
			<a href="#"> <img class="img-responsive" src="/html/image/single.png" alt=""> </a>
			<h3>SINGLE JOB</h3>
			<div id="fileUploadPanel" class="panel panel-warning panel-horizontal" style="width: -webkit-fill-available;">
				<div class="panel-heading w100" style="text-align: center;">
					UPLOAD<br>USER<br>FILE<br>
					<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-uploadUserFile"></button>
				</div>
				<div id="collapseFUP" class="panel-body form-inline panel-collapse collapse in" aria-expanded="true">
					<% request.setAttribute("systemProperties", java.lang.System.getProperties()); %>
					<spring:eval expression="@project['config.upload.url']" var="uploadUrl" />
					<form action="${systemProperties.HOSTIP}${uploadUrl}" class="dropzone needsclick dz-clickable" id="sjDropzone" method="post" enctype="multipart/form-data">
						<input type="hidden" name="fileKey" id="fileKey" value="${fileKey}">
					</form>
				</div>
			</div>
			</c:if>
			<div class="panel panel-danger panel-horizontal" style="width: -webkit-fill-available;">
				<div class="panel-heading w100" style="text-align: center;">
					DOCKER<br>RUN<br>
					<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-jobRequest btn_tip_align"></button>
				</div>
				<div class="panel-body form-inline panel-collapse collapse in" aria-expanded="true">
					<form id="jobRequestForm" name="jobRequestForm" method="post" role="form" data-toggle="validator">
					<input type="hidden" name="ynSimulate" id="ynSimulate">
					<input type="hidden" name="mode" id="mode" value="">
					<div class="form-inline" style="padding:5px;">
						<div class="input_line_height">
							<label for="inputName" class="label label-default label100">Job Select</label> 
							<select id="jobSelect" name="jobSelect" required 
								onChange="jobChange($(this));"  
								data-error="select docker">
								<option value=''>==DOCKER-SELECT==</option>
							</select>
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-dockerSelect"></button>
						</div>
						<div class="input_line_height">
							<span class="label label-default label100">Tags</span> 
							<select id="tag" name="tag" required></select>
							<span class="label label-default label100">Output Type</span>
							<input type="text" class="form-control input-tiny w50" id="resultArgument" name="resultArgument" readonly>
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-dockerResultOption"></button>
							<span class="label label-default label100">Output Ext</span>
							<input type="text" class="form-control input-tiny w100" id="resultExt" name="resultExt" readonly>
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-outputExt"></button>
						</div>
						<div class="form-group" id="refDbInfoSpan">
							<span>
								<span class="label label-default label100">REF DB Option</span>
								<input type="text" class="form-control input-tiny w50" id="refDbOptions" name="refDbOptions">
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argumentRefDb"></button>
								<span class="label label-default label100">REF DB Select</span> 
								<select id="refDbSelects" name="refDbSelects" required 
									data-error="select references">
									<option value=''>==REF-DB-SELECT==</option>
									<c:forEach items="${refDbFileNameList}" var="list"  varStatus="listIndex"><option value="${list}">${ufn:fileNameTruncate(list,30)}</option></c:forEach>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-refDb"></button>
							</span>
						</div>
						<div class="form-group" id="dbInfoSpan">
							<span>
								<span class="label label-default label100">dbSNP Option</span>
								<input type="text" class="form-control input-tiny w50" id="dbOptions" name="dbOptions">
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argumentDb"></button>
								<span class="label label-default label100">dbSNP Select</span> 
								<select id="dbSelects" name="dbSelects" required data-error="select snp db" onchange="console.log('dbSelects:'+$(this).val())">
									<option value=''>==dbSNP-SELECT==</option>
									<c:forEach items="${dbFileList}" var="list"  varStatus="listIndex"><option value="${list.name}">${ufn:fileNameTruncate(list.name,30)}</option></c:forEach>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-db"></button>
							</span>
							<a id="btnAdd" onclick="cloneObj('dbInfoSpan','dbInfoCloneSpan',true)">
								<btn class="glyphicon glyphicon-plus btn-xs btn-success"></btn>
							</a>
							<a btn="btnDel" onclick="cloneObj('dbInfoSpan','',false)" disabled="disabled">
								<btn class="glyphicon glyphicon-minus btn-xs btn-danger"></btn>
							</a>
						</div>
						<div id="dbInfoCloneSpan" ></div>
						<div class="form-group" id="userFileInfoSpan">
							<span>
								<span class="label label-default label100">user file Option</span>
								<input type="text" id="userDbOptions" name="userDbOptions" class="form-control input-tiny w50" placeholder="-db ">
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argumentUserDb"></button>
								<span class="label label-default label100">user file Select</span> 
								<select id="userDbSelects" name="userDbSelects" required 
									data-error="select user`s data">
									<option value=''>==USER-FILE-SELECT==</option>
									<c:forEach items="${fileList}" var="list"  varStatus="listIndex">
										<option value="${list.name}">${ufn:fileNameTruncate(list.name,30)}</option>
									</c:forEach>
								</select>
								<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-userDb"></button>
							</span>
							<a id="btnAdd" onclick="cloneObj('userFileInfoSpan','userFileInfoCloneSpan',true)">
								<btn class="glyphicon glyphicon-plus btn-xs btn-success"></btn>
							</a>
							<a btn="btnDel" onclick="cloneObj('userFileInfoSpan','',false)" disabled="disabled">
								<btn class="glyphicon glyphicon-minus btn-xs btn-danger"></btn>
							</a>
						</div>
						<div id="userFileInfoCloneSpan" ></div>
						<div class="form-inline">
							<span class="label label-default label100">Options</span>
							<input type="text"  id="argument" name="argument" class="form-control input-tiny w500" 
								style="min-width: 200px; width: 60%;" required data-error="insert command options">
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-argument"></button>
						</div>
						<div id="divCheckDockerCommand" class="form-inline" id="divCheckDockerCommand">
							<span class="label label-default label100">Check Command</span>
							<textarea id="commandTest" name="commandTest" class="form-control textAreaCss" rows="2" readonly></textarea>
						</div>
						<div id="divRunDocker" class="form-inline" align="center" style="margin-bottom: 5px;">
							<button type="submit" class="btn btn-info" value="check" onclick="$('#jobRequestForm #mode').val(this.value);">Check Docker Command</button>
							<button type="submit" class="btn btn-primary" value="run" onclick="$('#jobRequestForm #mode').val(this.value);">Run Docker</button>							
						</div>
					</div>
					</form>
				</div>
			</div>
			
			<div class="panel panel-primary">
				<div class="panel-body">
					<div style="float: left;">
						<h4 class="panel-title">
							<a href="#collapseJRH" class="" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="collapseJRH"> JOB REQUEST LIST </a>
							<button type="button" class="btn btn-default btn-xs glyphicon glyphicon-question-sign tip-jobRequestList btn_tip_align"></button>
						</h4>
					</div>
					<div style="float: right;">
						<span class="headerButtons">
							<i class="glyphicon glyphicon-minus btn-xs btn-success expandCollapse" aria-hidden="false"></i>
						</span>
					</div>
				</div>
				<div id="collapseJRH" class="panel-footer panel-collapse collapse in" aria-expanded="true">
					<table class="table table-striped" id="sjGrid" data-height="500" data-resizable="false" data-pagination="true" data-escape="false" >
						<thead class="thead-inverse">
							<tr>
								<th data-field="noUser" data-visible="false">noUser</th>
								<th data-field="noJob" data-visible="false">noJob</th>
								<th data-field="nmJob">Job Name</th>
								<th data-field="dtJobStart" data-formatter="dateTimeFormatter" data-align="center">req dt</th>
								<th data-field="dtJobEnd" data-formatter="dateTimeFormatter" data-align="center">end dt</th>
								<th data-field="cdJobStat" data-align="center">course</th>
								<th data-field="cdJobEndStat" data-align="center">status</th>
								<th data-field="successCondition" data-visible="false" >complect cond</th>
								<th data-field="commandTest" data-popover="popover" data-trigger="hover" data-class="colNoWrap">command</th>
								<th data-field="msgResult" data-popover="popover" data-trigger="hover" data-class="colNoWrap">result</th>
								<th data-field="file" data-align="center" data-events="operateEvents" data-formatter="operateFormatter">result</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
		<div class="col-md-12 portfolio-item" style="pointer-events: none; opacity: 0.4;">
			<a href="#"> <img class="img-responsive" src="/html/image/group.png" alt=""> </a>
			<h3>
				<a href="#">Group Jobs</a>
			</h3>
			<form action="/file-upload" class="dropzone needsclick dz-clickable" id="gjDropzone">
				<div class="fallback">
					<input id="gjFile" name="file" type="file" multiple />
				</div>
			</form>
			<div class="form-inline" style="padding:5px">
				<div style="padding:1px">
					<span class="label label-default">Group Job Select</span> <select>
						<option>Whole Genome Sequencing 1</option>
						<option>Whole Genome Sequencing 2</option>
					</select> 
				</div>
				<div style="padding:1px">
					<span class="label label-default">Error Post Method</span> <select>
						<option>Every Job Result</option>
						<option>Whole Job Result</option>
					</select> 
				</div>
			</div>
		</div>
	</div>
	<!-- /.row -->
	<!-- Modal -->
	<div id="resultFileModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Result File List</h4>
				</div>
				<div class="modal-body">
					<table id="resultGrid">
						<thead>
							<tr>
								<th data-field="dtJobStart" data-visible="false">dtJobStart</th>
								<th data-field="no">No</th>
								<th data-field="nmFile">result file</th>
								<th data-field="down" data-events="FileListEvents" data-formatter="FileListEventsFormatter" data-align="center">down</th>
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
	<c:if test="${ynSimulate ne 'Y'}">
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
	</c:if>
	<hr>

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
	var jobList;
	var refreshIntervalId;
	var timer = function(isStop){
		if(isStop){
			clearInterval(refreshIntervalId);
		}
		
		window.setTimeout(getJobRquestList(), 5000);
		refreshIntervalId=setInterval(function(){getJobRquestList()}, 60000)
	}
	
	var resetGrid = function () {
		$('#sjGrid').bootstrapTable();
		$('#resultGrid').bootstrapTable();
	    $(window).resize(function () {
	        $('#sjGrid').bootstrapTable('resetView');
	        $('#resultGrid').bootstrapTable('resetView');
	    });
	}
	
	$(document).ready(function() {
		getJobList();
		setMainForm();
		<c:if test="${ynSimulate ne 'Y'}">setBtnFileUploadPalel();</c:if>
		resetGrid();
		//$('#sjGrid').bootstrapTable({data:{}});
		//$('#resultGrid').bootstrapTable({data:{}});
		getJobRquestList();
		timer(false);
	});
	
	<c:if test="${ynSimulate ne 'Y'}">
	var setBtnFileUploadPalel = function() {
		$('.headerButtons .expandCollapse').on("click", function(e) {
			var myCollapse = $(this).parents(".panel").find(".collapse");
			myCollapse.collapse('toggle');
			//$(this).toggleClass("fa-chevron-up").toggleClass("fa-chevron-down");
		});

		$(".panel-collapse").on('hide.bs.collapse', function() {
			var but = $(this).parents(".panel").find(".expandCollapse");
			but.removeClass("glyphicon-minus").addClass("glyphicon-plus");
		});
		
		$(".panel-collapse").on('show.bs.collapse', function() {
			var but = $(this).parents(".panel").find(".expandCollapse");
			but.removeClass("glyphicon-plus").addClass("glyphicon-minus");
		});
	}
	</c:if>
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var setMainForm = function() {
		$("#jobRequestForm").on("submit", function(e) {
			// if the validator does not prevent form submit
			console.log('mode:'+$("#jobRequestForm #mode").val())
			if (!e.isDefaultPrevented()) {
				var argument = $("#jobRequestForm #argument").val();
				var refDbArg="", dbArg="", resultOpt="", userDbArg="";
				var userOpt= getArrayObj2Array("#jobRequestForm #userDbSelects option:selected", "text");
				if(!$("#refDbInfoSpan").hasClass("hidden")){
					arrArgumentRefDb =getArrayObj2Array("#jobRequestForm #refDbOptions", "val");
					arrRefDb = getArrayObj2Array("#jobRequestForm #refDbSelects option:selected", "text");
					for(var i=0; i < arrRefDb.length; i++){
						refDbArg += arrArgumentRefDb[i] + " " + arrRefDb[i] + " "
					}
				}			
				
				if(!$("#dbInfoSpan").hasClass("hidden")){
					arrArgumentDb = getArrayObj2Array("#jobRequestForm #dbOptions", "val");
					arrDb = getArrayObj2Array("#jobRequestForm #dbSelects option:selected", "text");
					for(var i=0; i < arrDb.length; i++){
						dbArg += arrArgumentDb[i] + " " + arrDb[i] + " "
					}
				}
				
				arrUserDb = getArrayObj2Array("#jobRequestForm #userDbSelects option:selected", "text");
				for(var i=0; i < arrUserDb.length; i++){
					userDbArg += arrUserDb[i] + " "
				}
				
				if($("#jobRequestForm #resultArgument").val()=="DIR"){
					resultOpt = "/resultFolder "
				}else{
					if($("#jobRequestForm #resultArgument").val
							()=='LOG') resultOpt = " > "
					
					var filename = $("#jobRequestForm #userDbSelects option:selected").val();
					<c:if test="${ynSimulate ne 'Y'}">
					filename = filename.substring(filename.indexOf("_") + 1, filename.lastIndexOf(".")+1) + $("#jobRequestForm #resultExt").val();
					</c:if><c:if test="${ynSimulate eq 'Y'}">
					filename = filename.substring(0, filename.lastIndexOf(".")+1) + $("#jobRequestForm #resultExt").val();
					</c:if>
					resultOpt += "/resultFolder/" + filename;
				}
				
				argument = argument.replace("[REFDB_OPT]",refDbArg)
								.replace("[DB_OPT]",dbArg)
								.replace("[USER_OPT]",userDbArg)
								.replace("[RESULT_OPT]",resultOpt);
				console.log(argument)
				$("#jobRequestForm #commandTest").val(argument);
				
				if($("#jobRequestForm #mode").val()=="run"){
				console.log($("#jobRequestForm #mode").val())
					$("#jobRequestForm #ynSimulate").val("${ynSimulate}");
					$.ajax({
						type : "POST",
						url : "/web/helix/insert",
						data : $('#jobRequestForm').serialize(),
						beforeSend : function(xhr) {
							xhr.setRequestHeader(header, token);
							console.log($('#jobRequestForm').serialize())
						},
						success : function(msg) {
							console.log(msg);
							if (msg.result == 'success') {
								tipCall('success job request');
								//location.href="/web/helix/";
								timer(false);
								$('#jobRequestForm').clearForm();
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
		
		$("#jobRequestForm #refDbSelects").on('change', function(e) {
			dbSelect($(this).val())
		});
		
		var selectboxUpdate = function(objNm, data) {
			//console.log('objNm:' + objNm + ',data:' + data)
			//AJAX select box function 
			//SELECT BOX 초기화 
			$("#" + objNm).find("option").remove().end().append("<option value=''>==DOCKER-SELECT==</option>");
			//배열 개수 만큼 option 추가
			var patten = "<option value='[NO_JOB]'>[NM_JOB] ([ID_DOCKER])</option>";
			$.each(data, function(i) {
				$("#" + objNm).append(
						patten.replace('[NO_JOB]', data[i].noJob)
							.replace('[NM_JOB]', data[i].nmJob)
							.replaceAll('[ID_DOCKER]', data[i].idDocker));
			});
		}
	}
	
	var dbSelect = function(refDbVal){
		var db = $("#jobRequestForm #dbSelects");
		
		var tmp = [];
		if(refDbVal){
			console.log('#jobRequestForm #refDbSelects.val'+refDbVal)
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
	
	var getJobList = function() {
		console.log('getJobList');

		$.ajax({
			type : "POST",
			url : "/web/helix/api/jobList",
			<c:if test="${ynSimulate eq 'Y'}">data : {"ynSimulate":"Y", "noJob":"${noJob}"},</c:if>
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

	function format(mask, number) {
		var s = '' + number, r = '';
		for (var im = 0, is = 0; im < mask.length && is < s.length; im++) {
			r += mask.charAt(im) == 'X' ? s.charAt(is++) : mask.charAt(im);
		}
		return r;
	}

	function operateFormatter(value, row, index) {
        return [
            '<a class="JRHFileView" href="javascript:void(0)" title="Result File">',
            '<i class="glyphicon glyphicon-list-alt"></i>',
            '</a>  '
        ].join('');
    }
	
	window.operateEvents = {
		'click .JRHFileView' : function(e, value, row, index) {
			console.log('operateEvents:'+value+','+row+','+index)
			resultView(row.noJob, row.dtJobStart);
		}
	};

	function FileListEventsFormatter(value, row, index) {
        return [
            '<a class="fileListView" href="javascript:void(0)" title="Result List">',
            '<i class="glyphicon glyphicon-download-alt"></i>',
            '</a>  '
        ].join('');
    }
	
	window.FileListEvents = {
		'click .fileListView' : function(e, value, row, index) {
			var downUrl = "/web/helix/download/"+row.dtJobStart+"/"+row.nmFile;
			//console.log('downUrl:'+downUrl);
			$.fileDownload(downUrl)
	        	.done(function () { console.log('file download request success'); })
	        	.fail(function () { alert('file download request failed'); });
		}
	};
	
	var resultView = function (noJob, dtJobStart){
		console.log('noJob:'+noJob + ' dtJobStart:'+dtJobStart);
		$.ajax({
			type : "POST",
			url : "/web/helix/api/resultFileList",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			data : "noJob=NOJOB&dtJobStart=DTJOBSTART".replaceAll("NOJOB",noJob).replaceAll("DTJOBSTART",dtJobStart), 
			success : function(msg) {
				console.log('msg:' + msg);
				fileList = JSON.parse(msg);
				//console.log("fileList:" + fileList.join(' '));
				//job list load
				$('#resultGrid').bootstrapTable('load', fileList);
				$('#resultGrid').bootstrapTable('resetView');
				$('#resultFileModal').appendTo("body").modal('show');
				//$('#resultFileModal').modal('show');
			},
			error : function(xhr, option, error) {
				tipCall('<spring:message code="common.error" />');
				console.log(xhr.status); //오류코드
				console.log(error); //오류내용
			}
		});
	}

	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var getJobRquestList = function() {
		console.log('getJobRquestList');
		$.ajax({
			type : "POST",
			url : "/web/helix/api/jobRequestList",
			<c:if test="${ynSimulate eq 'Y'}">data : {"ynSimulate":"Y", "noJob":"${noJob}"},</c:if>
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(msg) {
				//console.log('msg:' + msg);
				var JobRquestList = JSON.parse(msg);
				//console.log("jobRequestList:" + JobRquestList[0].noUser);
				//job list load
				$('#sjGrid').bootstrapTable('load', JobRquestList);

				tooltipInit();
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
			}
		});
	}

	String.prototype.replaceAll = function(org, dest) {
		return this.split(org).join(dest);
	}

	var selectboxUpdate = function(objNm, data) {
		//console.log('objNm:' + objNm + ',data:' + data)
		//AJAX select box function 
		//SELECT BOX 초기화 
		$("#" + objNm).find("option").remove().end().append("<option value=''>==DOCKER-SELECT==</option>");
		//배열 개수 만큼 option 추가
		var patten = "<option value='[NO_JOB]'>[NM_JOB] ([ID_DOCKER])</option>";
		$.each(data, function(i) {
			$("#" + objNm).append(
					patten.replace('[NO_JOB]', data[i].noJob)
						.replace('[NM_JOB]', data[i].nmJob)
						.replaceAll('[ID_DOCKER]', data[i].idDocker));
		});
	}

	var jobChange = function(obj) {
		//console.log(obj.prop('selectedIndex'));
		//console.log('jobChange, select index:' + obj.prop('selectedIndex'));
		//console.log('jobList[i]:'	+ JSON.stringify(jobList[obj.prop('selectedIndex') - 1]));
		var job = jobList[obj.prop('selectedIndex') - 1];
		console.log(job);
		if(job){
			$('#jobRequestForm #resultArgument').val(job.outputArgument);
			$('#jobRequestForm #resultExt').val(job.outputExt);
			$('#jobRequestForm #argument').val(job.argument);
			$("#jobRequestForm #refDbInfoCloneSpan").empty();
			$("#jobRequestForm #dbInfoCloneSpan").empty();
			$("#jobRequestForm #userFileInfoCloneSpan").empty();
			$("#jobRequestForm #userDbSelects").val("");
			$("#jobRequestForm #commandTest").val("");
			if(job.ynRefDb=='N'){
				//console.log('refDbInfoSpan disabled')
				$("#jobRequestForm #refDbInfoSpan").addClass("hidden");
				$("#jobRequestForm #refDbInfoCloneSpan").addClass("hidden");
				$("#jobRequestForm #refDbInfoSpan :input").attr("disabled", true);
			}else{
				//console.log('refDbInfoSpan abled')
				$("#jobRequestForm #refDbInfoSpan").removeClass("hidden");
				$("#jobRequestForm #refDbInfoSpan :input").attr("disabled", false);
				
				arrArgumentRefDb = job.argumentRefDb.split(",");
				arrRefDb = $.trim(job.refDb).split(",");
				for(var i=1; i < Number(job.ynRefDb); i++){
					cloneObj('refDbInfoSpan','refDbInfoCloneSpan',true);
				}
				for(var i=0; i < Number(job.ynRefDb); i++){
					//console.log('argumentDb='+i+','+arrArgumentRefDb[i]+','+arrRefDb[i]);
					$("input[name=refDbOptions]:eq("+i+")").val(arrArgumentRefDb[i]);
					$("select[name=refDbSelects]:eq("+i+")").val(arrRefDb[i]);
				}
			}
			
			if(job.ynDb=='N'){
				//console.log('dbInfoSpan disabled')
				$("#jobRequestForm #dbInfoSpan").addClass("hidden");
				$("#jobRequestForm #dbInfoCloneSpan").addClass("hidden");
				$("#jobRequestForm #dbInfoSpan :input").attr("disabled", true);
			}else{
				//console.log('dbInfoSpan abled')
				$("#jobRequestForm #dbInfoSpan").removeClass("hidden");
				$("#jobRequestForm #dbInfoCloneSpan").removeClass("hidden");
				$("#jobRequestForm #dbInfoSpan :input").attr("disabled", false);
				
				arrArgumentDb = $.trim(job.argumentDb).split(",");
				arrDb = $.trim(job.db).split(",");
				for(var i=1; i < Number(job.ynDb); i++){
					cloneObj('dbInfoSpan','dbInfoCloneSpan',true);
				}
				for(var i=0; i < Number(job.ynDb); i++){
					console.log('argumentDb='+i+','+arrArgumentDb[i]+','+arrDb[i]);
					$("input[name=dbOptions]:eq("+i+")").val(arrArgumentDb[i]);
					$("select[name=dbSelects]:eq("+i+")").val(arrDb[i]);
					console.log('db:'+$("select[name=dbSelects]:eq("+i+")").val());
				}
			}
			
			$("#jobRequestForm #tag").find("option").remove().end().append("<option>==TAG==</option>");
			tagSearch(job.idDocker, job.tag);
		}else{
			$('#jobRequestForm').clearForm();
			$('#jobRequestForm select').each(function(){
				$(this).prop('selectedIndex',0)}
			);
		}
	}
	
	//tag search
	var tagSearch = function(idDocker,tag){
		console.log('tag search:'+tag);
		if(!tag){tag='latest'}
		$.ajax({
			type : "POST",
			url : "/web/helix/searchDockerTag?idDocker="+idDocker,
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(msg) {
				if (msg.result == 'success') {
					console.log(msg.obj);
					$("#jobRequestForm #tag").find("option").remove().end().append("<option>==TAG==</option>");
					//배열 개수 만큼 option 추가
					var patten = "<option value='[TAGS]' [SELECTED]>[TAGS]</option>";
					$.each(msg.obj, function(i) {
						$("#jobRequestForm #tag").append(patten.replaceAll('[TAGS]', msg.obj[i]).replaceAll('[SELECTED]', (msg.obj[i]==tag?'selected':'')));
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

	Dropzone.options.sjDropzone = {
		method : "post",
		uploadMultiple : false,
		acceptedFiles : "<spring:eval expression="@project['config.ext.uploadFile']" var="uploadUrl" />${uploadUrl}",
		autoProcessQueue : true,
		maxFilesize : 50000,
		thumbnailWidth: 100,
	    thumbnailHeight: 100,
		init : function() {
			myDropzone = this;
			var submitButton = document.querySelector("#submit-all");
			var removeButton = document.querySelector("#remove-all");

			/*
			this.on("complete", function (file) {
			    if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
			        myDropzone.removeAllFiles();
			    	alert('success complete');
			        submitButton.removeAttribute("disabled");
			    }
			});*/
		    this.on("maxfilesexceeded", function(file){
		    	tipCall("file size limit exceeded. Only upload files below " + maxFilesize + " gigabytes!");
				myDropzone.removeFile(file);
		        return file.previewElement.classList.add("dz-error");
		    });
			this.on("error",	function(file, message) {
				tipCall('upload error : ' + message);
				myDropzone.removeFile(file);
				return file.previewElement.classList.add("dz-error");
			});
			this.on("success",	function(file) {
				if (file.previewElement) {
					myDropzone.removeFile(file);
					tipCall('<spring:message code="helix.fileupload.success" />');
					top.location.reload();
					return file.previewElement.classList.add("dz-success");
				}
			});
		}
	};

	var cloneObj = function(targetObjName, destObjName, isAdd) {
		if (isAdd) {
			$('#' + targetObjName).clone().prependTo('#' + destObjName);
			$("btn[id='btnAdd']").attr('disabled', 'disabled');
			$("btn[id='btnDel']").attr('disabled', 'disabled');
			$("btn[id='btnAdd']:last").attr('disabled', '');
			$("btn[id='btnDel']:last").attr('disabled', '');
		} else {
			//console.log('remove div count:' + $("div[id='" + targetObjName + "']").length);
			if ($("div[id='" + targetObjName + "']").length > 1) {
				$("div[id='" + targetObjName + "']:last").remove();
			} else {
				$("btn[id='btnDel']").attr('disabled', 'disabled');
			}
		}
	}
</script>
</footerScript>
</html>
