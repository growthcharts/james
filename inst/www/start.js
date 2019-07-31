// start.js

// user arguments
const urlParams = new URLSearchParams(window.location.search);
const user_bds = urlParams.get('bds');
const user_ind = urlParams.get('ind');
const user_chartcode = urlParams.get('chartcode');

// internal constants
const slider_values = {"0_2":  ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m"], "0_4":  ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m","36m","45m"], "0_19": ["0w","3m","6m","12m","24m","5y","9y","10y","11y","14y","19y"], "0_29": ["0w","4w","8w","3m","4m","6m","7.5m","9m","11m","14m","18m","24m","48m","6y","10y","18y","29y"],
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
  values: slider_values[["matches"]],
  onFinish: function (data) {
            update();
  }
});
$("#visitslider").ionRangeSlider({
  type: "double",
  skin: "round",
  grid_snap: true,
  min_interval: 1,
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
  // convert_ind_chartcodelist: load individual data (R),
  // calculate chartcode (R) and decompose chartcode (R)
  var rq1 = ocpu.rpc("convert_ind_chartcodelist", {
    ind_loc: user_ind,
    chartcode: user_chartcode,
    selector: selector
  }, function(output) {

    // alert user to invalid chartcode
    if (!output.chartcode) {
       alert("Unknown chartcode: " + user_chartcode);
       return;
    }

    // set chartgrp UI element
    var grp;
    var pop = String(output.population).toLowerCase();
    switch(pop) {
      case "nl":
      case "tu":
      case "ma":
      case "hs":
        grp = "nl2010";
        break;
      case "pt":
        grp = "preterm";
        break;
      case "whoblue":
      case "whopink":
        grp = "who";
        break;
      default:
        grp = "";
    }
    document.getElementById("chartgrp").value = grp;

    // set agegrp UI
    var agegrp;
    var design = String(output.design);
    switch(design) {
      case "A": agegrp = "0-15m"; break;
      case "B": case "E": agegrp = "0-4y"; break;
      case "C": agegrp = "1-21y"; break;
      case "D": agegrp = "0-21y"; break;
      default: agegrp = "";
    }
    document.forms.agegrp[agegrp].checked=true;

    // set msr UI
    var side = String(output.side);
    if (side === "-hdc") side = "back";
    document.forms.msr[side].checked=true;

    // set week slider
    var week = String(output.week);
    var weeknum = Math.trunc(Number(week));
    if (week && weeknum >= 25 && weeknum <= 36)
      $("#weekslider").data("ionRangeSlider").update({
        from: week
      });

    // set etnicity
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

    var dnr;
    // Determine dnr and slider_list depending on chartcode
    if (selector == "chartcode") {
      switch(grp) {
        case "nl2010":
        case "who":
        case "":
          switch(agegrp) {
            case "0-15m":
              dnr = "smocc";
              slider_list = "0_2";
              break;
            case "0-4y":
              dnr = "lollypop.term";
              slider_list = "0_4";
              break;
            case "1-21y":
            case "0-21y":
              dnr = "terneuzen";
              slider_list = "0_29";
              break;
            default:
              dnr = "smocc";
              slider_list = "0_2";
              break;
          }
          break;
        case "preterm":
          switch(agegrp) {
            case "0-15m":
            case "0-4y":
              dnr = "lollypop.preterm";
              slider_list = "0_4";
              break;
            case "1-21y":
            case "0-21y":
              dnr = "terneuzen";
              slider_list = "0_29";
              break;
            default:
              dnr = "lollypop.preterm";
              slider_list = "0_4";
              break;
          }
          break;
        default:
          dnr = "smocc";
          slider_list = "0_2";
      }
    }  /* end dnr/slider given chartcode */

    // Determine dnr and slider_list depending on age range
    if (selector == "data") {
      var agerange = output.agerange;
      alert ("agerange" + agerange);
    }

    // Set donordata entry
    document.getElementById("donordata").value = dnr;

    // Set visit slider
    $("#visitslider").ionRangeSlider({values: slider_values[[slider_list]]});

    // set UI controls and chart
    update();

    // for all subsequent calls, use derive
    selector = "derive";
});
  rq1.fail(function() {
    alert("Server error: " + rq1.responseText);
  });
}
