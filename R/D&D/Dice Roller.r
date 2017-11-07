library(ggplot2)

diceRoller <- function(n, d.size, add.ind=0, add.end=0, multiplier=1, advantage=0, print.result=TRUE) {
	rolls <- sample(d.size, n, replace=TRUE)*multiplier + add.ind
	if(print.result == FALSE) {
		return(rolls)
	} else {
		result <- cat("The sum of the rolls = ", sum(rolls)+add.end, "\n")
		if(advantage == 1) {
			roll.result <- cat("Your roll is", max(rolls), "\n")
		} else if(advantage == -1) {
			roll.result <- cat("Your roll is", min(rolls), "\n")
		} else {
			roll.result <- cat("Your roll is", rolls[1], "\n")
		}
		return(c(result, rolls, roll.result))
	}
}

asRoller <- function() {
	stat.array <- matrix(nrow=6, ncol=6)
	rownames(stat.array) <- 1:6
	colnames(stat.array) <- c(1:4, "4d6-L", "Mod")
	for (i in 1:6) {	
		roll <- diceRoller(4, 6, print.result=FALSE)
		stat.array[i,] <- c(roll, sum(roll)-min(roll), floor((sum(roll)-min(roll)-10)/2))
	}
	return(stat.array)
}

distr <- function(n) {
	stat.array <- c()
	for (i in 1:n) {	
		roll <- diceRoller(4, 6, print.result=FALSE)
		stat.array[i] <- sum(roll)-min(roll)
	}
	dataDL <- data.frame(stat.array)
	
	ggplot(data=dataDL, aes(dataDL$stat.array)) +
		geom_histogram(
			aes(y=..density..),
			breaks=seq(2, 18), 
			col="red", 
			fill="green", 
			alpha = .2
		) +
		geom_density(col=2) +
		labs(title="Histogram for 4d6-L") +
		labs(x="Ability Score", y="Count") +
		xlim(c(2,19))
	return(c(mean(stat.array), var(stat.array), sd(stat.array)))
}
distr(1000)