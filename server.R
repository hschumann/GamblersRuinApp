## server.R
## this is the background for the
## Gambler's Ruin applet

library(shiny)

shinyServer(function(input,output) {
  ## this will calculate the theoretical probability of Gambler A Winning 
  ## and create the text output
  output$theoryWinA <- renderText({
    ## first the probability if the odds are equal
    if (input$probA == .5) {
      numer <- (input$Astart)
      winA <- numer / 100
      paste("The true probability that gambler A wins all the money is",round(winA,5))
    } else {  ## probability if the odds are not equal
      ## the numerator and denomenator of the equation
      numer <- ((1 - input$probA)/(input$probA))**(input$Astart) - 1
      denom <- ((1 - input$probA)/(input$probA))**(100) - 1
      winA <- numer / denom
      ## create the text output of the winning probability (rounded to 5 places)
      paste0("The true probability that gambler A wins all the money is ",round(winA,5),".")
    }
  })
  
  ## amount of money B starts with (for the sidePanel)
  output$Bstart <- renderText({
    paste0("Gambler B has $",100 - input$Astart,".")
  })
  
  ## creates a variable N for the number of simulations
  N <- eventReactive(input$simulate, {
    input$n
  })
  
  ## below is the code for the plot showing the probability of winning approaching
  ## the expected value
  output$plot <- renderPlot({
    ## initialize values to contain the sum of wins and the current probabilities
    y <- c()
    Awins <- 0
    ## a loop for the number of repetitions specified
    for (j in 1:N()) {
      ## the code inside the loop will run one game until its finish
      A <- input$Astart
      B <- 100 - input$Astart
      while (A != 0 & B != 0) {
        num <- runif(1)  ## pick a random number from 0 to 1
        ## if/else is deciding who wins single "roll" based on num
        if (num < input$probA) {
          A <- A + 1
          B <- B - 1
        } else {
          A <- A - 1
          B <- B + 1
        }
      }
      ## add to the sum of Awins if needed and add to the overall probability vector
      if (B == 0) {
        Awins <- Awins + 1
      }
      y <- c(y,Awins/j)
    }
    ## produce the plot with a horizontal line at the theoretical probability
    if (N() < 5) {  ## if/else statement so the axes are cleaner for low N values
      plot(y ~ seq(1,N(),by = 1),xlab = "Simulation Number",ylab = "Probability of Gambler A Winning",
           pch = 16,main = paste("Observed Probability of Gambler A Winning Over",N(),"Simulations"),
           col = "lightslateblue",ylim = c(0,1),xaxt = 'n')
      axis(1,at = seq(1,N(),by = 1))
    } else {
      plot(y ~ seq(1,N(),by = 1),xlab = "Simulation Number",ylab = "Probability of Gambler A Winning",
           pch = 16,main = paste("Observed Probability of Gambler A Winning Over",N(),"Simulations"),
           col = "lightslateblue",ylim = c(0,1))
    }
    if (input$probA == .5) {
      numer <- (input$Astart)
      winA <- numer / 100
    } else {
      numer <- ((1 - input$probA)/(input$probA))**(input$Astart) - 1
      denom <- ((1 - input$probA)/(input$probA))**(100) - 1
      winA <- numer / denom
    }
    abline(h = winA)
  })
  
  ## The text for the rules of the game
  output$Rules <- renderText({
    rules <- "Two gamblers start with a certain amount of money and agree to play until one "
    rules <- paste0(rules,"of the gamblers has all the money and the other has none.  The game takes place over many ")
    rules <- paste0(rules,"turns, whereas on each turn, the players have same probability of winning as the turn before.")
    rules <- paste0(rules,"  The probability of winning for Gambler A is the complement of that of Gambler B.")
    rules <- paste0(rules,"  If Gambler B wins a turn, Gambler A gives one dollar to Gambler B, and vice versa.") 
    rules <- paste0(rules,"The turns continue to be played until a winner and loser are found.") 
    rules
  })
})