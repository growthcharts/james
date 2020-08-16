# james 0.22.1

* Tweaks behavior of `draw_chart()` for more intuitive API.
* Change default in `request_site()` to upload

# james 0.22.0

* Uses better defaults (`""` instead of `NULL`) for outward facing functions.

# james 0.21.0

* The communication between javascript and R is now based on empty strings instead of `null` and `NULL`. * The site is functional again!

# james 0.20.0

* Major change: Systematic use of `txt` and `loc` arguments in both `R` and javascript
* Codes `null` values in javascript by `{}` before making request to `R`
* Replaces `is.null(x)` by `!length(x)`
* Removes `stop()` within `tryCatch`
* Provides extra argument `txt`, so making `get_ind()` more intelligent
* Undoes behavior change in `draw_chart()` in `0.19.0` because that killed interactivity
* Undoes `dots` in `draw_chart()` because that didn't play well with requests

# james 0.19.0

* `validate_chartcode()` is no longer exported, and returns `TRUE`/`FALSE`
* Change of behavior in `draw_chart()`: When the user specifies a valid `chartcode`, then this chart is selected, irrespective of `selector`.
* Removes superfluous functions `draw_chart_ind()`, `draw_chart_bds` and `draw_plot()`
* Moves `select_chart()` arguments in `draw_chart()` to dots

# james 0.18.0

* Simplifies `screen_curves()`
* Moves functionality for AllegroSultum to `custom_list()`
* Adds various getters
* Makes server and data location independent

# james 0.17.0 

* Removes some hard paths in `screen_curves()`
* Add server-sided `upload_txt()` for uploading data
* Add server-sided `request_site()` for uploading data and url construction

# james 0.16.0 

* This version marges the `dscore` branch, so james now provide a `dscore` menu

# james 0.15.1 

* Reduce printing to `.val` by `draw_chart()`

# james 0.15.0

* Updated certificates in James and June and ensured that tests produced no errors

# james 0.14.4

* Uses fewer brokenstick knots for Terneuzen donordata

# james 0.14.0

* Uses the `svglite` shortcut in the javascript calls. This requires `opencpu 2.1.5.1001` and the `Arial` font to be installed on the server. 

# james 0.10.0

* Set the `max.print` option to 100.000 entries in order to allow for printing the full chart list

# james 0.8.0

* Adds function `screen_curves()` for screening on JGZ guidelines. The function 
also returns the site URL, so it acts as a one-stop-shop
* Adds dependencies to `growthscreener`, `jamesclient` and `jsonlite`

# james 0.7.0 

* Added: Support for https

# james 0.6.0 

* Relocates plotting to new `chartplotter` package
* Removes dependency on `groeidiagrammen` package

# james 0.5.1

* Removes flickering between chart transitions
* De-emphasizes the chartcode field

# james 0.1.0

* Added a `NEWS.md` file to track changes to the package.
