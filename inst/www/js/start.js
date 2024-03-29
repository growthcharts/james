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
const { protocol, hostname, pathname } = window.location;
const host = `${protocol}//${hostname}`;
const basePath = pathname.slice(0, -5); // Assuming removal of ".html"

// Set the OpenCPU server URL
ocpu.seturl(isSingleUser ? "../R" : `//${hostname}${basePath}/ocpu/library/james/R`);

// Extract URL parameters with fallbacks to handle null or undefined
const urlParams = new URLSearchParams(window.location.search);
const userText = urlParams.get('txt') || '';
const userSession = urlParams.get('session') || '';
const userChartcode = urlParams.get('chartcode') || '';

// Defaults
let chartcode = "NJAH";
$("#donordata").val("0-2");

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
addChangeListenerThrottledUpdate('exact_ga');

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

// Slider values
const sliderValues = {
  "0_2": ["0w", "4w", "8w", "3m", "4m", "6m", "7.5m", "9m", "11m", "14m", "18m", "24m"],
  "0_4": ["0w", "4w", "8w", "3m", "4m", "6m", "7.5m", "9m", "11m", "14m", "18m", "24m", "36m", "45m"],
  "0_19": ["0w", "3m", "6m", "12m", "24m", "5y", "9y", "10y", "11y", "14y", "19y"],
  "0_29": ["0w", "3m", "6m", "14m", "24m", "48m", "10y", "18y"],
  "matches": ["0", "1", "2", "5", "10", "25", "50", "100"]
};
let sliderList = "0_2";

// Initialize the sliders with both common and specific options
initializeSlider("#weekslider", { min: 25, max: 36, from: 36, step: 1 });
initializeSlider("#matchslider", { from: 0, values: sliderValues["matches"] });
initializeSlider("#visitslider", { type: "double", min_interval: 0, drag_interval: true, values: sliderValues[sliderList] });
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
      const chartGroupElementId = output.side === "dsc" ? "chartgrp_dsc" : "chartgrp";
      document.getElementById(chartGroupElementId).value = output.chartgrp.toString();
      if (output.side === "dsc") {
        // Signal to update() to use D-score UI controls
        active = "ontwikkeling";
      }
      if (output.side !== "dsc") {
        document.forms.msr[output.side].checked = true;
      }
      document.forms.agegrp[output.agegrp].checked = true;
      if (output.agegrp !== "1-21y") {
        document.forms.agegrp_dsc[output.agegrp].checked = true;
      }

      // Update sliders
      updateSliders(output);

      // Set ethnicity and sex
      setEthnicity(output.population);
      document.forms.sex[output.sex].checked = true;

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
  const weekNum = Math.trunc(Number(output.week));
  if (weekNum >= 25 && weekNum <= 36) {
    updateWeekSlider("#weekslider", String(output.week));
    updateWeekSlider("#weekslider_dsc", String(output.week));
  }

  document.getElementById("donordata").value = output.dnr;
  sliderList = output.slider_list.toString();
  const values = sliderValues[sliderList];
  const from = values.indexOf(output.period[0].toString());
  const to = values.indexOf(output.period[1].toString());
  $("#visitslider").data("ionRangeSlider").update({ values, from, to });
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

function updateDonordata() {
  // Update slider values and graph based on the donor data selection
  const donordata = document.getElementById("donordata").value;

  // Define a mapping from donor data to slider lists
  const donorToSliderMap = {
    "0-2": "0_2",
    "2-4": "0_4",
    "4-18": "0_29"
  };

  // Use the mapping to find the slider list, defaulting to "0_2" if not found
  const sliderList = donorToSliderMap[donordata] || "0_2";

  // Update the slider with the new values
  const values = sliderValues[sliderList];
  $("#visitslider").data("ionRangeSlider").update({
    values: values
  });

  // Refresh UI elements as necessary
  update();
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
