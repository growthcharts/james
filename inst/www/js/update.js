// update.js
// Author: Stef van Buuren
// (c) 2024 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL

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
    ga = (chartgrp === 'gsed1') ? 40 : Number($("#weekslider_dsc").data().from);
    document.getElementById("interpolation").checked = document.getElementById("interpolation_dsc").checked;
  }

  const sex = document.querySelector('input[name="sex"]:checked').value;
  const cm = document.getElementById("interpolation").checked;
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
    selector: selector,
    chartgrp: chartgrp,
    agegrp: agegrp,
    sex: sex,
    etn: population,
    ga: ga,
    side: msr,
    curve_interpolation: cm,
    quiet: false,
    dnr: null,
    lo: loStr,
    hi: hiStr,
    nmatch: nmatch,
    exact_sex: exact_sex,
    exact_ga: exact_ga,
    show_future: show_future,
    show_realized: show_realized
  });
}

/**
 * Creates a throttled version of a function that only invokes the original
 * function at most once per every wait milliseconds.
 *
 * @param {Function} func The function to throttle.
 * @param {number} wait The number of milliseconds to throttle invocations to.
 * @return {Function} A throttled version of the function.
 */
function throttle(func, wait) {
  let isThrottling = false;
  let lastArgs;
  let lastThis;

  const invokeFunc = () => {
    isThrottling = true;
    setTimeout(() => {
      isThrottling = false;
      if (lastArgs) {
        invokeFunc.apply(lastThis, lastArgs);
        lastArgs = lastThis = null;
      }
    }, wait);

    func.apply(lastThis, lastArgs);
  };

  return function() {
    if (!isThrottling) {
      invokeFunc.apply(this, arguments);
    } else {
      lastArgs = arguments;
      lastThis = this;
    }
  };
}

function drawChart(params) {
  const rq = $("#plotDiv").rplot("draw_chart", params, session => {
    updateNoticePanel(2, session);
  }).fail(session => {
    console.error("Server error rq2 – unable to draw chart", {
      txt: params.txt,
      session: params.session,
      chartcode: params.chartcode,
      selector: params.selector,
      error: rq.responseText // This might need adjustment based on how rq is scoped
    });
    // Logging or user notification
  });
}

// Set throttleUpdate to 3 seconds
const throttledUpdate = throttle(update, 3000);
