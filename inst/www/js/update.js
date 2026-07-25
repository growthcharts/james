// update.js
// Author: Stef van Buuren
// (c) 2024 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL

// Tracks which rendering engine last drew into #plotDiv. On a genuine
// engine switch, the OLD engine's DOM/state is torn down only once the NEW
// engine's first frame is actually ready (see clearEmbedWrapper()/
// clearOcpuplotState() in embed.js, called from drawChart() below and from
// injectWidget()'s iframe load handler) -- clearing #plotDiv eagerly here,
// before the new content exists, left a visible blank gap for the whole
// request/render round-trip on every fixed<->interactive switch.
let currentEngine = "fixed";

function ensureEngineDiv(newEngine) {
  const switching = newEngine !== currentEngine;
  currentEngine = newEngine;
  return switching;
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
  } else if (active === "ontwikkeling") {
    msr = "dsc";
    chartgrp = document.getElementById("chartgrp_dsc").value;
    agegrp = document.querySelector('input[name="agegrp_dsc"]:checked').value;
    population = "nl"; // Assume default population
    ga = (chartgrp === 'gsed1') ? 40 : Number($("#weekslider_dsc").data().from);
  }

  const sex = document.querySelector('input[name="sex"]:checked').value;
  // Shared across both cards (Instellingen) -- no per-card syncing needed,
  // unlike the removed interpolation/interpolation_dsc duplication.
  const cm = document.getElementById("interpolation").checked;
  const plotSize = Number($("#sizeslider").data().from);
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

  // Single "Interactief" checkbox, outside the accordion, so it needs no
  // per-card syncing (unlike interpolation/interpolation_dsc): it stays the
  // same DOM element regardless of which card is active.
  // handleEngineVisibility() (just above) already greyed it out (disabled)
  // for A4 charts, which have no interactive rendering -- read that same
  // disabled state here rather than re-deriving the A4 condition, so the
  // two stay in sync by construction. The checkbox's checked state is left
  // untouched while disabled, so the user's interactive preference is
  // restored automatically when they switch back to a supported msr.
  const engineCheckbox = document.getElementById("engine_interactive");
  const engine = (!engineCheckbox.disabled && engineCheckbox.checked)
    ? "interactive"
    : "fixed";

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
    // plotSize (the Instellingen ruler) only affects the interactive
    // engine's display -- a pure CSS transform:scale() of its fixed
    // 900x900 design canvas. The grid engine's own server-rendered SVG
    // uses absolute px font sizes that don't scale with the requested
    // width/height (a chartplotter/svglite limitation), so applying the
    // ruler there only distorted the chart; grid keeps its normal fixed
    // size (785 square / 927x1311 A4) regardless of the ruler.
    drawEmbedChart(embedParams, plotSize, session => updateNoticePanel(2, session));
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
    // Remove any leftover interactive-engine content now that the grid
    // engine has a session to render (setlocation() below triggers
    // updatesvg(), which preloads its own image before swapping
    // background-image -- see opencpu-0.5-james-0.1.js -- so the previous
    // interactive iframe removed here won't be followed by a blank flash).
    clearEmbedWrapper();
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
