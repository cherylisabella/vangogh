
# **Vincent van Gogh Color Palettes** <img align="right" width="150" src="logo.png" >

<!-- badges: start -->

[![R-CMD-check](https://github.com/cherylisabella/vangogh/workflows/R-CMD-check/badge.svg)](https://github.com/cherylisabella/vangogh/actions)
<!-- badges: end --> <br>

The goal of `vangogh` is to provide users with color palettes inspired
by a selection of Vincent van Gogh’s paintings. These palettes also aim
to increase the aesthetic appeal of data plots. Each palette contains 5
handpicked colors and were manually added by hex codes.

`vangogh` palettes can be used in conjunction with `ggplot2` or `plot`
to provide colors to data plots (for visualising qualitative data,
sequential plots etc).

Some `vangogh` functions include:

-   `vangogh_palette()`
-   `viz_palette()`
-   `scale_color_manual()`
-   `scale_color_vangogh()`
-   `scale_fill_vangogh()`

## Installation

``` r
install.packages("vangogh")
```

**Or the development version**

``` r
devtools::install_github("cherylisabella/vangogh")
```

## Usage

``` r
library("vangogh")
# See all palettes
names(vangogh_palettes)
#>  [1] "StarryNight"      "StarryRhone"      "SelfPortrait"     "CafeTerrace"     
#>  [5] "Eglise"           "Irises"           "SunflowersMunich" "SunflowersLondon"
#>  [9] "Rest"             "Bedroom"          "CafeDeNuit"       "Chaise"          
#> [13] "Shoes"            "Landscape"        "Cypresses"
```

<br>

## Palettes and their associated artworks

### The Starry Night (1889)

<img  height="300" src="starrynight 2.png">

``` r
vangogh_palette("StarryNight")
```

![](figure/StarryNight-1.png)<!-- -->

### Starry Night Over the Rhône / La Nuit étoilée (1888)

<img  height="300" src="rhone1.png">

``` r
vangogh_palette("StarryRhone")
```

![](figure/StarryRhone-1.png)<!-- -->

### Self-portrait (1889)

<img  height="300" src="selfp.png">

``` r
vangogh_palette("SelfPortrait")
```

![](figure/SelfPortrait-1.png)<!-- -->

### Café Terrace at Night (1888)

<img  height="300" src="cafeterrace.png">

``` r
vangogh_palette("CafeTerrace")
```

![](figure/CafeTerrace-1.png)<!-- -->

### The Church at Auvers (1890)

<img  height="300" src="eglise.png">

``` r
vangogh_palette("Eglise")
```

![](figure/Eglise-1.png)<!-- -->

### Irises / Les Iris (1889)

<img  height="300" src="irises.png">

``` r
vangogh_palette("Irises")
```

![](figure/Irises-1.png)<!-- -->

### Sunflowers - Munich version (1888)

<img  height="300" src="sunflowersm.png">

``` r
vangogh_palette("SunflowersMunich")
```

![](figure/SunflowersMunich-1.png)<!-- -->

### Sunflowers - London version (1888)

<img  height="300" src="sunflowersl.png">

``` r
vangogh_palette("SunflowersLondon")
```

![](figure/SunflowersLondon-1.png)<!-- -->

### Noon – Rest from Work (1890)

<img  height="300" src="rest.png">

``` r
vangogh_palette("Rest")
```

![](figure/Rest-1.png)<!-- -->

### Bedroom in Arles / Slaapkamer te Arles (1888)

<img  height="300" src="bedroom.png">

``` r
vangogh_palette("Bedroom")
```

![](figure/Bedroom-1.png)<!-- -->

### The Night Café / Le Café de nuit (1888)

<img  height="300" src="cafedenuit.png">

``` r
vangogh_palette("CafeDeNuit")
```

![](figure/CafeDeNuit-1.png)<!-- -->

### Van Gogh’s Chair (1888)

<img  height="300" src="chaise.png">

``` r
vangogh_palette("Chaise")
```

![](figure/Chaise-1.png)<!-- -->

### Shoes (1886)

<img  height="300" src="shoes.png">

``` r
vangogh_palette("Shoes")
```

![](figure/Shoes-1.png)<!-- -->

### Landscape with Houses (1890)

<img  height="300" src="landscape.png">

``` r
vangogh_palette("Landscape")
```

![](figure/Landscape-1.png)<!-- -->

### Wheat Field with Cypresses (1889)

<img  height="300" src="cypresses.png">

``` r
vangogh_palette("Cypresses")
```

![](figure/Cypresses-1.png)<!-- -->
