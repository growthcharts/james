// start.js

// Constants for OpenCPU server configuration based on environment
const isSingleUser = false;
const urlParams = new URLSearchParams(window.location.search);
const { protocol, hostname, pathname } = window.location;
const host = `${protocol}//${hostname}`;
const basePath = pathname.slice(0, -5); // Assuming removal of ".html"

// Extract URL parameters with fallbacks to handle null or undefined
const userText = urlParams.get('txt') || '';
const userSession = urlParams.get('session') || '';
const userChartcode = urlParams.get('chartcode') || '';

// Set the OpenCPU server URL
ocpu.seturl(isSingleUser ? "../R" : `//${hostname}${basePath}/ocpu/library/james/R`);

// Slider values configuration
const sliderValues = {
  "0_2": ["0w", "4w", "8w", "3m", "4m", "6m", "7.5m", "9m", "11m", "14m", "18m", "24m"],
  "0_4": ["0w", "4w", "8w", "3m", "4m", "6m", "7.5m", "9m", "11m", "14m", "18m", "24m", "36m", "45m"],
  "0_19": ["0w", "3m", "6m", "12m", "24m", "5y", "9y", "10y", "11y", "14y", "19y"],
  "0_29": ["0w", "3m", "6m", "14m", "24m", "48m", "10y", "18y"],
  "matches": ["0", "1", "2", "5", "10", "25", "50", "100"]
};

// Defaults for initialisation per child
let sliderList = "0_2";
let chartcode = "NJAH";
$("#donordata").val("0-2");

// Slider initialization with shared settings
const initializeSlider = (selector, settings) => {
  $(selector).ionRangeSlider({
    type: settings.type || "single", // Default type if not specified
    skin: "round",
    grid_snap: true,
    ...settings,
    onFinish: update
  });
};

initializeSlider("#weekslider", { min: 25, max: 36, from: 36, step: 1 });
initializeSlider("#matchslider", { values: sliderValues.matches });
initializeSlider("#visitslider", { type: "double", min_interval: 0, drag_interval: true, values: sliderValues[sliderList] });

// Accordion page activation
let active = "groei";
["#groei", "#ontwikkeling"].forEach(id => {
  $(id).click(() => {
    if (active !== id.substring(1)) {
      active = id.substring(1);
      update();
    }
  });
});

// Change listeners for UI controls
const addChangeListener = (elementId) => {
  document.getElementById(elementId).addEventListener('change', update, false);
};

addChangeListener('chartgrp');
addChangeListener('chartgrp_dsc');

// Simplified event attachment for radio buttons
["agegrp", "msr", "etnicity", "sex", "agegrp_dsc"].forEach(formName => {
  const radios = document.forms[formName].elements[formName]; // Assuming 'elements[formName]' is correct; might need adjustment based on actual HTML structure
  for (let radio of radios) {
    radio.onclick = update;
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
      showCards(output.accordion.toString());

      // Conditional UI adjustments
      const chartGroupElementId = output.side === "dsc" ? "chartgrp_dsc" : "chartgrp";
      document.getElementById(chartGroupElementId).value = output.chartgrp.toString();
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
      updateNoticePanel(true, session);
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
    updateNoticePanel(true, session);
  });
}

function updateSliders(output) {
  const weekNum = Math.trunc(Number(output.week));
  if (weekNum >= 25 && weekNum <= 36) {
    updateWeekSlider("#weekslider", output.week);
    updateWeekSlider("#weekslider_dsc", output.week);
  }

  document.getElementById("donordata").value = output.dnr;
  slider_list = output.slider_list.toString();
  const values = slider_values[slider_list];
  const from = values.indexOf(output.period[0].toString());
  const to = values.indexOf(output.period[1].toString());
  $("#visitslider").data("ionRangeSlider").update({ values, from, to });
}

function updateWeekSlider(selector, week) {
  $(selector).data("ionRangeSlider").update({ from: week });
}

function setEthnicity(population) {
  const pop = population.toLowerCase();
  if (["nl", "tu", "ma", "hs", "ds"].includes(pop)) {
    document.forms.etnicity[pop].checked = true;
  }
}

function updateDonorData() {
  // Update slider values and graph based on the donor data selection
  const donorData = document.getElementById("donordata").value;

  // Define a mapping from donor data to slider lists
  const donorToSliderMap = {
    "0-2": "0_2",
    "2-4": "0_4",
    "4-18": "0_29"
  };

  // Use the mapping to find the slider list, defaulting to "0_2" if not found
  const sliderList = donorToSliderMap[donorData] || "0_2";

  // Update the slider with the new values
  const values = slider_values[sliderList];
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

function showCards(option = "all") {
  const displayMap = {
    all: () => {
      sr('ontwikkelingcard', 'block');
      sr('groeicard', 'block');
      $('#collapseOne, #collapseTwo').collapse('show');
    },
    groei: () => {
      sr('ontwikkelingcard', 'none');
      sr('groeicard', 'block');
      $('#collapseOne').collapse('show');
    },
    ontwikkeling: () => {
      sr('groeicard', 'none');
      sr('ontwikkelingcard', 'block');
      $('#collapseTwo').collapse('show');
      active = "ontwikkeling";
    }
  };

  // Execute the relevant function based on the 'option' parameter
  if(displayMap[option]) displayMap[option]();
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
