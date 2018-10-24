/**
 * Created by Frenos on 18.08.2016.
 */
var stompClient = null;

$(document).ready(function()
{
    $('#btnAddJobs').click(function(){
        $.get("/trigger");
    });

    $('#btnSetPoolsize').click(function () {
        var newSize = $('#newPoolsize').val();
        $.get("/poolsize/"+newSize);
    });

    connect();
    //setTimeout(updateProgress, 10);
});

function connect(){
    var socket = new SockJS('/mystatus');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function(frame){
        stompClient.subscribe('/app/initial', function (messageOutput){
            console.log("INITIAL: "+messageOutput);
            var progressList = $.parseJSON(messageOutput.body);
            $.each(progressList,function(index, element){
                update(element);
            });
        });

        stompClient.subscribe('/topic/status', function(messageOutput) {
            console.log("New Message: "+messageOutput);
            var messageObject = $.parseJSON(messageOutput.body);
            update(messageObject);
        });
    });
}

function update(newMessage){

    var rows = $('#tableBody').find('#'+newMessage.processJobName);
    if(rows.length == 0)
    {
    	var stateClass = "success";
    	if(rows.status == "RUNNING"){stateClass = "active";}else if(rows.status == "NEW"){stateClass = "info"};
        $('#tableBody').append('<tr id="'+newMessage.processJobName+'" class="'+stateClass+'">' +
            '<td>'+newMessage.processJobName+'</td>'+
            '<td><div class="state">'+ newMessage.state +'</div></td></tr>');
    }

    //set stuffs
    var parentDiv = $('#'+newMessage.processJobName);
    //parentDiv.find('.progress-bar').html(newMessage.progress +"%");
    //parentDiv.find('.progress-bar').css('width',newMessage.progress+'%').attr("aria-valuenow",newMessage.progress);
    console.log('newState:'+newMessage.state);
    parentDiv.find('.state').html(newMessage.state);
    if(newMessage.state == "DONE")
    {
        parentDiv.removeClass("active info success").addClass("success");
    }
    else if(newMessage.state == "RUNNING")
    {
        parentDiv.removeClass("active info success").addClass("active");
    }
    else if(newMessage.state == "NEW")
    {
        parentDiv.removeClass("active info success").addClass("info");
    }
    //end set stuffs
}