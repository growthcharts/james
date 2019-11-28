// start.js

// user arguments
const urlParams = new URLSearchParams(window.location.search);
const user_bds = urlParams.get('bds');
const user_ind = urlParams.get('ind');
const user_chartcode = urlParams.get('chartcode');

// internal constants
const slider_values = {"0_2":  ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m"], "0_4":  ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m","36m","45m"], "0_19": ["0w","3m","6m","12m","24m","5y","9y","10y","11y","14y","19y"], "0_29": ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m","48m","6y","10y","18y"],
  "matches": ["0", "1", "2", "5", "10", "25", "50", "100"]};

// starting defaults
var slider_list = "0_2";
var chartcode = "NJAH";

// Set donordata entry
document.getElementById("donordata").value = "smocc";

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



function initialize_chart_controls() {
  // function executes at initialization, if there are child data
  // convert_ind_chartadvice() obtains useful statistics from
  // the uploaded individual data (R) from user_ind and
  // from user_chartcode
  var rq1 = ocpu.call("convert_ind_chartadvice", {
    ind_loc: user_ind,
    chartcode: user_chartcode,
    selector: selector
  }, function(session) {

    // return the session key (just for fun)
    $("#key").text(session.getKey());
    alert("Key: " + $("#key"));

    //retrieve the returned object async
    session.getObject(function(output){
        //output is the object returned by the R function

    // alert user to invalid chartcode
    if (!output.chartcode) {
       alert("Unknown chartcode: " + user_chartcode);
       return;
    }

    // set UI elements according to return vector
    document.getElementById("chartgrp").value = String(output.chartgrp);
    document.forms.agegrp[String(output.agegrp)].checked=true;
    document.forms.msr[String(output.side)].checked=true;

    // set week slider
    var week = String(output.week);
    var weeknum = Math.trunc(Number(week));
    if (week && weeknum >= 25 && weeknum <= 36)
      $("#weekslider").data("ionRangeSlider").update({
        from: week
      });

    // set etnicity
    var pop = String(output.population).toLowerCase();
    switch(pop) {
	      case "nl":
	      case "tu":
	      case "ma":
	      case "hs":
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

    // set exact-ga default for preterms
    if (dnr == "lollypop.preterm") document.getElementById("exact_ga").checked = true;

    // set UI controls and chart
    update();

    // for all subsequent calls, use derive
    selector = "derive";
    });
});
  rq1.fail(function() {
    alert("Server error: " + rq1.responseText);
  });
}

function update_donordata() {
  // update slider values and graph if user changes dnr
  var dnr = document.getElementById("donordata").value;
  switch (dnr){
    case "smocc":
      slider_list = "0_2";
      break;
    case "lollypop.preterm":
    case "lollypop.term":
      slider_list = "0_4";
      break;
    case "terneuzen":
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
