// handleUIvisibility.js
// Author: Stef van Buuren
// (c) 2024 Netherlands Organisation for Applied Scientific Research TNO, Leiden
// Part of the JAMES package
// Licence: AGPL

function handleUIVisibility(chartgrp, agegrp, population) {
  if (chartgrp == 'nl2010') {
    sr('agegrp_1-21y', 'block');
    sr('weekmenu', 'none');
    sr('etnicity', 'block');
  }
  if (chartgrp == 'preterm') {
    sr('agegrp_1-21y', 'none');
    sr('weekmenu', 'block');
    sr('etnicity', 'none');
  }
  if (chartgrp == 'who') {
    sr('agegrp_1-21y', 'none');
    sr('weekmenu', 'none');
    sr('etnicity', 'none');
  }
  if (chartgrp == 'gsed1') {
    sr('weekmenu_dsc', 'none');
  }
  if (chartgrp == 'gsed1pt') {
    sr('weekmenu_dsc', 'block');
  }

  if (agegrp == '0-15m' & chartgrp == 'nl2010' & population == 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-15m' & chartgrp == 'nl2010' & population != 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-15m' & chartgrp == 'preterm' & population == 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-15m' & chartgrp == 'preterm' & population != 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-15m' & chartgrp == 'who') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population == 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population != 'nl') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-4y' & chartgrp == 'nl2010' & population == 'hs') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '0-4y' & chartgrp == 'preterm') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'block');
    sr('msr_wfh', 'none');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '0-4y' & chartgrp == 'who') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'none');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
  if (agegrp == '1-21y' & population != 'hs') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'block');
    sr('msr_bmi', 'block');
    sr('msr_front', 'block');
    sr('msr_back', 'block');
  }
  if (agegrp == '1-21y' & population == 'hs') {
    sr('msr_hgt', 'block');
    sr('msr_wgt', 'none');
    sr('msr_wfh', 'block');
    sr('msr_hdc', 'none');
    sr('msr_bmi', 'block');
    sr('msr_front', 'block');
    sr('msr_back', 'none');
  }
}

// Auxiliary function to modify UI element display property
function sr(id, display) {
  document.getElementById(id).style.display = display;
}

// Greys out (disables, does not hide) the single "Interactief" checkbox
// for A4 chart layouts (front/back), which have no interactive rendering.
// Only the "groei" card's msr can be front/back; "ontwikkeling"'s is always
// "dsc". Computed unconditionally (not behind an "active === groei" early
// return) so switching to "ontwikkeling" always re-enables the checkbox
// rather than leaving it stuck disabled from a prior A4 selection. The
// checkbox's own checked state is intentionally left untouched while
// disabled, so the user's interactive preference is preserved and
// reapplied automatically when they switch back to a supported msr,
// instead of silently resetting to fixed every time. Rendering itself is
// forced to grid mode for A4 in update() based on msr, not on this checked
// state.
function handleEngineVisibility(active, msr) {
  const isA4 = active === "groei" && (msr === "front" || msr === "back");
  document.getElementById("engine_interactive").disabled = isA4;
}
