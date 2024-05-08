
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/growthcharts/james/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/growthcharts/james/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

JAMES is a web service for creating and interpreting charts of child
growth and development. The current version

1.  provides access to high-quality growth charts used by the Dutch
    youth health care;
2.  interchanges data coded according to the [Basisdataset JGZ
    4.0.1](https://www.ncj.nl/onderwerp/digitaal-dossier-jgz/bds-jgz-versiebeheer/);
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

| Verb | API Endpoint stem        | Description                             | Maps to `james` function |
|:-----|:-------------------------|:----------------------------------------|:-------------------------|
| POST | `/data/upload/{dfm}`     | Upload child data                       | `upload_data()`          |
| POST | `/charts/draw/{ffm}`     | Draw child data on growth chart         | `draw_chart()`           |
| POST | `/charts/list/{dfm}`     | List available growth charts            | `list_charts()`          |
| POST | `/charts/validate/{dfm}` | Validate a chart code                   | `validate_chartcode()`   |
| POST | `/screeners/apply/{dfm}` | Apply growth screeners to child data    | `apply_screeners()`      |
| POST | `/screeners/list/{dfm}`  | List available growth screeners         | `list_screeners()`       |
| POST | `/site/request/{dfm}`    | Request personalised site               | `request_site()`         |
| POST | `/blend/request/{sfm}`   | Obtain a blend from multiple end points | `request_blend()`        |
| POST | `/version/{dfm}`         | Obtain version information              | `version()`              |
| GET  | `/{session}/{info}`      | Extract session details                 |                          |
| GET  | `/{2}/{1}/man`           | Consult R help                          | `help({1}_{2})`          |

The table lists the defined API end points and the mapping to each end
point to the corresponding R function.

The current OpenAPI definition of JAMES is at
<https://app.swaggerhub.com/apis/stefvanbuuren/james/1.5.4>. Note that
this definition may evolve over time.

## Resources

### Internal

| Description                                                                                              | Status     |
|:---------------------------------------------------------------------------------------------------------|:-----------|
| [Download JAMES docker](https://github.com/growthcharts/jamesdocker/pkgs/container/james)                | restricted |
| [Release notes](https://github.com/growthcharts/jamesdocker/blob/master/NEWS.md)                         | restricted |
| [Example requests](https://james.groeidiagrammen.nl)                                                     | current    |
| [OpenAPI specification](https://app.swaggerhub.com/apis-docs/stefvanbuuren/james)                        | current    |
| [Source files](https://github.com/growthcharts)                                                          | current    |
| [JSON data schema 3.0](https://github.com/growthcharts/bdsreader/blob/master/inst/schemas/bds_v3.0.json) | current    |
| [JAMES issue tracker](https://github.com/growthcharts/james/issues)                                      | current    |

### External

| Description                                                                                            | Status  |
|:-------------------------------------------------------------------------------------------------------|:--------|
| [JAMES demo](https://tnochildhealthstatistics.shinyapps.io/james_tryout/)                              | current |
| [Basisdataset JGZ](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=13) | current |
| [OpenCPU API](https://www.opencpu.org/api.html)                                                        | current |
