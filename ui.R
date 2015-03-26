
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Sperm Whale First Draft"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      

      
      helpText('This first slider determines the mean number of days of disturbance an individual can tolerate before there is an effect.'),
      sliderInput("meanB",
                  "Mean parameter for Beta:",
                  min = 0,
                  max = 1,
                  value = 0.5),
  
      helpText('Higher values indicate higher confidence.'),
      sliderInput("precB",
                  "Confidence:",
                  min = 2,
                  max = 100,
                  value = 2),
      
      helpText('This third slider determines the number of days of disturbance required to reduce an individual’s growth rate to zero.'),
      sliderInput("meanE",
                  "Mean parameter for Beta:",
                  min = 0,
                  max = 1,
                  value = 0.5),

      helpText('Higher values indicate higher confidence.'),
      sliderInput("precE",
                  "Confidence:",
                  min = 2,
                  max = 100,
                  value = 2),
      
      downloadButton('downloadData', 'Download your Responses')
      
     
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      
      
      plotOutput('bstickPlot'),

      fluidRow(column(width = 6, offset = 3,
                sliderInput("nsamp",
                            "Number of lines:",
                            min = 1,
                            max = 500,
                            value = 100)))

    )
  )
))
