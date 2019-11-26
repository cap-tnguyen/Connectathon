function setActive(src)
	{	
    console.log('in setactive');
    console.log(src);

    $(src).removeClass("active");
    $(src).addClass("active");
    console.log(src);
    /*
		$("a").removeClass("active");
		  // add class to the one we clicked
    console.log(src);

    $("div").removeClass("active");
    console.log(src);
    //$("button").removeClass("active");
        // add class to the one we clicked
    $(src).addClass("active");
    console.log(src);
    */
    }

function CAPLogout() {
    console.log('signing out of CAP');

    window.location.href = 'authorize.aspx';
}


function getUrlVars() {
    var vars = {};
   
    var parts = window.location.href.toLowerCase().replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
        vars[key] = value;
    });
    return vars;
}

function getUrlParam(parameter, defaultvalue) {
    
    parameter = parameter.toLowerCase();
   
    var urlparameter = defaultvalue;
    if (window.location.href.toLowerCase().indexOf(parameter) > -1) {
        urlparameter = getUrlVars()[parameter];
    }
    return urlparameter;
}

function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) { return pair[1]; }
    }
    return (false);
}