"use strict";
var sideMenuOri;

function restoreElement(elementName){
    if(elementName == "layoutSideMenu"){
        $("#layoutSideMenu").html(sideMenuOri.clone());
    }
}

function showElement(eleID){
    document.getElementById(eleID).style.display = "block";
}
function hideElement(eleID){
    document.getElementById(eleID).style.display = "none";
}

function timeToUTC(date) {
    return Date.UTC(
        date.getFullYear()
        , date.getMonth()
        , date.getDate()
        , date.getHours()
        , date.getMinutes()
        , date.getSeconds()
        , date.getMilliseconds()
    );
}
