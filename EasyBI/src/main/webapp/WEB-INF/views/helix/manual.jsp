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
	
	<style>
	.table.table-ellipsis tbody td {
		max-width: 100px;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap
	}
	
	</style>
</head>
<body>
	<!-- Page Header -->
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">User Manual</h1>
		</div>
	</div>
	<!-- /.row -->

	<!-- Projects Row -->
	<div>
		<object data="/html/manual.pdf" type="application/pdf" width="100%" height="800">
			alt : <a href="/html/manual.pdf">User Manual.pdf</a>
		</object>
	</div>
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
	var lastObject;
	var patten = "<option value='[NAME1]'>[NAME2]</option>";
	$(document).ready(function() {
		getFileList();
		
		$('#myFileForm .btnCancelFile').on('click',function(e){getFileList();});
		$('#myFileForm #fileActive').on('blur',function(e){lastObject=$(this);});
		$('#myFileForm #fileTemp').on('blur',function(e){lastObject=$(this);});
		$('#myFileForm .file2Left').on('click',function(e){
			console.log('file2Left');
			var list = $('#myFileForm #fileTemp option:selected');
			if(list.length>0){
				list.each(function(index){
					if(/ \[\-\]/.test($(this).text())){
						tipCall("One Action allowed for One File");	
					}else if(/ \[\+\]/.test($(this).text())){
						$(this).remove();
						$('#myFileForm #fileActive').find('option').end().append(patten.replace('[NAME1]',$(this).val()).replace('[NAME2]',$(this).text().replace(' [+]','')));
					}else{
						$(this).remove();
						$('#myFileForm #fileActive').find('option').end().append(patten.replace('[NAME1]',$(this).val()).replace('[NAME2]',$(this).text()+' [+]'));
					}
				})				
			}else{
				tipCall("Select file first");
			}
		});
		$('#myFileForm .file2Remove').on('click',function(e){
			console.log('file2Remove');
			var list = lastObject.find('option:selected');
			var patten = "<option value='[NAME1]'>[NAME2]</option>";
			if(list.length>0){
				list.each(function(index){
					if(/ \[\+\]/g.test($(this).text())){
						tipCall("One Action allowed for One File");					
					}else if(/ \[\-\]/g.test($(this).text())){
						tipCall("One Action allowed for One File");					
					}else{
						$(this).text($(this).text() + ' [-]');
					}
				})				
			}else{
				tipCall("Select file first");
			}
		});
		$('#myFileForm .file2Right').on('click',function(e){
			console.log('file2Right');
			var list = $('#myFileForm #fileActive option:selected');
			var patten = "<option value='[NAME1]'>[NAME2]</option>";
			if(list.length>0){
				list.each(function(index){
					if(/ \[\-\]/.test($(this).text())){
						tipCall("One Action allowed for One File");	
					}else if(/ \[\+\]/.test($(this).text())){
						$(this).remove();
						$('#myFileForm #fileTemp').find('option').end().append(patten.replace('[NAME1]',$(this).val()).replace('[NAME2]',$(this).text().replace(' [+]','')));
					}else{
						$(this).remove();
						$('#myFileForm #fileTemp').find('option').end().append(patten.replace('[NAME1]',$(this).val()).replace('[NAME2]',$(this).text()+' [+]'));
					}
				})				
			}else{
				tipCall("Select file first");
			}
		});
		
		$("#myFileForm .btnSaveFile").on("click", function(e) {
			$('#myFileForm #fileActive option').each(function(e){
				if(/\[\-\]/.test($(this).text())){
					$('#myFileForm #fileActives').val($('#myFileForm #fileActives').val()+$(this).val()+'[-],');
				}else if(/\[\+\]/.test($(this).text())){
					$('#myFileForm #fileTemps').val($('#myFileForm #fileTemps').val()+$(this).val()+'[+],');
				}
			});
			$('#myFileForm #fileTemp option').each(function(e){
				if(/\[\-\]/.test($(this).text())){
					$('#myFileForm #fileTemps').val($('#myFileForm #fileTemps').val()+$(this).val()+'[-],');
				}else if(/\[\+\]/.test($(this).text())){
					$('#myFileForm #fileActives').val($('#myFileForm #fileActives').val()+$(this).val()+'[+],');
				}
			});
			console.log('fileActives:'+$('#myFileForm #fileActives').val());
			console.log('fileTemps:'+ $('#fileTemps').val());
			
			if(!$('#myFileForm #fileActives').val() && !$('#myFileForm #fileTemps').val()){
				tipCall("There is no file change");
				return false;
			}
			
			// if the validator does not prevent form submit
			if (!e.isDefaultPrevented()) {
				$.ajax({
					type : "POST",
					url : "/web/helix/api/myFileUpdate",
					data : $('#myFileForm').serialize(),
					beforeSend : function(xhr) {
						xhr.setRequestHeader(header, token);
						console.log($('#myFileForm').serialize())
					},
					success : function(msg) {
						console.log(msg);
						if (msg.result == 'success') {
							tipCall('success job request');
							$('#myFileForm').clearForm();
							getFileList();
						} else {
							tipCall(msg.message);
						}
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
			}else{
				return false;
			}
		});
	});
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var getFileList = function() {
		console.log('getFileList');

		$.ajax({
			type : "POST",
			url : "/web/helix/api/myFileList",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",  
			beforeSend : function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(msg) {
				jobList = JSON.parse(msg);
				console.log(jobList.fileList);
				selectLoad('#myFileForm #fileActive', jobList.fileList);
				console.log(jobList.fileTmpList);
				selectLoad('#myFileForm #fileTemp', jobList.fileTmpList);
			},
			error : function(xhr, option, error) {
				alert('<spring:message code="common.error" />');
				console.log(xhr.status); //오류코드
				console.log(error); //오류내용
			}
		});
	}
	
	var selectLoad = function(name, val){
		var db = $(name);
		db.find("option").remove().end();
		
		$.each(val, function( index, value ) {
			var patten = "<option value='[NAME1]'>[NAME2]</option>";
			db.append(patten.replaceAll('[NAME1]', value).replaceAll('[NAME2]', value));
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
</script>
</footerScript>
</html>
