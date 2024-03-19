function handleUIVisibility(chartGroup, ageGroup, population) {
  // Define a mapping for chart group visibility settings
  const chartGroupVisibility = {
    'nl2010': {
      'agegrp_1-21y': 'block',
      'weekmenu': 'none',
      'etnicity': 'block',
    },
    'preterm': {
      'agegrp_1-21y': 'none',
      'weekmenu': 'block',
      'etnicity': 'none',
    },
    'who': {
      'agegrp_1-21y': 'none',
      'weekmenu': 'none',
      'etnicity': 'none',
    },
    'gsed1': {
      'weekmenu_dsc': 'none',
    },
    'gsed1pt': {
      'weekmenu_dsc': 'block',
    }
  };

  // Mapping for age group and population visibility settings
  const ageGroupPopulationVisibility = {
    '0-15m': {
      'nl': {
        'msr_hgt': 'block',
        'msr_wgt': 'block',
        'msr_wfh': 'none',
        'msr_hdc': 'block',
        'msr_bmi': 'none',
        'msr_front': 'block',
        'msr_back': 'block',
      },
      'default': {
        'msr_hgt': 'block',
        'msr_wgt': 'block',
        'msr_wfh': 'none',
        'msr_hdc': 'block',
        'msr_bmi': 'none',
        'msr_front': 'block',
        'msr_back': 'none',
      }
    },
    '0-4y': {
      'nl': {
        'msr_hgt': 'block',
        'msr_wgt': 'block',
        'msr_wfh': 'block',
        'msr_hdc': 'block',
        'msr_bmi': 'none',
        'msr_front': 'block',
        'msr_back': 'block',
      },
      'hs': {
        'msr_hgt': 'block',
        'msr_wgt': 'none',
        'msr_wfh': 'block',
        'msr_hdc': 'none',
        'msr_bmi': 'none',
        'msr_front': 'block',
        'msr_back': 'block',
      },
      'default': {
        'msr_hgt': 'block',
        'msr_wgt': 'none',
        'msr_wfh': 'block',
        'msr_hdc': 'none',
        'msr_bmi': 'none',
        'msr_front': 'block',
        'msr_back': 'none',
      }
    },
    '1-21y': {
      'nl': {
        'msr_hgt': 'block',
        'msr_wgt': 'block',
        'msr_wfh': 'block',
        'msr_hdc': 'block',
        'msr_bmi': 'block',
        'msr_front': 'block',
        'msr_back': 'block',
      },
      'hs': {
        'msr_hgt': 'block',
        'msr_wgt': 'none',
        'msr_wfh': 'block',
        'msr_hdc': 'none',
        'msr_bmi': 'block',
        'msr_front': 'block',
        'msr_back': 'none',
      },
      'default': {
        'msr_hgt': 'block',
        'msr_wgt': 'none',
        'msr_wfh': 'block',
        'msr_hdc': 'block',
        'msr_bmi': 'block',
        'msr_front': 'block',
        'msr_back': 'block',
      }
    }
  };

  // Apply visibility settings for chart group
  Object.entries(chartGroupVisibility[chartGroup] || {}).forEach(([id, display]) => {
    sr(id, display);
  });

  // Apply visibility settings for age group and population
  const agePopSettings = ageGroupPopulationVisibility[ageGroup][population] || ageGroupPopulationVisibility[ageGroup]['default'];
  Object.entries(agePopSettings || {}).forEach(([id, display]) => {
    sr(id, display);
  });
}

// Auxiliary function to modify UI element display property
function sr(id, display) {
  document.getElementById(id).style.display = display;
}
