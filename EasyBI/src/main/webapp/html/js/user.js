$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

/* HashMap 객체 생성 */
var JqMap = function(){
    this.map = new Object();
}
 
JqMap.prototype = {
    /* key, value 값으로 구성된 데이터를 추가 */
    put: function (key, value) {
        this.map[key] = value;
    },
    /* 지정한 key값의 value값 반환 */
    get: function (key) {
        return this.map[key];
    },
    /* 구성된 key 값 존재여부 반환 */
    containsKey: function (key) {
        return key in this.map;
    },
    /* 구성된 value 값 존재여부 반환 */
    containsValue: function (value) {
        for (var prop in this.map) {
            if (this.map[prop] == value) {
                return true;
            }
        }
        return false;
    },
    /* 구성된 데이터 초기화 */
    clear: function () {
        for (var prop in this.map) {
            delete this.map[prop];
        }
    },
    /*  key에 해당하는 데이터 삭제 */
    remove: function (key) {
        delete this.map[key];
    },
    /* 배열로 key 반환 */
    keys: function () {
        var arKey = new Array();
        for (var prop in this.map) {
            arKey.push(prop);
        }
        return arKey;
    },
    /* 배열로 value 반환 */
    values: function () {
        var arVal = new Array();
        for (var prop in this.map) {
            arVal.push(this.map[prop]);
        }
        return arVal;
    },
    /* Map에 구성된 개수 반환 */
    size: function () {
        var count = 0;
        for (var prop in this.map) {
            count++;
        }
        return count;
    }
}

$(document).ready(function() {
	var tips = $('button[class*="tip-"]');
	$.each(tips, function(index, item){
		//console.log('classname:'+item.classList.toString().match(/tip-[a-zA-Z0-9]*/g));			
		item.onclick = function(event){
			var tipName = this.classList.toString().match(/tip-[a-zA-Z0-9]*/g);
			console.log("clicked:" + tipName);
			console.log("message:" + oMap.get(tipName));
			
			var tipContent=oMap.get(tipName);
			if(tipContent==null || tipContent.trim() == "") tipContent = "지원되는 설명이 없습니다.";
			$("#tipContent").html(oMap.get(tipName));
			$('#tipModal').modal('show');
		};
	});
	
	findToolTip();
});

var findToolTip = function(){
	$('[data-popover="popover"]').popover({
	    container: 'body'
	    , trigger: "click"
	});
}


var tooltipInit = function(){
	$(".colNoWrap").each(function () {
	     var $this = $(this);
	     
	     if (this.offsetWidth < this.scrollWidth && !$this.attr('title')) {
	    	 $this.attr("title","whole parameter");
	    	 $this.attr("data-content",$this.text());
	    	 $this.attr("data-popover","popover");
	     }
	 });
	
	findToolTip();
}

var tipCall = function(title){
	$("#tipContent").html(title);
	$('#tipModal').modal('show');
}

String.prototype.nvl=function(){
	return (typeof this == "undefined" || this == null || this == '' || this == "undefined")?'':this;
};

var getArrayObj2Array = function(name, method){
	console.log('name:'+name + ', value:'+eval("$(name).map(function(){return $(this)."+method+"();}).get()"));
	return eval("$(name).map(function(){return $(this)."+method+"();}).get()");
};

var getArrayObj2String = function(name,method){
	return getArrayObj2Array(name, method).join(' ')
};

var truncate = function (n, len) {
    var ext = n.substring(n.lastIndexOf(".") + 1, n.length).toLowerCase();
    var filename = n.replace('.'+ext,'');
    if(filename.length <= len) {
        return n;
    }
    filename = filename.substr(0, len) + (n.length > len ? '...' : '');
    return filename + '.' + ext;
};