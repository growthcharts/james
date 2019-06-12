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
  alert("chartgrp: " + chartgrp);

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
    document.getElementById('chartcode').innerHTML = chartcode;

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
  // or if a chartcode is requested
  // actions:
  // load individual data R: user_ind --> location
  // calculate chartcode R: select_chart()
  // decompose chartcode R: parse_chartcode(), return parsed list
  if (user_ind) alert("user_ind: " + user_ind);
  if (user_chartcode) alert("chartcode: " + user_chartcode);

  var rq1 = ocpu.rpc("convert_ind_chartcodelist", {
    location: user_ind,
    chartcode: user_chartcode
  }, function(output) {
    // set chartgrp menu value
    var oldchartgrp = document.getElementById('chartgrp').value;
    // var chartgrp = c.options[c.selectedIndex].value;
    alert("old chartgrp: " + oldchartgrp);
    var pop = String(output.population);
    var text;
    alert("population: " + output.population + "  " + pop);
    switch(pop) {
      case "NL":
      case "TU":
      case "MA":
      case "HS":
        text = "nl2010";
        break;
      case "PT":
        text = "preterm";
        break;
      case "WHOblue":
      case "WHOpink":
        text = "who";
        break;
      default:
        text = "";
    }
    document.getElementById("chartgrp").value = text;
    var newchartgrp = document.getElementById('chartgrp').value;
    // var chartgrp = c.options[c.selectedIndex].value;
    alert("text: " + text + "    new chartgrp: " + newchartgrp);

    // set chartcode UI
    if (output.chartcode) alert("output.chartcode: " + output.chartcode);
    document.getElementById('chartcode').innerHTML = output.chartcode;

    // set agegrp UI
    alert("output.design: " + output.design);
    switch(output.design) {
      case "A": document.forms.agegrp["0-15m"].checked=true;
      break;
      case "B":
      case "E": document.forms.agegrp["0-4y"].checked=true;
      break;
      case "C": document.forms.agegrp["1-21y"].checked=true;
      break;
      case "D": document.forms.agegrp["0-21y"].checked=true;
      break;
    }

    // set msr UI
    alert("output.side: " + output.side);
    switch(output.side) {
      case "hgt":
      case "wgt":
      case "hdc":
      case "bmi":
      case "wfh":
      case "front":
      case "back":
        document.forms.msr[output.side].checked=true;
        break;
      case "-hdc":
        document.forms.msr.back.checked=true;
    }

    // set weekmenu UI
    var weeknum = Math.trunc(Number(output.week));
    if (output.week && weeknum >= 25 && weeknum <= 36)
    document.getElementById("weekmenu").value = output.week;

    // set etnicity
    switch(output.population) {
      case "NL":
      case "TU":
      case "MA":
      case "HS":
        document.getElementById("etnicity").value = output.population.toLowerCase();
    }

    //set sex UI element
    alert("output.sex: " + output.sex);
    switch(output.sex) {
      case "male":
      case "female":
        document.getElementById("sex").value = output.sex;
    }
    update();
});
}
