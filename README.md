
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Joint Anthropometric Measurement and Evaluation System (JAMES)

JAMES is an experimental web service for creating and interpreting
charts of child growth and development. The current version

1.  provides access to high-quality growth charts used by the Dutch
    youth health care;
2.  interchanges data coded according to the [Basisdataset
    JGZ](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=13);
3.  screens for abnormal height, weight and head circumference;
4.  converts developmental data into the D-score;
5.  predicts future growth and development.

The service can be used by anyone interested in high-quality charts for
monitoring and evaluating childhood growth. This document highlights
some applications of JAMES, and provides pointers to relevant background
information.

## Check whether JAMES is running

JAMES is currently located at url `groeidiagrammen.nl`. The sections
below use `curl` for illustration, but any `HTTP` client will work.

In order to check whether the JAMES server is running, try generating
some random numbers by calling `stats::rnorm()`, in a terminal window as
follows,

``` bash
curl https://groeidiagrammen.nl/ocpu/library/stats/R/rnorm/json --data n=5
```

## Primary JAMES user functionality

| Function           | Description                            | Interesting URL’s    | Contents                    |
| ------------------ | -------------------------------------- | -------------------- | --------------------------- |
| `list_charts`      | List available growth charts           | `R/.val/json`        | Table of charts, JSON       |
|                    |                                        | `R/.val/text`        | Table of charts, text       |
| `fetch_loc`        | Validate, convert and store input data | `messages/json`      | parse messages, JSON        |
| `draw_chart`       | Draw chart, predict future growth      | `graphics/1/svglite` | chart, `svglite` format     |
|                    |                                        | `graphics/1/png`     | chart, `png` format         |
|                    |                                        | `messages/json`      | parse, graph messages, JSON |
| `request_site`     | Site URL with personalised charts      | `R/.val/json`        | site URL, JSON              |
|                    |                                        | `messages/json`      | parse, site messages, JSON  |
| `calculate_dscore` | Calculate the D-score for each visit   | `R/.val/json`        | D-score table, JSON         |
| `screen_growth`    | Screen growth along JGZ guidelines     | `R/.val/json`        | screening table, JSON       |
|                    |                                        | `messages/json`      | parse, screen msg, JSON     |
| `custom_list`      | Create list with custom returns        | `R/.val/json`        | list of returns, JSON       |

The primary user functions cover out wide range of activities. Let us
look into these in some more detail.

### Available growth charts

The site <https://groeidiagrammen.nl/ocpu/lib/james/www/> provides a
quick round-trip of growth charts. JAMES currently offers 394 different
charts, divided into three chart groups:

1.  140 charts for children of various ethnicities, age groups and
    outcomes (Talma et al. 2010);
2.  240 charts specifically designed for preterms (Bocca-Tjeertes et al.
    2012);
3.  14 charts based on the WHO Child Growth Standards (WHO 2006);

The `list_charts()` function in JAMES function produces a tabular
overview of all charts.

We may uses any HTTP client to download the list of growth charts. Many
systems have the `curl` command already installed. We download the list
into a JSON file by the following request:

``` bash
curl https://groeidiagrammen.nl/ocpu/lib/james/R/list_charts/json -d "" -o ~/Downloads/jamescharts.json
```

A request to `list_charts` on JAMES will yield a response like

``` bash
Response [https://groeidiagrammen.nl/ocpu/library/james/R/list_charts]
  Date: 2020-09-02 13:29
  Status: 201
  Content-Type: text/plain; charset=utf-8
  Size: 248 B
/ocpu/tmp/x07c4471d08dbd3/R/.val
/ocpu/tmp/x07c4471d08dbd3/R/list_charts
/ocpu/tmp/x07c4471d08dbd3/stdout
/ocpu/tmp/x07c4471d08dbd3/source
/ocpu/tmp/x07c4471d08dbd3/console
/ocpu/tmp/x07c4471d08dbd3/info
/ocpu/tmp/x07c4471d08dbd3/files/DESCRIPTION
```

The status is 201 (Resources created), and the unique session `{key}` is
`x07c4471d08dbd3`. Note that this changes with each request, so if you
are replicating these commands, be sure to change `{key}` accordingly.
Session keys and their url’s remain valid for 24 hours. See
<https://www.opencpu.org/api.html> for succinct documentation of the
OpenCPU interface.

