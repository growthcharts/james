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
// Shared plot size (px), used by both engines -- default (785) matches the
// pre-ruler fixed size, so nothing changes on page load until dragged.
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
  // Executes at initialization to get settings from uploaded data
  const request = ocpu.call("convert_tgt_chartadvice", {
    txt: userText,
    session: userSession,
    chartcode: userChartcode,
    selector: selector
  }, session => {
    // Retrieve the returned object asynchronously
    session.getObject(output => {
      // Handle invalid chartcode
      if (!output.chartcode) {
        alert(`Unknown chartcode: ${userChartcode}`);
        return;
      }

      // Set UI elements based on returned data
      showCards(String(output.accordion));

      // Conditional UI adjustments
      const chartGroupElementId = output.side[0] === "dsc" ? "chartgrp_dsc" : "chartgrp";
      document.getElementById(chartGroupElementId).value = output.chartgrp.toString();
      if (output.side[0] === "dsc") {
        // Signal to update() to use D-score UI controls
        active = "ontwikkeling";
        if (output.ga <= 36) document.getElementById(chartGroupElementId).value = "gsed1pt";
        else document.getElementById(chartGroupElementId).value = "gsed1";
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
      update();

      // Prep for subsequent calls
      selector = "derive";
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

function updateSliders(output) {
  const weekNum = Math.trunc(Number(output.week[0]));
  if (weekNum >= 25 && weekNum <= 36) {
    updateWeekSlider("#weekslider", String(output.week[0]));
    updateWeekSlider("#weekslider_dsc", String(output.week[0]));
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
