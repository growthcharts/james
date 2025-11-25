# Changelog

## james 1.8.1 (November 2025)

- Solves a problem with nested uploads on `localhost` with end points
  `site/request` and `blend/request`.
- Repairs problems with chart rendering on `james.groeidiagrammen.nl`

## james 1.8.0 (November 2025)

- Added the endpoints `/dcat/calculate`, `/dcat/start` and `/dcat/next`.
  These allow users to perform adaptive testing.
- Endpoints under `/dcat` can now handle gs1 milestone data. See API
  documentation for more detail on how to implement these.
- Added `select_vwc` function to calculate Van Wiechen milestones based
  on age and previously completed milestones.
- Added the endpoint `/dscore/calculate`, which directly returns d-score
  values.

## james 1.7.3 (August 2025)

This is a maintenance release that includes various infrastructure
updates, enhancements to the OpenAPI specification, and minor bug fixes.

### New features

- Adds the template `inst/spec/openapi.in.yaml` and the function
  `james:::update_openapi_spec()`, which updates the OpenAPI template to
  the current JAMES version and saves it as `inst/spec/openapi.yaml`.
  This enables:

  1.  Easy maintenance of the OpenAPI specification.  
  2.  Serving API documentation directly from the JAMES server at
      `https://<host>/docs`, removing the dependency on SwaggerHub.

- Includes versioned JSON schemas (`bds_vx.y.json`) for data exchange,
  now bundled with the package and downloadable from
  `https://<host>/schemas`.

- Updates all `R` and JavaScript code to default to `localhost:8080` as
  the OpenCPU server URL (previously `localhost:80`). Port 8080 is used
  to prevent confusion with Docker or system-level port 80.

- Adds `qmd/JAMES_version_maintaince.qmd`, a Quarto file to be run after
  each version change. This script updates version numbers across the
  package, including the OpenAPI spec, `index.html`, and the
  `getting_started.Rmd` vignette.

### Infrastructure and development changes

- Updates the package to use **R 4.5.0**.

- Cleans `renv.lock` by removing all development-only packages (e.g.,
  `"roxygen2"`, `"devtools"`, `"desc"`, `"evaluate"`, `"jamesdemodata"`,
  `"pkgload"`) and their dependencies. This reduces the package’s
  footprint in production environments.

  After running
  [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html)
  to install production dependencies, call
  `james:::install_dev_packages()` once to install development tools. Do
  not include development packages in `renv.lock`. Only snapshot
  production dependencies defined in the `DESCRIPTION` file using
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).

