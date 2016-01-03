
# Meadows ch. 1 -- caffeine consumption model (Fig. 9)

# Given parameters describing a human body and its perceived energy needs,
# return a data frame containing its amount of available, and stored, energy
# over time.
#
# init.stored.energy -- amount of energy theoretically present in the body
#   when the sim starts (kcal)
# init.available.energy -- amount of energy actually available in the body to
#   do work when the sim starts (kcal)
# low.expenditure.level -- when resting, how much energy consumed per time
#   (kcal/hr)
# high.expenditure.level -- when active, how much energy consumed per time
#   (kcal/hr)
# desired.available.energy -- amount of energy the person wants available
#   (kcal)
# baseline.metabolization.rate -- how much energy is metabolized from the
#   body's stores in the absence of any caffeine. (kcal/hr)
# sim.length (hr)
#
caffeine.sim <- function(init.stored.energy=1e5, init.available.energy=1e4,
    low.expenditure.level=2000/24, high.expenditure.level=3000/24,
    baseline.metabolization.rate=2300/24,
    desired.available.energy=1.5e4, sim.length=5*24) {

    delta.t <- .1   # hr
    time <- seq(0,sim.length,delta.t)   # hr

    stored.energy <- vector(length=length(time))   # kcal
    available.energy <- vector(length=length(time))   # kcal

    stored.energy[1] <- init.stored.energy
    available.energy[1] <- init.available.energy

    coffee.metabolization.factor <- 150/24   # (kcal/hr)/cup

    # Let's start off slow.
    coffee.intake <- 0  # cup/hour

    for (step in 2:length(time)) {

        time.now <- time[step]

        discrepancy <- available.energy[step-1] - desired.available.energy
        if (discrepancy < 0) {
            # Tired. Drink more coffee.
            coffee.intake <- coffee.intake + 1
        } else {
            # Feeling good. Drink less coffee.
            coffee.intake <- max(coffee.intake - 1, 0)
        }

        metabolic.mobilization <- baseline.metabolization.rate +
            coffee.intake * coffee.metabolization.factor * delta.t  # kcal/hr

        # We lose energy, if we have any, equal to our metabolic rate.
        if (stored.energy[step-1] > 0) {
            delta.stored.energy <- -metabolic.mobilization
        } else {
            delta.stored.energy <- 0
        }

        if (time.now %% 24 > 8  &  time.now %% 24 < 17) {
            # Between 8am and 5pm is high energy time.
            expenditure.level <- high.expenditure.level
        } else {
            expenditure.level <- low.expenditure.level
        }
        delta.available.energy <- -delta.stored.energy - expenditure.level

        stored.energy[step] <- 
            max(stored.energy[step-1] + delta.stored.energy * delta.t, 0)
        available.energy[step] <- 
            max(available.energy[step-1] + delta.available.energy * delta.t, 0)
    }

    return(data.frame(time=time,stored.energy=stored.energy,
        available.energy=available.energy))
}


# Given the results of caffeine.sim(), plot the stored and available energy 
# over time.
plot.energy <- function(sim.results) {
    all.energies <- c(sim.results$available.energy, sim.results$stored.energy)
    plot(sim.results$time, sim.results$available.energy, xlab="time (hrs)",
        ylab="kcal", type="l", col="red", main="Energy",
        ylim=c(min(all.energies), max(all.energies)))
    lines(sim.results$time, sim.results$stored.energy, col="black", lwd=2)
    legend("topright",fill=c("red","black"),legend=c("available","stored"))
}