Not all information that JAMES return is interesting. In this case, we
would like to see the table of charts in JSON format. We may these
obtain this table from the URL
`https://groeidiagrammen.nl/ocpu/tmp/x07c4471d08dbd3/R/.val/json`. The
first entry looks like

``` json
{
  "chartgrp": "nl2010",
  "chartcode": "HJAA",
  "population": "HS",
  "sex": "male",
  "design": "A",
  "side": "front",
  "language": "dutch",
  "week": ""
}
```

The central field is `chartcode`, which contains a unique 4-7 character
code identifying the particular chart. In this example, code `HJAA`
represents a chart for boys with Indo-Surinamese background (population
`HS`) and design `A` (chart with head circumference, length and weight
for boys aged 0-15 months). The codes are compatible and extend those
used in Talma et al. (2010).

### Requesting a growth chart

We may download growth chart `HJAA` with the `draw_chart()` function as
follows:

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/draw_chart -d "chartcode='HJAA'"
```

This produces the following output

``` bash
/ocpu/tmp/x038e163dc6de71/R/.val
/ocpu/tmp/x038e163dc6de71/R/draw_chart
/ocpu/tmp/x038e163dc6de71/graphics/1
/ocpu/tmp/x038e163dc6de71/stdout
/ocpu/tmp/x038e163dc6de71/source
/ocpu/tmp/x038e163dc6de71/console
/ocpu/tmp/x038e163dc6de71/info
/ocpu/tmp/x038e163dc6de71/files/DESCRIPTION
```

View the chart in the browser by pasting the following into the url
address field:

``` bash
https://groeidiagrammen.nl/ocpu/tmp/x038e163dc6de71/graphics/1/svglite?width=8.27&height=11.69
```

or download the growth chart as

``` bash
curl -o mychart.svg 'https://groeidiagrammen.nl/ocpu/tmp/x038e163dc6de71/graphics/1/svglite?width=8.27&height=11.69' -H 'Cache-Control: max-age=0'
```

In order to obtain the right canvas size, the URL needs to be in quotes
and the request needs `-H 'Cache-Control: max-age=0'` option added.

### Adding data to charts

Until now, we have only seen empty growth charts. This section describes
various ways to add child data to the charts.

#### Data format

The [BDS
JGZ 3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12)
protocol facilitates the exchange of data between parties active in the
Dutch youth health care. The format is basically a codebook of
variables. Each variable has a number: `bdsnummer`. JAMES adopts the
format, and accepts data in JSON format according to a [JSON
schema](https://raw.githubusercontent.com/stefvanbuuren/minihealth/master/inst/json/bds_schema_str.json).

A minimal example of the data according to the schema is:

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json
```

Save the file
[client3.json](https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json)
on your local system by

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json -O
```

which produces a file called `client3.json` in your working directory.

For testing purposes, you may change its values, but please keep the
general structure intact.

#### Charting the child data, JSON file

The following `curl` command uploads and converts the file, and plots
the data on a growth chart:

``` bash
curl -F 'txt=@client3.json' https://groeidiagrammen.nl/ocpu/library/james/R/draw_chart

/ocpu/tmp/x0f59c6526dba8a/R/.val
/ocpu/tmp/x0f59c6526dba8a/R/draw_chart
/ocpu/tmp/x0f59c6526dba8a/graphics/1
/ocpu/tmp/x0f59c6526dba8a/stdout
/ocpu/tmp/x0f59c6526dba8a/source
/ocpu/tmp/x0f59c6526dba8a/console
/ocpu/tmp/x0f59c6526dba8a/info
/ocpu/tmp/x0f59c6526dba8a/files/client3.json
/ocpu/tmp/x0f59c6526dba8a/files/DESCRIPTION
```

As before, you can draw the chart by pasting the following URL in the
browser:

``` bash
https://groeidiagrammen.nl/ocpu/tmp/x0f59c6526dba8a/graphics/1/svglite
```

JAMES automatically selected the length-by-age chart for preterm girls
born at a gestational age of 27 weeks.

#### Charting the child data, JSON string

Send the child’s data as a JSON string instead of a file provides some
more flexibility. The following code assumes that utility `jq` is
installed.

First, convert the JSON file into a JSON string, with double quotes
(`"`) properly escaped.

