
# Meadows ch. 1 -- bathtub model

# Given an initial level of water in a bathtub, return a data frame of water
# levels over time. 
#
# inflow.rate from the faucet, when on (gallons/sec)
# outflow.rate down the drain, when unplugged (gallons/sec)
# turn.on.faucet.time -- faucet begins off, then is turned on at this point
#   (sec)
# turn.off.faucet.time -- faucet turns back off at this point (sec)
# pull.plug.time -- drain begins closed, then is unplugged at this point (sec)
# sim.length (min)
#
bathtub.sim <- function(init.water.level.gal=50, turn.on.faucet.time=10,
    turn.off.faucet.time=120, pull.plug.time=40, inflow.rate=15/60,
    outflow.rate=20/60, sim.length=5) {

    delta.t <- 1   # sec
    time <- seq(0,sim.length*60,delta.t)   # sec

    water.level <- vector(length=length(time))   # gallons

    water.level[1] <- init.water.level.gal

    for (step in 2:length(time)) {

        time.now <- time[step]

        delta.water.level <- 0    # gallons/sec
        if (time.now > turn.on.faucet.time && 
            time.now < turn.off.faucet.time) {
            delta.water.level <- delta.water.level + inflow.rate
        } 
        if (time.now > pull.plug.time) {
            delta.water.level <- delta.water.level - outflow.rate
        } 
        
        water.level[step] <- 
            max(water.level[step-1] + delta.water.level * delta.t, 0)
    }

    return(data.frame(time=time,water.level=water.level))
}


# Given the results of bathtub.sim(), plot the water level over time.
plot.bathtub.water.level <- function(sim.results) {
    plot(sim.results$time, sim.results$water.level, xlab="time (sec)",
        ylab="gallons", type="l", ylim=c(0,max(sim.results$water.level)))
}
