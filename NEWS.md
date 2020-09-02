# james 0.24.2

* Adds table of primary user functions to README
* Adds table of legacy functions indicating preferred alternatives
* Adds function `fetch_loc()` that should take over from `upload_txt()` (which implements client functionality) and `convert_bds_ind()` (which has a terrible name)
* Adds function `calculate_dscore()`
* Transfers the toJSON() call in `custom_list()` to its caller screen_curves(), so `custom_list()` doesn't anymore JSONify the function result
* Adds function `screen_growth()`, a replacement for `screen_curves()` (which is now locked for backward compatibility)
* Adds deprecated warnings to `convert_bds_ind()`, `draw_chart_bds`, `draw_chart_ind` and `screen_curves`

# james 0.24.1 

* Solves a problem in `screen_curves()`. The function now always returns a JSON result

# james 0.24.0

* Re-introduces legacy functions `draw_chart_bds`, `draw_chart_ind`
* Changes `screen_curves` to old bahavior, thus producing a list instead of a table
* Re-introduces arguments `bds_data`, `location`, `ind_loc` and `?ind=`

# james 0.23.0

* Major update incorporating the following **breaking changes** since `james 0.16.0`

1. JAMES now consistently uses the `txt` parameter for JSON child data input, both in the `R` package and in the javascript. This replaces arguments like `bds_data` and `bds`.
2. JAMES now consistently uses the `loc` parameters as the URL with uploaded child data. This replaces arguments named `location`, `ind_loc` and `ind`. The query parameter `?ind=` in URL's is outdated, and superseeded by `?loc=`.
3. All analysis functions now accept `txt` and `loc` input. When both are specified, `txt` takes precedence.
4. For consistency, function `upload_txt` replaces `update_bds`.
5. Function `screen_curves` no longer returns a list, but only the screening results, consistent with its naming. A new function `custom_list` takes over this task from `screen_curves`.
6. Removed functions: `draw_chart_bds`, `draw_chart_ind`, `draw_plot` (replaced by `draw_chart`).

* Enhancements:

1. The site accept now the `?txt=` query parameter, which bypasses the need to upload data.
2. The new function `request_site` constructs URL's for personalised sites.
3. The new function `custom_list` creates a custom list of return values (formerly implemented by `screen_curves`), and adds a new element containing the D-score from the last observation.
4. A new function `update_txt()` to upload data to JAMES
5. The JAMES server location is now independent of the data location, so uploaded data can be stored on an external URL that is under control of the client.
6. The javascript reduces the number of calls via `OpenCPU`, resulting in speedier site updates.
7. Function `draw_chart` gets a new parameter `draw_grob` argument, which allows the user to defer drawing and to tweak the `gTree` object directly.


# james 0.22.1

* Make JAMES server default in `get_host()`
* Tweaks behavior of `draw_chart()` for more intuitive API.
* Change default in `request_site()` to upload
* Solves bug in `get_loc()`

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