``` bash
var=$(jq '.' client3.json | jq -sR '.')
echo $var
```

Then run the following command requesting chart code `PMAAN27`:

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/draw_chart -d "txt=$var&chartcode='PMAAN27'&selector='chartcode'"
```

The results returns an URL pointing to an A4 formatted different chart
for preterm girls with the points added.

There are many more options possible. See the help in:

``` bash
curl https://groeidiagrammen.nl/ocpu/lib/james/man/draw_chart/text
```

### Data cache

JAMES takes the following general steps to plot data:

1.  The client sends a request that posts the child data;
2.  The server validates the input;
3.  The server transforms the data into JAMES internal format;
4.  The server adds the data points to the chart;
5.  The server sends a response to the client;
6.  The client interprets the response.

All JAMES functions support the complete set of actions through the
`txt` parameter, as used above. In addition, many functions also accept
the cached result from steps 1-3 as input through the `loc` parameter.
More in particular, the `loc` method saves the result after step 3, and
feeds the location of the converted data into a second request that
applies the plotting. Both `txt` and `loc`methods yield the same result.

The obvious advantage of caching is that validation has only to be done
once. In cases where the user needs multiple analyses for the same
child, for example for building an interactive site, caching may result
in snappier behaviour. It may also be easier to diagnose errors in the
input data. On the other hand, caching also requires some more work on
the client side. The nature of the application determines which method
works best.

#### Example of data cache

An example, let’s create a chart in two steps. We first upload the data
using `fetch_loc`, which accepts JSON input and return the location with
the uploaded data.

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/fetch_loc -d "txt=$var"

/ocpu/tmp/x02691745d874cc/R/.val
/ocpu/tmp/x02691745d874cc/R/fetch_loc
/ocpu/tmp/x02691745d874cc/stdout
/ocpu/tmp/x02691745d874cc/source
/ocpu/tmp/x02691745d874cc/console
/ocpu/tmp/x02691745d874cc/info
/ocpu/tmp/x02691745d874cc/files/DESCRIPTION
```

We create the chart by

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/draw_chart -d "loc='https://groeidiagrammen.nl/ocpu/tmp/x02691745d874cc/'"
```

## Request a dedicated url to the chart site

The child’s data can be plotted on any of the available charts using a
*child chart site*. We can construct a child’s site by means of the
following request.

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/request_site/json -d "txt=$var"
["https://groeidiagrammen.nl/ocpu/lib/james/www/?loc=https://groeidiagrammen.nl/ocpu/tmp/x0dde6c563edb40/"]
```

This command uploads and checks the input data, and appends the result
URL to the site base URL. The combined URL starts a personalised site
with the child’s data.

Alternatively, if we already obtained a `loc` parameters (e.g. by using
`fetch_loc`), we can combine that with the site base URL as follows.

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/request_site/json -d "loc='https://groeidiagrammen.nl/ocpu/tmp/x02691745d874cc/'"
["https://groeidiagrammen.nl/ocpu/lib/james/www/?loc=https://groeidiagrammen.nl/ocpu/tmp/x02691745d874cc/"]
```

There are three ways to choose which chart is being plotted:

1.  JAMES picks a default chart;
2.  The developer provides a `chartcode` parameter;
3.  The end user manipulates the interactive controls.

Options 1 and 2 determine the first chart that is shown to the end user.

#### Site with default chart

The default chart picked by JAMES is currently hard-wired as the child’s
height chart that contains the most recent measurements. If the child is
a pre-term (gestational age \<= 36 weeks) and younger than 4 years, then
JAMES chooses the appropriate preterm chart.

The chart site with the default start can be started by combining the
[uploaded data](https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/)
and the main site at (<https://groeidiagrammen.nl/ocpu/lib/james/www/>)
as

``` bash
curl "https://groeidiagrammen.nl/ocpu/lib/james/www/?loc=https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/"
```

Pasting this url in your browser starts the site with the child’s data.

### Site with developer-specified chart

Starting the site at a given growth chart is possible by specifying the
`chartcode` parameters. For example, we may initialize the site at chart
`PMAAN27` by

``` bash
curl "https://groeidiagrammen.nl/ocpu/lib/james/www/?loc=https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/&chartcode=PMAAN27"
```

The site now starts with `PMAAN27` instead of `PMAHN27`. Any chart can
be chosen. It is the responsability of the developer that the choice is
sensible given the child’s data.

#### Site with user-specified chart

After the site is started the end user may change the chart on which the
data are drawn by simply using the site controls.

## Screen growth curves according to JGZ guidelines

`screen_curves` | Screen growth curves according to JGZ guidelines

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/screen_curves -d "txt=$var"
```

