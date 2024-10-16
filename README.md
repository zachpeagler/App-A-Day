# App A Day
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/license/mit)
![experimental](https://img.shields.io/badge/lifecycle-maturing-lightblue)
![year](https://img.shields.io/badge/year-2024-darkblue)

 Hello, I'm Zach Peagler and I'm creating an app a day until I get hired as a data scientist.

## **DAY ONE - 10/12/2024**
For day one I created an R Shiny app that uses meteorite data taken from [Data.gov](https://catalog.data.gov/dataset/meteorite-landings). It features a map using Leaflet, a couple of histogram, and a data viewer, and is themed with bootstrap via the R package bslib. It is published on shinyapps.io [here](https://zachpeagler.shinyapps.io/01_meteorites).

![App Screenshot](/01_meteorites/01_screenshot_map.png)

![App Screenshot 2](/01_meteorites/01_screenshot_plots.png)

For more information, see the day one [README](/01_meteorites/README.md).

## **DAY TWO - 10/13/2024**
For day two I created a distribution fitting app. It takes a variable and fits it across a series of specified distributions. I made functions to fit both the probability density function (PDF) and cumulative distribution function (CDF) and returned both of them as interactive plots. I also made a function to perform a series of Kolmogorov-Smirnov tests against a chosen variable, which returns a table with the distance and pvalue for the desired distributions.

This distribution fitter is for **continuous** distributions only. I'll add discrete distributions later as a separate function.

I used data from [Data.gov](https://catalog.data.gov/dataset/data-from-plant-strategies-for-maximizing-growth-during-drought-and-drought-recovery-in-so-98fae) from a paper titled "Plant strategies for maximizing growth during drought and drought recovery in Solanum melongena L. (eggplant)" and features data from a study about eggplant drought recovery that has several continuous biological response variables that can be used for fitting continuous distributions.

![Screenshot](/02_distribution_fitter/02screenshot.png)

For more informaiton, see the day two [README](/02_distribution_fitter/README.md).

## **DAY THREE - 10/14/2024**
For day three I created an interactive scatter plot app using the iris dataset included in R.

![Screenshot](/03_scatter/03screenshot.png)

For more information, see the day three [README](/03_scatter/README.md)

## **DAY FOUR - 10/15/2024**
For day four I created an app looking at the most popular baby names by year and gender as a bar plot. I also added a scatter plot showing the change in a name's popularity over time.

This required some extensive data wrangling, which can be found as its own script [here](/04_baby_names/data_wrangling.R).

![screenshot04_1](/04_baby_names/05_screenshot_scatter.png)

![screenshot04_2](/04_baby_names/05_screenshot_bar.png)

The data for this can be found [here](https://catalog.data.gov/dataset/baby-names-from-social-security-card-applications-national-data). This example data contains *all* the registered names in the United States with more than 5 occurrences since 1880. It was last updated on March 3, 2024.

#### From the National Data on U.S. Birth Name's readme

>For each year of birth YYYY after 1879, we created a comma-delimited file called yobYYYY.txt.
Each record in the individual annual files has the format "name,sex,number," where name is 2 to 15
characters, sex is M (male) or F (female) and "number" is the number of occurrences of the name.
Each file is sorted first on sex and then on number of occurrences in descending order. When there is
a tie on the number of occurrences, names are listed in alphabetical order. This sorting makes it easy to
determine a name's rank. The first record for each sex has rank 1, the second record for each sex has
rank 2, and so forth.
To safeguard privacy, we restrict our list of names to those with at least 5 occurrences. 

I may also do a chi-square or other appropriate statistical analysis to see what names are significantly different from expected.

## **DAY FIVE - 10/16/2024**
An app looking at the percent change by year of baby names in the United States.