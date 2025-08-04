// start.js
// Author: Stef van Buuren
// (c) 2024 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL

// Do we run as a single-user server OCPU app. If so, set to true:
// Not yet implemented
const isSingleUser = false;
var appBase = isSingleUser ? '' : 'app/';

// Constants for OpenCPU server configuration based on environment
const { protocol, hostname, port, pathname } = window.location;
const fullHost = port ? `${hostname}:${port}` : hostname;
const basePath = pathname.slice(0, -5);  // Assuming removal of ".html"

// Set the OpenCPU server URL
ocpu.seturl(
  isSingleUser
    ? "../R"
    : `${protocol}//${fullHost}${basePath}/ocpu/library/james/R`
);

// Extract URL parameters with fallbacks to handle null or undefined
const urlParams = new URLSearchParams(window.location.search);
const userText = urlParams.get('txt') || '';
const userSession = urlParams.get('session') || '';
const userChartcode = urlParams.get('chartcode') || '';

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
addChangeListenerThrottledUpdate('interpolation_dsc');
addChangeListenerThrottledUpdate('exact_sex');
addChangeListenerThrottledUpdate('exact_ga');
addChangeListenerThrottledUpdate('show_future');
addChangeListenerThrottledUpdate('show_realized');

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

  // Helper function to set session info
  const setSessionInfo = (selector, method) => {
    session[method](outtxt => {
      $(selector).text(outtxt);
    });
  };

  setSessionInfo(consoleOutput, 'getConsole');
  setSessionInfo(warningsOutput, 'getWarnings');
  setSessionInfo(messagesOutput, 'getMessages');
}
