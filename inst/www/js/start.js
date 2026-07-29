// start.js
// Author: Stef van Buuren
// (c) 2024 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL

// Flag for single-user mode; not yet implemented
const isSingleUser = false;
const appBase = isSingleUser ? '' : 'app/';

// Extract URL parameters with fallbacks to handle null or undefined
const urlParams = new URLSearchParams(window.location.search);
const userText = urlParams.get('txt') || '';
const userSession = urlParams.get('session') || '';
const userChartcode = urlParams.get('chartcode') || '';

// Display defaults (independent of which child's data is shown) -- e.g.
// request_site(..., display = list(interactive = TRUE, interpolation =
// FALSE, size = 600)) appends these as query params, read once here to
// seed the Instellingen controls before the first render.
const userInteractive = urlParams.get('interactive');
const userInterpolation = urlParams.get('interpolation');
const userSize = Number(urlParams.get('size')) || 785;

// Slider values
const sliderValues = {
  "0-18": ["0w", "4w", "8w", "3m", "4m", "6m", "7.5m", "9m", "11m", "14m", "18m", "24m", "36m", "45m", "10y", "18y"],
  "matches": ["0", "1", "2", "5", "10", "25", "50", "100"]
};

// Defaults
let chartcode = "NJAH";

// Event attachment for UI controls
const addChangeListenerUpdate = (elementId) => {
  document.getElementById(elementId).addEventListener('change', update, false);
};
const addChangeListenerThrottledUpdate = (elementId) => {
  document.getElementById(elementId).addEventListener('change', throttledUpdate, false);
};

// Event attachment for UI controls: menus
addChangeListenerUpdate('chartgrp');
addChangeListenerUpdate('chartgrp_dsc');

// Event attachment for UI controls: check boxes
addChangeListenerThrottledUpdate('interpolation');
addChangeListenerThrottledUpdate('exact_sex');
addChangeListenerThrottledUpdate('exact_ga');
addChangeListenerThrottledUpdate('show_future');
addChangeListenerThrottledUpdate('show_realized');
addChangeListenerThrottledUpdate('engine_interactive');

// "Proeftuin" is an experimental accordion card, hidden by default; the
// Instellingen checkbox only toggles its visibility, no chart re-render
document.getElementById('show_proeftuin').addEventListener('change', function() {
  sr('proeftuincard', this.checked ? 'block' : 'none');
}, false);

// Event attachment for UI controls: radio buttons
["agegrp", "msr", "etnicity", "sex", "agegrp_dsc"].forEach(formName => {
  const radios = document.forms[formName].elements[formName];
  for (let radio of radios) {
    radio.onclick = throttledUpdate;
  }
});

// Event attachment for UI controls: accordion
document.addEventListener('DOMContentLoaded', function() {
  // Create a mapping of element IDs to the function arguments they correspond to.
  // This assumes toggleDisplay accepts two arguments for divs to show/hide.
  const linksToToggle = {
    'groei': ['plotDiv', 'textDiv'],
    'ontwikkeling': ['plotDiv', 'textDiv'],
    'voorspeller': ['plotDiv', 'textDiv'],
    'meldingen': ['textDiv', 'plotDiv']
  };

  // Iterate over the entries in the mapping object.
  Object.entries(linksToToggle).forEach(([id, divs]) => {
    const link = document.getElementById(id);
    if (link) { // Check if the element exists to avoid null reference errors
      link.addEventListener('click', function(event) {
        // Prevent the default action if it's a link or a button inside a form
        event.preventDefault();

        // Call toggleDisplay with the div IDs specific to this link
        toggleDisplay(...divs);
      });
    }
  });
});

// Event attachment for UI controls: sliders
function initializeSlider(selector, options) {
  const commonOptions = {
    type: "single",
    skin: "round",
    grid_snap: true,
    onFinish: throttledUpdate
  };

  // Merge common options with specific options provided for each slider
  $(selector).ionRangeSlider($.extend({}, commonOptions, options));
}

// Initialize the sliders with both common and specific options
initializeSlider("#weekslider", { min: 25, max: 36, from: 36, step: 1 });
initializeSlider("#matchslider", { from: 0, values: sliderValues["matches"] });
initializeSlider("#visitslider", { type: "double", min_interval: 0, drag_interval: true, values: sliderValues["0-18"] });
initializeSlider("#weekslider_dsc", { min: 25, max: 36, from: 36, step: 1 });
// Interactive-engine display size (px) -- grid keeps its own fixed sizes
// (see update.js/opencpu-0.5-james-0.1.js). Default (785) matches the
// interactive engine's pre-ruler fixed size, so nothing changes on page
// load until dragged.
initializeSlider("#sizeslider", { min: 400, max: 1000, from: userSize, step: 5 });

