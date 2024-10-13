##### Meteorite App #####

# Dependencies
library(shiny)
library(tidyverse)
library(leaflet)
library(bslib)
library(scico)
library(plotly)
library(GWalkR)
library(DT)
# Load Data
meteorite_file <- "Meteorite_Landings.csv"
# Rename variables for clarity and omit NAs
met_dat <- read.csv(meteorite_file) %>%
  rename(mass = mass..g.,
         lat = reclat,
         lon = reclong) %>%
  mutate(nametype = as.factor(nametype),
         recclass = as.factor(recclass),
         fall = as.factor(fall),
         id = as.factor(id)) %>%
  filter(mass > 0) %>%
  na.omit()
# Make variable object
met_vars <- c(
  "Mass" = "mass",
  "Year" = "year"
)
# Get outliers for mass
Qmass <- quantile(met_dat$mass, probs=c(.25, .75))
iqr_mass <- IQR(met_dat$mass)
# Make color palettes object
p_pals <- scico_palette_names()

##### UI #####
ui <- navbarPage("Meteorite Landings",
                 theme = bs_theme(bootswatch = "sandstone"),
                 sidebar = sidebar(
                   markdown("##### **Global Settings**"),
                   checkboxInput("extremes", "Exclude Extremes", TRUE),
                   checkboxInput("outliers", "Exclude Outliers", FALSE),
                   selectInput("palette", "Select Color Palette", p_pals, selected = "acton"),
                   numericInput("date_min", "Date Range Start", min=0, max=2024, value = 1975),
                   numericInput("date_max", "Date Range End", min=0, max=2024, value=2024),
                 ),
        nav_panel("Map",
          card(layout_sidebar(
            sidebar = sidebar(
              markdown("##### **Map Settings**"),
              selectInput("size", "Size", met_vars, selected = "mass"), 
            selectInput("color", "Color", met_vars, selected = "year")
            ),
            card_body(leafletOutput("map"), height=800)
          )
          )
          ),
        nav_panel("Plots",
            card("Histograms",
              layout_sidebar(sidebar = sidebar(
                markdown("##### **Histogram Settings**"),
                sliderInput("bins",
                            "Number of bins:",
                            min = 1,
                            max = 100,
                            value = 30)
              ),
            layout_column_wrap(
              card(card_header("Year Histogram"),
              plotlyOutput("year_hist")
              ),
              card(card_header("Mass Histogram"),
              plotlyOutput("mass_hist")
              )
              )))
          ),
        nav_panel("Data Explorer",
                  card(
                    DTOutput("met_DT")
                  ),
                  card(gwalkrOutput("met_gwalk"),
                       card_body(markdown("For more information on using GWalkR's Tableau-style visualizations please see the author's [Github repo](https://github.com/Kanaries/GWalkR)."))
                  )
                  ),
        nav_spacer(),
        nav_item(tags$a("Github", href = "https://github.com/zachpeagler/AppADay/01_meteorites"))
)

##### Server
server <- function(input, output) {
  
  # Reactive function that filters data
  Rbins <- reactive({input$bins})
  Rpalette <- reactive({input$palette})
  
  Rmet_dat <- reactive({
    m_dat <- met_dat %>%
      filter(year > input$date_min,
             year < input$date_max
             )
    if (input$extremes == TRUE) {
      m_dat <- subset(m_dat, mass > (Qmass[1] - 3 * iqr_mass) &
                        mass < (Qmass[2] + 3 * iqr_mass)
      )
    }
    if (input$outliers == TRUE) {
      m_dat <- subset(m_dat, mass > (Qmass[1] - 1.5 * iqr_mass) &
                        mass < (Qmass[2] + 1.5 * iqr_mass)
                      )
    }
    return(m_dat)
  })
  
  # Map output
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -93, lat=38, zoom = 3)
  })
  
  # reactive expression to see whats inbounds
  recInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(met_dat[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lonRng <- range(bounds$east, bounds$west)
    
    subset(met_dat,
           lat >= latRng[1] & lat <= latRng[2] &
             lon >= lonRng[1] & lat <= lonRng[2])
  })
  
  observe({
    colorBy <- input$color
    sizeBy <- input$size
      colordat <- Rmet_dat()[[colorBy]]
      pal <- colorBin(scico(length(colordat), begin = 0.8, end = 0,
                               palette = Rpalette(), categorical = FALSE),
                         colordat)
        radius <- Rmet_dat()[[sizeBy]] / max(Rmet_dat()[[sizeBy]]) * 100000
    
    leafletProxy("map", data = Rmet_dat()) %>%
      clearShapes() %>%
      clearControls() %>%
      addCircles(~lon, ~lat, radius = radius, stroke = FALSE,
                 fillOpacity = 0.4, fillColor = pal(colordat),
                 layerId = ~id) %>%
      addLegend("bottomleft", pal=pal, values=colordat, title = colorBy)
  })
  
  showMetPopup <- function(id, lat, lon) {
    selectedMet <- met_dat[met_dat$id == id,]
    content <- paste("Name:", selectedMet$name, "<br/>",
                     "Class:", selectedMet$recclass, "<br/>",
                     "Mass:", selectedMet$mass, "grams", "<br/>",
                     "Year:", selectedMet$year, "<br/>",
                     "Coords:", selectedMet$lat, selectedMet$lon,
                     sep = " ")
    leafletProxy("map") %>% addPopups(lng = lon, lat = lat, popup = content)
  }
  
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showMetPopup(event$id, event$lat, event$lng)
    })
  })
  # Plot outputs
  ## Mass histogram
  output$mass_hist <- renderPlotly({
      options(scipen = 999)
      mass <- Rmet_dat()$mass
      bins <- seq(min(as.integer(mass)), max(as.integer(mass)), length.out = Rbins() + 1)
      `Mass Bins` <- cut(mass, bins)
      m_hist <- ggplot(data = Rmet_dat(), aes(x = mass, fill = `Mass Bins`, color = `Mass Bins`))+
                    geom_histogram(bins = Rbins())+
                    scale_fill_scico_d(begin=0.8, end=0, palette=Rpalette())+
                    scale_color_scico_d(begin=0.8, end=0, palette=Rpalette())
      m_hist <- ggplotly(m_hist)
      return(m_hist)
  })
  ## Year histogram
  output$year_hist <- renderPlotly({
    options(scipen = 999)
    year <- Rmet_dat()$year
    bins <- seq(min(year), max(year), length.out = Rbins() + 1)
    `Year Bins` <- cut(year, bins)
    y_hist <- ggplot(data = Rmet_dat(), aes(x = year, fill = `Year Bins`, color = `Year Bins`))+
      geom_histogram(bins = Rbins()+1)+
      scale_fill_scico_d(begin=0.8, end=0, palette=Rpalette())+
      scale_color_scico_d(begin=0.8, end=0, palette=Rpalette())
    y_hist <- ggplotly(y_hist)
    return(y_hist)
  })
  # GWalkR
  output$met_gwalk <- renderGwalkr({
    gwalkr(Rmet_dat())
  })
  
  output$met_DT <- renderDT({
    Rmet_dat()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
