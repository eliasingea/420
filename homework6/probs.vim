#Homework 6 
#Elias Ingea
#CPSC 420

#Question 1: what's the probability that the Nationals will win the N.L? 
cat("1. The probability of the Nationals winning the title is", 1 - pbinom(97, size=162, prob=.556), "percent\n")

#Question 2:  What's the probability that he will take the gold -- and bragging rights -- at the end of the competition?
cat("2. The probability that Thomas will take gold is", pnorm(32000, mean=100000, sd=40000, lower.tail=TRUE),"percent\n")

#Question 3: Using Poisson disterbution, what percentage of college students send more than 100 texts per day? 
cat("3. With the Poisson distro about", ppois(100, lambda=96, lower=FALSE), "percent of college students send over 100 text messages per day.", ppois(80, lambda=96, lower=TRUE), "Percent send under 80 text messages per day and",
    ppois(150, lambda=96, lower=FALSE), "percent send over 150 text messages.", 
    "In my opinion Poisson distro is an appropriate method of modeling this random variable because it is intended to measure the probability disterbution of independent event occurences in an interval which is exactly what he have in the given scenerio above.\n")
#Question 4: Probability of getting a split between boys and girls in a family of 2 and 12. 
cat("4. The probability of an even boy/girl split in a family of 2 kids is", dbinom(1, size=2, prob=0.5), "and in a family of 12 kids it's", dbinom(1, size=12, prob=0.5),".\n")
#Question 5: if he attends a hundred races over the course of his spectating career, what's the closest he will ever be to the finish line?
cat("5. The closest Melvin sat to the finish line line in 100 races was", 150 - max(runif(100, 0, 150)),"Km\n")


