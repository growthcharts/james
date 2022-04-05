
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Overview

The Joint Automatic Measurement and Evaluation System (JAMES) is a web
service for creating and interpreting charts of child growth and
development. The service aids in monitoring and evaluating childhood
growth. The current version

1.  provides access to high-quality growth charts used by the Dutch
    youth health care;
2.  interchanges data coded according to the Basisdataset JGZ;
3.  screens for abnormal height, weight and head circumference;
4.  converts developmental data into the D-score;
5.  predicts future growth and development.

JAMES is a REST API that runs on a remote host. The following sections
illustrate how a client can make requests to JAMES using R and bash. In
principle, any `HTTP` client will work with JAMES. The document provides
pointers to relevant background information.

## JAMES R Package

The JAMES R package defines the end points of the JAMES REST API.

JAMES is created and maintained by TNO, the Netherlands Organisation for
Applied Scientific Research. Please contact Stef van Buuren
\<stef.vanbuuren at tno.nl> for further information.

## Primary JAMES user functionality

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
| GET  | `/site`                  | Display personalised site               |                          |
| GET  | `/{session}/{info}`      | Extract session details                 |                          |
| GET  | `/{2}/{1}/man`           | Consult R help                          | `help({1}_{2})`          |

The table lists the defined API end points and the mapping to each end
point to the corresponding R function.

## Resources

| Description                                                                                            | Version |
|:-------------------------------------------------------------------------------------------------------|:--------|
| [JAMES demo](https://tnochildhealthstatistics.shinyapps.io/james_tryout/)                              | 1.2.0   |
| [Example requests]()                                                                                   | 1.2.0   |
| [OpenAPI specification](https://app.swaggerhub.com/apis-docs/stefvanbuuren/james)                      | 1.2.0   |
| [JSON data schema](https://github.com/growthcharts/bdsreader/blob/master/inst/schemas/bds_v2.0.json)   | 2.0     |
| [Source files](https://github.com/growthcharts/james)                                                  | current |
| [JAMES issue tracker](https://github.com/growthcharts/james/issues)                                    | current |
| [Basisdataset JGZ](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=13) | current |
