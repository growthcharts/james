
<!-- README.md is generated from README.Rmd. Please edit that file -->

## james

The `james` package implements the **Joint Anthropometric Measurement
and Evaluation System (JAMES)**, an experimental online resource for
creating growth charts.

The web service can be used by anyone interested in high-quality charts
for monitoring and evaluating childhood growth.

This document explains how to set up communications with JAMES and
provides some guidance in its use.

## Architecture

The growth charts in JAMES are programmed in `R`. JAMES makes these
available through the [OpenCPU](https://www.opencpu.org) system for
scientific computing and reproducuble research. The system allows for
easy integration of growth charts into any `HTTP` compliant client by
means of OpenCPU’s [API](https://www.opencpu.org/api.html). JAMES is a
RESTful webservice.

## Access

JAMES is currently located at url `groeidiagrammen.nl`. The sections
below use `curl` for illustration, but any `HTTP` client will work.

In order to check whether the JAMES server is running, try generating
some random numbers by calling `stats::rnorm()`, in a terminal window as
follows,

``` bash
curl https://groeidiagrammen.nl/ocpu/library/stats/R/rnorm/json --data n=5

[2.259, 0.0538, 1.0583, 0.8665, 0.8412]
```

## What JAMES can currently do

JAMES can currently do four things:

1.  provides access to 342 high-quality growth charts used by the Dutch
    youth health care;
2.  can accept child data in BDS-format;
3.  can create a personalised chart site with child’s data;
4.  can create separate growth charts.

I’ll explain each of these action in more detail below.

## Available growth charts

Copy the [following url](https://groeidiagrammen.nl/ocpu/lib/james/www/)
into your browser to obtain an interactive overview of the available
growth charts:

``` bash
https://groeidiagrammen.nl/ocpu/lib/james/www/
```

There are 342 different charts, each identified with a `chartcode`, a
4-7 character code identifying each design. The `list_charts()` function
in JAMES function can produce a tabular overview. Obtain its help file
as

``` bash
curl https://groeidiagrammen.nl/ocpu/lib/james/man/list_charts/text
```

The list of growth charts can be created by the following request:

``` bash
curl https://groeidiagrammen.nl/ocpu/lib/james/R/list_charts -d ""

/ocpu/tmp/x045d183eddf2f4/R/.val
/ocpu/tmp/x045d183eddf2f4/R/list_charts
/ocpu/tmp/x045d183eddf2f4/stdout
/ocpu/tmp/x045d183eddf2f4/source
/ocpu/tmp/x045d183eddf2f4/console
/ocpu/tmp/x045d183eddf2f4/info
/ocpu/tmp/x045d183eddf2f4/files/DESCRIPTION
```

which return a list of 8 urls created by `OpenCPU`. The table can be
download by

``` bash
curl https://groeidiagrammen.nl/ocpu/tmp/x045d183eddf2f4/R/.val/print

    chartgrp chartcode population    sex design  side language week
1     nl2010      HJAA         HS   male      A front    dutch
2     nl2010      HJAB         HS   male      A  back    dutch
3     nl2010      HJAH         HS   male      A   hgt    dutch
4     nl2010      HJAO         HS   male      A   hdc    dutch
...
```

The chart codes are compatible with the codes used in Talma et al.
(2010).

Note that the session key `x045d183eddf2f4` in the above example is
specific to the call, and will be different for each session. Session
keys and their url’s on the JAMES server will be removed after 24 hours.

## Posting BDS data to JAMES

### Sending the child’s data as a JSON file

Suppose that the child data are coded according to the specification
[BDS
JGZ 3.2.5](https://www.ncj.nl/themadossiers/informatisering/basisdataset/documentatie/?cat=12),
and converted into `JSON` format. The JAMES server contains the
following example:

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json
```

Save the file
[client3.json](https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json)
on your local system by

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/testdata/client3.json -O
```

which produces a file called `client3.json` in your work directory.

For testing purposes, you may change its values (but please keep the
general structure intact) and re-upload it to JAMES for analysis.

The following `curl` command re-uploads and converts the file
`client3.json` from BDS format into an `R` object of S4 class
`minihealth::individual`:

``` bash
curl -F 'txt=@client3.json' https://groeidiagrammen.nl/ocpu/library/james/R/convert_bds_ind

/ocpu/tmp/x06938035d05dac/R/.val
/ocpu/tmp/x06938035d05dac/R/convert_bds_ind
/ocpu/tmp/x06938035d05dac/stdout
/ocpu/tmp/x06938035d05dac/source
/ocpu/tmp/x06938035d05dac/console
/ocpu/tmp/x06938035d05dac/info
/ocpu/tmp/x06938035d05dac/files/client3.json
/ocpu/tmp/x06938035d05dac/files/DESCRIPTION
```

An print version of the result is stored in

``` r
curl https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/R/.val/print

An object of class "individual"
Slot "child":
data frame with 0 columns and 0 rows

Slot "time":
data frame with 0 columns and 0 rows

Slot "id":
[1] 0

Slot "name":
[1] "fa308134-069e-49ce-9847-ccdae380ed6f"

Slot "dob":
[1] "11-10-18"

Slot "src":
[1] "1234"

Slot "dnr":
[1] NA

Slot "sex":
[1] "female"

Slot "etn":
[1] "NL"

Slot "edu":
[1] NA

Slot "ga":
[1] 27

Slot "bw":
[1] 990

Slot "twin":
[1] NA

Slot "agem":
[1] NA

Slot "smo":
[1] 0

Slot "hgtm":
[1] 1670

Slot "wgtm":
[1] NA

Slot "hgtf":
[1] 1900

Slot "wgtf":
[1] NA

Slot "bfexc06":
[1] NA

Slot "durbrst":
[1] NA

Slot "hgt":
package: clopus, library: clopus::nl1997 , member: nl1997.fhgtNL 
     age  hgt     hgt.z
1 0.0849 38.0 -7.943717
2 0.1670 43.5 -6.385568

Slot "wgt":
package: clopus, library: clopus::nl1997 , member: nl1997.fwgtNL 
     age  wgt     wgt.z
1 0.0849 1.25 -8.583512
2 0.1670 2.10 -6.581767

Slot "hdc":
package: clopus, library: clopus::nl1997 , member: nl1997.fhdcNL 
     age  hdc     hdc.z
1 0.0849 27.0 -7.548492
2 0.1670 30.5 -6.066642

Slot "bmi":
package: clopus, library: clopus::nl1997 , member: nl1997.fbmiNL 
     age      bmi     bmi.z
1 0.0849  8.65651 -5.719143
2 0.1670 11.09790 -3.766751

Slot "wfh":
No reference
   hgt  wfh wfh.z
1 38.0 1.25    NA
2 43.5 2.10    NA

Slot "bs.hgt":
package: donordata, model: donordata::smocc_bs , member: hgt 
      age      hgt     hgt.z
1  0.0000 37.63782 -6.929621
2  0.0767 38.73560 -7.445715
3  0.1533 42.68033 -6.591987
4  0.2500 46.91763 -5.895737
5  0.3333 50.40139 -5.332599
6  0.5000 55.73412 -4.619819
7  0.6250 58.76424 -4.255843
8  0.7500 61.29885 -4.003211
9  0.9167 63.95774 -3.879229
10 1.1667 67.36804 -3.820196
11 1.5000 71.67160 -3.603667
12 2.0000 77.18910 -3.270500
13 3.0000 90.09290 -1.771377

Slot "bs.wgt":
package: donordata, model: donordata::smocc_bs , member: wgt 
      age        wgt     wgt.z
1  0.0000  0.9056132 -9.006665
2  0.0767  1.2496280 -8.454686
3  0.1533  1.9393741 -6.894393
4  0.2500  2.8894599 -5.392084
5  0.3333  3.5923136 -4.653004
6  0.5000  4.9277774 -3.525314
7  0.6250  5.5292387 -3.306713
8  0.7500  6.1150749 -3.054297
9  0.9167  6.6887088 -2.946767
10 1.1667  7.3461849 -2.920375
11 1.5000  8.2449663 -2.680337
12 2.0000  9.2358047 -2.608811
13 3.0000 10.7343002 -2.773075

Slot "bs.hdc":
package: donordata, model: donordata::smocc_bs , member: hdc 
      age      hdc     hdc.z
1  0.0000 24.74355 -8.185195
2  0.0767 27.30185 -7.188857
3  0.1533 30.11832 -6.148961
4  0.2500 32.12195 -5.860350
5  0.3333 34.30669 -5.121962
6  0.5000 36.13303 -5.082818
7  0.6250 37.72714 -4.571027
8  0.7500 38.47569 -4.519543
9  0.9167 39.62832 -4.234684
10 1.1667 40.34018 -4.247731
11 1.5000 41.79837 -3.710716
12 2.0000 42.51795 -3.634945
13 3.0000 43.21616 -3.808453

Slot "bs.bmi":
package: donordata, model: donordata::smocc_bs , member: bmi 
      age       bmi     bmi.z
1  0.0000  9.191473 -3.230867
2  0.0767  9.055411 -5.031675
3  0.1533 10.752560 -4.023688
4  0.2500 12.188298 -3.201624
5  0.3333 13.524967 -2.264696
6  0.5000 13.881065 -2.343775
7  0.6250 13.829450 -2.527176
8  0.7500 14.487793 -1.969734
9  0.9167 14.597060 -1.853467
10 1.1667 14.419768 -1.878160
11 1.5000 14.525894 -1.568160
12 2.0000 14.376370 -1.485082
13 3.0000 13.781281 -1.783393

Slot "bs.wfh":
Broken stick model not found.
  hgt wfh wfh.z
1  NA  NA    NA
```

The child’s data on the server may be used for plotting on growth
charts.

### Sending the child’s data as a JSON string

If desired, the child’s data may be sent by a JSON string instead of a
file. The following code assumes that utility `jq` is installed.

First, make the json file into a JSON string, with double quotes (`"`)
properly escaped.

``` bash
var=$(jq '.' client3.json | jq -sR '.')
echo $var
```

Then paste into into the call to the OpenCPU server:

``` bash
curl https://groeidiagrammen.nl/ocpu/library/james/R/convert_bds_ind -d "txt=$var"
```

The results of the string- and file-methods are identical.

## Request a dedicated url to the chart site

The child’s data can be plotted on any of the available charts using a
*child chart site*. There are three ways to choose which chart is being
plotted:

1.  JAMES picks a default chart;
2.  The developer provides a `chartcode` parameter;
3.  The end user manipulates the interactive controls.

Options 1 and 2 determine the first chart that shown to the end user.

### Site with default chart

The default chart picked by JAMES is currently hard-wired as the child’s
height chart that contains the most recent measurements. If the child is
a pre-term (gestational age \<= 36 weeks) and younger than 4 years, then
JAMES chooses the appropriate preterm chart.

The chart site with the default start can be started by combining the
[uploaded data](https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/)
and the main site at (<https://groeidiagrammen.nl/ocpu/lib/james/www/>)
as

``` bash
curl "https://groeidiagrammen.nl/ocpu/lib/james/www/?ind=https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/"
```

Pasting this url in your browser starts the site with the child’s data.

### Site with developer-specified chart

Starting the site at a given growth chart is possible by specifying the
`chartcode` parameters. For example, we may initialize the site at chart
`PMAAN27` by

``` bash
curl "https://groeidiagrammen.nl/ocpu/lib/james/www/?ind=https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/&chartcode=PMAAN27"
```

The site now starts with `PMAAN27` instead of `PMAHN27`. Any chart can
be chosen. It is the responsability of the developer that the choice is
sensible given the child’s data.

### Site with user-specified chart

After the site is started the end user may change the chart on which the
data are drawn by simply using the site controls.

## Requesting a single growth chart

Requesting a single growth chart can be done through the main JAMES
chart drawing function is `draw_chart()`.

The `draw_chart()` function does not yet support the creation of single
graphs. The `draw_chart_bds()` and `draw_chart_ind()` are temporary
specialty functions that can do this. The functions are documented in

``` bash
curl https://groeidiagrammen.nl/ocpu/lib/james/man/draw_chart/text
```

    ##   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
    ##                                  Dload  Upload   Total   Spent    Left  Speed
    ##   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0100  4288    0  4288    0     0  23178      0 --:--:-- --:--:-- --:--:-- 23178
    ## draw_chart                package:james                R Documentation
    ## 
    ## Draw growth chart
    ## 
    ## Description:
    ## 
    ##      The function draw_chart() can read data from an input location
    ##      from a previous call, calculate the chartcode, and plot the
    ##      individual data on the requested growth chart.
    ## 
    ##      The function draw_chart_bds() convert bds data into an object of
    ##      class individual, and then draws the individual data on the
    ##      requested growth chart.
    ## 
    ##      The function draw_chart_ind() expect an input location from a
    ##      previous call, and plots the individual data on the requested
    ##      growth chart.
    ## 
    ## Usage:
    ## 
    ##      draw_chart(
    ##        bds_data = NULL,
    ##        ind_loc = NULL,
    ##        selector = c("derive", "data", "chartcode"),
    ##        chartcode = NULL,
    ##        chartgrp = NULL,
    ##        agegrp = NULL,
    ##        sex = NULL,
    ##        etn = NULL,
    ##        ga = NULL,
    ##        side = "hgt",
    ##        curve_interpolation = TRUE,
    ##        dnr = c("smocc", "terneuzen", "lollypop.preterm", "lollypop.term"),
    ##        lo = NULL,
    ##        hi = NULL,
    ##        nmatch = 0L,
    ##        exact_sex = TRUE,
    ##        exact_ga = FALSE,
    ##        break_ties = FALSE,
    ##        show_realized = FALSE,
    ##        show_future = FALSE,
    ##        ...
    ##      )
    ##      
    ##      draw_chart_bds(txt = NULL, chartcode = NULL, curve_interpolation = TRUE, ...)
    ##      
    ##      draw_chart_ind(
    ##        ind_loc = NULL,
    ##        chartcode = NULL,
    ##        curve_interpolation = TRUE,
    ##        ...
    ##      )
    ##      
    ## Arguments:
    ## 
    ## bds_data: A JSON string, URL or file. Optional.
    ## 
    ##  ind_loc: A url that points to the server location where the data from
    ##           a previous request to convert_bds_ind() are stored. Optional.
    ##           ind_loc takes priority over bds_data.
    ## 
    ## selector: A string, either "derive", "data" or "chartcode", that
    ##           indicates the method to decide which growth chart is drawn.
    ##           Method "derive" (default) calculates the chart from
    ##           parameters chartgrp, agegrp, sex, etn, ga and side parameters
    ##           through the select_chart() function. Method "data" calculates
    ##           the chart from the individual data. Method "chartcode" will
    ##           return the chart specified by the chartcode parameter.
    ## 
    ## chartcode: The code of the requested growth chart, in the case the
    ##           selector == "chartcode".
    ## 
    ## chartgrp: The chart group: 'nl2010', 'preterm', 'who' or character(0)
    ## 
    ##   agegrp: Either '0-15m', '0-4y', '1-21y', '0-21y' or '0-4ya'. Age
    ##           group '0-4ya' provides the 0-4 chart with weight for age
    ##           (design E).
    ## 
    ##      sex: Either 'male' or 'female'
    ## 
    ##      etn: Either 'netherlands', 'turkish', 'moroccan' or 'hindustani'
    ## 
    ##       ga: Gestational age (in completed weeks)
    ## 
    ##     side: Either 'front', 'back', '-hdc' or 'both'
    ## 
    ## curve_interpolation: A logical indicating whether curve interpolation
    ##           shoud be applied.
    ## 
    ##      dnr: A string with the name of the donor data (currently available
    ##           are smocc, terneuzen, lollypop.preterm or lollypop.term)
    ## 
    ##       lo: Value of the left visit coded as string, e.g. "4w" or "7.5m"
    ## 
    ##       hi: Value of the right visit coded as string, e.g. "4w" or "7.5m"
    ## 
    ##   nmatch: Integer. Number of matches needed. When nmatch == 0L no
    ##           matches are sought.
    ## 
    ## exact_sex: A logical indicating whether sex should be matched exactly
    ## 
    ## exact_ga: A logical indicating whether gestational age should be
    ##           matched exactly
    ## 
    ## break_ties: A logical indicating whether ties should broken randomly.
    ##           The default (TRUE) breaks ties randomly.
    ## 
    ## show_realized: A logical indicating whether the realized growth of the
    ##           target child should be drawn
    ## 
    ## show_future: A logical indicating whether the predicted growth of the
    ##           target child should be drawn
    ## 
    ##      ...: For draw_chart_bds, additional parameter passed down to
    ##           fromJSON(txt, ...), new("xyz",... ) and new("bse",... ).
    ##           Useful parameters are models = "bsmodel" for setting the
    ##           broken stick model, or call = as.call(...) for setting proper
    ##           reference standards.
    ## 
    ##      txt: A JSON string, URL or file
    ## 
    ## Value:
    ## 
    ##      tbd
    ## 
    ## Author(s):
    ## 
    ##      Stef van Buuren 2019
    ## 
    ## See Also:
    ## 
    ##      individual, select_chart
    ## 
    ##      individual, select_chart process_chart
    ## 
    ## Examples:
    ## 
    ##      fn <- system.file("testdata", "client3.json", package = "james")
    ##      g <- draw_chart_bds(txt = fn)
    ## 

Use `draw_chart_bds()` to draw chart directly from the BDS data file.

``` r
curl -F 'txt=@client3.json' https://groeidiagrammen.nl/ocpu/library/james/R/draw_chart_bds

/ocpu/tmp/x0a862a7b6829a1/R/.val
/ocpu/tmp/x0a862a7b6829a1/R/draw_chart_bds
/ocpu/tmp/x0a862a7b6829a1/graphics/1
/ocpu/tmp/x0a862a7b6829a1/source
/ocpu/tmp/x0a862a7b6829a1/console
/ocpu/tmp/x0a862a7b6829a1/info
/ocpu/tmp/x0a862a7b6829a1/files/client3.json
/ocpu/tmp/x0a862a7b6829a1/files/DESCRIPTION
```

Download the growth chart as

``` bash
curl -o mychart.svg https://groeidiagrammen.nl/ocpu/tmp/x0a862a7b6829a1/graphics/1/svg
```

or view it in the browser by paste the following into the url address
field:

``` bash
https://groeidiagrammen.nl/ocpu/tmp/x0a862a7b6829a1/graphics/1/svg
```

If the data are already uploaded, we may use `draw_chart_ind()`. Suppose
we want to create the A4 chart for the child. We can do so by

``` bash
curl https://groeidiagrammen.nl/ocpu/lib/james/R/draw_chart_ind -d "ind_loc='https://groeidiagrammen.nl/ocpu/tmp/x06938035d05dac/'&chartcode='PMAAN27'"

/ocpu/tmp/x029e4ee555a9e1/R/.val
/ocpu/tmp/x029e4ee555a9e1/R/draw_chart_ind
/ocpu/tmp/x029e4ee555a9e1/graphics/1
/ocpu/tmp/x029e4ee555a9e1/source
/ocpu/tmp/x029e4ee555a9e1/console
/ocpu/tmp/x029e4ee555a9e1/info
/ocpu/tmp/x029e4ee555a9e1/files/DESCRIPTION
```

where we used the data previously stored from session `x06938035d05dac`.

As before, we may browse the graph by pasting the following in the
address field of the browser:

``` bash
https://groeidiagrammen.nl/ocpu/tmp/x029e4ee555a9e1/graphics/1/svg?width=8.27&height=11.69
```

or download it the the client’s system.

The functions `draw_chart_bds()` and `draw_chart_ind()` address special
cases. When they are integrated in future versions of `draw_chart()`,
both functions will be deprecated.

## A client in `R`

If `R` is your analysis environment, then you can use the `james.client`
package to achieve the same result in an easier way. The functions
`upload_bds()` and `request_chart()` in the `jamesclient` package have
simple syntax, and automate the steps outlined above. See
<https://github.com/stefvanbuuren/jamesclient> for more detail.

## Next steps

Still many things on the wish list:

  - transfer JAMES to url james.tno.nl
  - allow for more input formats
  - add https protocol \[DONE\]
  - add functionality to test for Dutch guidelines for referral \[DONE,
    for length\]
  - add functionality to predict individual growth curves \[DONE\]
  - extend functionality to include the \(D\)-score charts

## Known problems

  - Older versions of Edge (before 44.11763.1.0) do not display charts

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

<div id="ref-talma2010">

Talma, H., Y. Schonbeck, B. Bakker, R. A. Hirasing, and S. van Buuren.
2010. *Groeidiagrammen 2010: Handleiding Bij Het Meten En Wegen van
Kinderen En Het Invullen van Groeidiagrammen*. Leiden: TNO Kwaliteit van
Leven.

</div>

</div>
