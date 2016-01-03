
library(shiny)

shinyUI(fluidPage(

    tags$head(tags$link(rel="stylesheet", type="text/css", href="shiny.css")),

    titlePanel("CPSC 420 -- System Dynamics examples"),

    tabsetPanel(selected="Bathtub",
        tabPanel("Bathtub",
            sidebarLayout(sidebarPanel(
                numericInput("bathtubSimLength", "Simulation time (min)",
                    value=5, min=0, step=.5, width="40%"),
                sliderInput("initWaterLevel", "Initial water level (gal)",
                    min=0, max=60, value=50),

                # (Putting the code for these into server.R is necessary so
                # their width can vary dynamically dependent on the
                # bathtubSimLength widget's value.)
                uiOutput("faucetOnOffWidget"),
                uiOutput("pullPlugTimeWidget"),

                div(class="container-fluid",
                    div(class="row",
                        div(class="col-lg-6", 
                            numericInput("inflowRate", "Faucet rate (gal/min)",
                                value=15, min=0, step=1)),
                        div(class="col-lg-6", 
                            numericInput("outflowRate", "Drain rate (gal/min)",
                                value=20, min=0, step=1))
                    )
                )),
                mainPanel(
                    plotOutput("bathtubWaterLevelPlot")
                )
            )
        )
    )

))
