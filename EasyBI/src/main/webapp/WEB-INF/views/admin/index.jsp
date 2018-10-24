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
			<h1 class="page-header">Admin</h1>			
		</div>
	</div>
	<!-- /.row -->

	<!-- Projects Row -->
	<div class="row">
		Admin
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
					if($("#jobRequestForm #resultArgument").val()=='LOG') resultOpt = " > "
					
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
		db.find("option").remove().end().append("<option value=''>==dbSNP-SELECT==</option>");
		
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
		}else{
			tmp = tmp.concat(arrDbsHg[0]).concat(arrDbsHg[1]).concat(arrDbsHg[2]);
		}
		
		console.log(tmp);
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
					//console.log('argumentDb='+i+','+arrArgumentDb[i]+','+arrDb[i]);
					$("input[name=dbOptions]:eq("+i+")").val(arrArgumentDb[i]);
					$("select[name=dbSelects]:eq("+i+")").val(arrDb[i]);
				}
			}
			
			$("#jobRequestForm #tag").find("option").remove().end().append("<option>==TAG==</option>");
			tagSearch(job.idDocker, job.tag);
		}else{
			$('#jobRequestForm').clearForm();
		}
		
		dbSelect('');
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
		acceptedFiles : "<spring:eval expression="@project['config.uploadFile.ext']" var="uploadUrl" />${uploadUrl}",
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
