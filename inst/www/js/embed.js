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

function injectWidget(html, params) {
  const $plotDiv = $("#plotDiv");

  // Target on-screen size: reuse the same square footprint draw_chart()
  // uses for non-A4 charts (785x785) for visual continuity when toggling
  // engines. A4 front/back never reaches this function -- the interactive
  // radio is hidden for those (see handleEngineVisibility()) -- so this can
  // safely assume square regardless of msr.
  const displaySize = 785;
  const scale = displaySize / EMBED_DESIGN_SIZE;

  $plotDiv.css({ width: displaySize, height: displaySize, "background-image": "none" });

  // Build the new iframe off-screen (absolutely positioned, on top but
  // invisible) so the previous render stays visible until the replacement
  // has actually finished loading -- srcdoc iframes paint blank first, then
  // fetch+run plotly.js/jQuery from the CDN, so swapping in-place on every
  // render (including the very first) produced a visible blank flash.
  const $oldWrapper = $plotDiv.children(".mk-embed-wrapper");

  const $wrapper = $("<div>").addClass("mk-embed-wrapper").css({
    width: displaySize, height: displaySize, overflow: "hidden",
    position: "absolute", top: "-15px", left: "-15px", visibility: "hidden"
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
  });

  $wrapper.append($iframe);
  $plotDiv.css("position", "relative").append($wrapper);
}

// Tears down any .rplot()-managed state (cached ocpuplot controller,
// background-image div, spinner, resize handler) so switching back to the
// grid engine on the same #plotDiv starts clean.
function clearPlotDiv() {
  const $plotDiv = $("#plotDiv");
  if ($plotDiv.data("ocpuplot")) {
    $(window).off("resize");
    $plotDiv.removeData("ocpuplot");
  }
  $plotDiv.empty();
}
