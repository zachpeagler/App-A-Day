# Meteorite Landings App
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](https://opensource.org/license/mit)
![experimental](https://img.shields.io/badge/lifecycle-experimental-orange)
![year](https://img.shields.io/badge/year-2024-darkblue)
![new](https://img.shields.io/badge/lifecycle-new-brightgreen)

![App Screenshot](../01_meteorites/screenshot.png)

# Links
[Link](https://zachpeagler.shinyapps.io/01_meteorites)

## QR Code

![QRCode](../01_meteorites/qrcode.png)


# Description

Using data taken from [Data.gov](https://catalog.data.gov/dataset/meteorite-landings) I'll be making an interactive app using R Shiny that shows meteorite landing data. It features a map using Leaflet, a couple of histogram, and a data viewer.
It adds circles to the map with user input variables for radius and color, with variable options including mass and year.
It has two date inputs with minimum and maximum corresponding to the min and max values of meteorite landing years, and it has inputs for excluding extreme and outliers from the data.
When you click on a circle on the map with leaflet, a value card pops up showing you the name, class, mass, year found and exact coordinates.

This was created for day 1 of my AppADay series!