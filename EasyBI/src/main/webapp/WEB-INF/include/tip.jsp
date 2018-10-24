<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@include file="/WEB-INF/include/taglib.jsp" %><c:set var="strTips">
tip-uploadUserFile,tip-nmJob,tip-idDocker,tip-argument,tip-outputArgument,tip-successCondition\
,tip-ynRefDb,tip-refDb,tip-argumentRefDb,tip-ynDb,tip-db,tip-argumentDb,tip-userDb,tip-argumentUserDb\
,tip-dockerSelect,tip-dockerResultOption,tip-uploadFile,tip-jobRequest,tip-jobRequestList,tip-dockerList\
,tip-dockerRegister,tip-RequestDb,tip-RequestRefDb,tip-outputExt
</c:set>	var oMap = new JqMap();
<c:forTokens items="${strTips}" delims="," var="value">	oMap.put("${value}", '<spring:message code="tip.${value}" text="-" />');
var strDbs="<c:forEach items="${dbFileList}" var="list"  varStatus="listIndex">${list.name},</c:forEach>";
var arrDbsHg=[[],[],[],[],[]];
</c:forTokens>
$(document).ready(function() {
	if(strDbs){
		var arrDbs=strDbs.split(",");
		for(i=0;i<arrDbs.length;i++){
			//console.log('arrDbs['+i+']='+arrDbs[i]);
			if(arrDbs[i]!=null && +arrDbs[i].indexOf('hg18')>0 && +arrDbs[i].indexOf('RNA')<0){
				arrDbsHg[0].push(arrDbs[i]);
			}else if(arrDbs[i]!=null && +arrDbs[i].indexOf('hg19')>0 && +arrDbs[i].indexOf('RNA')<0){
				arrDbsHg[1].push(arrDbs[i]);
			}else if(arrDbs[i]!=null && +arrDbs[i].indexOf('hg38')>0 && +arrDbs[i].indexOf('RNA')<0){
				arrDbsHg[2].push(arrDbs[i]);
			}else if(arrDbs[i]!=null && +arrDbs[i].indexOf('hg19')>0 && +arrDbs[i].indexOf('RNA')>-1){
				arrDbsHg[3].push(arrDbs[i]);
			}else if(arrDbs[i]!=null && +arrDbs[i].indexOf('hg38')>0 && +arrDbs[i].indexOf('RNA')>-1){
				arrDbsHg[4].push(arrDbs[i]);
			}
		}
		console.log(arrDbsHg);	
	}
});	