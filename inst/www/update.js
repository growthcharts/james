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
  var dnr = document.getElementById("donordata").value;
  var lo = $("#visitslider").data().from;
  var hi = $("#visitslider").data().to;
  var match = Number($("#matchslider").data().from);
  var exact_sex = document.getElementById("exact_sex").checked;
  var exact_ga = document.getElementById("exact_ga").checked;
  var show_future = document.getElementById("show_future").checked;
  var show_realized = document.getElementById("show_realized").checked;

  var hi_str = slider_values[[slider_list]][hi];
  var lo_str = slider_values[[slider_list]][lo];
  var nmatch = String(slider_values[["matches"]][match]);

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
      chartcode: user_chartcode,
      chartgrp : chartgrp,
      agegrp   : agegrp,
      sex      : sex,
      etn      : population,
      ga       : ga,
      side     : msr,
      curve_interpolation : cm,
      quiet : false,
      dnr      : dnr,
      lo       : lo_str,
      hi       : hi_str,
      nmatch   : nmatch,
      exact_sex: exact_sex,
      exact_ga : exact_ga,
      show_future : show_future,
      show_realized : show_realized
    });
  rq2.fail(function() {
    alert("Server error: " + rq2.responseText);
  });
}

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

    // Determine donor data
    var dnr;
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

function sr(id, display) {
  // set UI element display
  document.getElementById(id).style.display = display;
}
