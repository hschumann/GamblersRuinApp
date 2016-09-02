## ui.R
## the user interface for the 
## Gambler's Ruin applet

shinyUI(fluidPage(
  ## App title
  headerPanel("THE GAMBLER'S RUIN PROBLEM"),
  ## the sidebar Panel
  sidebarPanel(
    h3("The total amount of money in the game is $100."),
    ## input parameter for the starting amount of Gambler A
    numericInput("Astart","Starting Money for Gambler A",value = 50,min = 1,max = 99),
    textOutput("Bstart"),
    br(),
    ## input parameter for Gambler A's probability of winning
    numericInput("probA","Probability of A winning a turn",min = .0001,
                 max = .9999, value = .50),
    br(), ## a break
    ## user specified number of simulations
    numericInput("n","N (number of Simulations)",value = 1,min = 1,max = 1000),
    "Push Button to Simulate N Games",
    ## a button to run a simulation
    actionButton("simulate","Simulate")
  ),
  mainPanel(
    h4("The Gambler's Ruin Problem:"),
    textOutput("Rules"),
    br(),
    h4(textOutput("theoryWinA")),
    plotOutput("plot"),
    h6("Made by Hans Schumann")
  )
  
))
