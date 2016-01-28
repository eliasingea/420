
# Aliens v. Vampires -- version 1.0
# (quadratic vs. exponential growth)
# CPSC 420 -- spring 2016


# Set up time.
delta.t <- 1   # years
time <- seq(1940,2050,delta.t)

# Utility functions to convert between i and t.
itot <- function(i) (i-1)*delta.t + 1940
ttoi <- function(t) (t-1940)/delta.t + 1

# Simulation parameters.
alien.abduction.rate <- 3      # (people/year)/year
bite.rate <- .1                # (people/year)/vampire

A <- vector()
V <- vector()

# Initial conditions. (No aliens until 1940, and only one lonely vampire.)
A[1] <- 0
V[1] <- 1


# Simulate.
for (i in 2:length(time)) {

    # Compute flows.
    A.prime <- alien.abduction.rate * (time[i] - 1940)   # people/year
    V.prime <- bite.rate * V[i-1]                        # people/year

    # Compute stocks.
    A[i] <- A[i-1] + A.prime * delta.t                   # people
    V[i] <- V[i-1] + V.prime * delta.t                   # people
}


# Plot results.
all.values <- c(A,V)
plot(time,A,type="l",col="green",lwd=2,
    ylim=c(min(all.values),max(all.values)),
    main="Aliens v. Vampires apocalypse -- oh my!!",
    xlab="year",
    ylab="# of victims")
lines(time,V,col="red",lwd=2)
legend("topleft",legend=c("Alien abductions","Vampire bites"),
    fill=c("green","red"))

