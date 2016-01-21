
# Meadows ch. 1 -- coffee warming/cooling model (Fig. 10)

# Given parameters describing a coffee cup's environment and insular 
# properties, return a data frame containing its temperature over time.
#
# init.coffee.temp -- temperature of coffee when the sim starts (degF)
# room.temp (degF)
# sim.length (min)
# prev.results -- a data frame of previous results, if this new call should
#   add to a previously running sim (set to NULL for a new sim). In this case,
#   init.coffee.temp is irrelevant. The sim.length is how much *additional* 
#   time to run the sim.
#
coffee.sim <- function(init.coffee.temp=192, room.temp=70, sim.length=2*60, 
    prev.results=NULL) {

    delta.t <- .1   # min
    if (is.null(prev.results)) {
        init.time <- 0
    } else {
        num.rows <- nrow(prev.results)
        init.time <- prev.results[num.rows,"time"]
        init.coffee.temp <- prev.results[num.rows,"coffee.temp"]
    }

    time <- seq(init.time,init.time+sim.length,delta.t)   # min

    coffee.temp <- vector(length=length(time))   # degF
    coffee.temp[1] <- init.coffee.temp

    coffee.cooling.factor <- .01   # (degF/min)/degF

    for (step in 2:length(time)) {

        discrepancy <- coffee.temp[step-1] - room.temp

        temp.prime <- -(coffee.cooling.factor * discrepancy)

        coffee.temp[step] <- coffee.temp[step-1] + temp.prime * delta.t
    }

    return(rbind(prev.results,
        data.frame(time=time,coffee.temp=coffee.temp,room.temp=room.temp)))
}


# Given the results of coffee.sim(), plot the room and coffee temp over time.
plot.coffee <- function(sim.results) {
    plot(sim.results$time, sim.results$coffee.temp, xlab="time (mins)",
        ylab="*degree*F", type="l", col="brown", lwd=2,
        main="Mah coffee's getting col'",
        ylim=c(0,220))
    lines(sim.results$time, sim.results$room.temp, col="black", lwd=2)
    legend("topright",fill=c("brown","black"),legend=c("coffee","room"))
}