- Adds a test to `test-request_site()` that demonstrates:

  - How
    [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
    fails on nested data uploads when using `localhost`.  
  - A working alternative solution.

  This change ensures that the `jamesdemo` Shiny app can now also
  demonstrate a fully functioning localhost server.

- Adapts links to reflect the change of BDS-maintenance from NCJ TO
  NICTIZ

- Updates `getting_started.Rmd` to work with localhost:8080 and show
  two-step data upload

## james 1.7.2 (Feb 2025)

- Evades a problem in `vignettes/articles/getting_started.Rmd` that
  occasionally occurs when the `validate = TRUE` flag is active

## james 1.7.1 (Feb 2025)

- Resolves a bug in the de-duplication of parental data in BDS field 63.
  The `bdsreader 0.28.0` package now returns the correct data for these
  cases. See <https://github.com/growthcharts/bdsreader/issues/10>.

## james 1.7.0 (Nov 2024)

- Adds a target height indicator to height charts for ages 1–21 years
  and 0–21 years. The target height is calculated using the mid-parental
  height method described by Hermanussen and Cole (2004). This indicator
  is plotted at the age of 20.5 years and includes the 95% target height
  range. The calculation requires the heights of both biological parents
  (preferred) but can also be performed using only the mother’s height.
  The target height is adjusted based on the child’s sex and the
  population standard used for comparison. In the JAMES interface, the
  target height is automatically recalculated when the user selects a
  different population.

## james 1.6.5 (Oct 2024)

- Solves an issue for same-sex couples with two mothers or two fathers
  in BDS 63 field . The `bdsreader 0.27.0` package returns the correct
  data for these cases. See
  <https://github.com/growthcharts/bdsreader/issues/10>.
- Adds a `inst/CITATION` file for suggestion a citation to JAMES
- Changes the return value of `version` to conform to swagger
  documentation

## james 1.6.4 (May 2024)

- Solves an issue where the week sliders for pre-terms were not properly
  initialized in the case that the child has no data for the first four
  years ([\#6](https://github.com/growthcharts/james/issues/6))

## james 1.6.3 (May 2024)

### Automatic donordata selection

- Simplifies individual prediction by means of curve matching. The user
  needs to specify “now” and “future” age and the number of desired
  matches, and JAMES automatically select appropriate donor data based
  on the “future” age. This update resolves two issues related to choice
  and updating of the donordata menu.
  ([\#5](https://github.com/growthcharts/james/issues/5),
  [\#31](https://github.com/growthcharts/james/issues/31))

## james 1.6.2 (May 2024)

### Better chart initialisation

- When the data contain only developmental data, JAMES initialises to
  the D-score chart
  ([\#33](https://github.com/growthcharts/james/issues/33))

## james 1.6.1 (May 2024)

#### Administrative updates and workflow improvements

- Updates to `R 4.4.0` and associated libraries
- Adds helper `james:::update_version_files()` to automate references to
  current version
  ([\#32](https://github.com/growthcharts/james/issues/32))
- Adds a description of package update actions: `qmd/deploy_JAMES.rmd`
- Updates the GH workflow for package checking

## james 1.6.0 (Apr 2024)

#### Visible changes

- Changes the version number so that the JAMES package has the same
  version as the JAMES docker
- Updates to `growthscreener 1.21.0`, which changes weight for height
  criteria into weight-for-age
- Changes the definition and processing of BDS 71 (parental birth land)
  to provide a string with 4 digits (was numeric and integer previously)
  to conform to alphanumeric typology in BDS (updates to
  `bdsreader 0.25.0`)
- Introduces throttling of 3 sec for checkbox, sliders and radio buttons
- Resolves the WFH sequence problem when later height is shorter
  ([\#24](https://github.com/growthcharts/james/issues/24))
- Added JAMES, version and copyright note to “Meldingen”
- Removed the superfluous header “GROEIDIAGRAMMEN” from the left panel
- Adds a check and warning if the stored OpenCPU session does not
  contain data created by read_bds()

#### More informative `Meldingen` panel

JAMES now writes on `Meldingen` for `rq1`
([`james::convert_tgt_chartadvice()`](https://growthcharts.org/james/reference/convert_tgt_chartadvice.md))
and `rq2`
([`james::draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)):

1.  The session ID
2.  The `ocpu.call` from javascript to the `R` function
3.  A summary of the response from `R`
4.  If present: warnings from `R`
5.  If present: messages from `R`

Note: The update of “Meldingen” when the call failed does always work,
so it may be that “Meldingen” displays the results from the last
functional call instead of the failed call. If the request failed, there
will be a pop-up window with a stack trace from R.

#### Internal changes

- Updates javascript, HTML and CSS for clarity and efficiency
- Moves styling from `index.html` to `main.css`
- Removes allegro blend
  ([\#20](https://github.com/growthcharts/james/issues/20))
- Returns `txt`, `session` and `site` in blend response as strings
  ([\#21](https://github.com/growthcharts/james/issues/21))
- Transfers all event binding functionality from `index.html` into
  `start.js`
- Refactors JS code
  <https://github.com/growthcharts/james/pull/26/#issue-2197694510>
- Updates all packages and renv to CRAN version March 2024

#### Bug fixes

- Fixes a bug during initialization of children \> 4y
  ([\#29](https://github.com/growthcharts/james/issues/29))
- Resolves
  `Error in eval(predvars, data, env) : object 'hgt_z_0' not found`
  ([\#23](https://github.com/growthcharts/james/issues/23))
- Solves issue [\#19](https://github.com/growthcharts/james/issues/19)
  which appears when JAMES cannot find the child data.

#### Simplified update logic

- The JS call to [`update()`](https://rdrr.io/r/stats/update.html)
  (which draws the chart) is now removed from the call-back function of
  `rq1`. Thus, initialization of controls and drawing of charts are now
  done independently and in parallel. This removes a nested
  `ocpu.call()` call, thereby improveing performance.
- This change was undone in 1.5.6 because controls were not properly
  updated.

## james 0.68.0

- Updates all packages, includes `growthscreener 1.20.0`, which include
  language development guideline
- Version meant to test and solve various implementation issues reported
  by K Nienhuis, okt 2023

## james 0.67.0

- Adds support for the `validate` and `intermediate` flags to
  [`upload_data()`](https://growthcharts.org/james/reference/upload_data.md)
- Updates to faster and cleaner `bdsreader` 0.23.0 package

## james 0.66.0

### Solves problems with the javascript interface

1.  The interface did not select the correct chart for `lollypop`
    children. The problem was related to an incorrect gestational age
    field in the demodata. The
    [`bdsreader::write_bds()`](https://rdrr.io/pkg/bdsreader/man/write_bds.html)
    was refactored. All `demodata` were updated with the correct values.

2.  Made a change in the data schema: `Reference` –\> `reference` to
    adhere to `camelCase` in BDS schema

3.  Added a new possibility to run the javascript interface in the local
    environment. See `../notes/debug-javascript.qmd` for details.

4.  Repaired the `chartcode` field in the interface

## james 0.65.0

- Repairs some error in the JSON schema V2.0 and V3.0 by an update to
  `bdsreader 0.19.0`

## james 0.64.0

### Two major enhancements

- Adds support for JSON schema V3.0 by updating to `bdsreader 0.18.0`
- Replaces Dutch D-score charts by GSED Phase 1 references and charts

## james 0.63.0

- Resolves a problem with the weight-for-age references for 0-15 months
- Updates JAMES to latest R packages

## james 0.62.0

- Add pathname in URL construction to make JAMES browsers requests
  reachable when URL is something like htpps://site/path/request.

## james 0.61.0

### A few changes intended to support external hosting of JS functionality:

- Make the href locations of index.html, css and js relative to
  /var/www/html. The directory james/www should be copied into
  /var/www/html/app to make JAMES work.
- Support CORS with hostname in ocpu.seturl()

## james 0.60.0

- Refreshes `renv.lock` by starting from fresh library
- Tweak test to pass windows conf

## james 0.59.2

- Version used to build james docker 1.3.0
- Update packages
- Make library snapshot, update `renv.lock`

## james 0.59.1

- Update all packages
- Make new library snapshot

## james 0.59.0

- Update all packages
- Make new library snapshot

## james 0.58.2

- Make `sitehost` in
  [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
  work with URL path

## james 0.58.1

- Update README and documentation to JAMES API 1.2.0

## james 0.58.0

- Changes to make an isolated `http` API
- Allows for host names such as `http://myhost/module` with a partial
  path
- Reads `OpenCPU` session from the local file system
- Removes `host` arguments to functions
- Removes `host` parameter from javascript calls
- Introduces `sitehost` argument for
  [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
- Update to `jamesclient 0.30.0`

## james 0.57.0

- Makes host definitions consistent everywhere as `http://myhost`
- Uses txt, host, session, format argument sequence in all functions
- Obtains current host and protocol from javascript URL
- Replaces `uloc` session indicator by `uses` (user session)
- Adds arguments `scheme`, `host` and `session` to
  [`convert_tgt_chartadvice()`](https://growthcharts.org/james/reference/convert_tgt_chartadvice.md)
- Renames `$key` to `$session` in JS

## james 0.56.0

### Breaking changes

- Uses generalised `httr` response object as defined in
  `jamesclient 0.26.1`
- Replaces `loc` parameter by `session` parameter
- Adds deprecated notes about the `loc` parameter
- Replaces all calls to
  [`jamesclient::upload_txt()`](https://rdrr.io/pkg/jamesclient/man/upload_txt.html)
  by
  [`jamesclient::james_post()`](https://rdrr.io/pkg/jamesclient/man/james_post.html)
- Update `renv.lock` with `jamesclient` and other R package updates
- Adds processing steps for new `session` query argument

### Other changes

- Moves all deprecated functions into `deprecated.R`
- Creates new `internal.R` to bundle internal helpers
- Removes superfluous `preloads.R`
- Adapts the `last_dscore` calculation to work with `psn` and `xyz` list
  components

## james 0.55.0

- Updates to `renv 0.15.2`
- Update to current R packages

## james 0.54.0

- Upgrades james.groeidiagrammen.nl to https

## james 0.53.0

- Adds host names `ijgz.eaglescience.nl` and `james.groeidiagrammen.nl`
  to `get_host()`

## james 0.52.1

- Updates documentation of
  [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md)

## james 0.52.0

- Breaking change is data structure
- Change data structure of `read_bds()` to a simple list to ease
  standard JSON representation
- Adapt various JAMES functions to work with change to simple list
- Update to `bdsreader 0.17.0`
- Update `renv.lock`

## james 0.51.2

- Remove chart element from
  [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md)
  because of problems with the JSON representation

## james 0.51.1

- Return chart from
  [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md)
  now contains SVG instead of grob

## james 0.51.0

- Add
  [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md)
  that acts like a one-stop-shop
- Deprecate
  [`custom_list()`](https://growthcharts.org/james/reference/custom_list.md)
  in favour of
  [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md)
- Add messages that indicate removal of deprecated function in Sept 2022

## james 0.49.0

- Replace
  [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md)
  and
  [`screen_growth()`](https://growthcharts.org/james/reference/screen_growth-deprecated.md)
  by
  [`apply_screeners()`](https://growthcharts.org/james/reference/apply_screeners.md)
- Make relevant screener parameters visible in james package

## james 0.48.1

- Block passing of `\dots` to
  [`chartbox::list_charts()`](https://rdrr.io/pkg/chartbox/man/list_charts.html)

## james 0.48.0

- Copy over all arguments from
  [`bdsreader::read_bds()`](https://rdrr.io/pkg/bdsreader/man/read_bds.html)
  to
  [`upload_data()`](https://growthcharts.org/james/reference/upload_data.md)
- Update documentation
- Do not pass down `\dots` to `jsonlite::FROMjson()`

## james 0.47.0

- Decrecate
  [`fetch_loc()`](https://growthcharts.org/james/reference/fetch_loc-deprecated.md)
  by the better-named
  [`upload_data()`](https://growthcharts.org/james/reference/upload_data.md)

## james 0.46.3

- Update docs for
  [`fetch_loc()`](https://growthcharts.org/james/reference/fetch_loc-deprecated.md)

## james 0.46.2

- Pass down arguments in all functions using `\dots`
- Sync to `jamesclient 0.23.0`

## james 0.46.1

- Sync to `bdsreader 0.14.0` and `jamesclient 0.22.0`

## james 0.46.0

- Adds
  [`list_screeners()`](https://growthcharts.org/james/reference/list_screeners.md)
  to produce overview of JGZ guidelines

## james 0.45.4

- Send dots in `fetch_loc(...)` to `bdsreader::read_bds(...)`

## james 0.45.3

- Solve authentication bug in
  [`validate_chartcode()`](https://growthcharts.org/james/reference/validate_chartcode.md)

## james 0.45.2

- Vectorise and export
  [`validate_chartcode()`](https://growthcharts.org/james/reference/validate_chartcode.md)

## james 0.45.1

- Update `renv.lock` to `jamesclient 0.20.0`

## james 0.45.0

- Solves a bug in `bdsreader` that prevented reading data from a URL

## james 0.44.1

- Adds a
  [`version()`](https://growthcharts.org/james/reference/version.md)
  function

## james 0.44.0

- Increase dependencies to `bdsreader 0.11.0` and `jamesclient 0.18.0`

## james 0.43.3

- Prevent “the condition has length \> 1 and only the first element will
  be used” in
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)

## james 0.43.2

- Adds forgotten `authenticate` to
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
- Updates renv.lock to `chartplotter 0.28.0`

## james 0.43.1

- Update renv to `donorloader 0.31.1`

## james 0.43.0

- Update renv to `brokenstick 2.0.0`

## james 0.41.1

- Adds an explicit `authToken` argument for
  [`list_charts()`](https://growthcharts.org/james/reference/list_charts.md)

## james 0.42.0

- Refreshes the public key for Eaglescience integration
- Solves a problem with token validation

## james 0.41.0

- Builds in fall back in case `pubkey` is not given to `authenticate`
- Changes argument `jwt` to `authToken` for easy integration

## james 0.40.0

- Repairs a problem with `bdsreader` that prevented D-score calculation
  with format = “2.0”

## james 0.39.0

- Adds authentication of externally facing services with a JSON web
  token

## james 0.38.0

- Adds full stack of Down Syndrome charts to javascript site

## james 0.37.0

### Major changes

- Adds support for data formats “1.0” (Allegro Sultum), “1.1” (numeric
  version) and “2.0” (Eaglescience)
- Introduces the `format` argument to `bds_read()` and `bds_write()`
- Introduces `auto_format` as a way to minimise confusion about the data
  format

### Minor changes

- Uses longer paths in the javascript header to deal with Apache
  rewrites

## james 0.36.0

- Update to R 4.1.0
- Solves a bug that resulted from changes in the internal format of the
  grid package. The james package now depends on `grid 4.1.0` and hence
  on `R >= 4.1`.

## james 0.35.0

- Checks spelling and updates word list
- Adds token to GHA R-CMD-CHECK
- Removes LICENCE file, which makes CMD-CHECK complain
- Install V8 lib in linux workflow

## james 0.34.0

- Update dependency versions
- Removes unneeded `nlreferences` dependency

## james 0.33.0

- Tranfers repo to `growthcharts` organisation
- Adds `schema` argument to users facing functions, set
  `bds_schema_str.json` as default
- Adds automatic GHA R CMD check
- Cleans out error so that R CMD check runs without errors

## james 0.32.0

- Breaking changes
- Replaces `jamestest` dependency by `jamesdemodata` package
- Replaces `minihealth` dependency by `bdsreader` package
- Styles all files
- Switches to `markdown` documentation
- Uses `localhost` in examples (localhost should be on)

## james 0.31.0

- Removes `clopus` dependency

## james 0.30.0

- Uses the `nlreferences` package

## james 0.29.1

- Simplifies testing condition in
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)

## james 0.29.0

- Includes `svglite` dependency as needed by the javascript calls

## james 0.28.2

- Downgrades to `chartplotter 0.15.0`

## james 0.28.1

- Includes `jamesyzy` dependency

## james 0.28.0

- Switches to an age-related choice for donordata: `0-2`, `2-4` and
  `4-18`.

## james 0.27.1

- Repairs a problem in the slider_list initialisation

## james 0.27.0

- Combines `lollypop.term` and `lollypop.preterm` into `lollypop`
- Simplifies donordata menu
- Renames “anthropometric” to “automatic”

## james 0.26.0

- Solves a bug that prevented proper initialisation for 1-21y charts

## james 0.25.0

### Major changes:

- Splits the site output into “Groei”, “Ontwikkeling” and “Voorspeller”
- Add function
  [`fetch_loc()`](https://growthcharts.org/james/reference/fetch_loc-deprecated.md)
  as a replacement for
  [`upload_txt()`](https://rdrr.io/pkg/jamesclient/man/upload_txt.html)
  and
  [`convert_bds_ind()`](https://growthcharts.org/james/reference/convert_bds_ind-deprecated.md)
- Add function
  [`screen_growth()`](https://growthcharts.org/james/reference/screen_growth-deprecated.md)
  as a replacement for
  [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md)
- Add function
  [`calculate_dscore()`](https://growthcharts.org/james/reference/calculate_dscore.md)
- Add table of primary user functions to README
- Add table of legacy functions indicating preferred alternatives
- Run styler on all R sources
- Move out
  [`upload_txt()`](https://rdrr.io/pkg/jamesclient/man/upload_txt.html)
  to `jamesclient` package
- Transfer toJSON() call in
  [`custom_list()`](https://growthcharts.org/james/reference/custom_list.md)
  to its caller screen_curves(), so
  [`custom_list()`](https://growthcharts.org/james/reference/custom_list.md)
  doesn’t anymore JSONify the function result

### Minor changes

- Add deprecated warnings to
  [`convert_bds_ind()`](https://growthcharts.org/james/reference/convert_bds_ind-deprecated.md),
  `draw_chart_bds`, `draw_chart_ind` and `screen_curves`
- Update tests to account for deprecated functions and arguments
- Solve problem in
  [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md).
  The function now always returns a JSON result

## james 0.24.0

- Re-introduce legacy functions `draw_chart_bds`, `draw_chart_ind`
- Change `screen_curves` to old behavior, thus producing a list instead
  of a table
- Re-introduce arguments `bds_data`, `location`, `ind_loc` and `?ind=`

## james 0.23.0

- Major update incorporating the following **breaking changes** since
  `james 0.16.0`

1.  JAMES now consistently uses the `txt` parameter for JSON child data
    input, both in the `R` package and in the javascript. This replaces
    arguments like `bds_data` and `bds`.
2.  JAMES now consistently uses the `loc` parameters as the URL with
    uploaded child data. This replaces arguments named `location`,
    `ind_loc` and `ind`. The query parameter `?ind=` in URL’s is
    outdated, and superseeded by `?loc=`.
3.  All analysis functions now accept `txt` and `loc` input. When both
    are specified, `txt` takes precedence.
4.  For consistency, function `upload_txt` replaces `update_bds`.
5.  Function `screen_curves` no longer returns a list, but only the
    screening results, consistent with its naming. A new function
    `custom_list` takes over this task from `screen_curves`.
6.  Removed functions: `draw_chart_bds`, `draw_chart_ind`, `draw_plot`
    (replaced by `draw_chart`).

- Enhancements:

1.  The site accept now the `?txt=` query parameter, which bypasses the
    need to upload data.
2.  The new function `request_site` constructs URL’s for personalised
    sites.
3.  The new function `custom_list` creates a custom list of return
    values (formerly implemented by `screen_curves`), and adds a new
    element containing the D-score from the last observation.
4.  A new function `update_txt()` to upload data to JAMES
5.  The JAMES server location is now independent of the data location,
    so uploaded data can be stored on an external URL that is under
    control of the client.
6.  The javascript reduces the number of calls via `OpenCPU`, resulting
    in speedier site updates.
7.  Function `draw_chart` gets a new parameter `draw_grob` argument,
    which allows the user to defer drawing and to tweak the `gTree`
    object directly.

## james 0.22.1

- Make JAMES server default in `get_host()`
- Tweaks behavior of
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
  for more intuitive API.
- Change default in
  [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
  to upload
- Solves bug in `get_loc()`

## james 0.22.0

- Uses better defaults (`""` instead of `NULL`) for outward facing
  functions.

## james 0.21.0

- The communication between javascript and R is now based on empty
  strings instead of `null` and `NULL`. \* The site is functional again!

## james 0.20.0

- Major change: Systematic use of `txt` and `loc` arguments in both `R`
  and javascript
- Codes `null` values in javascript by
  [`{}`](https://rdrr.io/r/base/Paren.html) before making request to `R`
- Replaces `is.null(x)` by `!length(x)`
- Removes [`stop()`](https://rdrr.io/r/base/stop.html) within `tryCatch`
- Provides extra argument `txt`, so making `get_tgt()` more intelligent
- Undoes behavior change in
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
  in `0.19.0` because that killed interactivity
- Undoes `dots` in
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
  because that didn’t play well with requests

## james 0.19.0

- [`validate_chartcode()`](https://growthcharts.org/james/reference/validate_chartcode.md)
  is no longer exported, and returns `TRUE`/`FALSE`
- Change of behavior in
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md):
  When the user specifies a valid `chartcode`, then this chart is
  selected, irrespective of `selector`.
- Removes superfluous functions
  [`draw_chart_ind()`](https://growthcharts.org/james/reference/draw_chart_ind-deprecated.md),
  `draw_chart_bds` and `draw_plot()`
- Moves
  [`select_chart()`](https://growthcharts.org/james/reference/select_chart.md)
  arguments in
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
  to dots

## james 0.18.0

- Simplifies
  [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md)
- Moves functionality for Allegro Sultum to
  [`custom_list()`](https://growthcharts.org/james/reference/custom_list.md)
- Adds various getters
- Makes server and data location independent

## james 0.17.0

- Removes some hard paths in
  [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md)
- Add server-sided
  [`upload_txt()`](https://rdrr.io/pkg/jamesclient/man/upload_txt.html)
  for uploading data
- Add server-sided
  [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
  for uploading data and url construction

## james 0.16.0

- This version marges the `dscore` branch, so james now provide a
  `dscore` menu

## james 0.15.1

- Reduce printing to `.val` by
  [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)

## james 0.15.0

- Updated certificates in James and June and ensured that tests produced
  no errors

## james 0.14.4

- Uses fewer brokenstick knots for Terneuzen donordata

## james 0.14.0

- Uses the `svglite` shortcut in the javascript calls. This requires
  `opencpu 2.1.5.1001` and the `Arial` font to be installed on the
  server.

## james 0.10.0

- Set the `max.print` option to 100.000 entries in order to allow for
  printing the full chart list

## james 0.8.0

- Adds function
  [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md)
  for screening on JGZ guidelines. The function also returns the site
  URL, so it acts as a one-stop-shop
- Adds dependencies to `growthscreener`, `jamesclient` and `jsonlite`

## james 0.7.0

- Added: Support for https

## james 0.6.0

- Relocates plotting to new `chartplotter` package
- Removes dependency on `groeidiagrammen` package

## james 0.5.1

- Removes flickering between chart transitions
- De-emphasizes the chartcode field

## james 0.1.0

- Added a `NEWS.md` file to track changes to the package.
