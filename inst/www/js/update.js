// update.js
// Author: Stef van Buuren, 2019-2023
// Netherlands Organisation for Applied Scientific Research TNO, Leiden

function update() {

  // grab active variables
  if (active == "groei"){
    var msr = document.querySelector('input[name="msr"]:checked').value;
    var chartgrp = document.getElementById("chartgrp").value;
    var agegrp = document.querySelector('input[name="agegrp"]:checked').value;
    var population = document.querySelector('input[name="etnicity"]:checked').value;
    var ga = Number($("#weekslider").data().from);
    document.getElementById("interpolation_dsc").checked = document.getElementById("interpolation").checked;
  } else if (active == "ontwikkeling"){
    var msr = "dsc";
    var chartgrp = document.getElementById("chartgrp_dsc").value;
    var agegrp = document.querySelector('input[name="agegrp_dsc"]:checked').value;
    var population = "nl";
    var ga = Number($("#weekslider_dsc").data().from);
    document.getElementById("interpolation").checked = document.getElementById("interpolation_dsc").checked;
  }

  var sex = document.querySelector('input[name="sex"]:checked').value;
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

  // set active UI elements
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
  if (chartgrp == 'gsed1') {
    ga = 40;
    sr('weekmenu_dsc', 'none');
  }
  if (chartgrp == 'gsed1pt') {
    sr('weekmenu_dsc', 'block');
  }

  if (agegrp == '0-15m' & chartgrp == 'nl2010' & population == 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-15m' & chartgrp == 'nl2010' & population != 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-15m' & chartgrp == 'preterm' & population == 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-15m' & chartgrp == 'preterm' & population != 'nl') {
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

  // handle null user inputs
  var utxt = '';
  var uses = '';
  var ucode  = '';
  if (typeof user_txt !== "undefined" && user_txt !== null)  utxt = user_txt;
  if (typeof user_session !== "undefined" && user_session !== null)  uses = user_session;
  if (typeof user_chartcode !== "undefined" && user_chartcode !== null)  ucode = user_chartcode;

  // trigger chart drawing
  var rq2 = $("#plotdiv").rplot("draw_chart", {
      txt      : utxt,
      session  : uses,
      chartcode: ucode,
      selector : selector,
      chartgrp : chartgrp,
      agegrp   : agegrp,
      sex      : sex,
      etn      : population,
      ga       : ga,
      side     : msr,
      curve_interpolation : cm,
      quiet    : false,
      dnr      : dnr,
      lo       : lo_str,
      hi       : hi_str,
      nmatch   : nmatch,
      exact_sex: exact_sex,
      exact_ga : exact_ga,
      show_future : show_future,
      show_realized : show_realized
    }, function(session) {
      var rq2_key = session;

    //read the session properties
    $("#session").text(session.getKey());

    //retrieve session warnings async
    session.getWarnings(function(outtxt){
        $("#warnings").text(outtxt);
    });
    //retrieve session warnings async
    session.getMessages(function(outtxt){
        $("#messages").text(outtxt);
    });
    //retrieve the returned object async
    session.getObject(function(data){
        //data is the object returned by the R function
        alert("Array of length " + data.length + ".\nFirst few values:" + data.slice(0,3));
    });
  })

  rq2.fail(function() {
    alert("Server error rq2 - cannot read data for plotting\n" +
          "txt: " + utxt + "\n" +
          "session: " + uses + "\n" +
          "chartcode: " + ucode + "\n" +
          "selector: " + selector + "\n" +
          "error: " + rq2.responseText);
    console.log("rq2 txt: " + utxt);
    console.log("rq2 session: " + uses);
    console.log("rq2 chartcode: " + ucode);
    console.log("rq2 selector: " + selector);
    console.log("rq2 error: " + rq2.responseText);
  });

function sr(id, display) {
  // set UI element display
  document.getElementById(id).style.display = display;
}