// Apply display-default URL params to the Instellingen checkboxes before the
// first render. userInteractive/userInterpolation are left at their HTML
// defaults (interpolation checked, interactive unchecked) when the param is
// absent -- only an explicit "1"/"true" or "0"/"false" overrides.
if (userInteractive !== null) {
  document.getElementById("engine_interactive").checked = ["1", "true"].includes(userInteractive.toLowerCase());
}
if (userInterpolation !== null) {
  document.getElementById("interpolation").checked = ["1", "true"].includes(userInterpolation.toLowerCase());
}

// Set active accordion page
let active = "groei";
$('#groei').click(function (){
        if (active != "groei"){
          active = "groei";
          update();
        }
    });

$('#ontwikkeling').click(function (){
        if (active != "ontwikkeling"){
          active = "ontwikkeling";
          update();
        }
    });

// Selector logic
let selector = userChartcode ? "chartcode" : (userText || userSession) ? "data" : "derive";

// Initialize chart controls or update based on user input
(userText || userSession || userChartcode) ? initializeChartControls() : update();

function initializeChartControls() {
  // Executes at initialization to get settings from uploaded data.
  //
  // This used to call convert_tgt_chartadvice() and then, once the controls
  // had been populated, call update() -- which reads those same controls
  // back out of the DOM to build its draw_chart() parameters. That
  // read-back made the two calls strictly sequential: two forked R
  // requests (~0.2s each in fixed OpenCPU overhead) before the first chart
  // appeared.
  //
  // draw_chart(selector = "data") already derives the chart from the child
  // data internally, so it can return the very same advice list
  // (include_advice = TRUE) alongside the chart it draws. One call now
  // yields both, and the chart starts rendering immediately rather than
  // waiting for a DOM round trip.
  const request = ocpu.call("draw_chart", {
    txt: userText,
    session: userSession,
    chartcode: userChartcode,
    selector: selector,
    include_advice: true
  }, session => {
    // Show the chart this same call already drew, without waiting for the
    // advice payload below. .graphic() points the plot widget at an
    // existing session's graphics output, which is exactly what .rplot()
    // does internally after its own r_fun_call().
    $("#plotDiv").graphic(session);

    // Retrieve the returned object asynchronously
    session.getObject(output => {
      // Handle invalid chartcode
      if (!output.chartcode) {
        alert(`Unknown chartcode: ${userChartcode}`);
        return;
      }

      // Set UI elements based on returned data
      showCards(String(output.accordion));

      // This session's .val is the advice list, not the grob, so
      // updatesvg()'s "gTree[CHARTCODE]" parsing deliberately skipped it.
      // Take the chartcode straight from the payload instead.
      chartcode = String(output.chartcode);
      document.getElementById("chartcode").innerHTML = chartcode;
      document.getElementById("chartcode_dsc").innerHTML = chartcode;

      // Conditional UI adjustments
      const chartGroupElementId = output.side[0] === "dsc" ? "chartgrp_dsc" : "chartgrp";
      document.getElementById(chartGroupElementId).value = output.chartgrp.toString();
      if (output.side[0] === "dsc") {
        // Signal to update() to use D-score UI controls
        active = "ontwikkeling";
        // Preterm D-score children get the gsed1pt chart. Mirrors
        // select_chartgrp(): ga <= 36 is preterm, an unknown ga counts as
        // term. Note this reads output.week, not output.ga -- initializer()
        // returns the gestational age as "week" and has no "ga" element at
        // all, so the previous output.ga test was always undefined <= 36,
        // i.e. false, and every D-score child silently got gsed1.
        document.getElementById(chartGroupElementId).value =
          isPretermWeek(output.week) ? "gsed1pt" : "gsed1";
      }
      if (output.side[0] !== "dsc") {
        document.forms.msr[output.side[0]].checked = true;
      }
      document.forms.agegrp[output.agegrp[0]].checked = true;
      if (output.agegrp[0] !== "1-21y") {
        document.forms.agegrp_dsc[output.agegrp[0]].checked = true;
      }

      // Update sliders
      updateSliders(output);

      // Set ethnicity and sex
      setEthnicity(output.population[0]);
      document.forms.sex[output.sex[0]].checked = true;

      // Final UI updates
      updateNoticePanel(1, session);

      // Prep for subsequent calls
      selector = "derive";

      // No update() here: the chart for these settings was already drawn
      // by the include_advice call above and shown via .graphic(). Calling
      // update() would issue a second, identical draw_chart() request.
      //
      // The D-score card is the exception. draw_chart() drew a growth
      // chart, but the data are developmental, so the UI just switched to
      // the "ontwikkeling" card and its own chartgrp (gsed1/gsed1pt) --
      // settings the drawn chart does not reflect. Redraw for those.
      //
      // The interactive engine is likewise not covered by the grid-drawn
      // chart, so it needs its own render pass too.
      const wantsInteractive =
        !document.getElementById("engine_interactive").disabled &&
        document.getElementById("engine_interactive").checked;
      if (output.side[0] === "dsc" || wantsInteractive) {
        update();
      }
    });
  });

  request.fail(session => {
    console.error("Server error rq1 - cannot read data for initialization", {
      txt: userText,
      session: userSession,
      chartcode: userChartcode,
      selector: selector,
      error: request.responseText
    });
    alert(`Server error rq1 - cannot read data for initialization\nDetails logged to console.`);
    updateNoticePanel(1, session);
  });
}

