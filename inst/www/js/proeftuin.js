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

function renderDataTable(selector, rows, options = {}) {
  const { pageLength = 20, columnOrder = null, hideColumns = [], labels = {} } = options;

  if ($.fn.DataTable.isDataTable(selector)) {
    $(selector).DataTable().destroy();
    $(selector).empty();
  }
  // No data.frame() has no columns to build a table around -- show an
  // explicit message instead of silently leaving an empty <table>, which
  // otherwise looks like a rendering bug rather than "nothing to preview".
  if (!rows || rows.length === 0) {
    $(selector).html(
      '<tbody><tr><td class="text-muted">Geen data beschikbaar (nog geen kind geüpload).</td></tr></tbody>'
    );
    return;
  }
  // Union of keys across all rows, not just rows[0]: jsonlite drops NA
  // values from a row's JSON object entirely rather than serializing them
  // as null (e.g. a missing z-score for an out-of-range reference curve),
  // so a column present in most rows can be absent from any given one.
  // defaultContent renders those as an empty cell instead of DataTables
  // throwing "Requested unknown parameter" for the missing key.
  const allKeys = new Set();
  rows.forEach(row => Object.keys(row).forEach(key => allKeys.add(key)));
  // columnOrder pins specific keys to the front (e.g. "Leeftijd" first);
  // any remaining keys keep their natural (insertion) order after that.
  let keys = Array.from(allKeys);
  if (columnOrder) {
    const rest = keys.filter(key => !columnOrder.includes(key));
    keys = [...columnOrder.filter(key => allKeys.has(key)), ...rest];
  }
  keys = keys.filter(key => !hideColumns.includes(key));
  const columns = keys.map(key => ({ title: labels[key] || key, data: key, defaultContent: "" }));
  $(selector).DataTable({
    data: rows,
    columns: columns,
    pageLength: pageLength,
    // R already sorts these rows (yname/category, then descending age) so
    // the most recent occasion is on top; DataTables' own default of
    // sorting by the first column ascending would otherwise override that
    // the moment a "Leeftijd" column happens to come first.
    order: []
  });
}

function loadProeftuinPreview() {
  const args = { txt: userText, session: userSession };
  ocpu.rpc("preview_persondata", args, data => renderDataTable("#persondataTable", data));
  ocpu.rpc("preview_timedata", args, data => renderDataTable("#timedataTable", data));
  ocpu.rpc("preview_screeners", args, data => renderDataTable("#screenersTable", data, {
    columnOrder: ["Leeftijd"],
    hideColumns: ["Categorie", "Versie"],
    labels: {
      CategorieOmschrijving: "Groei",
      CodeOmschrijving: "Advies"
    }
  }));
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
