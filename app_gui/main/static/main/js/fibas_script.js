// Выполняется ли запрос
let isAjaxFibas = false;

function fibasDataConversion() {
    if (!isAjaxFibas) {
        ajaxRequestFibasDataConversion();
    } else {
        alert('Sorry, but now I am fulfilling the request.');
    }
}

function ajaxRequestFibasDataConversion() {
    isAjaxFibas = true;
    $.ajax({
        type: "POST",
        url: 'fibas-data-conversion/',
        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
        beforeSend : function (){
            $("#upper-block").css({"display": "block"});
        },
        success: function (response) {
            isAjaxFibas = false;
            $("#upper-block").css({"display": "none"});
            alert(response);
            location.reload();
        }
    });
}

function fibasRunDBChecks() {
    $.ajax({
        type: "POST",
        url: 'fibas-run-db-checks/',
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

function fibasRunMMonetinputs() {
    $.ajax({
        type: "POST",
        url: 'fibas-run-monetinputs/',
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

function fibasRunCheck() {
    $.ajax({
        type: "POST",
        url: 'fibas-run-check/',
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

function fibasRunAllMacros() {
    $.ajax({
        type: "POST",
        url: 'fibas-run-all-macros/',
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

function fibasConvertMonetResultsAll() {
    $.ajax({
        type: "POST",
        url: 'fibas-convert-monet-results-all/',
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
    $("#fibas-run-sql").click(function() {
        $("#fibas-loading-spinner").show();
        $.get("fibas_execute_sql/<int:sql_id>/", function() {
            $("#fibas-loading-spinner").hide();
        });
    });
});


$(document).ready(function() {
    $("#fibas-run-macros").click(function() {
        $("#fibas-loading-spinner").show();
        $.get("fibas_execute_macros/<int:macro_id>/", function() {
            $("#fibas-loading-spinner").hide();
        });
    });
});

$(document).ready(function() {
    $(".fibas-download").click(function() {
        $("#fibas-loading-spinner").show();
    });
});
