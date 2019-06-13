// update.js
// Author: Stef van Buuren, 2019
// Netherlands Organisation for Applied Scientific Research TNO, Leiden

function update() {
  var chartgrp = document.getElementById("chartgrp").value;
  var agegrp = document.querySelector('input[name="agegrp"]:checked').value;
  var population = document.querySelector('input[name="etnicity"]:checked').value;
  var ga = document.getElementById("ga").value;
  var sex = document.querySelector('input[name="sex"]:checked').value;
  var msr = document.querySelector('input[name="msr"]:checked').value;
  var cm = document.getElementById("interpolation").checked;

  if (chartgrp == 'nl2010') {
    sr('agegrp_1-21y', 'block');
    sr('weekmenu', 'none');
    sr('etnicity', 'block');
  }
  if (chartgrp == 'preterm') {
    sr('agegrp_1-21y', 'none');
    sr('weekmenu', 'block');
    sr('etnicity', 'none');
  }
  if (chartgrp == 'who') {
    sr('agegrp_1-21y', 'none');
    sr('weekmenu', 'none');
    sr('etnicity', 'none');
  }
  if (agegrp == '0-15m' & chartgrp == 'nl2010') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-15m' & chartgrp == 'preterm') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-15m' & chartgrp == 'who') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population == 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population != 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population == 'hs') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-4y' & chartgrp == 'preterm') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-4y' & chartgrp == 'who') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '1-21y' & population != 'hs') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'block');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '1-21y' & population == 'hs') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'block');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }

  // trigger chart drawing
  var rq2 = $("#plotdiv").rplot("draw_chart", {
      bds_data : null,
      ind_loc : user_ind,
      selector : selector,
      chartcode: chartcode,
      chartgrp : chartgrp,
      agegrp   : agegrp,
      sex      : sex,
      etn      : population,
      ga       : ga,
      side     : msr,
      curve_interpolation : cm,
      quiet : false
    });
  rq2.fail(function() {
    alert("Server error: " + rq2.responseText);
  });
}

function initialize_chart_controls() {
  // function executes at initialization, if there are child data
  // convert_ind_chartcodelist: load individual data (R),
  // calculate chartcode (R) and decompose chartcode (R)
  var ind_loc = user_ind;

  var rq1 = ocpu.rpc("convert_ind_chartcodelist", {
    ind_loc: ind_loc,
    chartcode: user_chartcode
  }, function(output) {

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
    switch(String(output.design)) {
      case "A": grp = "0-15m"; break;
      case "B": case "E": grp = "0-4y"; break;
      case "C": grp = "1-21y"; break;
      case "D": grp = "0-21y"; break;
      default: grp = "";
    }
    document.forms.agegrp[grp].checked=true;

    // set msr UI
    var side = String(output.side);
    if (side === "-hdc") side = "back";
    document.forms.msr[side].checked=true;

    // set weekmenu UI
    var week = String(output.week);
    var weeknum = Math.trunc(Number(week));
    if (week && weeknum >= 25 && weeknum <= 36)
      document.getElementById("ga").value = week;

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

    // set UI controls and chart
    update();

    // for all subsequent calls, use derive
    selector = "derive";
});
}

function sr(id, display) {
  // set UI element display
  document.getElementById(id).style.display = display;
}
