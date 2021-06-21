data1 <- read.csv(file = "C:/Users/mingm/Downloads/churn_clean.csv", header= TRUE, stringsAsFactors = TRUE)
str(data1)
sapply(data1, function(x) sum(is.na(x)))
new_data=subset(data1, select = -c(CaseOrder, Customer_id, Interaction, UID, City, State, County, Zip, Lat, Lng, Population, Area, TimeZone, Job, Children, Age, Income, Marital, Gender, Churn, Item1, Item2, Item3, Item4, Item5, Item6, Item7, Item8))
str(new_data)

library(ggplot2)
bar1 <- ggplot(new_data) + geom_bar(aes(x=StreamingTV), fill = "blue")
bar1
plot(Tenure ~ MonthlyCharge, data=new_data)


MLR <- lm(Tenure~Outage_sec_perweek+Email+Contacts+Yearly_equip_failure+Techie+Contract+Port_modem+Tablet+InternetService+Phone+Multiple+OnlineSecurity+OnlineBackup+DeviceProtection+TechSupport+StreamingTV+StreamingMovies+PaperlessBilling+MonthlyCharge+Bandwidth_GB_Year, data=new_data)
print(MLR)
library(MASS)
fitted_model <- stepAIC(MLR, direction="both")
fitted_model$anova
summary(fitted_model)
summary (MLR)
plot(fitted(fitted_model), residuals(fitted_model))
abline(h = 0, lty = 2)

RMSE.MLR <- sqrt(mean(MLR$residuals^2))
RMSE.FIT <- sqrt(mean(fitted_model$residuals^2))


