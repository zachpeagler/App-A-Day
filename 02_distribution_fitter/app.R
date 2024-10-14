# dependencies
library(shiny)
library(bslib)
library(tidyverse)
library(MASS)
library(scico)
library(DT)

# load example data
deployment_file <- "SupplyChainGHGEmissionFactors_v1.3.0_NAICS_byGHG_USD2022.csv"
tfile <- "C:/Github/App-A-Day/02_distribution_fitter/SupplyChainGHGEmissionFactors_v1.3.0_NAICS_byGHG_USD2022.csv"
ghgdat <- read.csv(tfile) %>%
  rename(Code = "X2017.NAICS.Code",
         Title = "X2017.NAICS.Title",
         SupplyEmissionFactorsNoMargins = "Supply.Chain.Emission.Factors.without.Margins",
         MarginsofSupplyEmissionFactors = "Margins.of.Supply.Chain.Emission.Factors",
         SupplyEmissionFactorsWithMargins = "Supply.Chain.Emission.Factors.with.Margins")

# make data objects
vars <- c("SupplyEmissionFactorsNoMargins", "MarginsofSupplyEmissionFactors", 
          "SupplyEmissionFactorsWithMargins")

dists <- c("normal", "lognormal", "gamma", "exponential",
                   "cauchy", "t", "weibull", "logistic")
ghgs <- ghgdat[!duplicated(ghgdat$GHG),]$GHG
ghgs <- c(ghgs, "None")

# functions

##### UI #####
ui <- navbarPage(title = "Distribution Fitter",
    theme = bs_theme(bootswatch = "yeti"),
    # Show a plot of the generated distribution
    nav_panel(
    sidebarLayout(
      sidebarPanel = sidebar(
        "Controls",
         selectInput("var", "Variable to Fit Distributions Against",
                     choices = vars, selected = "SupplyEmissionFactorsNoMargins"),
         checkboxGroupInput("cont_dists", "Continuous Distributions",
                            choices = dists, selected = c("normal", 
                                                                  "lognormal", "gamma")),
         sliderInput("length", "Length of Sequence", min = 0, max = 1000, 
                     value = 100),
         selectInput("ghgfilter", "Filter By GHG", choices = ghgs,
                     selected = "None")
      ),
      mainPanel = card(plotOutput("distPlot")),
    )),
    nav_panel(
              card(DTOutput("DT")))
)

##### SERVER #####
server <- function(input, output) {
  cont_pdf <- function(x, seq_length, distributions){
    # get a sequence from the minimum to maximum of x with length
    #equal to seq_length + 1
    x_seq <- seq(min(x), max(x), length.out = seq_length+1)
    # create real density for x
    x_pdf <- density(x, n=seq_length+1)
    # initialize df of x and the real density
    pdf_df <- as.data.frame(x_seq) %>%
      mutate(dens = x_pdf$y)
    if ("normal" %in% distributions == TRUE) {
      x_n <- fitdistr(x, "normal")
      x_pdf_n <- dnorm(x_seq, mean=x_n$estimate[1],
                       sd = x_n$estimate[2])
      pdf_df <- pdf_df %>% mutate(pdf_normal = x_pdf_n)
    }
    if ("lognormal" %in% distributions  == TRUE) {
      x_ln <- fitdistr(x, "lognormal")
      x_pdf_ln <- dlnorm(x_seq, meanlog=x_ln$estimate[1],
                         sdlog = x_ln$estimate[2])
      pdf_df <- pdf_df %>% mutate(pdf_lognormal = x_pdf_ln)
    }
    if ("gamma" %in% distributions  == TRUE) {
      x_g <- fitdistr(x, "gamma")
      x_pdf_g <- dgamma(x_seq, shape=x_g$estimate[1],
                        rate=x_g$estimate[2])
      pdf_df <- pdf_df %>% mutate(pdf_gamma = x_pdf_g)
    }
    if ("exponential" %in% distributions  == TRUE) {
      x_exp <- fitdistr(x, "exponential")
      x_pdf_exp <- dexp(x_seq, rate = x_exp$estimate)
      pdf_df <- pdf_df %>% mutate(pdf_exponential = x_pdf_exp)
    }
    if ("cauchy" %in% distributions  == TRUE) {
      x_cau <- fitdistr(x, "cauchy")
      x_pdf_cau <- dcauchy(x_seq, location=x_cau$estimate[1],
                           scale = x_cau$estimate[2])
      pdf_df <- pdf_df %>% mutate(pdf_cauchy = x_pdf_cau)
    }
    if ("t" %in% distributions  == TRUE) {
      x_t <- fitdistr(x, "t")
      x_pdf_t <- dt(x_seq, df = x_t$estimate[3])
      pdf_df <- pdf_df %>% mutate(pdf_t = x_pdf_t)
    }
    if ("weibull" %in% distributions  == TRUE) {
      x_wei <- fitdistr(x, "weibull")
      x_pdf_wei <- dweibull(x_seq, shape = x_wei$estimate[1],
                            scale = x_wei$estimate[2])
      pdf_df <- pdf_df %>% mutate(pdf_weibull = x_pdf_wei)
    }
    if ("logistic" %in% distributions  == TRUE) {
      x_logis <- fitdistr(x, "logistic")
      x_pdf_logis <- dlogis(x_seq, x_logis$estimate[1],
                            x_logis$estimate[2])
      pdf_df <- pdf_df %>% mutate(pdf_logistic = x_pdf_logis)
    }
    
    return(pdf_df)
  }
  # Reactive function to return a subsetted dataframe in the event of a filter
   # input. Can be easily built out to include more rules.
  Rdat <- reactive({
    dat <- ghgdat
    if (input$ghgfilter != "None") {
      dat <- subset(dat, GHG == input$ghgfilter)
    }
    print(str(dat))
    return(dat)
  })
  # Reactive function to get input variable#
  Rvar <- reactive({
    var <-input$var
    print(var)
    return(var)
    })
  # Reactive function to get distributions
  Rdists <- reactive({input$cont_dists})
  # Reactive function for length of sequence
  Rlength <- reactive({input$length})
  # Reactive function to return a dataframe of pdfs for the selected 
  # distributions against the target variables.
  Rpdf_df <- reactive({
    var_name <- Rvar()
    data <- Rdat()
    if (var_name %in% colnames(data)){
      cont_pdf(data[[var_name]], Rlength(), Rdists())
    } else {
      return(data.frame())
    }
  })
  
  output$distPlot <- renderPlot({
        p <- ggplot(Rpdf_df)
        return(p)
    })
  output$DT <- renderDT({
    Rpdf_df()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
