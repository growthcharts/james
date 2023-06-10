// start.js
const localapp = true;
const urlParams = new URLSearchParams(window.location.search);
const user_txt = urlParams.get('txt');
const user_session =  urlParams.get('session');
const user_chartcode = urlParams.get('chartcode');
const protocol = window.location.protocol;
const hostname = window.location.hostname;
const host = protocol + '//' + hostname;
const pathname = window.location.pathname.slice(0,-5);

// This path is used by javascript calls into OpenCPU
// Use double // to support CORS
if (localapp)
{
  ocpu.seturl("../R");
} else {
  ocpu.seturl('//' + hostname + pathname + '/ocpu/library/james/R');
}

// internal constants
const slider_values = {
  "0_2":  ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m"],
  "0_4":  ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m","36m","45m"],
  "0_19": ["0w","3m","6m","12m","24m","5y","9y","10y","11y","14y","19y"],
  "0_29": ["0w","3m","6m","14m","24m","48m","10y","18y"],
  "matches": ["0", "1", "2", "5", "10", "25", "50", "100"]};

// starting defaults for initialisation per child
var slider_list = "0_2";
var chartcode = "NJAH";
document.getElementById("donordata").value = "0-2";

// Fire up sliders
$("#weekslider").ionRangeSlider({
  type: "single",
  skin: "round",
  grid_snap: true,
  min: 25,
  max: 36,
  from: 36,
  step: 1,
  onFinish: function (data) {
            update();
  }
});
$("#matchslider").ionRangeSlider({
  type: "single",
  skin: "round",
  grid_snap: true,
  from: 0,
  values: slider_values[["matches"]],
  onFinish: function (data) {
            update();
  }
});
$("#visitslider").ionRangeSlider({
  type: "double",
  skin: "round",
  grid_snap: true,
  min_interval: 0,
  drag_interval: true,
  values: slider_values[[slider_list]],
  onFinish: function (data) {
            update();
  }
});
$("#weekslider_dsc").ionRangeSlider({
  type: "single",
  skin: "round",
  grid_snap: true,
  min: 25,
  max: 36,
  from: 36,
  step: 1,
  onFinish: function (data) {
            update();
  }
});

// set active accordion page
var active = "groei";
$('#groei').click(function (){
        if (active != "groei"){
          active = "groei";
          update();
        }
    });

$('#ontwikkeling').click(function (){
        if (active != "ontwikkeling"){
          active = "ontwikkeling";
          update();
        }
    });

// set onchange triggers
var chartgrplist = document.getElementById('chartgrp');
chartgrplist.addEventListener('change', update, false);

var chartgrplist_dsc = document.getElementById('chartgrp_dsc');
chartgrplist_dsc.addEventListener('change', update, false);

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

var radios = document.forms.agegrp_dsc.elements.agegrp_dsc;
for(var i = 0, max = radios.length; i < max; i++) {
  radios[i].onclick = function() {
      update();
  };
}

// if user_session is specified, report any warnings and messages
if (user_session) {
  var warn = host + pathname + '/' + user_session + "/warnings/text";
  var mess = host + pathname + '/' + user_session + "/messages/text";
  $("#session").text(user_session);
  $("#warnings").load(warn);
  $("#messages").load(mess);
}

// updating logic to select charts
// 1. use "derive" based on user interaction
var selector  = "derive";
// 2. use "data" if we can calculate or load child data
if (user_txt || user_session) selector = "data";
// 3. use hard chartcode if user specified one
if (user_chartcode) selector = "chartcode";

// calculate chartcode, set chart controls, update visibility, draw chart
if (user_txt || user_session || user_chartcode) initialize_chart_controls();
// no user arguments: update visibility, draw chart
else update();


