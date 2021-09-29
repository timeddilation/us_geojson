# us_geojson

## Purpose
The sole intent of this repository is to host topojson files for use in [Power BI Drilldown Choropleth](https://appsource.microsoft.com/en-us/product/power-bi-visuals/wa104381044?tab=overview).

The original author of the Power BI tool did not maintain the URLs for the US states and counties shape files. Therefore, I was motivated to not only host files that could be used in this tool, but also create a script that can reproduce and even update the shape files using Census TIGER shape files.

The R tigris package is an interface to the US Census TIGER shapefiles and other census data. The script contained in this repository leverages this R package to create the necessary json files for the Power BI tool.

## Requirements
R >= v4.1.0
and the R packages loaded in the script.
