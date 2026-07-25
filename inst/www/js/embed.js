// embed.js
// Author: Stef van Buuren
// (c) 2026 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL
//
// Interactive (plotly) chart rendering via james::embed_chart(), parallel
// to update.js's drawChart() (grid/SVG rendering via draw_chart()).

// Design resolution of the embed_chart() document (fixed, per R/embed_chart.R
// -> multikaart::save_widget_cdn output). Do not change without checking the
// R side.
const EMBED_DESIGN_SIZE = 900;

function drawEmbedChart(params, cb) {
  const rq = ocpu.call("embed_chart", params, function (session) {
    session.getWidget(function (html) {
      injectWidget(html, params);
      if (cb) cb(session);
    });
  });

  rq.fail(function (jqxhr, textStatus, errorThrown) {
    console.error("Server error - unable to call embed_chart", {
      txt: params.txt,
      session: params.session,
      chartcode: params.chartcode,
      selector: params.selector,
      error: jqxhr.responseText || errorThrown || textStatus
    });
  });

  return rq;
}

// The widget HTML has no separate, directly retrievable chartcode (unlike
// draw_chart(), whose returned grob happens to print as "rect[NMBH]",
// parsed by updatesvg() below) -- multikaart::generate_copyright() embeds
// it in the bottom-right annotation's text ("... Served by JAMES · NMBH")
// specifically so it can be recovered here.
function extractChartcode(html) {
  const m = html.match(/Served by JAMES · (\w+)/);
  return m ? m[1] : null;
}

function injectWidget(html, params) {
  const $plotDiv = $("#plotDiv");

  const chartcode = extractChartcode(html);
  if (chartcode) {
    document.getElementById("chartcode").innerHTML = chartcode;
    document.getElementById("chartcode_dsc").innerHTML = chartcode;
  }

  // Target on-screen size: reuse the same square footprint draw_chart()
  // uses for non-A4 charts (785x785) for visual continuity when toggling
  // engines. A4 front/back never reaches this function -- the interactive
  // radio is hidden for those (see handleEngineVisibility()) -- so this can
  // safely assume square regardless of msr.
  const displaySize = 785;
  const scale = displaySize / EMBED_DESIGN_SIZE;

  $plotDiv.css({ width: displaySize, height: displaySize });

  // Build the new iframe off-screen (absolutely positioned, on top but
  // invisible) so the previous render -- whichever engine produced it --
  // stays visible until the replacement has actually finished loading.
  // srcdoc iframes paint blank first, then fetch+run plotly.js/jQuery from
  // the CDN, so swapping in-place on every render (including the very
  // first, and including switching engines) produced a visible blank flash.
  const $oldWrapper = $plotDiv.children(".mk-embed-wrapper");

  const $wrapper = $("<div>").addClass("mk-embed-wrapper").css({
    width: displaySize, height: displaySize, overflow: "hidden",
    position: "absolute", top: 0, left: 0, visibility: "hidden"
  });
  const $iframe = $("<iframe>").attr({
    srcdoc: html, scrolling: "no", frameborder: "0"
  }).css({
    width: EMBED_DESIGN_SIZE, height: EMBED_DESIGN_SIZE,
    border: "none", transform: `scale(${scale})`, "transform-origin": "top left"
  });

  $iframe.on("load", function () {
    $wrapper.css("visibility", "visible");
    $oldWrapper.remove();
    // Only now (new content visibly ready) tear down any leftover grid
    // engine state, so a grid->interactive switch never shows a blank gap
    // either. Safe no-op if the previous render was already interactive.
    clearOcpuplotState();
    $plotDiv.css("background-image", "none");
  });

  $wrapper.append($iframe);
  $plotDiv.css("position", "relative").append($wrapper);
}

// Removes .rplot()-managed state (cached ocpuplot controller, its inner
// div/spinner, resize handler) without touching an interactive-engine
// .mk-embed-wrapper that may still be present -- called once the *other*
// engine's new content is confirmed ready (see drawChart()/injectWidget()),
// never eagerly, so the previous engine's content stays visible for the
// full duration of the new engine's request/render round-trip.
function clearOcpuplotState() {
  const $plotDiv = $("#plotDiv");
  if ($plotDiv.data("ocpuplot")) {
    $(window).off("resize");
    $plotDiv.removeData("ocpuplot");
  }
  $plotDiv.children().not(".mk-embed-wrapper").remove();
}

// Removes a leftover interactive-engine .mk-embed-wrapper without touching
// .rplot()'s own DOM/state -- called once the grid engine's new content is
// confirmed ready (see drawChart() in update.js).
function clearEmbedWrapper() {
  $("#plotDiv").children(".mk-embed-wrapper").remove();
}