function initialize_chart_controls() {
  // function executes at initialization
  // convert_tgt_chartadvice() obtains useful statistics from
  // the uploaded individual data (R) from user_loc and
  // from user_chartcode

  // handle null user inputs
  var utxt = '';
  var uses = '';
  var ucode  = '';
  if (typeof user_txt !== "undefined" && user_txt !== null)  utxt = user_txt;
  if (typeof user_session !== "undefined" && user_session !== null)  uses = user_session;
  if (typeof user_chartcode !== "undefined" && user_chartcode !== null)  ucode = user_chartcode;

  var rq1 = ocpu.call("convert_tgt_chartadvice", {
    txt       : utxt,
    session   : uses,
    chartcode : ucode,
    selector  : selector
  }, function(session) {

    //retrieve the returned object async
    session.getObject(function(output){
        //output is the object returned by the R function

    // alert user to invalid chartcode
    if (!output.chartcode) {
       alert("Unknown chartcode: " + user_chartcode);
       return;
    }

    // set accordion menus according to return vector
    showCards(String(output.accordion));

    // set UI elements according to return vector
    if (String(output.side) === "dsc") {
      document.getElementById("chartgrp_dsc").value = String(output.chartgrp);
    } else {
      document.getElementById("chartgrp").value = String(output.chartgrp);
      document.forms.msr[String(output.side)].checked=true;
    }
    document.forms.agegrp[String(output.agegrp)].checked=true;
    if (String(output.agegrp) !== "1-21y") {document.forms.agegrp_dsc[String(output.agegrp)].checked=true;}

    var week = String(output.week);
    var weeknum = Math.trunc(Number(week));

    // set week slider for both growth and development
    if (week && weeknum >= 25 && weeknum <= 36) {
      $("#weekslider").data("ionRangeSlider").update({
        from: week
      });
      $("#weekslider_dsc").data("ionRangeSlider").update({
        from: week
      });
    }

    // set etnicity
    var pop = String(output.population).toLowerCase();
    switch(pop) {
	      case "nl":
	      case "tu":
	      case "ma":
	      case "hs":
	      case "ds":
	        document.forms.etnicity[pop].checked=true;
	        break;
	      default:
	    }

    //set sex UI element
    document.forms.sex[String(output.sex)].checked=true;

    // Set donordata and visit slider
    var dnr = String(output.dnr);
    document.getElementById("donordata").value = dnr;
    slider_list = String(output.slider_list);
    var values = slider_values[[slider_list]];
    var from = values.indexOf(String(output.period[0]));
    var to   = values.indexOf(String(output.period[1]));
    var slider_instance = $("#visitslider").data("ionRangeSlider");
    slider_instance.update({
      values: values,
      from: from,
      to: to});

    // set UI controls and chart
    update();

    // for all subsequent calls, use derive
    // this allows user to change charts interactively
    selector = "derive";
    });
});
  rq1.fail(function() {
    alert("Server error (rq1, convert_tgt_chartadvice): " + rq1.responseText);
  });
}

function update_donordata() {
  // update slider values and graph if user changes dnr
  var dnr = document.getElementById("donordata").value;
  switch (dnr){
    case "0-2":
      slider_list = "0_2";
      break;
    case "2-4":
      slider_list = "0_4";
      break;
    case "4-18":
      slider_list = "0_29";
      break;
    default:
      slider_list = "0_2";
  }
  var values = slider_values[[slider_list]];
  var slider_instance = $("#visitslider").data("ionRangeSlider");
  slider_instance.update({
      values: values});

  update();
}

function showTextdiv() {
  $("#plotdiv").hide(500);
  $("#textdiv").show(500);
}

function showPlotdiv() {
  $("#plotdiv").show(500);
  $("#textdiv").hide(500);
}

function showCards(show = "all") {
  if (show == "all") {
    sr('ontwikkelingcard', 'block');
    sr('ontwikkelingcard', 'block');
    $('#collapseOne').collapse('show');

  } else if (show == "groei") {
    sr('ontwikkelingcard', 'none');
    $('#collapseOne').collapse('show');

  } else if (show == "ontwikkeling") {
    sr('groeicard', 'none');
    $('#collapseTwo').collapse('show');
    active = "ontwikkeling";
  }
}
