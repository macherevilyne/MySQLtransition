let isAjaxTerm = false;

function termDataConversion() {
    if (!isAjaxTerm) {
        ajaxRequestTermDataConversion();
    } else {
        alert('Sorry, but now I am fulfilling the request.');
    }
}

function ajaxRequestTermDataConversion() {
    isAjaxTerm = true;
    $.ajax({
        type: "POST",
        url: 'term-data-conversion/',
        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
        beforeSend : function (){
            $("#upper-block").css({"display": "block"});
        },
        success: function (response) {
            isAjaxTerm = false;
            $("#upper-block").css({"display": "none"});
            alert(response);
            location.reload();
        }
    });
}


function termGenerateMonetInputs() {
    $.ajax({
        type: "POST",
        url: 'generate-monet-inputs/',
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


//function termGenerateMonetInputsTerm() {
//    $.ajax({
//        type: "POST",
//        url: 'term-generate-monet-inputs-term/',
//        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
//        beforeSend : function (){
//            $("#upper-block").css({"display": "block"});
//        },
//        success: function (response) {
//            $("#upper-block").css({"display": "none"});
//            alert(response);
//            location.reload();
//        }
//    });
//}

//
//function termGenerateMonetInputsExpPL() {
//    $.ajax({
//        type: "POST",
//        url: 'generate-monet-inputs/',
//        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
//        beforeSend : function (){
//            $("#upper-block").css({"display": "block"});
//        },
//        success: function (response) {
//            $("#upper-block").css({"display": "none"});
//            alert(response);
//            location.reload();
//        }
//    });
//}


function termDbCheckData() {
        $.ajax({
        type: "POST",
        url: 'term-db-check-data/',
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


function termRunCheck() {
        $.ajax({
        type: "POST",
        url: 'term-run-check/',
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
    $("#term-run-sql").click(function() {
        $("#term-loading-spinner").show();
        $.get("term_execute_sql/<int:sql_id>/", function() {
            $("#term-loading-spinner").hide();
        });
    });
});


$(document).ready(function() {
    $("#term-run-macros").click(function() {
        $("#term-loading-spinner").show();
        $.get("term_execute_macros/<int:macro_id>/", function() {
            $("#term-loading-spinner").hide();
        });
    });
});
