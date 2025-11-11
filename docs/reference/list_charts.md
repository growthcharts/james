# List available growth charts

List available growth charts

## Usage

``` r
list_charts(chartgrp = NULL, ...)
```

## Arguments

- chartgrp:

  Optional. String chart group name, e.g. `chartgrp = "who"`. If
  omitted, `list_charts()` return all charts groups.

- ...:

  Not used

## Value

A `data.frame` with eight columns:

- `chartgrp`:

  Chart group code

- `chartcode`:

  Unique chart code

- `population`:

  Population code: DS (Down Syndrome), HS (Hindostanic), MA (Morrocan),
  NL (Dutch), PT (Preterm), TU (Turkish), WHOblue (WHO male), WHOpink
  (WHO female)

- `sex`:

  Either `"male"` or `"female"`

- `design`:

  Chart design A: 0-15m, B: 0-4y (WFH), C: 1-21y, D: 0-21y, E: 0-4y
  (WFA)

- `side`:

  Outcome measure: hgt (height), wgt (weight), hdc (head circumference),
  wfh (weight for height), bmi (body mass index), front (multiple), back
  (multiple), -hdc (back, no head circumference)

- `language`:

  Chart language: dutch

- `week`:

  Weeks of gestation 25-36, or missing (\>= 37 weeks)

## Examples

