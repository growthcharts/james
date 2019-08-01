// update.js
// Author: Stef van Buuren, 2019
// Netherlands Organisation for Applied Scientific Research TNO, Leiden

function update() {
  var chartgrp = document.getElementById("chartgrp").value;
  var agegrp = document.querySelector('input[name="agegrp"]:checked').value;
  var population = document.querySelector('input[name="etnicity"]:checked').value;
  var ga = Number($("#weekslider").data().from);
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
  var nmatch = slider_values[["matches"]][match];

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


function sr(id, display) {
  // set UI element display
  document.getElementById(id).style.display = display;
}
