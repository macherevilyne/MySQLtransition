let isAjaxLifeWare = false;

function lifewareDataConversion() {
    if (!isAjaxLifeWare) {
        ajaxRequestLifeWareDataConversion();
    } else {
        alert('Sorry, but now I am fulfilling the request.');
    }
}

function ajaxRequestLifeWareDataConversion() {
    isAjaxLifeWare = true;
    $.ajax({
        type: "POST",
        url: 'lifeware-data-conversion/',
        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
        beforeSend : function (){
            $("#upper-block").css({"display": "block"});
        },
        success: function (response) {
            isAjaxLifeWare = false;
            $("#upper-block").css({"display": "none"});
            alert(response);
            location.reload();
        }
    });
}


function lifeWareRunCheckNew() {
    $.ajax({
        type: "POST",
        url: 'lifeware-run-check-new/',
        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
        beforeSend : function (){
            $("#upper-block").css({"display": "block"});
        },
        success: function (response) {
            $("#upper-block").css({"display": "none"});
            alert(response);
            location.reload();
        }
    });
}


function lifeWareRunTermsheetChecks() {
    $.ajax({
        type: "POST",
        url: 'lifeware-run-termsheet-checks/',
        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
        beforeSend : function (){
            $("#upper-block").css({"display": "block"});
        },
        success: function (response) {
            $("#upper-block").css({"display": "none"});
            alert(response);
            location.reload();
        }
    });
}


$(document).ready(function() {
    $("#lifeware-run-sql").click(function() {
        $("#lifeware-loading-spinner").show();
        $.get("life_ware_execute_sql/<int:sql_id>/", function() {
            $("#lifeware-loading-spinner").hide();
        });
    });
});


$(document).ready(function() {
    $("#lifeware-run-macros").click(function() {
        $("#lifeware-loading-spinner").show();
        $.get("life_ware_execute_macros/<int:macro_id>/", function() {
            $("#lifeware-loading-spinner").hide();
        });
    });
});