``` r
# list all available charts
list_charts()
#>     chartgrp chartcode population    sex design  side language week
#> 1     nl2010      DJAA         DS   male      A front    dutch     
#> 2     nl2010      DJAB         DS   male      A  back    dutch     
#> 3     nl2010      DJAH         DS   male      A   hgt    dutch     
#> 4     nl2010      DJAO         DS   male      A   hdc    dutch     
#> 5     nl2010      DJAW         DS   male      A   wgt    dutch     
#> 6     nl2010      DJBA         DS   male      B front    dutch     
#> 7     nl2010      DJBB         DS   male      B  back    dutch     
#> 8     nl2010      DJBH         DS   male      B   hgt    dutch     
#> 9     nl2010      DJBO         DS   male      B   hdc    dutch     
#> 10    nl2010      DJBR         DS   male      B   wfh    dutch     
#> 11    nl2010      DJCA         DS   male      C front    dutch     
#> 12    nl2010      DJCB         DS   male      C  back    dutch     
#> 13    nl2010      DJCH         DS   male      C   hgt    dutch     
#> 14    nl2010      DJCO         DS   male      C   hdc    dutch     
#> 15    nl2010      DJCQ         DS   male      C   bmi    dutch     
#> 16    nl2010      DJCR         DS   male      C   wfh    dutch     
#> 17    nl2010      DMAA         DS female      A front    dutch     
#> 18    nl2010      DMAB         DS female      A  back    dutch     
#> 19    nl2010      DMAH         DS female      A   hgt    dutch     
#> 20    nl2010      DMAO         DS female      A   hdc    dutch     
#> 21    nl2010      DMAW         DS female      A   wgt    dutch     
#> 22    nl2010      DMBA         DS female      B front    dutch     
#> 23    nl2010      DMBB         DS female      B  back    dutch     
#> 24    nl2010      DMBH         DS female      B   hgt    dutch     
#> 25    nl2010      DMBO         DS female      B   hdc    dutch     
#> 26    nl2010      DMBR         DS female      B   wfh    dutch     
#> 27    nl2010      DMCA         DS female      C front    dutch     
#> 28    nl2010      DMCB         DS female      C  back    dutch     
#> 29    nl2010      DMCH         DS female      C   hgt    dutch     
#> 30    nl2010      DMCO         DS female      C   hdc    dutch     
#> 31    nl2010      DMCQ         DS female      C   bmi    dutch     
#> 32    nl2010      DMCR         DS female      C   wfh    dutch     
#> 33    nl2010      HJAA         HS   male      A front    dutch     
#> 34    nl2010      HJAB         HS   male      A  back    dutch     
#> 35    nl2010      HJAH         HS   male      A   hgt    dutch     
#> 36    nl2010      HJAO         HS   male      A   hdc    dutch     
#> 37    nl2010      HJAW         HS   male      A   wgt    dutch     
#> 38    nl2010      HJBA         HS   male      B front    dutch     
#> 39    nl2010      HJBC         HS   male      B  -hdc    dutch     
#> 40    nl2010      HJBH         HS   male      B   hgt    dutch     
#> 41    nl2010      HJBR         HS   male      B   wfh    dutch     
#> 42    nl2010      HJCA         HS   male      C front    dutch     
#> 43    nl2010      HJCC         HS   male      C  -hdc    dutch     
#> 44    nl2010      HJCH         HS   male      C   hgt    dutch     
#> 45    nl2010      HJCQ         HS   male      C   bmi    dutch     
#> 46    nl2010      HJCR         HS   male      C   wfh    dutch     
#> 47    nl2010      HMAA         HS female      A front    dutch     
#> 48    nl2010      HMAB         HS female      A  back    dutch     
#> 49    nl2010      HMAH         HS female      A   hgt    dutch     
#> 50    nl2010      HMAO         HS female      A   hdc    dutch     
#> 51    nl2010      HMAW         HS female      A   wgt    dutch     
#> 52    nl2010      HMBA         HS female      B front    dutch     
#> 53    nl2010      HMBC         HS female      B  -hdc    dutch     
#> 54    nl2010      HMBH         HS female      B   hgt    dutch     
#> 55    nl2010      HMBR         HS female      B   wfh    dutch     
#> 56    nl2010      HMCA         HS female      C front    dutch     
#> 57    nl2010      HMCC         HS female      C  -hdc    dutch     
#> 58    nl2010      HMCH         HS female      C   hgt    dutch     
#> 59    nl2010      HMCQ         HS female      C   bmi    dutch     
#> 60    nl2010      HMCR         HS female      C   wfh    dutch     
#> 61    nl2010      MJAA         MA   male      A front    dutch     
#> 62    nl2010      MJAB         MA   male      A  back    dutch     
#> 63    nl2010      MJAH         MA   male      A   hgt    dutch     
#> 64    nl2010      MJAO         MA   male      A   hdc    dutch     
#> 65    nl2010      MJAW         MA   male      A   wgt    dutch     
#> 66    nl2010      MJBA         MA   male      B front    dutch     
#> 67    nl2010      MJBB         MA   male      B  back    dutch     
#> 68    nl2010      MJBH         MA   male      B   hgt    dutch     
#> 69    nl2010      MJBO         MA   male      B   hdc    dutch     
#> 70    nl2010      MJBR         MA   male      B   wfh    dutch     
#> 71    nl2010      MJCA         MA   male      C front    dutch     
#> 72    nl2010      MJCB         MA   male      C  back    dutch     
#> 73    nl2010      MJCH         MA   male      C   hgt    dutch     
#> 74    nl2010      MJCO         MA   male      C   hdc    dutch     
#> 75    nl2010      MJCQ         MA   male      C   bmi    dutch     
#> 76    nl2010      MJCR         MA   male      C   wfh    dutch     
#> 77    nl2010      MMAA         MA female      A front    dutch     
#> 78    nl2010      MMAB         MA female      A  back    dutch     
#> 79    nl2010      MMAH         MA female      A   hgt    dutch     
#> 80    nl2010      MMAO         MA female      A   hdc    dutch     
#> 81    nl2010      MMAW         MA female      A   wgt    dutch     
#> 82    nl2010      MMBA         MA female      B front    dutch     
#> 83    nl2010      MMBB         MA female      B  back    dutch     
#> 84    nl2010      MMBH         MA female      B   hgt    dutch     
#> 85    nl2010      MMBO         MA female      B   hdc    dutch     
#> 86    nl2010      MMBR         MA female      B   wfh    dutch     
#> 87    nl2010      MMCA         MA female      C front    dutch     
#> 88    nl2010      MMCB         MA female      C  back    dutch     
#> 89    nl2010      MMCH         MA female      C   hgt    dutch     
#> 90    nl2010      MMCO         MA female      C   hdc    dutch     
#> 91    nl2010      MMCQ         MA female      C   bmi    dutch     
#> 92    nl2010      MMCR         MA female      C   wfh    dutch     
#> 93    nl2010      NJAA         NL   male      A front    dutch     
#> 94    nl2010      NJAB         NL   male      A  back    dutch     
#> 95    nl2010      NJAD         NL   male      A   dsc    dutch     
#> 96    nl2010      NJAH         NL   male      A   hgt    dutch     
#> 97    nl2010      NJAO         NL   male      A   hdc    dutch     
#> 98    nl2010      NJAW         NL   male      A   wgt    dutch     
#> 99    nl2010      NJBA         NL   male      B front    dutch     
#> 100   nl2010      NJBB         NL   male      B  back    dutch     
#> 101   nl2010      NJBC         NL   male      B  -hdc    dutch     
#> 102   nl2010      NJBD         NL   male      B   dsc    dutch     
#> 103   nl2010      NJBH         NL   male      B   hgt    dutch     
#> 104   nl2010      NJBO         NL   male      B   hdc    dutch     
#> 105   nl2010      NJBR         NL   male      B   wfh    dutch     
#> 106   nl2010      NJCA         NL   male      C front    dutch     
#> 107   nl2010      NJCB         NL   male      C  back    dutch     
#> 108   nl2010      NJCH         NL   male      C   hgt    dutch     
#> 109   nl2010      NJCO         NL   male      C   hdc    dutch     
#> 110   nl2010      NJCQ         NL   male      C   bmi    dutch     
#> 111   nl2010      NJCR         NL   male      C   wfh    dutch     
#> 112   nl2010      NJEA         NL   male      E front    dutch     
#> 113   nl2010      NJEB         NL   male      E  back    dutch     
#> 114   nl2010      NJEH         NL   male      E   hgt    dutch     
#> 115   nl2010      NJEO         NL   male      E   hdc    dutch     
#> 116   nl2010      NJEW         NL   male      E   wgt    dutch     
#> 117   nl2010      NMAA         NL female      A front    dutch     
#> 118   nl2010      NMAB         NL female      A  back    dutch     
#> 119   nl2010      NMAD         NL female      A   dsc    dutch     
#> 120   nl2010      NMAH         NL female      A   hgt    dutch     
#> 121   nl2010      NMAO         NL female      A   hdc    dutch     
#> 122   nl2010      NMAW         NL female      A   wgt    dutch     
#> 123   nl2010      NMBA         NL female      B front    dutch     
#> 124   nl2010      NMBB         NL female      B  back    dutch     
#> 125   nl2010      NMBC         NL female      B  -hdc    dutch     
#> 126   nl2010      NMBD         NL female      B   dsc    dutch     
#> 127   nl2010      NMBH         NL female      B   hgt    dutch     
#> 128   nl2010      NMBO         NL female      B   hdc    dutch     
#> 129   nl2010      NMBR         NL female      B   wfh    dutch     
#> 130   nl2010      NMCA         NL female      C front    dutch     
#> 131   nl2010      NMCB         NL female      C  back    dutch     
#> 132   nl2010      NMCH         NL female      C   hgt    dutch     
#> 133   nl2010      NMCO         NL female      C   hdc    dutch     
#> 134   nl2010      NMCQ         NL female      C   bmi    dutch     
#> 135   nl2010      NMCR         NL female      C   wfh    dutch     
#> 136   nl2010      NMEA         NL female      E front    dutch     
#> 137   nl2010      NMEB         NL female      E  back    dutch     
#> 138   nl2010      NMEH         NL female      E   hgt    dutch     
#> 139   nl2010      NMEO         NL female      E   hdc    dutch     
#> 140   nl2010      NMEW         NL female      E   wgt    dutch     
#> 141   nl2010      TJAA         TU   male      A front    dutch     
#> 142   nl2010      TJAB         TU   male      A  back    dutch     
#> 143   nl2010      TJAH         TU   male      A   hgt    dutch     
#> 144   nl2010      TJAO         TU   male      A   hdc    dutch     
#> 145   nl2010      TJAW         TU   male      A   wgt    dutch     
#> 146   nl2010      TJBA         TU   male      B front    dutch     
#> 147   nl2010      TJBB         TU   male      B  back    dutch     
#> 148   nl2010      TJBH         TU   male      B   hgt    dutch     
#> 149   nl2010      TJBO         TU   male      B   hdc    dutch     
#> 150   nl2010      TJBR         TU   male      B   wfh    dutch     
#> 151   nl2010      TJCA         TU   male      C front    dutch     
#> 152   nl2010      TJCB         TU   male      C  back    dutch     
#> 153   nl2010      TJCH         TU   male      C   hgt    dutch     
#> 154   nl2010      TJCO         TU   male      C   hdc    dutch     
#> 155   nl2010      TJCQ         TU   male      C   bmi    dutch     
#> 156   nl2010      TJCR         TU   male      C   wfh    dutch     
#> 157   nl2010      TMAA         TU female      A front    dutch     
#> 158   nl2010      TMAB         TU female      A  back    dutch     
#> 159   nl2010      TMAH         TU female      A   hgt    dutch     
#> 160   nl2010      TMAO         TU female      A   hdc    dutch     
#> 161   nl2010      TMAW         TU female      A   wgt    dutch     
#> 162   nl2010      TMBA         TU female      B front    dutch     
#> 163   nl2010      TMBB         TU female      B  back    dutch     
#> 164   nl2010      TMBH         TU female      B   hgt    dutch     
#> 165   nl2010      TMBO         TU female      B   hdc    dutch     
#> 166   nl2010      TMBR         TU female      B   wfh    dutch     
#> 167   nl2010      TMCA         TU female      C front    dutch     
#> 168   nl2010      TMCB         TU female      C  back    dutch     
#> 169   nl2010      TMCH         TU female      C   hgt    dutch     
#> 170   nl2010      TMCO         TU female      C   hdc    dutch     
#> 171   nl2010      TMCQ         TU female      C   bmi    dutch     
#> 172   nl2010      TMCR         TU female      C   wfh    dutch     
#> 173  preterm   PJAAN25         PT   male      A front    dutch   25
#> 174  preterm   PJAAN26         PT   male      A front    dutch   26
#> 175  preterm   PJAAN27         PT   male      A front    dutch   27
#> 176  preterm   PJAAN28         PT   male      A front    dutch   28
#> 177  preterm   PJAAN29         PT   male      A front    dutch   29
#> 178  preterm   PJAAN30         PT   male      A front    dutch   30
#> 179  preterm   PJAAN31         PT   male      A front    dutch   31
#> 180  preterm   PJAAN32         PT   male      A front    dutch   32
#> 181  preterm   PJAAN33         PT   male      A front    dutch   33
#> 182  preterm   PJAAN34         PT   male      A front    dutch   34
#> 183  preterm   PJAAN35         PT   male      A front    dutch   35
#> 184  preterm   PJAAN36         PT   male      A front    dutch   36
#> 185  preterm   PJABN25         PT   male      A  back    dutch   25
#> 186  preterm   PJABN26         PT   male      A  back    dutch   26
#> 187  preterm   PJABN27         PT   male      A  back    dutch   27
#> 188  preterm   PJABN28         PT   male      A  back    dutch   28
#> 189  preterm   PJABN29         PT   male      A  back    dutch   29
#> 190  preterm   PJABN30         PT   male      A  back    dutch   30
#> 191  preterm   PJABN31         PT   male      A  back    dutch   31
#> 192  preterm   PJABN32         PT   male      A  back    dutch   32
#> 193  preterm   PJABN33         PT   male      A  back    dutch   33
#> 194  preterm   PJABN34         PT   male      A  back    dutch   34
#> 195  preterm   PJABN35         PT   male      A  back    dutch   35
#> 196  preterm   PJABN36         PT   male      A  back    dutch   36
#> 197  preterm   PJADN25         PT   male      A   dsc    dutch   25
#> 198  preterm   PJADN26         PT   male      A   dsc    dutch   26
#> 199  preterm   PJADN27         PT   male      A   dsc    dutch   27
#> 200  preterm   PJADN28         PT   male      A   dsc    dutch   28
#> 201  preterm   PJADN29         PT   male      A   dsc    dutch   29
#> 202  preterm   PJADN30         PT   male      A   dsc    dutch   30
#> 203  preterm   PJADN31         PT   male      A   dsc    dutch   31
#> 204  preterm   PJADN32         PT   male      A   dsc    dutch   32
#> 205  preterm   PJADN33         PT   male      A   dsc    dutch   33
#> 206  preterm   PJADN34         PT   male      A   dsc    dutch   34
#> 207  preterm   PJADN35         PT   male      A   dsc    dutch   35
#> 208  preterm   PJADN36         PT   male      A   dsc    dutch   36
#> 209  preterm   PJAHN25         PT   male      A   hgt    dutch   25
#> 210  preterm   PJAHN26         PT   male      A   hgt    dutch   26
#> 211  preterm   PJAHN27         PT   male      A   hgt    dutch   27
#> 212  preterm   PJAHN28         PT   male      A   hgt    dutch   28
#> 213  preterm   PJAHN29         PT   male      A   hgt    dutch   29
#> 214  preterm   PJAHN30         PT   male      A   hgt    dutch   30
#> 215  preterm   PJAHN31         PT   male      A   hgt    dutch   31
#> 216  preterm   PJAHN32         PT   male      A   hgt    dutch   32
#> 217  preterm   PJAHN33         PT   male      A   hgt    dutch   33
#> 218  preterm   PJAHN34         PT   male      A   hgt    dutch   34
#> 219  preterm   PJAHN35         PT   male      A   hgt    dutch   35
#> 220  preterm   PJAHN36         PT   male      A   hgt    dutch   36
#> 221  preterm   PJAON25         PT   male      A   hdc    dutch   25
#> 222  preterm   PJAON26         PT   male      A   hdc    dutch   26
#> 223  preterm   PJAON27         PT   male      A   hdc    dutch   27
#> 224  preterm   PJAON28         PT   male      A   hdc    dutch   28
#> 225  preterm   PJAON29         PT   male      A   hdc    dutch   29
#> 226  preterm   PJAON30         PT   male      A   hdc    dutch   30
#> 227  preterm   PJAON31         PT   male      A   hdc    dutch   31
#> 228  preterm   PJAON32         PT   male      A   hdc    dutch   32
#> 229  preterm   PJAON33         PT   male      A   hdc    dutch   33
#> 230  preterm   PJAON34         PT   male      A   hdc    dutch   34
#> 231  preterm   PJAON35         PT   male      A   hdc    dutch   35
#> 232  preterm   PJAON36         PT   male      A   hdc    dutch   36
#> 233  preterm   PJAWN25         PT   male      A   wgt    dutch   25
#> 234  preterm   PJAWN26         PT   male      A   wgt    dutch   26
#> 235  preterm   PJAWN27         PT   male      A   wgt    dutch   27
#> 236  preterm   PJAWN28         PT   male      A   wgt    dutch   28
#> 237  preterm   PJAWN29         PT   male      A   wgt    dutch   29
#> 238  preterm   PJAWN30         PT   male      A   wgt    dutch   30
#> 239  preterm   PJAWN31         PT   male      A   wgt    dutch   31
#> 240  preterm   PJAWN32         PT   male      A   wgt    dutch   32
#> 241  preterm   PJAWN33         PT   male      A   wgt    dutch   33
#> 242  preterm   PJAWN34         PT   male      A   wgt    dutch   34
#> 243  preterm   PJAWN35         PT   male      A   wgt    dutch   35
#> 244  preterm   PJAWN36         PT   male      A   wgt    dutch   36
#> 245  preterm   PJEAN25         PT   male      E front    dutch   25
#> 246  preterm   PJEAN26         PT   male      E front    dutch   26
#> 247  preterm   PJEAN27         PT   male      E front    dutch   27
#> 248  preterm   PJEAN28         PT   male      E front    dutch   28
#> 249  preterm   PJEAN29         PT   male      E front    dutch   29
#> 250  preterm   PJEAN30         PT   male      E front    dutch   30
#> 251  preterm   PJEAN31         PT   male      E front    dutch   31
#> 252  preterm   PJEAN32         PT   male      E front    dutch   32
#> 253  preterm   PJEAN33         PT   male      E front    dutch   33
#> 254  preterm   PJEAN34         PT   male      E front    dutch   34
#> 255  preterm   PJEAN35         PT   male      E front    dutch   35
#> 256  preterm   PJEAN36         PT   male      E front    dutch   36
#> 257  preterm   PJEDN25         PT   male      E   dsc    dutch   25
#> 258  preterm   PJEDN26         PT   male      E   dsc    dutch   26
#> 259  preterm   PJEDN27         PT   male      E   dsc    dutch   27
#> 260  preterm   PJEDN28         PT   male      E   dsc    dutch   28
#> 261  preterm   PJEDN29         PT   male      E   dsc    dutch   29
#> 262  preterm   PJEDN30         PT   male      E   dsc    dutch   30
#> 263  preterm   PJEDN31         PT   male      E   dsc    dutch   31
#> 264  preterm   PJEDN32         PT   male      E   dsc    dutch   32
#> 265  preterm   PJEDN33         PT   male      E   dsc    dutch   33
#> 266  preterm   PJEDN34         PT   male      E   dsc    dutch   34
#> 267  preterm   PJEDN35         PT   male      E   dsc    dutch   35
#> 268  preterm   PJEDN36         PT   male      E   dsc    dutch   36
#> 269  preterm   PJEHN25         PT   male      E   hgt    dutch   25
#> 270  preterm   PJEHN26         PT   male      E   hgt    dutch   26
#> 271  preterm   PJEHN27         PT   male      E   hgt    dutch   27
#> 272  preterm   PJEHN28         PT   male      E   hgt    dutch   28
#> 273  preterm   PJEHN29         PT   male      E   hgt    dutch   29
#> 274  preterm   PJEHN30         PT   male      E   hgt    dutch   30
#> 275  preterm   PJEHN31         PT   male      E   hgt    dutch   31
#> 276  preterm   PJEHN32         PT   male      E   hgt    dutch   32
#> 277  preterm   PJEHN33         PT   male      E   hgt    dutch   33
#> 278  preterm   PJEHN34         PT   male      E   hgt    dutch   34
#> 279  preterm   PJEHN35         PT   male      E   hgt    dutch   35
#> 280  preterm   PJEHN36         PT   male      E   hgt    dutch   36
#> 281  preterm   PJEWN25         PT   male      E   wgt    dutch   25
#> 282  preterm   PJEWN26         PT   male      E   wgt    dutch   26
#> 283  preterm   PJEWN27         PT   male      E   wgt    dutch   27
#> 284  preterm   PJEWN28         PT   male      E   wgt    dutch   28
#> 285  preterm   PJEWN29         PT   male      E   wgt    dutch   29
#> 286  preterm   PJEWN30         PT   male      E   wgt    dutch   30
#> 287  preterm   PJEWN31         PT   male      E   wgt    dutch   31
#> 288  preterm   PJEWN32         PT   male      E   wgt    dutch   32
#> 289  preterm   PJEWN33         PT   male      E   wgt    dutch   33
#> 290  preterm   PJEWN34         PT   male      E   wgt    dutch   34
#> 291  preterm   PJEWN35         PT   male      E   wgt    dutch   35
#> 292  preterm   PJEWN36         PT   male      E   wgt    dutch   36
#> 293  preterm   PMAAN25         PT female      A front    dutch   25
#> 294  preterm   PMAAN26         PT female      A front    dutch   26
#> 295  preterm   PMAAN27         PT female      A front    dutch   27
#> 296  preterm   PMAAN28         PT female      A front    dutch   28
#> 297  preterm   PMAAN29         PT female      A front    dutch   29
#> 298  preterm   PMAAN30         PT female      A front    dutch   30
#> 299  preterm   PMAAN31         PT female      A front    dutch   31
#> 300  preterm   PMAAN32         PT female      A front    dutch   32
#> 301  preterm   PMAAN33         PT female      A front    dutch   33
#> 302  preterm   PMAAN34         PT female      A front    dutch   34
#> 303  preterm   PMAAN35         PT female      A front    dutch   35
#> 304  preterm   PMAAN36         PT female      A front    dutch   36
#> 305  preterm   PMABN25         PT female      A  back    dutch   25
#> 306  preterm   PMABN26         PT female      A  back    dutch   26
#> 307  preterm   PMABN27         PT female      A  back    dutch   27
#> 308  preterm   PMABN28         PT female      A  back    dutch   28
#> 309  preterm   PMABN29         PT female      A  back    dutch   29
#> 310  preterm   PMABN30         PT female      A  back    dutch   30
#> 311  preterm   PMABN31         PT female      A  back    dutch   31
#> 312  preterm   PMABN32         PT female      A  back    dutch   32
#> 313  preterm   PMABN33         PT female      A  back    dutch   33
#> 314  preterm   PMABN34         PT female      A  back    dutch   34
#> 315  preterm   PMABN35         PT female      A  back    dutch   35
#> 316  preterm   PMABN36         PT female      A  back    dutch   36
#> 317  preterm   PMADN25         PT female      A   dsc    dutch   25
#> 318  preterm   PMADN26         PT female      A   dsc    dutch   26
#> 319  preterm   PMADN27         PT female      A   dsc    dutch   27
#> 320  preterm   PMADN28         PT female      A   dsc    dutch   28
#> 321  preterm   PMADN29         PT female      A   dsc    dutch   29
#> 322  preterm   PMADN30         PT female      A   dsc    dutch   30
#> 323  preterm   PMADN31         PT female      A   dsc    dutch   31
#> 324  preterm   PMADN32         PT female      A   dsc    dutch   32
#> 325  preterm   PMADN33         PT female      A   dsc    dutch   33
#> 326  preterm   PMADN34         PT female      A   dsc    dutch   34
#> 327  preterm   PMADN35         PT female      A   dsc    dutch   35
#> 328  preterm   PMADN36         PT female      A   dsc    dutch   36
#> 329  preterm   PMAHN25         PT female      A   hgt    dutch   25
#> 330  preterm   PMAHN26         PT female      A   hgt    dutch   26
#> 331  preterm   PMAHN27         PT female      A   hgt    dutch   27
#> 332  preterm   PMAHN28         PT female      A   hgt    dutch   28
#> 333  preterm   PMAHN29         PT female      A   hgt    dutch   29
#> 334  preterm   PMAHN30         PT female      A   hgt    dutch   30
#> 335  preterm   PMAHN31         PT female      A   hgt    dutch   31
#> 336  preterm   PMAHN32         PT female      A   hgt    dutch   32
#> 337  preterm   PMAHN33         PT female      A   hgt    dutch   33
#> 338  preterm   PMAHN34         PT female      A   hgt    dutch   34
#> 339  preterm   PMAHN35         PT female      A   hgt    dutch   35
#> 340  preterm   PMAHN36         PT female      A   hgt    dutch   36
#> 341  preterm   PMAON25         PT female      A   hdc    dutch   25
#> 342  preterm   PMAON26         PT female      A   hdc    dutch   26
#> 343  preterm   PMAON27         PT female      A   hdc    dutch   27
#> 344  preterm   PMAON28         PT female      A   hdc    dutch   28
#> 345  preterm   PMAON29         PT female      A   hdc    dutch   29
#> 346  preterm   PMAON30         PT female      A   hdc    dutch   30
#> 347  preterm   PMAON31         PT female      A   hdc    dutch   31
#> 348  preterm   PMAON32         PT female      A   hdc    dutch   32
#> 349  preterm   PMAON33         PT female      A   hdc    dutch   33
#> 350  preterm   PMAON34         PT female      A   hdc    dutch   34
#> 351  preterm   PMAON35         PT female      A   hdc    dutch   35
#> 352  preterm   PMAON36         PT female      A   hdc    dutch   36
#> 353  preterm   PMAWN25         PT female      A   wgt    dutch   25
#> 354  preterm   PMAWN26         PT female      A   wgt    dutch   26
#> 355  preterm   PMAWN27         PT female      A   wgt    dutch   27
#> 356  preterm   PMAWN28         PT female      A   wgt    dutch   28
#> 357  preterm   PMAWN29         PT female      A   wgt    dutch   29
#> 358  preterm   PMAWN30         PT female      A   wgt    dutch   30
#> 359  preterm   PMAWN31         PT female      A   wgt    dutch   31
#> 360  preterm   PMAWN32         PT female      A   wgt    dutch   32
#> 361  preterm   PMAWN33         PT female      A   wgt    dutch   33
#> 362  preterm   PMAWN34         PT female      A   wgt    dutch   34
#> 363  preterm   PMAWN35         PT female      A   wgt    dutch   35
#> 364  preterm   PMAWN36         PT female      A   wgt    dutch   36
#> 365  preterm   PMEAN25         PT female      E front    dutch   25
#> 366  preterm   PMEAN26         PT female      E front    dutch   26
#> 367  preterm   PMEAN27         PT female      E front    dutch   27
#> 368  preterm   PMEAN28         PT female      E front    dutch   28
#> 369  preterm   PMEAN29         PT female      E front    dutch   29
#> 370  preterm   PMEAN30         PT female      E front    dutch   30
#> 371  preterm   PMEAN31         PT female      E front    dutch   31
#> 372  preterm   PMEAN32         PT female      E front    dutch   32
#> 373  preterm   PMEAN33         PT female      E front    dutch   33
#> 374  preterm   PMEAN34         PT female      E front    dutch   34
#> 375  preterm   PMEAN35         PT female      E front    dutch   35
#> 376  preterm   PMEAN36         PT female      E front    dutch   36
#> 377  preterm   PMEDN25         PT female      E   dsc    dutch   25
#> 378  preterm   PMEDN26         PT female      E   dsc    dutch   26
#> 379  preterm   PMEDN27         PT female      E   dsc    dutch   27
#> 380  preterm   PMEDN28         PT female      E   dsc    dutch   28
#> 381  preterm   PMEDN29         PT female      E   dsc    dutch   29
#> 382  preterm   PMEDN30         PT female      E   dsc    dutch   30
#> 383  preterm   PMEDN31         PT female      E   dsc    dutch   31
#> 384  preterm   PMEDN32         PT female      E   dsc    dutch   32
#> 385  preterm   PMEDN33         PT female      E   dsc    dutch   33
#> 386  preterm   PMEDN34         PT female      E   dsc    dutch   34
#> 387  preterm   PMEDN35         PT female      E   dsc    dutch   35
#> 388  preterm   PMEDN36         PT female      E   dsc    dutch   36
#> 389  preterm   PMEHN25         PT female      E   hgt    dutch   25
#> 390  preterm   PMEHN26         PT female      E   hgt    dutch   26
#> 391  preterm   PMEHN27         PT female      E   hgt    dutch   27
#> 392  preterm   PMEHN28         PT female      E   hgt    dutch   28
#> 393  preterm   PMEHN29         PT female      E   hgt    dutch   29
#> 394  preterm   PMEHN30         PT female      E   hgt    dutch   30
#> 395  preterm   PMEHN31         PT female      E   hgt    dutch   31
#> 396  preterm   PMEHN32         PT female      E   hgt    dutch   32
#> 397  preterm   PMEHN33         PT female      E   hgt    dutch   33
#> 398  preterm   PMEHN34         PT female      E   hgt    dutch   34
#> 399  preterm   PMEHN35         PT female      E   hgt    dutch   35
#> 400  preterm   PMEHN36         PT female      E   hgt    dutch   36
#> 401  preterm   PMEWN25         PT female      E   wgt    dutch   25
#> 402  preterm   PMEWN26         PT female      E   wgt    dutch   26
#> 403  preterm   PMEWN27         PT female      E   wgt    dutch   27
#> 404  preterm   PMEWN28         PT female      E   wgt    dutch   28
#> 405  preterm   PMEWN29         PT female      E   wgt    dutch   29
#> 406  preterm   PMEWN30         PT female      E   wgt    dutch   30
#> 407  preterm   PMEWN31         PT female      E   wgt    dutch   31
#> 408  preterm   PMEWN32         PT female      E   wgt    dutch   32
#> 409  preterm   PMEWN33         PT female      E   wgt    dutch   33
#> 410  preterm   PMEWN34         PT female      E   wgt    dutch   34
#> 411  preterm   PMEWN35         PT female      E   wgt    dutch   35
#> 412  preterm   PMEWN36         PT female      E   wgt    dutch   36
#> 413      who      WJAA    WHOblue   male      A front    dutch     
#> 414      who   WJADN25    WHOblue   male      A   dsc    dutch   25
#> 415      who   WJADN26    WHOblue   male      A   dsc    dutch   26
#> 416      who   WJADN27    WHOblue   male      A   dsc    dutch   27
#> 417      who   WJADN28    WHOblue   male      A   dsc    dutch   28
#> 418      who   WJADN29    WHOblue   male      A   dsc    dutch   29
#> 419      who   WJADN30    WHOblue   male      A   dsc    dutch   30
#> 420      who   WJADN31    WHOblue   male      A   dsc    dutch   31
#> 421      who   WJADN32    WHOblue   male      A   dsc    dutch   32
#> 422      who   WJADN33    WHOblue   male      A   dsc    dutch   33
#> 423      who   WJADN34    WHOblue   male      A   dsc    dutch   34
#> 424      who   WJADN35    WHOblue   male      A   dsc    dutch   35
#> 425      who   WJADN36    WHOblue   male      A   dsc    dutch   36
#> 426      who   WJADN40    WHOblue   male      A   dsc    dutch   40
#> 427      who      WJAH    WHOblue   male      A   hgt    dutch     
#> 428      who      WJAO    WHOblue   male      A   hdc    dutch     
#> 429      who      WJAW    WHOblue   male      A   wgt    dutch     
#> 430      who      WJBA    WHOblue   male      B front    dutch     
#> 431      who   WJBDN25    WHOblue   male      B   dsc    dutch   25
#> 432      who   WJBDN26    WHOblue   male      B   dsc    dutch   26
#> 433      who   WJBDN27    WHOblue   male      B   dsc    dutch   27
#> 434      who   WJBDN28    WHOblue   male      B   dsc    dutch   28
#> 435      who   WJBDN29    WHOblue   male      B   dsc    dutch   29
#> 436      who   WJBDN30    WHOblue   male      B   dsc    dutch   30
#> 437      who   WJBDN31    WHOblue   male      B   dsc    dutch   31
#> 438      who   WJBDN32    WHOblue   male      B   dsc    dutch   32
#> 439      who   WJBDN33    WHOblue   male      B   dsc    dutch   33
#> 440      who   WJBDN34    WHOblue   male      B   dsc    dutch   34
#> 441      who   WJBDN35    WHOblue   male      B   dsc    dutch   35
#> 442      who   WJBDN36    WHOblue   male      B   dsc    dutch   36
#> 443      who   WJBDN40    WHOblue   male      B   dsc    dutch   40
#> 444      who      WJBH    WHOblue   male      B   hgt    dutch     
#> 445      who      WJBR    WHOblue   male      B   wfh    dutch     
#> 446      who      WMAA    WHOpink female      A front    dutch     
#> 447      who   WMADN25    WHOpink female      A   dsc    dutch   25
#> 448      who   WMADN26    WHOpink female      A   dsc    dutch   26
#> 449      who   WMADN27    WHOpink female      A   dsc    dutch   27
#> 450      who   WMADN28    WHOpink female      A   dsc    dutch   28
#> 451      who   WMADN29    WHOpink female      A   dsc    dutch   29
#> 452      who   WMADN30    WHOpink female      A   dsc    dutch   30
#> 453      who   WMADN31    WHOpink female      A   dsc    dutch   31
#> 454      who   WMADN32    WHOpink female      A   dsc    dutch   32
#> 455      who   WMADN33    WHOpink female      A   dsc    dutch   33
#> 456      who   WMADN34    WHOpink female      A   dsc    dutch   34
#> 457      who   WMADN35    WHOpink female      A   dsc    dutch   35
#> 458      who   WMADN36    WHOpink female      A   dsc    dutch   36
#> 459      who   WMADN40    WHOpink female      A   dsc    dutch   40
#> 460      who      WMAH    WHOpink female      A   hgt    dutch     
#> 461      who      WMAO    WHOpink female      A   hdc    dutch     
#> 462      who      WMAW    WHOpink female      A   wgt    dutch     
#> 463      who      WMBA    WHOpink female      B front    dutch     
#> 464      who   WMBDN25    WHOpink female      B   dsc    dutch   25
#> 465      who   WMBDN26    WHOpink female      B   dsc    dutch   26
#> 466      who   WMBDN27    WHOpink female      B   dsc    dutch   27
#> 467      who   WMBDN28    WHOpink female      B   dsc    dutch   28
#> 468      who   WMBDN29    WHOpink female      B   dsc    dutch   29
#> 469      who   WMBDN30    WHOpink female      B   dsc    dutch   30
#> 470      who   WMBDN31    WHOpink female      B   dsc    dutch   31
#> 471      who   WMBDN32    WHOpink female      B   dsc    dutch   32
#> 472      who   WMBDN33    WHOpink female      B   dsc    dutch   33
#> 473      who   WMBDN34    WHOpink female      B   dsc    dutch   34
#> 474      who   WMBDN35    WHOpink female      B   dsc    dutch   35
#> 475      who   WMBDN36    WHOpink female      B   dsc    dutch   36
#> 476      who   WMBDN40    WHOpink female      B   dsc    dutch   40
#> 477      who      WMBH    WHOpink female      B   hgt    dutch     
#> 478      who      WMBR    WHOpink female      B   wfh    dutch     
```
