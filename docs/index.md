## Overview

JAMES is a web service for creating and interpreting charts of child
growth and development. The current version

1.  provides access to high-quality growth charts used by the Dutch
    youth health care;
2.  interchanges data coded according to the [Basisdataset
    JGZ](https://decor.nictiz.nl/pub/jeugdgezondheidszorg/jgz-html-20240426T081156/index.html);
3.  screens for abnormal height, weight and head circumference;
4.  converts developmental data into the D-score;
5.  predicts future growth and development.

JAMES is a RESTful API that runs on a remote host. The following
sections illustrate how a client can make requests to JAMES using
various client languages. In principle, any `HTTP` client will work with
JAMES. The document highlights some applications of the service and
provides pointers to relevant background information.

The service aids in monitoring and evaluating childhood growth. JAMES is
created and maintained by the Netherlands Organisation for Applied
Scientific Research TNO. Please contact Stef van Buuren \<stef.vanbuuren
at tno.nl\> for further information.

### Primary JAMES user functionality

| Verb | API end point | Description | Maps to `james` function |
|:---|:---|:---|:---|
| POST | `/version/{dfm}` | Obtain version information | [`version()`](https://growthcharts.org/james/reference/version.md) |
| POST | `/data/upload/{dfm}` | Upload child data | [`upload_data()`](https://growthcharts.org/james/reference/upload_data.md) |
|   |   |   |   |
| POST | `/charts/draw/{ffm}` | Draw child data on growth chart | [`draw_chart()`](https://growthcharts.org/james/reference/draw_chart.md) |
| POST | `/charts/list/{dfm}` | List available growth charts | [`list_charts()`](https://growthcharts.org/james/reference/list_charts.md) |
| POST | `/charts/validate/{dfm}` | Validate a chart code | [`validate_chartcode()`](https://growthcharts.org/james/reference/validate_chartcode.md) |
|   |   |   |   |
| POST | `/dscore/calculate/{dfm}` | Calculate developmental score (D-score) | [`calculate_dscore()`](https://growthcharts.org/james/reference/calculate_dscore.md) |
| POST | `/ddomain/calculate/{dfm}` | Calculate domain scores | [`calculate_ddomain()`](https://growthcharts.org/james/reference/calculate_ddomain.md) |
| POST | `/vwc/select/{dfm}` | Select developmental milestones for age | [`select_vwc()`](https://growthcharts.org/james/reference/select_vwc.md) |
| POST | `/vwc/percentiles/{dfm}` | Obtain developmental milestone percentiles | [`percentiles_vwc()`](https://growthcharts.org/james/reference/percentiles_vwc.md) |
| POST | `/dcat/calculate/{dfm}` | Adaptive testing of milestones | [`dcat()`](https://growthcharts.org/james/reference/dcat.md) |
|   |   |   |   |
| POST | `/screeners/list/{dfm}` | List available growth screeners | [`list_screeners()`](https://growthcharts.org/james/reference/list_screeners.md) |
| POST | `/screeners/apply/{dfm}` | Apply growth screeners to child data | [`apply_screeners()`](https://growthcharts.org/james/reference/apply_screeners.md) |
|   |   |   |   |
| GET | `/site` | Request empty site | [`request_site()`](https://growthcharts.org/james/reference/request_site.md) |
| POST | `/site/request/{dfm}` | Request personalised site | [`request_site()`](https://growthcharts.org/james/reference/request_site.md) |
|   |   |   |   |
| POST | `/blend/request/{sfm}` | Obtain a blend from multiple end points | [`request_blend()`](https://growthcharts.org/james/reference/request_blend.md) |
|   |   |   |   |
| GET | `/{session}/{info}` | Extract session details |  |
| GET | `/{2}/{1}/man` | Consult R help | `help({1}_{2})` |

The table lists the defined API end points and the mapping to each end
point to the corresponding R function.

The definition of the JAMES endpoints can be found at [OpenAPI
specification](https://james.groeidiagrammen.nl/docs/).

## Resources

### Internal

| Description | Status |
|:---|:---|
| [Example requests](https://james.groeidiagrammen.nl) | current |
| [OpenAPI specification](https://james.groeidiagrammen.nl/docs/) | current |
| [JSON data schema 3.0](https://james.groeidiagrammen.nl/schemas/bds_v3.0.json) | current |
| [JAMES issue tracker](https://github.com/growthcharts/james/issues) | current |
| [GitHub Organization](https://github.com/growthcharts) | current |

### External

| Description | Status |
|:---|:---|
| [JAMES demo](https://tnochildhealthstatistics.shinyapps.io/james_tryout/) | current |
| [Basisdataset JGZ](https://decor.nictiz.nl/pub/jeugdgezondheidszorg/jgz-html-20240426T081156/index.html) | current |
| [OpenCPU API](https://www.opencpu.org/api.html) | current |
