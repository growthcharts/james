# Package index

## JAMES end points

Main commands to communicate with JAMES

- [`apply_screeners()`](https://growthcharts.org/james/reference/apply_screeners.md)
  : Apply growth screeners to child data
- [`dcat()`](https://growthcharts.org/james/reference/dcat.md) : Applies
  the adaptive test algorithm to determine the next step: administer the
  next item or stop test and return D-score.
- [`dcat_start()`](https://growthcharts.org/james/reference/dcat_start.md)
  : Calculates the start item from age for an adaptive test to measure
  D-score.
- [`dcat_next()`](https://growthcharts.org/james/reference/dcat_next.md)
  : Calculates the next item to administer in an adaptive test to
  measure the D-score. Uses the previously administered items and item
  scores as input.
- [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md)
  : Draw growth chart
- [`list_charts()`](https://growthcharts.org/james/reference/list_charts.md)
  : List available growth charts
- [`list_screeners()`](https://growthcharts.org/james/reference/list_screeners.md)
  : List the available growth screeners
- [`percentiles_vwc()`](https://growthcharts.org/james/reference/percentiles_vwc.md)
  : Provides additional information on percentiles of D-score and age in
  months for the percentiles 2, 10, 50, 90 and 98. User either provides
  known van Wiechen milestones, or information to calculate the
  recommended van Wiechen milestones based on age and past milestones.
- [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md)
  : Provides multiple outputs in one request
- [`request_site()`](https://growthcharts.org/james/reference/request_site.md)
  : Request site containing personalised charts
- [`select_vwc()`](https://growthcharts.org/james/reference/select_vwc.md)
  : Calculates the recommended van Wiechen milestones based on age and
  past milestones
- [`upload_data()`](https://growthcharts.org/james/reference/upload_data.md)
  : Uploads, parses, converts and stores data on the server
- [`validate_chartcode()`](https://growthcharts.org/james/reference/validate_chartcode.md)
  : Validates a growth chart code
- [`version()`](https://growthcharts.org/james/reference/version.md) :
  Reports JAMES version

## Helper functions

Auxiliary functions for JAMES

- [`authenticate()`](https://growthcharts.org/james/reference/authenticate.md)
  : Authentication request
- [`calculate_dscore()`](https://growthcharts.org/james/reference/calculate_dscore.md)
  : Calculates the D-score and DAZ for each visit
- [`convert_tgt_chartadvice()`](https://growthcharts.org/james/reference/convert_tgt_chartadvice.md)
  : Derive advice on chart choice from data
- [`get_session_object()`](https://growthcharts.org/james/reference/get_session_object.md)
  : Load data from a previous OpenCPU session on same host
- [`select_chart()`](https://growthcharts.org/james/reference/select_chart.md)
  : Selects the growth chart

## Deprecated functions

Superceded functionality

- [`convert_bds_ind()`](https://growthcharts.org/james/reference/convert_bds_ind-deprecated.md)
  : Convert json BSD data for single individual to class individual
- [`custom_list()`](https://growthcharts.org/james/reference/custom_list.md)
  : Provides a Screen growth curves according to JGZ guidelines
- [`draw_chart_bds()`](https://growthcharts.org/james/reference/draw_chart_bds-deprecated.md)
  : Convert bds-format data to individual and return growth chart
- [`draw_chart_ind()`](https://growthcharts.org/james/reference/draw_chart_ind-deprecated.md)
  : Draw growth chart with individual data
- [`fetch_loc()`](https://growthcharts.org/james/reference/fetch_loc-deprecated.md)
  : Uploads, parses, converts and stores data on the server for further
  processing
- [`screen_curves()`](https://growthcharts.org/james/reference/screen_curves-deprecated.md)
  : Screen growth curves according to JGZ guidelines
- [`screen_growth()`](https://growthcharts.org/james/reference/screen_growth-deprecated.md)
  : Screen growth curves according to JGZ guidelines
