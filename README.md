<!-- README.md is generated from README.Rmd. Please edit that file -->

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
Scientific Research TNO. Please contact Stef van Buuren
&lt;stef.vanbuuren at tno.nl&gt; for further information.

### Primary JAMES user functionality

<table style="width:100%;">
<colgroup>
<col style="width: 6%" />
<col style="width: 26%" />
<col style="width: 41%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Verb</th>
<th style="text-align: left;">API end point</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Maps to <code>james</code> function</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/version/{dfm}</code></td>
<td style="text-align: left;">Obtain version information</td>
<td style="text-align: left;"><code>version()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/data/upload/{dfm}</code></td>
<td style="text-align: left;">Upload child data</td>
<td style="text-align: left;"><code>upload_data()</code></td>
</tr>
<tr>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/charts/draw/{ffm}</code></td>
<td style="text-align: left;">Draw child data on growth chart</td>
<td style="text-align: left;"><code>draw_chart()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/charts/list/{dfm}</code></td>
<td style="text-align: left;">List available growth charts</td>
<td style="text-align: left;"><code>list_charts()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/charts/validate/{dfm}</code></td>
<td style="text-align: left;">Validate a chart code</td>
<td style="text-align: left;"><code>validate_chartcode()</code></td>
</tr>
<tr>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/dscore/calculate/{dfm}</code></td>
<td style="text-align: left;">Calculate developmental score
(D-score)</td>
<td style="text-align: left;"><code>calculate_dscore()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/vwc/select/{dfm}</code></td>
<td style="text-align: left;">Select developmental milestones for
age</td>
<td style="text-align: left;"><code>select_vwc()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/vwc/percentiles/{dfm}</code></td>
<td style="text-align: left;">Obtain developmental milestone
percentiles</td>
<td style="text-align: left;"><code>percentiles_vwc()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/dcat/calculate/{dfm}</code></td>
<td style="text-align: left;">Adaptive testing of milestones</td>
<td style="text-align: left;"><code>dcat()</code></td>
</tr>
<tr>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/screeners/list/{dfm}</code></td>
<td style="text-align: left;">List available growth screeners</td>
<td style="text-align: left;"><code>list_screeners()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/screeners/apply/{dfm}</code></td>
<td style="text-align: left;">Apply growth screeners to child data</td>
<td style="text-align: left;"><code>apply_screeners()</code></td>
</tr>
<tr>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
</tr>
<tr>
<td style="text-align: left;">GET</td>
<td style="text-align: left;"><code>/site</code></td>
<td style="text-align: left;">Request empty site</td>
<td style="text-align: left;"><code>request_site()</code></td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/site/request/{dfm}</code></td>
<td style="text-align: left;">Request personalised site</td>
<td style="text-align: left;"><code>request_site()</code></td>
</tr>
<tr>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
</tr>
<tr>
<td style="text-align: left;">POST</td>
<td style="text-align: left;"><code>/blend/request/{sfm}</code></td>
<td style="text-align: left;">Obtain a blend from multiple end
points</td>
<td style="text-align: left;"><code>request_blend()</code></td>
</tr>
<tr>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
<td style="text-align: left;"> </td>
</tr>
<tr>
<td style="text-align: left;">GET</td>
<td style="text-align: left;"><code>/{session}/{info}</code></td>
<td style="text-align: left;">Extract session details</td>
<td style="text-align: left;"></td>
</tr>
<tr>
<td style="text-align: left;">GET</td>
<td style="text-align: left;"><code>/{2}/{1}/man</code></td>
<td style="text-align: left;">Consult R help</td>
<td style="text-align: left;"><code>help({1}_{2})</code></td>
</tr>
</tbody>
</table>

The table lists the defined API end points and the mapping to each end
point to the corresponding R function.

The definition of the JAMES endpoints can be found at [OpenAPI
specification](https://james.groeidiagrammen.nl/docs/).

## Resources

### Internal

<table>
<colgroup>
<col style="width: 57%" />
<col style="width: 42%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Status</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><a
href="https://james.groeidiagrammen.nl">Example requests</a></td>
<td style="text-align: left;">current</td>
</tr>
<tr>
<td style="text-align: left;"><a
href="https://james.groeidiagrammen.nl/docs/">OpenAPI
specification</a></td>
<td style="text-align: left;">current</td>
</tr>
<tr>
<td style="text-align: left;"><a
href="https://james.groeidiagrammen.nl/schemas/bds_v3.0.json">JSON data
schema 3.0</a></td>
<td style="text-align: left;">current</td>
</tr>
<tr>
<td style="text-align: left;"><a
href="https://github.com/growthcharts/james/issues">JAMES issue
tracker</a></td>
<td style="text-align: left;">current</td>
</tr>
<tr>
<td style="text-align: left;"><a
href="https://github.com/growthcharts">GitHub Organization</a></td>
<td style="text-align: left;">current</td>
</tr>
</tbody>
</table>

### External

<table>
<colgroup>
<col style="width: 57%" />
<col style="width: 42%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Status</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><a
href="https://tnochildhealthstatistics.shinyapps.io/james_tryout/">JAMES
demo</a></td>
<td style="text-align: left;">current</td>
</tr>
<tr>
<td style="text-align: left;"><a
href="https://decor.nictiz.nl/pub/jeugdgezondheidszorg/jgz-html-20240426T081156/index.html">Basisdataset
JGZ</a></td>
<td style="text-align: left;">current</td>
</tr>
<tr>
<td style="text-align: left;"><a
href="https://www.opencpu.org/api.html">OpenCPU API</a></td>
<td style="text-align: left;">current</td>
</tr>
</tbody>
</table>
