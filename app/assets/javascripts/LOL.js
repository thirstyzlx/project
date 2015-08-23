"use strict";
var sideMenuOri;

function restoreElement(elementName){
    if(elementName == "layoutSideMenu"){
        $("#layoutSideMenu").html(sideMenuOri.clone());
    }
}
