// james.js
const urlParams = new URLSearchParams(window.location.search);
const url_data = urlParams.get('url_data');

var chartgrp = document.getElementById('chartgrp');
chartgrp.addEventListener('change', update, false);

var radios = document.forms.agegrp.elements.agegrp;
for(var i = 0, max = radios.length; i < max; i++) {
  radios[i].onclick = function() {
      update();
  };
}

var radios = document.forms.msr.elements.msr;
for(var i = 0, max = radios.length; i < max; i++) {
  radios[i].onclick = function() {
      update();
  };
}

var ga = document.getElementById('ga');
ga.addEventListener('change', update, false);

var radios = document.forms.etnicity.elements.etnicity;
  for(var i = 0, max = radios.length; i < max; i++) {
    radios[i].onclick = function() {
      update();
  };
}

var radios = document.forms.sex.elements.sex;
  for(var i = 0, max = radios.length; i < max; i++) {
    radios[i].onclick = function() {
      update();
  };
}

// initialize
update();
