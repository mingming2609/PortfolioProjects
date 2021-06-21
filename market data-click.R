# read dataset
data1 <- read.csv(file = "C:/Users/mingm/Downloads/Ad_click_prediction_train.csv", header= TRUE, stringsAsFactors = TRUE)
str(data1)
# check missing values
sapply(data1, function(x) sum(is.na(x)))
# delete the rows that have missing value 
data1 <- data1[complete.cases(data1),]
sapply(data1, function(x) sum(is.na(x)))

#install libraries 
library(ggplot2) 
library(caret)  
library(party)
library(dplyr)

# PieChart
table(is_click)
perc<-round(table(is_click)/length(is_click),digit=3)*100
lab<-c("Not Clicked on Ad","Clicked on Ad")
labs<-paste(lab,":",perc,"%")
pie(table(is_click),col=c(0,4),labels=labs,radius=1,edges=1000,
    main="PieChart of binary (response) variable Ad")
# BarCharts
bar1 <- ggplot(data1) + geom_bar(aes(x=Date), fill="blue")
bar2 <- ggplot(data1) + geom_bar(aes(x=Time), fill="blue")
bar3 <- ggplot(data1) + geom_bar(aes(x=product), fill="blue")
bar4 <- ggplot(data1) + geom_bar(aes(x=campaign_id), fill="blue")
bar5 <- ggplot(data1) + geom_bar(aes(x=webpage_id), fill="blue")
bar6 <- ggplot(data1) + geom_bar(aes(x=product_category_1), fill="blue")
bar7 <- ggplot(data1) + geom_bar(aes(x=user_group_id), fill="blue")
bar8 <- ggplot(data1) + geom_bar(aes(x=gender), fill="blue")
bar9 <- ggplot(data1) + geom_bar(aes(x=age_level), fill="blue")
bar10 <- ggplot(data1) + geom_bar(aes(x=user_depth), fill="blue")
bar11 <- ggplot(data1) + geom_bar(aes(x=var_1), fill="blue")

#Correlation Matrix
library(ggcorrplot)
corrplot(data1)
corr <- round(cor(data1),1)
head(corr[, 1:12])
ggcorrplot(corr)

#logistric regression
set.seed(123)
sample_size <- floor(0.7 * nrow(data1))
part <- sample(seq_len(nrow(data1)), size=sample_size)
training <- data1[part,]
testing <- data1[-part,]
dim(training); dim(testing)
model <- glm(formula = is_click ~ ., family = binomial(link = "logit"), data= training)
print(summary(model))
#StepAIC
library(MASS)
fitted_model <- stepAIC(model, direction = "both")
fitted_model$anova
summary(fitted_model)
# McFadden's R2 value
pR2(fitted_model)
# varify accuracy 
predict1 <- predict(fitted_model, newdata = testing, type = "response")
head(project1)
contrasts(testing$is_click)
predited <- ifelse(predict1 > 0.5, 1, 0)
mean(predicted == testing$is_click)
