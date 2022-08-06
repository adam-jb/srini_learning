


t.test(1:10, y = c(7:20)) 


# chisqaured
file_path <- "http://www.sthda.com/sthda/RDoc/data/housetasks.txt"
housetasks <- read.delim(file_path, row.names = 1)
chisq.test(housetasks)



# anova
size <- c(3,4,5,6,4,5,6,7,7,8,9,10)
pop <- c("A","A","A","A","B","B","B","B","C","C","C","C")
aov.model <- aov(size ~ pop)
summary(aov.model)

# Tukey’s Honest Significant Differences (tukeyHSD)
# compares means between each pair in group: are they over 2sd apart?
#     where the sd is between mean the means
TukeyHSD(aov.model)
plot(TukeyHSD(aov.model))

# tukeyHSD = basically same as multiple t-tests which reduce p-value to avoid
# p-hacking (similar, but not same, method as bonferroni correction)



# boxcox transformation
library(MASS)
boxcox(size ~ pop)
bc <- boxcox(size ~ pop)
lambda <- bc$x[which.max(bc$y)]
boxcox_scaled_size <- (size ^ lambda - 1) / lambda



# kruskal-wallis: if groups arent normally distributed
kruskal.test(size ~ pop)



# normality test
shapiro.test(size)







