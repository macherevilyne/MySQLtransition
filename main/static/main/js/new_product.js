let isAjaxConversionFileNewProduct = false;

function new_productDataConversion() {
    console.log('Function new_productDataConversion called.'); // Проверка вызова функции
    if (!isAjaxConversionFileNewProduct) {
        console.log('AJAX request will be made.'); // Перед вызовом AJAX-запроса
        ajaxRequestConversionFileNewProductDataConversion();
    } else {
        alert('Sorry, but now I am fulfilling the request.');
        console.log('Request is already in progress.'); // Проверка случая, когда запрос уже выполняется
    }
}

function ajaxRequestConversionFileNewProductDataConversion() {
    isAjaxConversionFileNewProduct = true;
    console.log('AJAX request started.'); // Проверка перед началом запроса
    $.ajax({
        type: "POST",
        url: 'new-product-data-conversion/',
        data: {csrfmiddlewaretoken: '{{ csrf_token }}'},
        beforeSend: function () {
            console.log('Before send AJAX.'); // Проверка перед отправкой запроса
            $("#upper-block").css({"display": "block"});
        },
        success: function (response) {
            console.log('AJAX request successful:', response); // Проверка успешного выполнения запроса
            isAjaxConversionFileNewProduct = false;
            $("#upper-block").css({"display": "none"});
            alert(response);
            location.reload();
        },
        error: function (xhr, status, error) {
            console.log('AJAX request failed:', error); // Проверка в случае ошибки запроса
            isAjaxConversionFileNewProduct = false;
        }
    });
}
