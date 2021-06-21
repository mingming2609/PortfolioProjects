# read & clean data
DATA_RAW <- read.csv(file = "C:/Users/mingm/Downloads/WA_Fn-UseC_-Telco-Customer-Churn.csv", header = TRUE, stringsAsFactors = TRUE)
str(DATA_RAW) 
summary(DATA_RAW)
#check missing values
sapply(DATA_RAW, function(x) sum(is.na(x)))
DATA_RAW <- DATA_RAW[complete.cases(DATA_RAW), ]

#UNIFORM DATASET
DATA_RAW$SeniorCitizen <- ifelse(DATA_RAW$SeniorCitizen == 0, "No", ifelse(DATA_RAW$SeniorCitizen ==1, "Yes", "Unkown"))
DATA_RAW$SeniorCitizen <- as.factor(DATA_RAW$SeniorCitizen)
levels(DATA_RAW$MultipleLines)[levels(DATA_RAW$MultipleLines)=="No phone service"] <- "No"
levels(DATA_RAW$OnlineBackup)[levels(DATA_RAW$OnlineBackup)=="No internet service"] <- "No"
levels(DATA_RAW$DeviceProtection)[levels(DATA_RAW$DeviceProtection)=="No internet service"] <- "No"
levels(DATA_RAW$TechSupport)[levels(DATA_RAW$TechSupport)=="No internet service"] <- "No"
levels(DATA_RAW$StreamingTV)[levels(DATA_RAW$StreamingTV)=="No internet service"] <- "No"
levels(DATA_RAW$StreamingMovies)[levels(DATA_RAW$StreamingMovies)=="No internet service"] <- "No"
levels(DATA_RAW$OnlineSecurity)[levels(DATA_RAW$OnlineSecurity)=="No internet service"] <- "No"

#bar charts
library(ggplot2)
bar1 <- ggplot2(DATA_RAW) + geom_bar(aes(x=SeniorCitizen), fill = "blue")
bar1

# correlation plot
numeric.var <- sapply(DATA_RAW, is.numeric)
corr.matrix <- cor(DATA_RAW[,numeric.var])
corrplot(corr.matrix, main="\n\nCorrelation Plot for Numerical Variables", method = "number")

#delete  column 
drop <- c("customerID","TotalCharges")
DATA_RAW <- DATA_RAW[,!(names(DATA_RAW) %in% drops)]
rm(drops)
#chi-square test
table(DATA_RAW$Churn, DATA_RAW$SeniorCitizen)
test <- chisq.test(table(DATA_RAW$Churn, DATA_RAW$SeniorCitizen))
test
#Pearson residuals 
library(vcd)
mosaic(~ Churn + SeniorCitizen, direction = c("v", "h"), data = DATA_RAW, shade = TRUE)

summary(DATA_RAW)

#logistic regression
set.seed(2017)
sample_size <- floor(0.7 * nrow(DATA_RAW))
PART <- sample(seq_len(nrow(DATA_RAW)), size = sample_size)
training <- DATA_RAW[PART,]
testing <- DATA_RAW[-PART,]
dim(training); dim(testing)
model <- glm(formula = Churn ~ ., family = binomial(link = "logit"), data = training)
print(summary(model))

customer.predicts <- predicts <- predict(model, newdata=testing, type = "response")
customer.predicts <- ifelse(customer.predicts>0.5,1,0)
a <- testing$Churn
table(a,customer.predicts)

#Decision tree
tree<- ctree(Churn~gender+SeniorCitizen+Partner+Dependents+PhoneService+MultipleLines+InternetService+OnlineSecurity+OnlineBackup+DeviceProtection+StreamingMoviews+Contract+MonthlyCharges+tensure, training)
plot(tree)
plot(tree, typle='simple')

predict_tree <- predict(tree, testing)
table(predict_tree, testing$Churn)