### Create one request with list of return values

`custom_list` | Create JSON string with custom return

## Legacy functionality

This following table lists functions that are active in the current
version, but that we will not further develop. Please replace them by
the suggested alternative.

| Function          | Description                             | Preferred alternative          |
| ----------------- | --------------------------------------- | ------------------------------ |
| `convert_bds_ind` | Validate, convert, store input (server) | `fetch_loc`                    |
| `upload_txt`      | Validate, convert, store input (client) | `jamesclient::upload_txt`      |
| `draw_chart_bds`  | Draw chart from uploaded                | `draw_chart(txt = ...)`        |
| `draw_chart_ind`  | Draw chart from cached data             | `draw_chart(loc = ...)`        |
| `screen_curves`   | Screen growth along JGZ guidelines      | `screen_growth`, `custom_list` |

This following table lists argument names that are active in the current
version, but that will be phased out for consistency. Please replace
them by the suggested alternative.

| Argument   | Description                         | Preferred alternative |
| ---------- | ----------------------------------- | --------------------- |
| `bds_data` | JSON input data                     | `txt`                 |
| `ind_loc`  | Location with cached data.          | `loc`                 |
| `location` | Location with cached data.          | `loc`                 |
| `?ind=`    | URL query parameter for cached data | `?loc=`               |

At some point these functions and argument names will be deprecated and
removed.

## Next steps

Things that were still on the wish list in Sept 2019:

  - transfer JAMES to url james.tno.nl \[wait for docker version\]
  - allow for more input formats \[NOW support for both `txt` and
    `loc`\]
  - add https protocol \[DONE\]
  - add functionality to test for Dutch guidelines for referral \[DONE,
    3 guidelines\]
  - add functionality to predict individual growth curves \[DONE\]
  - extend functionality to include the \(D\)-score charts \[DONE\]

## Architecture

The growth charts in JAMES are programmed in `R`. JAMES makes these
available through the [OpenCPU](https://www.opencpu.org) system for
scientific computing and reproducuble research. The system allows for
easy integration of growth charts into any `HTTP` compliant client by
means of OpenCPU’s [API](https://www.opencpu.org/api.html). JAMES is a
RESTful webservice.

## Resources

  - [OpenCPU system](https://www.opencpu.org)
  - [OpenCPU API](https://www.opencpu.org/api.html)
  - <https://www.w3schools.com/js/>
  - <https://www.tno.nl/groei> and <https://www.tno.nl/growth>
  - <https://github.com/stefvanbuuren/james>
  - <https://github.com/stefvanbuuren/james.client>
  - <https://github.com/stefvanbuuren/minihealth>
  - <https://github.com/stefvanbuuren/brokenstick>

## About

**Work in progress**. Direct suggestions and inquiries to Stef van
Buuren (stef.vanbuuren at tno.nl), <https://stefvanbuuren.name>,
<https://github.com/stefvanbuuren>.

## Literature

<div id="refs" class="references">

<div id="ref-bocca-tjeertes2012">

Bocca-Tjeertes, I. F. A., S. van Buuren, A. F. Bos, J. M. Kerstens, E.
M. ten Vergert, and Reijneveld.S. A. 2012. “Growth of Preterm and
Fullterm Children Aged 0-4 Years: Integrating Median Growth and
Variability in Growth Charts.” *Journal of Pediatrics* 161 (3): 460–65.

</div>

<div id="ref-talma2010">

Talma, H., Y. Schonbeck, B. Bakker, R. A. Hirasing, and S. van Buuren.
2010. *Groeidiagrammen 2010: Handleiding Bij Het Meten En Wegen van
Kinderen En Het Invullen van Groeidiagrammen*. Leiden: TNO Kwaliteit van
Leven.

</div>

<div id="ref-who2006">

WHO, Multicentre Growth Reference Study Group. 2006. “WHO Child Growth
Standards Based on Length/Height, Weight and Age.” *Acta Paediatrica* 95
(Supplement 450): 76–85.

</div>

</div>
