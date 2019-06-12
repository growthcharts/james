// update.js
// Update the JAMES system
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
    var chartcode = output.chartcode;
    document.getElementById('chartcode').innerHTML = String(chartcode);

    // trigger chart drawing
    var cm = document.getElementById("interpolation").checked;
    var rq2 = $("#plotdiv").rplot("draw_chart_ind", {
      location : user_ind,
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

function initialize_chart_controls() {
  // function executes at initialization, if there are child data
  // convert_ind_chartcodelist: load individual data (R),
  // calculate chartcode (R) and decompose chartcode (R)

  var rq1 = ocpu.rpc("convert_ind_chartcodelist", {
    location: user_ind,
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

    // set chartcode UI
    document.getElementById('chartcode').innerHTML = String(output.chartcode);

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

    update();
});
}
