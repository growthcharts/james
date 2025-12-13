/**
 * File: opencpu-0.5-james-x.y.js
 * Javascript client library for OpenCPU
 * Version 0.5.0
 * -- Adapted for JAMES by Stef van Buuren
 * Depends: jQuery
 * Requires HTML5 FormData support for file uploads
 * http://github.com/jeroenooms/opencpu.js
 *
 * Include this file in your apps and packages.
 * You only need to use ocpu.seturl if this page is hosted outside of the OpenCPU package. For example:
 *
 * ocpu.seturl("../R") //default, use for apps
 * ocpu.seturl("//public.opencpu.org/ocpu/library/mypackage/R") //CORS
 * ocpu.seturl("/ocpu/library/mypackage/R") //hardcode path
 * ocpu.seturl("https://user:secret/my.server.com/ocpu/library/pkg/R") // basic auth
 */

//Warning for the newbies
if (!window.jQuery) {
  alert("Could not find jQuery! The HTML must include jquery.js before opencpu.js!");
}

(function ($) {

  //new Session()
  function Session(loc, key, txt) {
    this.loc = loc;
    this.key = key;
    this.txt = txt;
    this.output = txt.split(/\r\n|\r|\n/g);

    this.getKey = function () {
      return key;
    };

    this.getLoc = function () {
      return loc;
    };

    this.getFile = function (path, success) {
      var url = this.getFileURL(path);
      return $.get(url, success);
    };

    this.getFileURL = function (path) {
      return this.loc + "files/" + path;
    };

    this.getObject = function (name, data, success) {
      //in case of no arguments
      name = name || ".val";

      //first arg is a function
      if (name instanceof Function) {
        //pass on to second arg
        success = name;
        name = ".val";
      }

      var url = this.getLoc() + "R/" + name + "/json";
      return $.get(url, data, success);
    };

    this.getStdout = function (success) {
      var url = this.getLoc() + "stdout/text";
      return $.get(url, success);
    };

    this.getSource = function (success) {
      var url = this.getLoc() + "source/text";
      return $.get(url, success);
    };

    this.getConsole = function (success) {
      var url = this.getLoc() + "console/text";
      return $.get(url, success);
    };

    this.getWarnings = function (success) {
      var url = this.getLoc() + "warnings/text";
      return $.get(url, success);
    };

    this.getMessages = function (success) {
      var url = this.getLoc() + "messages/text";
      return $.get(url, success);
    };
  }

  //for POSTing raw code snippets
  //new Snippet("rnorm(100)")
  function Snippet(code) {
    this.code = code || "NULL";

    this.getCode = function () {
      return code;
    };
  }

  //for POSTing files
  //new Upload($('#file')[0].files)
  function Upload(file) {
    if (file instanceof File) {
      this.file = file;
    } else if (file instanceof FileList) {
      this.file = file[0];
    } else if (file.files instanceof FileList) {
      this.file = file.files[0];
    } else if (file.length > 0 && file[0].files instanceof FileList) {
      this.file = file[0].files[0];
    } else {
      throw 'invalid new Upload(file). Argument file must be a HTML <input type="file"></input>';
    }

    this.getFile = function () {
      return file;
    };
  }

  function stringify(x) {
    if (x instanceof Session) {
      return x.getKey();
    } else if (x instanceof Snippet) {
      return x.getCode();
    } else if (x instanceof Upload) {
      return x.getFile();
    } else if (x instanceof File) {
      return x;
    } else if (x instanceof FileList) {
      return x[0];
    } else if (x && x.files instanceof FileList) {
      return x.files[0];
    } else if (x && x.length && x[0].files instanceof FileList) {
      return x[0].files[0];
    } else {
      return JSON.stringify(x);
    }
  }

  function r_fun_ajax(fun, settings = {}, handler = () => { }) {
    if (!fun) {
      throw new Error("r_fun_ajax: Missing function name (fun)");
    }

    // Build request URL from ocpu.url
    const baseUrl = ocpu.url.replace(/\/$/, "");
    settings.url = settings.url || `${baseUrl}/${fun}`;
    settings.type = settings.type || "POST";
    settings.data = settings.data || {};
    settings.dataType = settings.dataType || "text";

    console.log(`[r_fun_ajax] Requesting: ${settings.url}`);
    console.log("[r_fun_ajax] Settings:", settings);

    // Parse ocpu.url to derive host for session URL
    let derivedHost;

    if (ocpu.url.startsWith("http://") || ocpu.url.startsWith("https://")) {
      // absolute URL → safe to parse
      const ocpuUrl = new URL(ocpu.url);
      derivedHost = `${ocpuUrl.protocol}//${ocpuUrl.host}`;
    } else {
      // relative URL → use window.location origin
      derivedHost = `${window.location.protocol}//${window.location.host}`;
    }

    // Perform AJAX call
    const jqxhr = $.ajax(settings)
      .done((data, textStatus, jqxhr) => {
        const key = jqxhr.getResponseHeader('X-ocpu-session');
        const txt = jqxhr.responseText;

        if (!key) {
          console.warn("[r_fun_ajax] Missing X-ocpu-session header");
          return;
        }

        const sessionPath = `/ocpu/tmp/${key}/`;
        const loc = `${derivedHost}${sessionPath}`;

        console.log("[r_fun_ajax] Session key:", key);
        console.log("[r_fun_ajax] Session URL:", loc);

        // Call handler with Session object
        handler(new Session(loc, key, txt));
      })
      .fail((jqxhr, textStatus, errorThrown) => {
        const errorInfo = {
          function: fun,
          url: settings.url,
          status: jqxhr.status,
          statusText: jqxhr.statusText,
          textStatus: textStatus,
          errorThrown: errorThrown,
          responseText: jqxhr.responseText
        };
        console.error("[r_fun_ajax] OpenCPU error:", errorInfo);
      });

    return jqxhr;  // For chaining or advanced handling
  }

  //call a function using json arguments
  function r_fun_call_json(fun, args, handler) {
    return r_fun_ajax(fun, {
      data: JSON.stringify(args || {}),
      contentType: 'application/json'
    }, handler);
  }

  //call function using url encoding
  //needs to wrap arguments in quotes, etc
  function r_fun_call_urlencoded(fun, args, handler) {
    var data = {};
    $.each(args, function (key, val) {
      data[key] = stringify(val);
    });
    return r_fun_ajax(fun, {
      data: $.param(data)
    }, handler);
  }

  //call a function using multipart/form-data
  //use for file uploads. Requires HTML5
  function r_fun_call_multipart(fun, args, handler) {
    testhtml5();
    var formdata = new FormData();
    $.each(args, function (key, value) {
      formdata.append(key, stringify(value));
    });
    return r_fun_ajax(fun, {
      data: formdata,
      cache: false,
      contentType: false,
      processData: false
    }, handler);
  }

  //Automatically determines type based on argument classes.
  function r_fun_call(fun, args, handler) {
    args = args || {};
    var hasfiles = false;
    var hascode = false;

    //find argument types
    $.each(args, function (key, value) {
      if (value instanceof File || value instanceof Upload || value instanceof FileList) {
        hasfiles = true;
      } else if (value instanceof Snippet || value instanceof Session) {
        hascode = true;
      }
    });

    //determine type
    if (hasfiles) {
      return r_fun_call_multipart(fun, args, handler);
    } else if (hascode) {
      return r_fun_call_urlencoded(fun, args, handler);
    } else {
      return r_fun_call_json(fun, args, handler);
    }
  }

  //call a function and return JSON
  function rpc(fun, args, handler) {
    return r_fun_call(fun, args, function (session) {
      session.getObject(function (data) {
        if (handler) handler(data);
      }).fail(function () {
        console.log("Failed to get JSON response for " + session.getLoc());
      });
    });
  }

  //plotting widget
  //to be called on an (empty) div.
  $.fn.rplot = function (fun, args, cb) {
    var targetdiv = this;
    var myplot = initplot(targetdiv);

    //reset state
    // myplot.setlocation();
    // myplot.spinner.show();

    // call the function
    return r_fun_call(fun, args, function (tmp) {
      myplot.setlocation(tmp.getLoc());

      //call success handler as well
      if (cb) cb(tmp);
    }).always(function () {
      //  myplot.spinner.hide();
    });
  };

  $.fn.graphic = function (session, n) {
    initplot(this).setlocation(session.getLoc(), n || "last");
  };

  function initplot(targetdiv) {
    if (targetdiv.data("ocpuplot")) {
      return targetdiv.data("ocpuplot");
    }
    var ocpuplot = function () {
      //local variables
      var Location;
      var n = "last";
      // var pngwidth;
      // var pngheight;
      var svgwidth;
      var svgheight;

      var plotDiv = $('<div />').attr({
        style: "width: 100%; height:100%; min-width: 100px; min-height: 100px; position:relative; background-repeat:no-repeat; background-size: 100% 100%;"
      }).appendTo(targetdiv).css("background-image", "none");

      var spinner = $('<span />').attr({
        style: "position: absolute; top: 20px; left: 20px; z-index:1000; font-family: monospace;"
      }).text("loading...").appendTo(plotDiv).hide();


      /*
            var pdf = $('<a />').attr({
              target: "_blank",
              style: "position: absolute; top: 10px; right: 10px; z-index:1000; text-decoration:underline; font-family: monospace;"
            }).text("pdf").appendTo(plotDiv);
      
            var svg = $('<a />').attr({
              target: "_blank",
              style: "position: absolute; top: 30px; right: 10px; z-index:1000; text-decoration:underline; font-family: monospace;"
            }).text("svg").appendTo(plotDiv);
      
            var png = $('<a />').attr({
              target: "_blank",
              style: "position: absolute; top: 50px; right: 10px; z-index:1000; text-decoration:underline; font-family: monospace;"
            }).text("png").appendTo(plotDiv);
      */
      /*
            function updatepng(){
              if(!Location) return;
              pngwidth = plotDiv.width();
              pngheight = plotDiv.height();
              plotDiv.css("background-image", "url(" + Location + "graphics/" + n + "/png?width=" + pngwidth + "&height=" + pngheight + ")");
            }
       */
      function updatesvg() {
        if (!Location) return;

        // reserve screen space for A4 charts or square charts
        var msr = document.querySelector('input[name="msr"]:checked').value;
        if (msr === "front" & active !== "ontwikkeling" ||
          msr === "back" & active !== "ontwikkeling") {
          svgwidth = 8.27;
          svgheight = 11.69;
          plotDiv_width = 927;
          plotDiv_height = 1311;
        } else {
          svgwidth = 7.09;
          svgheight = 7.09;
          plotDiv_width = 785;
          plotDiv_height = 785;
        }

        // now plot it, prevent flicker
        // https://stackoverflow.com/questions/22269759/how-to-prevent-a-background-image-flickering-on-change
        var img_tag = new Image(plotDiv_width, plotDiv_height);
        var img_url = Location + "graphics/" + n + "/svglite?width=" + svgwidth + "&height=" + svgheight;
        img_tag.onload = function () {
          plotDiv.css("background-image", "url(" + Location + "graphics/" + n + "/svglite?width=" + svgwidth + "&height=" + svgheight + ")");
          // $("#navcontainer").css("height", plotDiv_height + 15);
          // $("#plotcontainer").css("height", plotDiv_height + 15);
          $("#plotDiv").css("width", plotDiv_width);
          $("#plotDiv").css("height", plotDiv_height);
        };
        img_tag.src = img_url;

        // update the chartcode field
        var url = Location + "R/.val/print";
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
          if (this.readyState == 4 && this.status == 200) {
            var text = String(this.responseText);
            text = text.substring(
              text.lastIndexOf("[") + 1,
              text.lastIndexOf("]"));
            document.getElementById('chartcode').innerHTML = text;
            document.getElementById('chartcode_dsc').innerHTML = text;
            chartcode = text;
          }
        };
        xhttp.open("GET", url, true);
        xhttp.send();
      }

      function setlocation(newloc, newn) {
        n = newn || n;
        Location = newloc;
        if (!Location) {
          //          pdf.hide();
          //          svg.hide();
          //          png.hide();
          plotDiv.css("background-image", "");
        } else {
          // pdf.attr("href", Location + "graphics/" + n + "/pdf?width=8.27&height=11.69&paper=a4").show();
          // svg.attr("href", Location + "graphics/" + n + "/svg?width=7&height=7").show();
          // png.attr("href", Location + "graphics/" + n + "/png?width=800&height=600").show();
          // updatepng();
          updatesvg();
        }
      }

      // function to update the png image
      var onresize = debounce(function (e) {
        //  if(pngwidth == plotDiv.width() && pngheight == plotDiv.height()){
        if (svgwidth == plotDiv.width() / 96 && svgheight == plotDiv.height() / 96) {
          return;
        }
        if (plotDiv.is(":visible")) {
          // updatepng();
          updatesvg();
        }
      }, 500);

      // register update handlers
      plotDiv.on("resize", onresize);
      $(window).on("resize", onresize);

      //return objects
      return {
        setlocation: setlocation,
        spinner: spinner
      };
    }();

    targetdiv.data("ocpuplot", ocpuplot);
    return ocpuplot;
  }

  // from understore.js
  function debounce(func, wait, immediate) {
    var result;
    var timeout = null;
    return function () {
      var context = this, args = arguments;
      var later = function () {
        timeout = null;
        if (!immediate)
          result = func.apply(context, args);
      };
      var callNow = immediate && !timeout;
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
      if (callNow)
        result = func.apply(context, args);
      return result;
    };
  }

  function testhtml5() {
    if (window.FormData === undefined) {
      alert("Uploading of files requires HTML5. It looks like you are using an outdated browser that does not support this. Please install Firefox, Chrome or Internet Explorer 10+");
      throw "HTML5 required.";
    }
  }

  // Define or reuse global ocpu object
  var ocpu = window.ocpu = window.ocpu || {};

  // Define seturl function with validation
  ocpu.seturl = function (path) {
    if (typeof path !== "string" || !path.match(/\/R\/?$/)) {
      console.error("Invalid OpenCPU URL. Must end in '/R'. Got:", path);
      return;
    }
    ocpu.url = path.replace(/\/+$/, "") + "/";
    console.log("OpenCPU base URL set to:", ocpu.url);
  };

  // Auto-detect and set ocpu.url (safe for both local and production)
  (function initOcpuUrl() {
    ocpu.seturl(`${window.location.origin}/ocpu/library/james/R`);
  })();

  // Export remaining functions
  ocpu.call = r_fun_call;
  ocpu.rpc = rpc;
  ocpu.Snippet = Snippet;
  ocpu.Upload = Upload;

  // For older browsers
  if (typeof console == "undefined") {
    this.console = { log: function () { } };
  }

}(jQuery));
