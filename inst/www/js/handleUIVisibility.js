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
    ga = 40;
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
