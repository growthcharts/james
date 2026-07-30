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

// Screener advice codes end in a two-digit sub-code that groups their
// severity (see growthscreener's messages table): 10-30 = can't be
// determined, 31-39 = normal, 41-69 = refer, 71-89 = look wider. Colors
// follow the dataviz skill's fixed status palette (good/warning/serious),
// with "can't be determined" left neutral since it's not a judgement
// about the child, just a data/technical gap.
function screeningSeverityColor(code) {
  const sub = Number(code) % 100;
  if (sub >= 31 && sub <= 39) return "#0ca30c"; // normaal -- good
  if (sub >= 41 && sub <= 69) return "#ec835a"; // verwijzen -- serious
  if (sub >= 71 && sub <= 89) return "#fab219"; // kijk breder -- warning
  return "#c3c2b7"; // kan niet bepalen (10-30) -- neutral
}

function renderDataTable(selector, rows, options = {}) {
  const {
    pageLength = 20,
    columnOrder = null,
    hideColumns = [],
    labels = {},
    severityColumn = null,
    groupColumn = null,
    groupOrder = null,
    decimalOverrides = {}
  } = options;

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
  // groupOrder re-sorts rows by a fixed, clinically meaningful group
  // order (e.g. Lengte, Gewicht, Hoofdomtrek) instead of R's alphabetical
  // default, while preserving each group's existing internal order
  // (descending age) via a stable sort. Groups not listed in groupOrder
  // keep their relative position after the listed ones.
  if (groupColumn && groupOrder) {
    const rank = value => {
      const i = groupOrder.indexOf(value);
      return i === -1 ? groupOrder.length : i;
    };
    rows = rows
      .map((row, i) => ({ row, i }))
      .sort((a, b) => rank(a.row[groupColumn]) - rank(b.row[groupColumn]) || a.i - b.i)
      .map(entry => entry.row);
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
  // Right-align + pad every value in a numeric column to a fixed decimal
  // count, so the decimal point lands on the same character position
  // every row -- true decimal-point alignment, not just a matching right
  // edge (which tabular-nums alone gives you, but "0" and "2.0397" still
  // don't line up on the point). decimalOverrides sets a specific count
  // per column (e.g. age/x = 3, y = 2); anything not listed there falls
  // back to that column's own max decimal count across all rows. Columns
  // of whole numbers (e.g. "Code") get 0 decimals and are left untouched,
  // rather than padded into "2075.0000".
  const numericDecimals = key => {
    if (key in decimalOverrides) return decimalOverrides[key];
    const values = rows.map(row => row[key]).filter(v => v !== null && v !== undefined && v !== "");
    if (!values.length || !values.every(v => !isNaN(Number(v)))) return null;
    return Math.max(0, ...values.map(v => {
      const s = String(v);
      const i = s.indexOf(".");
      return i === -1 ? 0 : s.length - i - 1;
    }));
  };
  const columns = keys.map(key => {
    const decimals = numericDecimals(key);
    if (decimals === null) return { title: labels[key] || key, data: key, defaultContent: "" };
    return {
      title: labels[key] || key,
      data: key,
      defaultContent: "",
      className: "text-right proeftuin-numeric",
      render: (value) => (value === null || value === undefined || value === "")
        ? ""
        : Number(value).toFixed(decimals)
    };
  });
  $(selector).DataTable({
    data: rows,
    columns: columns,
    pageLength: pageLength,
    // R already sorts these rows (yname/category, then descending age) so
    // the most recent occasion is on top. Disable interactive sorting
    // entirely (not just the initial order): a user click-sorting a
    // column would still reorder the rows themselves, silently breaking
    // both that meaning and the groupColumn spacing above, which assumes
    // rows arrive in the server's grouped order.
    ordering: false,
    // Same reasoning for search: filtering changes which rows are
    // present in the displayed set, so displayIndexFull no longer lines
    // up with an unbroken previous row the way groupColumn's rowCallback
    // assumes -- it read table.row(displayIndexFull - 1) as undefined
    // the moment a filter excluded that row, crashing on data[groupColumn].
    // These tables max out around 60 rows; paging covers browsing them
    // fine without a search box.
    searching: false,
    rowCallback: (row, data, displayIndex, displayIndexFull) => {
      // Subtle severity cue: a colored left border on the row's first
      // cell, not a filled background or colored text -- identity/urgency
      // is carried by an accent, so the advice text itself stays fully
      // legible. Set on the <td> rather than the <tr>: border-collapse
      // on the table element means a border on the row itself does not
      // reliably paint.
      if (severityColumn) {
        row.cells[0].style.borderLeft = `4px solid ${screeningSeverityColor(data[severityColumn])}`;
      }
      // Extra breathing room above the first row of each new group (e.g.
      // a new "yname" in Metingen, a new "Groei" category in
      // Richtlijnen), so scanning the table reads as sections rather
      // than one undifferentiated list. Compares against the previous
      // row in the currently *displayed* (filtered/sorted) order.
      // rowCallback's 3rd argument (displayIndex) resets to 0 on every
      // page -- comparing against table.row(displayIndex - 1) then reads
      // the wrong row on any page after the first, e.g. row 0 of the
      // whole table instead of the actual previous row on screen. The
      // 4th argument (displayIndexFull) is the position within the full
      // filtered/sorted result set, stable across pages, matching what
      // order: [] above already fixes as the row order.
      // Uses padding-top on every cell, not border/margin on the <tr>:
      // with box-sizing: border-box (Bootstrap's default), a border on
      // a row whose height is already content-driven just eats into
      // that space instead of adding to it, and <tr> ignores margin
      // entirely -- padding on a cell is the one box property a table
      // row reliably grows for. All cells need it, not just the first:
      // padding on a single cell only pushes that cell's own content
      // down, leaving the row's other columns misaligned against it.
      if (groupColumn && displayIndexFull > 0) {
        const table = $(selector).DataTable();
        const prev = table.row(displayIndexFull - 1, { order: "current", search: "applied" }).data();
        if (prev[groupColumn] !== data[groupColumn]) {
          Array.from(row.cells).forEach(cell => { cell.style.paddingTop = "20px"; });
        }
      }
    }
  });
}

// Fixed, clinically meaningful group orders, replacing R's alphabetical
// default (which put e.g. "Gewicht" before "Lengte", and "bmi"/"dsc"
// before "hgt"). "Taal" (a language-development screener) isn't
// screened by preview_screeners() yet -- calculate_advice_devlang()
// needs different source data (vw41-vw46 items) that preview_screeners
// doesn't extract from tgt today -- so it's omitted here for now rather
// than added as a category with no rows.
const RICHTLIJNEN_GROUP_ORDER = ["Lengte", "Gewicht", "Hoofdomtrek"];
const METINGEN_GROUP_ORDER = ["hgt", "wgt", "wfh", "hdc", "dsc"];

function loadProeftuinPreview() {
  const args = { txt: userText, session: userSession };
  ocpu.rpc("preview_persondata", args, data => renderDataTable("#persondataTable", data));
  ocpu.rpc("preview_timedata", args, data => renderDataTable("#timedataTable", data, {
    groupColumn: "yname",
    groupOrder: METINGEN_GROUP_ORDER,
    decimalOverrides: { age: 3, x: 3, y: 2 }
  }));
  ocpu.rpc("preview_screeners", args, data => renderDataTable("#screenersTable", data, {
    columnOrder: ["Leeftijd"],
    hideColumns: ["Categorie", "Versie"],
    labels: {
      CategorieOmschrijving: "Groei",
      CodeOmschrijving: "Advies"
    },
    severityColumn: "Code",
    groupColumn: "CategorieOmschrijving",
    groupOrder: RICHTLIJNEN_GROUP_ORDER
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

// The two Proeftuin sub-sections, each showing exactly one preview
// inside #proeftuinPanel. Kindgegevens combines the fixed characteristics
// (persondata, always one row) and the measurement history (timedata) as
// two stacked tables under one heading, since browsing a child's fixed
// facts and their measurements are usually the same task, not two.
const PROEFTUIN_SECTIONS = ["screenersSection", "persondataSection"];

function showProeftuinSection(sectionId) {
  PROEFTUIN_SECTIONS.forEach(id => {
    $(`#${id}`).toggle(id === sectionId);
  });
}

$("#showKinddata").on("click", function(e) {
  e.preventDefault();
  showProeftuinSection("persondataSection");
});
$("#showScreeners").on("click", function(e) {
  e.preventDefault();
  showProeftuinSection("screenersSection");
});

// Feedback survey (Formbricks link survey): "onderdeel" is a recall hidden
// field in the survey, so the question text itself becomes e.g. "Uw mening
// over de bruikbaarheid van Kindgegevens" -- no per-section survey needed.
const PROEFTUIN_FEEDBACK_URL = "https://app.formbricks.com/s/cms77vlps13zs01q8vh4sb704";

$(".proeftuin-feedback-btn").on("click", function() {
  const onderdeel = $(this).data("onderdeel");
  const url = `${PROEFTUIN_FEEDBACK_URL}?onderdeel=${encodeURIComponent(onderdeel)}`;
  window.open(url, "_blank", "noopener");
});
