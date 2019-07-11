// start.js
const urlParams = new URLSearchParams(window.location.search);
const user_bds = urlParams.get('bds');
const user_ind = urlParams.get('ind');
const user_chartcode = urlParams.get('chartcode');

// Fire up visit_slider
var values = ["0w", "4w", "8w", "3m", "4m", "6m", "7.5m", "9m", "11m", "14m", "18m", "24m"];
$("#visit_slider").ionRangeSlider({
  values: values
});

// define fallback chartcode
var chartcode = "NJAH";

// updating logic: use derive, unless there are data and unless
// chartcode is directly specified
var selector  = "derive";
if (user_bds || user_ind) selector = "data";
if (user_chartcode) selector = "chartcode";


// if there are data or chartcode arguments specified by user:
// determine chartcode, set chart controls, update visibility, draw chart
if (user_bds || user_ind || user_chartcode) initialize_chart_controls();

// no user arguments: update visibility, draw chart
else update();


// set onchange triggers
var chartgrplist = document.getElementById('chartgrp');
chartgrplist.addEventListener('change', update, false);

var radios = document.forms.agegrp.elements.agegrp;
for(var i = 0, max = radios.length; i < max; i++) {
  radios[i].onclick = function() {
      update();
  };
}

var radios = document.forms.msr.elements.msr;
for(var i = 0, max = radios.length; i < max; i++) {
  radios[i].onclick = function() {
      update();
  };
}

var ga = document.getElementById('ga');
ga.addEventListener('change', update, false);

var radios = document.forms.etnicity.elements.etnicity;
  for(var i = 0, max = radios.length; i < max; i++) {
    radios[i].onclick = function() {
      update();
  };
}

var radios = document.forms.sex.elements.sex;
  for(var i = 0, max = radios.length; i < max; i++) {
    radios[i].onclick = function() {
      update();
  };
}
