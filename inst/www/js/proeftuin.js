// proeftuin.js
// Author: Stef van Buuren
// (c) 2026 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL
//
// Experimental "Proeftuin" preview: renders the raw child data and
// screener results JAMES itself computes, using ocpu.rpc() (defined in
// opencpu-0.5-james-0.1.js, unused elsewhere in the app) to fetch each
// data frame as JSON and DataTables to display it. The tables render in
// the wide #plotcontainer panel (normally showing the chart), not the
// narrow sidebar -- these data frames have 6-16 columns, too many for the
// col-sm-3 sidenav.

function renderDataTable(selector, rows, pageLength = 20) {
  if ($.fn.DataTable.isDataTable(selector)) {
    $(selector).DataTable().destroy();
    $(selector).empty();
  }
  if (!rows || rows.length === 0) return;
  const columns = Object.keys(rows[0]).map(key => ({ title: key, data: key }));
  $(selector).DataTable({
    data: rows,
    columns: columns,
    pageLength: pageLength
  });
}

function loadProeftuinPreview() {
  const args = { txt: userText, session: userSession };
  ocpu.rpc("preview_persondata", args, data => renderDataTable("#persondataTable", data));
  ocpu.rpc("preview_timedata", args, data => renderDataTable("#timedataTable", data));
  ocpu.rpc("preview_screeners", args, data => renderDataTable("#screenersTable", data));
}

// Load once, the first time the Proeftuin card is actually expanded --
// not on checkbox-toggle (that only shows/hides the card) and not eagerly
// on page load, to avoid 3 extra requests for users who never open it.
// Bootstrap 4's collapse events are jQuery custom events (dispatched via
// jQuery's own event system, not native DOM events), so they must be
// bound with jQuery's .on() -- addEventListener never sees them.
let proeftuinLoaded = false;
$("#collapseProeftuin").on("show.bs.collapse", function() {
  showPanel("proeftuinPanel");
  if (proeftuinLoaded) return;
  proeftuinLoaded = true;
  loadProeftuinPreview();
});

// The three Proeftuin sub-sections, each showing exactly one of the
// three data previews inside #proeftuinPanel.
const PROEFTUIN_SECTIONS = ["persondataSection", "timedataSection", "screenersSection"];

function showProeftuinSection(sectionId) {
  PROEFTUIN_SECTIONS.forEach(id => {
    $(`#${id}`).toggle(id === sectionId);
  });
}

$("#showKinddata").on("click", function(e) {
  e.preventDefault();
  showProeftuinSection("persondataSection");
});
$("#showMeetdata").on("click", function(e) {
  e.preventDefault();
  showProeftuinSection("timedataSection");
});
$("#showScreeners").on("click", function(e) {
  e.preventDefault();
  showProeftuinSection("screenersSection");
});

// Feedback survey (Formbricks link survey): "onderdeel" is a recall hidden
// field in the survey, so the question text itself becomes e.g. "Uw mening
// over de bruikbaarheid van Kinddata" -- no per-section survey needed.
const PROEFTUIN_FEEDBACK_URL = "https://app.formbricks.com/s/cms77vlps13zs01q8vh4sb704";

$(".proeftuin-feedback-btn").on("click", function() {
  const onderdeel = $(this).data("onderdeel");
  const url = `${PROEFTUIN_FEEDBACK_URL}?onderdeel=${encodeURIComponent(onderdeel)}`;
  window.open(url, "_blank", "noopener");
});
