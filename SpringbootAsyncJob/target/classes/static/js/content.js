/**
 * Created by Frenos on 18.08.2016.
 */
$(document).ready(function()
{
    $('#btnAddJobs').click(function(){
        $.get("/trigger");
    });

    $('#btnSetPoolsize').click(function () {
        var newSize = $('#newPoolsize').val();
        $.get("/poolsize/"+newSize);
    });

    setTimeout(updateProgress, 100);
});

function updateProgress(){
    $.ajax({
        url: './status',
        success: function(data){
            $.each(data,function(index, element){
                var rows = $('#tableBody').find('#'+element.processJobName);
                if(rows.length == 0)
                {
                	var stateClass = "success";
                	if(element.status == "RUNNING"){stateClass = "active";}else if(element.status == "NEW"){stateClass = "info"};
                	
                    $('#tableBody').append('<tr id="'+element.processJobName+'" class="'+stateClass+'">' +
                        '<td>'+element.processJobName+'</td>'+
                        '<td><div class="state">'+element.state+'</div></td></tr>');
                }


                //set stuffs
                var parentDiv = $('#'+element.jobName);
                //parentDiv.find('.progress-bar').html(element.progress +"%");
                //parentDiv.find('.progress-bar').css('width',element.progress+'%').attr("aria-valuenow",element.progress);
                parentDiv.find('.state').html(element.state);
                
                if(element.status == "DONE")
                {
                    parentDiv.removeClass("active info success").addClass("success");
                }
                else if(element.status == "RUNNING")
                {
                    parentDiv.removeClass("active info success").addClass("active");
                }
                else if(element.status == "NEW")
                {
                    parentDiv.removeClass("active info success").addClass("info");
                }
                //end set stuffs
            })
        }
    });
    console.log($('#content').children().length);
    setTimeout(updateProgress,10000);
}