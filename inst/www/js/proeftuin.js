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

function renderDataTable(selector, rows) {
  if ($.fn.DataTable.isDataTable(selector)) {
    $(selector).DataTable().destroy();
    $(selector).empty();
  }
  if (!rows || rows.length === 0) return;
  const columns = Object.keys(rows[0]).map(key => ({ title: key, data: key }));
  $(selector).DataTable({
    data: rows,
    columns: columns,
    pageLength: 5
  });
}

function loadProeftuinPreview() {
  const args = { txt: userText, session: userSession };
  ocpu.rpc("preview_persondata", args, data => renderDataTable("#persondataTable", data));
  ocpu.rpc("preview_timedata", args, data => renderDataTable("#timedataTable", data));
  ocpu.rpc("preview_screeners", args, data => renderDataTable("#screenersTable", data));
}

// Swap the chart panel for the preview panel (or back), matching the
// pattern in update.js's ensureEngineDiv()/clearEmbedWrapper() of hiding
// rather than removing DOM so re-showing needs no re-render.
function showProeftuinPanel() {
  $("#plotDiv").hide();
  $("#proeftuinPanel").show();
}
function hideProeftuinPanel() {
  $("#proeftuinPanel").hide();
  $("#plotDiv").show();
}

// Load once, the first time the Proeftuin card is actually expanded --
// not on checkbox-toggle (that only shows/hides the card) and not eagerly
// on page load, to avoid 3 extra requests for users who never open it.
// Bootstrap 4's collapse events are jQuery custom events (dispatched via
// jQuery's own event system, not native DOM events), so they must be
// bound with jQuery's .on() -- addEventListener never sees them.
let proeftuinLoaded = false;
$("#collapseProeftuin").on("show.bs.collapse", function() {
  showProeftuinPanel();
  if (proeftuinLoaded) return;
  proeftuinLoaded = true;
  loadProeftuinPreview();
});
$("#collapseProeftuin").on("hide.bs.collapse", hideProeftuinPanel);

$("#showKinddata").on("click", function(e) {
  e.preventDefault();
  $("#screenersSection").hide();
  $("#kinddataSection").show();
});
$("#showScreeners").on("click", function(e) {
  e.preventDefault();
  $("#kinddataSection").hide();
  $("#screenersSection").show();
});
