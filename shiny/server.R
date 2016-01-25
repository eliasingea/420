
library(shiny)

source("../sd/bathtub.R")
source("../sd/caffeine.R")
source("../sd/coffee.R")
source("../sd/contiga.R")
source("../sd/interest.R")

shinyServer(function(input,output,session) {

    ############# Bathtub ###################################################

    output$bathtubWaterLevelPlot <- renderPlot({
        if (is.null(input$faucetOnOff)) {
            return(NULL)
        }
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


    ############# Caffeine ###################################################

    output$caffeinePlot <- renderPlot({
        sim.results <- caffeine.sim(init.stored.energy=input$initStoredEnergy,
            init.available.energy=input$initAvailableEnergy,
            low.expenditure.level=input$lowExpenditureLevel,
            high.expenditure.level=input$highExpenditureLevel,
            baseline.metabolization.rate=input$baselineMetabolizationRate,
            desired.available.energy=input$desiredAvailableEnergy,
            sim.length=input$caffeineSimLength)
        plot.energy(sim.results)
    })


    ############# Coffee #####################################################
    observeEvent(input$runCoffeeSim,
    {
        prev.coffee.results <<- NULL
        output$coffeePlot <- renderPlot({
            run.and.plot.coffee()
        })
    })

    observeEvent(input$contCoffeeSim,
    {
        output$coffeePlot <- renderPlot({
            run.and.plot.coffee()
        })
    })

    run.and.plot.coffee <- function() {
        isolate({
            prev.coffee.results <<- 
                coffee.sim(init.coffee.temp=input$initCoffeeTemp,
                    room.temp=input$roomTemp,
                    sim.length=input$coffeeSimLength,
                    prev.results=prev.coffee.results)
            plot.coffee(prev.coffee.results, "sucky 7-11 mug")
        })
    }


    observeEvent(input$runContigaSim,
    {
        prev.contiga.results <<- NULL
        output$contigaPlot <- renderPlot({
            run.and.plot.contiga()
        })
    })

    observeEvent(input$contContigaSim,
    {
        output$contigaPlot <- renderPlot({
            run.and.plot.contiga()
        })
    })

    run.and.plot.contiga <- function() {
        isolate({
            prev.contiga.results <<- 
                contiga.sim(init.coffee.temp=input$initCoffeeTemp,
                    room.temp=input$contigaRoomTemp,
                    sim.length=input$coffeeSimLength,
                    prev.results=prev.contiga.results)
            plot.coffee(prev.contiga.results, "slick insulated Contiga mug")
        })
    }


    ############# Interest ##################################################

    output$interestPlot <- renderPlot({
        sim.results <- interest.sim(init.balance=input$initBalance,
            annual.interest.rate=input$interestRate,
            amortize.period=input$amortizationPeriod,
            sim.length=input$caffeineSimLength)

        amor.per <- as.numeric(input$amortizationPeriod)
        if (isTRUE(all.equal(amor.per, 1/30))) {
            plot.period.desc <- "daily"
        } else if (isTRUE(all.equal(amor.per, 1))) {
            plot.period.desc <- "monthly"
        } else if (isTRUE(all.equal(amor.per, 12))) {
            plot.period.desc <- "yearly"
        } else {
            plot.period.desc <- paste("every",
                round(input$amortizationPeriod,1), "months")
        }
        plot.interest(sim.results, paste0(100 * input$interestRate, "%"),
            plot.period.desc)
    })

})
