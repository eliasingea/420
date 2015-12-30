
library(shiny)

source("../sd/bathtub.R")

shinyServer(function(input,output,session) {

    output$bathtubWaterLevelPlot <- renderPlot({
        sim.results <- bathtub.sim(init.water.level.gal=input$initWaterLevel,
            turn.on.faucet.time=input$faucetOnOff[1]*60,
            turn.off.faucet.time=input$faucetOnOff[2]*60,
            pull.plug.time=input$pullPlugTime*60,
            inflow.rate=input$inflowRate/60,
            outflow.rate=input$outflowRate/60,
            sim.length=input$bathtubSimLength)
        plot.bathtub.water.level(sim.results)
    })

    output$faucetOnOffWidget <- renderUI({
        sliderInput("faucetOnOff", "Turn on/off faucet time (min)",
            min=0, max=input$bathtubSimLength, step=.1, value=c(1,4))
    })

    output$pullPlugTimeWidget <- renderUI({
        sliderInput("pullPlugTime", "Pull plug time (min)",
            min=0, max=input$bathtubSimLength, step=.1, value=2)
    })
})
