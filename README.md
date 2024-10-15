# App A Day
 Hello, I'm Zach Peagler and I'm creating an app a day until I get hired as a data scientist.

## **DAY ONE - 10/12/2024**
For day one I created an R Shiny app that uses meteorite data taken from [Data.gov](https://catalog.data.gov/dataset/meteorite-landings). It features a map using Leaflet, a couple of histogram, and a data viewer, and is themed with bootstrap via the R package bslib. It is published on shinyapps.io [here](https://zachpeagler.shinyapps.io/01_meteorites).

![Screenshot](/01_meteorites/01_screenshot.png)

For more information, see the day one [README](/01_meteorites/README.md).

## **DAY TWO - 10/13/2024**
For day two I created a distribution fitting app. It takes a variable and fits it across a series of specified distributions. I made functions to fit both the probability density function (PDF) and cumulative distribution function (CDF) and returned both of them as interactive plots. I also made a function to perform a series of Kolmogorov-Smirnov tests against a chosen variable, which returns a table with the distance and pvalue for the desired distributions.

This distribution fitter is for **continuous** distributions only. I'll add discrete distributions later as a separate function.

I used data from [Data.gov](https://catalog.data.gov/dataset/data-from-plant-strategies-for-maximizing-growth-during-drought-and-drought-recovery-in-so-98fae) from a paper titled "Plant strategies for maximizing growth during drought and drought recovery in Solanum melongena L. (eggplant)" and features data from a study about eggplant drought recovery that has several continuous biological response variables that can be used for fitting continuous distributions.

![Screenshot](/02_distribution_fitter/02_screenshot.png)

For more informaiton, see the day two [README](/02_distribution_fitter/README.md).

## **DAY THREE - 10/14/2024**
For day three I created an interactive scatter plot app using the iris dataset included in R.

![Screenshot](/03_scatter/03screenshot.png)

For more information, see the day three [README](/03_scatter/README.md)

## **DAY FOUR - 10/15/2024**
For day four I created an app looking at the most popular baby names by year and gender as a bar plot. I also added a scatter plot showing the change in a name's popularity over time.

The data for this can be found [here](https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-data). This example data contains *all* the registered names in the United States with more than 5 occurrences since 1880.

#### From the data's readme

I may also do a chi-square or other appropriate statistical analysis to see what names are significantly different from expected.
