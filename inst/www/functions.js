// functions.js
// Helpers for the JAMES system
// Author: Stef van Buuren, 2019
// Netherlands Organisation for Applied Scientific Research TNO, Leiden

function update() {
  var c = document.getElementById('chartgrp');
  var chartgrp = c.options[c.selectedIndex].value;
  var agegrp = document.querySelector('input[name="agegrp"]:checked').value;
  var population = document.querySelector('input[name="etnicity"]:checked').value;
  var g = document.getElementById('ga');
  var ga = g.options[g.selectedIndex].value;
  var sex = document.querySelector('input[name="sex"]:checked').value;
  var msr = document.querySelector('input[name="msr"]:checked').value;
  var childname = document.getElementById('childname').textContent;
  var chartcode = "";

  if (chartgrp == 'nl2010') {
    document.getElementById('agegrp_1-21y').style.display = 'block';
    document.getElementById('weekmenu').style.display = 'none';
    document.getElementById('etnicity').style.display = 'block';
  }
  if (chartgrp == 'preterm') {
    document.getElementById('agegrp_1-21y').style.display = 'none';
    document.getElementById('weekmenu').style.display = 'block';
    document.getElementById('etnicity').style.display = 'none';
  }
  if (chartgrp == 'who') {
    document.getElementById('agegrp_1-21y').style.display = 'none';
    document.getElementById('weekmenu').style.display = 'none';
    document.getElementById('etnicity').style.display = 'none';
  }
  if (agegrp == '0-15m' & chartgrp == 'nl2010') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'block';
    document.getElementById('msr_wfh').style.display = 'none';
    document.getElementById('msr_hdc').style.display = 'block';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'block';
  }
  if (agegrp == '0-15m' & chartgrp == 'preterm') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'block';
    document.getElementById('msr_wfh').style.display = 'none';
    document.getElementById('msr_hdc').style.display = 'block';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'none';
  }
  if (agegrp == '0-15m' & chartgrp == 'who') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'block';
    document.getElementById('msr_wfh').style.display = 'none';
    document.getElementById('msr_hdc').style.display = 'block';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'none';
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population == 'nl') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'block';
    document.getElementById('msr_wfh').style.display = 'block';
    document.getElementById('msr_hdc').style.display = 'block';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'block';
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population != 'nl') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'none';
    document.getElementById('msr_wfh').style.display = 'block';
    document.getElementById('msr_hdc').style.display = 'block';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'block';
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population == 'hs') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'none';
    document.getElementById('msr_wfh').style.display = 'block';
    document.getElementById('msr_hdc').style.display = 'none';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'block';
  }
  if (agegrp == '0-4y' & chartgrp == 'preterm') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'block';
    document.getElementById('msr_wfh').style.display = 'none';
    document.getElementById('msr_hdc').style.display = 'none';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'none';
  }
  if (agegrp == '0-4y' & chartgrp == 'who') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'block';
    document.getElementById('msr_wfh').style.display = 'none';
    document.getElementById('msr_hdc').style.display = 'none';
    document.getElementById('msr_bmi').style.display = 'none';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'none';
  }
  if (agegrp == '1-21y' & population != 'hs') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'none';
    document.getElementById('msr_wfh').style.display = 'block';
    document.getElementById('msr_hdc').style.display = 'block';
    document.getElementById('msr_bmi').style.display = 'block';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'block';
  }
  if (agegrp == '1-21y' & population == 'hs') {
    document.getElementById('msr_hgt').style.display = 'block';
    document.getElementById('msr_wgt').style.display = 'none';
    document.getElementById('msr_wfh').style.display = 'block';
    document.getElementById('msr_hdc').style.display = 'none';
    document.getElementById('msr_bmi').style.display = 'block';
    document.getElementById('msr_front').style.display = 'block';
    document.getElementById('msr_back').style.display = 'none';
  }

  // call james::select_chart
  var rq1 = ocpu.rpc("select_chart", {
    chartgrp : chartgrp,
    agegrp   : agegrp,
    sex      : sex,
    etn      : population,
    ga       : ga,
    side     : msr
  }, function(output) {
    // overwrite on success
    chartcode = output.chartcode;
    document.getElementById('code').innerHTML = chartcode;

    // trigger chart drawing
    var cm = document.getElementById("interpolation").checked;
    var rq2 = $("#plotdiv").rplot("draw_chart_ind", {
      location : url_data,
      chartcode : chartcode,
      curve_interpolation : cm,
      quiet : false
    });

    rq2.fail(function(){
      alert("Server error: " + rq2.responseText);
    });
  });

  rq1.fail(function() {
    alert("R server error: " + rq1.responseText);
  });
}
