// update.js
// Author: Stef van Buuren
// (c) 2024 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL

// Tracks which rendering engine last drew into #plotDiv, so switching
// engines can tear down the other engine's DOM/state first.
let currentEngine = "fixed";

function ensureEngineDiv(newEngine) {
  if (newEngine !== currentEngine) {
    clearPlotDiv(); // from embed.js; safe no-op if nothing to clean up
    currentEngine = newEngine;
  }
}

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
  const hiStr = sliderValues["0-18"][hi];
  const loStr = sliderValues["0-18"][lo];
  const nmatch = sliderValues.matches[match];

  // Show/hide elements based on `chartgrp` and `agegrp` and `population`
  handleUIVisibility(chartgrp, agegrp, population);
  handleEngineVisibility(active, msr);

  // Read the rendering engine from whichever card is active, same pattern
  // as chartgrp/chartgrp_dsc.
  const engineGroupName = (active === "ontwikkeling") ? "engine_dsc" : "engine";
  const engine = document.querySelector(`input[name="${engineGroupName}"]:checked`).value;

  const chartParams = {
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
  };

  ensureEngineDiv(engine);

  // Trigger chart drawing, simplified error handling
  if (engine === "interactive") {
    // embed_chart() has no server-side inference for these (unlike
    // draw_chart()/process_chart(), which infers from nmatch/dnr/period) --
    // derive them explicitly here to match grid-mode behavior.
    const embedParams = Object.assign({}, chartParams, {
      show_matches: nmatch > 0,
      show_prediction: show_future
    });
    drawEmbedChart(embedParams, session => updateNoticePanel(2, session));
  } else {
    drawChart(chartParams);
  }
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
  });

  console.log("rplot() return value:", rq);

  rq.fail((jqxhr, textStatus, errorThrown) => {
    console.error("Server error rq2 – unable to draw chart", {
      txt: params.txt,
      session: params.session,
      chartcode: params.chartcode,
      selector: params.selector,
      error: jqxhr.responseText || errorThrown || textStatus
    });
  });
}

// Set throttleUpdate to 3 seconds
const throttledUpdate = throttle(update, 3000);
