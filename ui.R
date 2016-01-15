library(shiny)
library(ggplot2)
library(pwr) #useful because can use effect size rather than calculate manually
library(ggthemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Power Analysis - Determining Sample Size"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      p("John H. Bradford"),
      sliderInput("es", label="effect size (Cohen's d)",
                  min = .2,
                  max = .8,
                  value = .2, 
                  step = .01),
      sliderInput("powerLevel", label="Power Level",
                  min = .8,
                  max = .99,
                  value = .8, 
                  step = .01),
      sliderInput("alpha", label="Sig. Level (alpha)",
                  min = .01,
                  max = .1,
                  value = .05, 
                  step = .01),
      selectInput("type", label="Type of Sample", c("two sample", "paired"), selected="two sample"),
      selectInput("alternative", label="Type of Test", c("two-sided", "one-sided"), selected="two-sided")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      #p("n = # of observations per sample"),
      #verbatimTextOutput("summary"),
      plotOutput("distPlot")
    )
  )
))