// Gestational age in completed weeks from an initializer() payload, or
// null when it is unavailable.
//
// week is target$psn$ga, which bdsreader derives as trunc(gad / 7) from
// BDS 82 (gestational age in days) -- so it is always whole weeks, and
// needs no rounding by the caller.
//
// It can be unavailable in two ways, neither of which is a JSON null:
//   - no ga element at all -> toJSON() emits "week":{}, so output.week is
//     an object, and output.week[0] is undefined;
//   - ga is NA (e.g. no BDS 82 in the data) -> toJSON() emits
//     "week":["NA"], i.e. the *string* "NA", which Number() turns into NaN
//     rather than anything falsy.
// Number.isFinite() is what actually catches the second case; the explicit
// undefined/null test just avoids Number(undefined) and keeps the intent
// readable.
function getWeek(week) {
  const raw = week ? week[0] : undefined;
  if (raw === undefined || raw === null) return null;
  const num = Number(raw);
  return Number.isFinite(num) ? num : null;
}

// Preterm iff a known gestational age of 36 weeks or less, matching
// select_chartgrp(): an unknown ga counts as term there too.
function isPretermWeek(week) {
  const num = getWeek(week);
  return num !== null && num <= 36;
}

function updateSliders(output) {
  // Leave the week sliders at their defaults when ga is unavailable,
  // rather than driving them to NaN.
  const weekNum = getWeek(output.week);
  if (weekNum === null) return;
  if (weekNum >= 25 && weekNum <= 36) {
    updateWeekSlider("#weekslider", String(weekNum));
    updateWeekSlider("#weekslider_dsc", String(weekNum));
  }
}

function updateWeekSlider(selector, week) {
  $(selector).data("ionRangeSlider").update({ from: week });
}

function setEthnicity(population) {
  const pop = String(population).toLowerCase();
  if (["nl", "tu", "ma", "hs", "ds"].includes(pop)) {
    document.forms.etnicity[pop].checked = true;
  }
}

function toggleDisplay(divToShow, divToHide) {
  $(`#${divToHide}`).hide(500);
  $(`#${divToShow}`).show(500);
}

function showCards(show = "all") {
  if (show == "all") {
    sr('ontwikkelingcard', 'block');
    sr('ontwikkelingcard', 'block');
    $('#collapseOne').collapse('show');
  } else if (show == "groei") {
    sr('ontwikkelingcard', 'none');
    $('#collapseOne').collapse('show');
  } else if (show == "ontwikkeling") {
    sr('groeicard', 'none');
    $('#collapseTwo').collapse('show');
    active = "ontwikkeling";
  }
}

function updateNoticePanel(rq, session) {
  // Handle multiple requests
  const rqKey = `#rq${rq}-session`;
  const consoleOutput = `#rq${rq}-console`;
  const warningsOutput = `#rq${rq}-warnings`;
  const messagesOutput = `#rq${rq}-messages`;

  $(rqKey).text(session.getKey());

  // Helper function to set session info, capped to a fixed character length.
  // getConsole() in particular echoes the full R console transcript,
  // including the function's auto-printed return value -- for
  // embed_chart(), that's the entire HTML widget document, printed as R's
  // quoted-string representation (escaped \n, not real newlines), so it
  // shows up as a single ~100+KB "line" that a line-based truncation
  // wouldn't shrink at all.
  const MAX_NOTICE_CHARS = 300;
  const setSessionInfo = (selector, method) => {
    session[method](outtxt => {
      const truncated = outtxt.length > MAX_NOTICE_CHARS
        ? outtxt.slice(0, MAX_NOTICE_CHARS) + "..."
        : outtxt;
      $(selector).text(truncated);
    });
  };

  setSessionInfo(consoleOutput, 'getConsole');
  setSessionInfo(warningsOutput, 'getWarnings');
  setSessionInfo(messagesOutput, 'getMessages');
}
