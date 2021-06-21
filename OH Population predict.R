df <- read.csv("population.csv")

linear_regression <- lm(POP_SIZE ~ YEAR, data = df)
#Plot Linear Model and Regression Line
plot(df,col="blue", main = "Population Trend of OH", xlab = "Year", ylab = "Population")
abline(Linear_regression)
summary(df) 
summary(linear_regression)

new_data <- data.frame(YEAR=c(2020,2021,2022,2023,2024)) 
predict(Linear_regression, newdata=new_data)
