
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
shinyServer(function(input, output) {

  # make the data
  # QUESTION 1
  A <- 10 # defined by group
  C <- 60 # defined by group
  range <- C - A
  axseqB <- seq(A, C, by = 10)
  axsclB <- (axseqB - A) / (range)
  
  muB <- reactive(input$meanB)
  precisionB <- reactive(input$precB) 
  
  
  # QUESTION 2
  D <- 170 # defined by group
  f <- 220 # defined by group
  range2 <- f - D
  axseqE <- seq(D, f, by = 10)
  axsclE <- (axseqE - D) / (range2)
  
  muE <- reactive(input$meanE)
  precisionE <- reactive(input$precE) 
  
    
    
    output$distPlot <- renderPlot({  
     
      
      # draw the plots
      par(mfrow=c(1, 2))
    
      x <- seq(0, 1, length = 1000)
      alpha <- muB() * precisionB()
      beta <- precisionB() - muB() * precisionB() 
      plot(x, dbeta(x, alpha, beta), type = 'l', 
               ylab = 'PDF', xlab = '# Days', 
               main = 'Days Tolerated', las = 1, cex.axis = 1.5, axes = FALSE)  
      axis(side = 1, at = axsclB, labels = axseqB)
      axis(side = 2)
      
      alpha2 <- muE() * precisionE()
      beta2 <- precisionE() - muE() * precisionE() 
      plot(x, dbeta(x, alpha2, beta2), type = 'l', 
           ylab = 'PDF', xlab = '# Days', 
           main = 'Max Days Tolerated', las = 1, cex.axis = 1.5, axes = FALSE)  
      axis(side = 1, at = axsclE, labels = axseqE)
      axis(side = 2)    
    
    
  
    })

# # make the broken stick plot
output$bstickPlot <- renderPlot({
  # build up the data based on the parameters above
  alpha <- muB() * precisionB()
  beta <- precisionB() - muB() * precisionB() 
  alpha2 <- muE() * precisionE()
  beta2 <- precisionE() - muE() * precisionE() 
  
  n <- input$nsamp
  df <- data.frame(id = seq(n), 
                   bdat = rbeta(n, alpha, beta),
                   edat = rbeta(n, alpha2, beta2))
  df$bdays <- round(df$bdat * range + A)
  df$edays <- round(df$edat * range2 + D)
  df$y1 <- 0
  df$y2 <- 100

  par(mfrow = c(1,1))
  plot(0:365, seq(0, 100, length = 366), type = 'n', 
       xlab = 'Number of days on which a behavioural response occurred in the previous 365 days', 
       ylab = 'Reduction in Growth Rate (%)')
  segments(min(df$edays), 100, 365, 100)
  rug(jitter(df$bdays), side = 1)
  rug(jitter(df$edays), side = 3)

  
  for(i in 1:n){
    segments(df$bdays[i], 0, df$edays[i], 100, col=rgb(0,0,0,0.2))
  }
})

output$downloadData <- downloadHandler(
  filename = function() { 
    paste('round1responses_', Sys.Date(), '.csv', sep='') 
  },
  content = function(file) {
    write.csv(c(input$input$meanB, input$input$precB, input$input$meanE, input$input$precE), file)
  }
)

})
