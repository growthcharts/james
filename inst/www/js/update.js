// update.js
// Author: Stef van Buuren, 2019-2023
// Netherlands Organisation for Applied Scientific Research TNO, Leiden

function update() {
  // Use let for variables that may change within the function
  let msr, chartgrp, agegrp, population, ga;

  if (active === "groei") {
    msr = document.querySelector('input[name="msr"]:checked').value;
    chartgrp = document.getElementById("chartgrp").value;
    agegrp = document.querySelector('input[name="agegrp"]:checked').value;
    population = document.querySelector('input[name="etnicity"]:checked').value;
    ga = Number($("#weekslider").data().from);
    // Synchronize interpolation checkboxes
    document.getElementById("interpolation_dsc").checked = document.getElementById("interpolation").checked;
  } else if (active === "ontwikkeling") {
    msr = "dsc";
    chartgrp = document.getElementById("chartgrp_dsc").value;
    agegrp = document.querySelector('input[name="agegrp_dsc"]:checked').value;
    population = "nl"; // Assume default population
    ga = Number($("#weekslider_dsc").data().from);
    document.getElementById("interpolation").checked = document.getElementById("interpolation_dsc").checked;
  }

  const sex = document.querySelector('input[name="sex"]:checked').value;
  const cm = document.getElementById("interpolation").checked;
  const dnr = document.getElementById("donordata").value;
  const lo = $("#visitslider").data().from;
  const hi = $("#visitslider").data().to;
  const match = Number($("#matchslider").data().from);
  const exact_sex = document.getElementById("exact_sex").checked;
  const exact_ga = document.getElementById("exact_ga").checked;
  const show_future = document.getElementById("show_future").checked;
  const show_realized = document.getElementById("show_realized").checked;

  // Simplify retrieval of string values
  const hiStr = sliderValues[sliderList][hi];
  const loStr = sliderValues[sliderList][lo];
  const nmatch = sliderValues.matches[match];

  // Show/hide elements based on `chartgrp` and `agegrp` and `population`
  handleUIVisibility(chartgrp, agegrp, population);

  // Trigger chart drawing, simplified error handling
  drawChart({
    txt: userText,
    session: userSession,
    chartcode: userChartcode,
    selector,
    chartgrp,
    agegrp,
    sex,
    etn: population,
    ga,
    side: msr,
    curve_interpolation: cm,
    quiet: false,
    dnr,
    lo: loStr,
    hi: hiStr,
    nmatch,
    exact_sex,
    exact_ga,
    show_future,
    show_realized
  });
}

function drawChart(params) {
  const rq = $("#plotDiv").rplot("draw_chart", params, session => {
    updateNoticePanel(2, session);
  }).fail(session => {
    console.error("Server error rq2 - cannot read data for plotting", {
      txt: params.txt,
      session: params.session,
      chartcode: params.chartcode,
      selector: params.selector,
      error: rq.responseText // This might need adjustment based on how rq is scoped
    });
    // Logging or user notification
  });
}
