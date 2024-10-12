# load necessary libraries
library(readr)
library(caTools)
library(corrplot)
library(caret)
library(iterators)
library(car)
library(caTools)
library(ggplot2)
library(tidyr)
library(dplyr)
library(rpart)
library(rpart.plot )
library(ROCR)
library(rattle)
library(randomForest)

# load and explore data
bike <- read.csv("data/SeoulBikeData.csv")
dim(bike)
str(bike)
names(bike)
head(bike)

# check for NAs, invalid values and outliers
summary(bike)
boxplot(bike[,c(2:11)])

# looking for correlation of dependent variable with independent variables and multicollinearity
df = subset(bike, select = -c(1, 12, 13, 14))
corrplot(cor(df),method='number', type="lower")

# does the dependent variable follow a normal distribution
hist(bike$Rented.Bike.Count,
     main = "Histogram of Rented Bikes",
     xlab = "Rented Bike Count")

# check linearity of dependent variable with each independent variable
ggplot(bike, aes(x = Date, y = Rented.Bike.Count)) +
  geom_bar(stat="identity") +
  labs (title = "Rented Bike Count Across the Year",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Hour, y = Rented.Bike.Count)) +
  geom_bar(stat="identity") +
  labs (title = "Rented Bike Count Across the Day", 
        y = "Rented Bike Count")

ggplot(bike, aes(x = Temperature..C., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Temperature (°C)", 
        x = "Temperature (°C)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Humidity..., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Humidity (%)", 
        x = "Humidity (%)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Wind.speed..m.s., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Wind Speed (m/s)",
        x = "Wind Speed (m/s)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Visibility..10m., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Visibility (10m)",
        x = "Visibility (10m)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Dew.point.temperature..C., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Dew Point Temperature (°C)",
        x = "Dew Point Temperature (°C)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Solar.Radiation..MJ.m2., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Solar Radiation (MJ/m2)",
        x = "Solar Radiation (MJ/m2)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Rainfall.mm., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Rainfall (mm)",
        x = "Rainfall (mm)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Snowfall..cm., y = Rented.Bike.Count)) +
  geom_point() +
  geom_smooth(method=lm) +
  labs (title = "Rented Bike Count and Snowfall (cm)",
        x = "Snowfall (cm)",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Seasons, y = Rented.Bike.Count)) +
  geom_bar(stat="identity") +
  labs (title = "Rented Bike Count Across the Seasons",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Holiday, y = Rented.Bike.Count)) +
  geom_bar(stat="identity") +
  labs (title = "Rented Bike Count Across the Holidays",
        y = "Rented Bike Count")

ggplot(bike, aes(x = Functioning.Day, y = Rented.Bike.Count)) +
  geom_bar(stat="identity") +
  labs (title = "Rented Bike Count and Functioning Days",
        x = "Functioning Day",
        y = "Rented Bike Count")

# convert 'Seasons', 'Holiday', and 'Functioning Day' to factors
bike$Seasons <- as.factor(bike$Seasons)
bike$Holiday <- as.factor(bike$Holiday)
bike$Functioning.Day <- as.factor(bike$Functioning.Day)

# Linear Regression Model

# random seed
set.seed(123)

# make a split
split = sample.split(bike$Rented.Bike.Count, SplitRatio=0.6)

# create training and test sets
train = subset(bike, split==TRUE)
test = subset(bike, split==FALSE)
nrow(train)
nrow(test)

# baseline model - predict the mean
best.guess <- mean(bike$Rented.Bike.Count)
RMSE.baseline <- sqrt(mean((best.guess-train$Rented.Bike.Count)^2))
RMSE.baseline
MAE.baseline <- mean(abs(best.guess-train$Rented.Bike.Count))
MAE.baseline

# build linear regression using all independent variables apart from date
LIN1 = lm(Rented.Bike.Count~Hour+Temperature..C.+Humidity...+Wind.speed..m.s.+Visibility..10m.+Dew.point.temperature..C.+Solar.Radiation..MJ.m2.+Rainfall.mm.+Snowfall..cm.+Seasons+Holiday+Functioning.Day,data=train)
options(scipen=999) # turns off scientific notation
summary(LIN1)

# display values of all residuals
LIN1$residuals

# compute Sum of Square Errors (SSE)
SSE.LIN1 = sum(LIN1$residuals^2)
SSE.LIN1

# compute Root Mean Square Error (RMSE) and MAE of LIN1
RMSE.LIN1 = sqrt(mean((train$Rented.Bike.Count - predict(LIN1, train)) ^ 2))
RMSE.LIN1
RMSE.LIN1.1 = sqrt((SSE.LIN1/nrow(train)))
RMSE.LIN1.1
MAE.LIN1 = mean(abs(train$Rented.Bike.Count-predict(LIN1, train)))
MAE.LIN1

# check for multicollinearity
vif(LIN1)

# make predictions for the test data
predict.LIN1 = predict(LIN1,newdata=test)
predict.LIN1

# compute sum of squared errors for predictions
SSE.LIN1.prediction= sum((test$Rented.Bike.Count - predict.LIN1)^2)

# compute total sum of squares 
SST = sum((test$Rented.Bike.Count - best.guess)^2)

# compute out of sample R-squared
R2.LIN1.prediction =1 - SSE.LIN1.prediction/SST
R2.LIN1.prediction

# compute Root Mean Square Error (RMSE) and MAE of LIN1 on the test set
RMSE.LIN1.prediction = sqrt(mean((test$Rented.Bike.Count - predict.LIN1) ^ 2))
RMSE.LIN1.prediction
RMSE.LIN1.prediction.1 = sqrt((SSE.LIN1.prediction/nrow(test)))
RMSE.LIN1.prediction.1
MAE.LIN1.prediction = mean(abs(test$Rented.Bike.Count- predict.LIN1))
MAE.LIN1.prediction

# second model removes visibility
LIN2 = lm(Rented.Bike.Count~Hour+Temperature..C.+Humidity...+Wind.speed..m.s.+Dew.point.temperature..C.+Solar.Radiation..MJ.m2.+Rainfall.mm.+Snowfall..cm.+Seasons+Holiday+Functioning.Day,data=train)
summary(LIN2)

# compute Sum of Square Errors (SSE)
SSE.LIN2 = sum(LIN2$residuals^2)
SSE.LIN2

# compute Root Mean Square Error (RMSE) and MAE of LIN2
RMSE.LIN2 = sqrt(mean((train$Rented.Bike.Count - predict(LIN2, train)) ^ 2))
RMSE.LIN2
RMSE.LIN2.1 = sqrt((SSE.LIN2/nrow(train)))
RMSE.LIN2.1
MAE.LIN2 = mean(abs(train$Rented.Bike.Count-predict(LIN2, train)))
MAE.LIN2

# check for multicollinearity
vif(LIN2)

# make predictions for the test data
predict.LIN2 = predict(LIN2,newdata=test)
predict.LIN2

# compute sum of squared errors for predictions
SSE.LIN2.prediction = sum((test$Rented.Bike.Count - predict.LIN2)^2)

# compute out of sample R-squared
R2.LIN2.prediction =1 - SSE.LIN2.prediction/SST
R2.LIN2.prediction

# compute Root Mean Square Error (RMSE) and MAE of LIN2 on the test set
RMSE.LIN2.prediction = sqrt(mean((test$Rented.Bike.Count - predict.LIN2) ^ 2))
RMSE.LIN2.prediction
RMSE.LIN2.prediction.1 = sqrt((SSE.LIN2.prediction /nrow(test)))
RMSE.LIN2.prediction.1
MAE.LIN2.prediction = mean(abs(test$Rented.Bike.Count- predict.LIN2))
MAE.LIN2.prediction

# third model removes dew point temperature
LIN3 = lm(Rented.Bike.Count~Hour+Temperature..C.+Humidity...+Wind.speed..m.s.+Solar.Radiation..MJ.m2.+Rainfall.mm.+Snowfall..cm.+Seasons+Holiday+Functioning.Day,data=train)
summary(LIN3)

# compute Sum of Square Errors (SSE)
SSE.LIN3 = sum(LIN3$residuals^2)
SSE.LIN3

# compute Root Mean Square Error (RMSE) and MAE of LIN3
RMSE.LIN3 = sqrt(mean((train$Rented.Bike.Count - predict(LIN3, train)) ^ 2))
RMSE.LIN3
RMSE.LIN3.1 = sqrt((SSE.LIN3/nrow(train)))
RMSE.LIN3.1
MAE.LIN3 = mean(abs(train$Rented.Bike.Count-predict(LIN3, train)))
MAE.LIN3

# check for multicollinearity
vif(LIN3)

# make predictions for the test data
predict.LIN3 = predict(LIN3,newdata=test)
predict.LIN3

# compute sum of squared errors for predictions
SSE.LIN3.prediction = sum((test$Rented.Bike.Count - predict.LIN3)^2)

# compute out of sample R-squared
R2.LIN3.prediction =1 - SSE.LIN3.prediction/SST
R2.LIN3.prediction

# compute Root Mean Square Error (RMSE) and MAE of LIN3 on the test set
RMSE.LIN3.prediction = sqrt(mean((test$Rented.Bike.Count - predict.LIN3) ^ 2))
RMSE.LIN3.prediction
RMSE.LIN3.prediction.1 = sqrt((SSE.LIN3.prediction /nrow(test)))
RMSE.LIN3.prediction.1
MAE.LIN3.prediction = mean(abs(test$Rented.Bike.Count- predict.LIN3))
MAE.LIN3.prediction

# Model Comparison

# create a data frame with the prediction error metrics for each method 
accuracy.LIN <- data.frame(Method = c("Baseline","LIN1","LIN2","LIN3"), 
                       R2 = c(NA,R2.LIN1.prediction,R2.LIN2.prediction,R2.LIN3.prediction),
                       RMSE=c(RMSE.baseline,RMSE.LIN1.prediction,RMSE.LIN2.prediction,RMSE.LIN3.prediction), 
                       MAE = c(MAE.baseline,MAE.LIN1.prediction,MAE.LIN2.prediction,MAE.LIN3.prediction))

# round the values and print the table 
accuracy.LIN$RMSE <- round(accuracy.LIN$RMSE,4) 
accuracy.LIN$MAE <- round(accuracy.LIN$MAE,4) 
accuracy.LIN$R2 <- round(accuracy.LIN$R2,4)
accuracy.LIN 

# create a data frame with the predictions for each method 
all.predictions.LIN <- data.frame(actual = test$Rented.Bike.Count, 
                              baseline = best.guess, 
                              LIN1 = predict.LIN1, 
                              LIN2 = predict.LIN2,
                              LIN3 = predict.LIN3) 
# first six observations 
head(all.predictions.LIN) 

# melt the columns with the gather() function and gather the prediction variables (columns) into a single row
all.predictions.LIN <- gather(all.predictions.LIN,key = model,value = predictions,2:5) 
head(all.predictions.LIN) 
tail (all.predictions.LIN) 
summary(all.predictions.LIN)

# plot predicted vs. actual for each linear regression model 
ggplot(data = all.predictions.LIN,aes(x = actual, y = predictions)) + 
  geom_point(colour = "blue") + 
  geom_abline(intercept = 0, slope = 1, colour = "red") + 
  facet_wrap(~ model,ncol = 2) + 
  coord_cartesian(xlim = NULL,ylim = NULL) + 
  ggtitle("Predicted vs. Actual, by model")

# Regression Tree

# rpart function applied to a numeric variable => regression tree 
rt <- rpart(Rented.Bike.Count~.-Date, data=train)

# see the tree
fancyRpartPlot(rt) 

# predict and evaluate on the test set 
test.pred.rtree <- predict(rt,test) 
RMSE.rtree <- sqrt(mean((test.pred.rtree-test$Rented.Bike.Count)^2)) 
RMSE.rtree 
MAE.rtree <- mean(abs(test.pred.rtree-test$Rented.Bike.Count)) 
MAE.rtree 

# check cross-validation results (xerror column) 
printcp(rt) 

# get the optimal CP
min.xerror.CP <- rt$cptable[which.min(rt$cptable[,"xerror"]),"CP"] 
min.xerror.CP 
# optimal is what we already have so no need to prune tree

# RandomForest Model

# random seed
set.seed(1234) 

# create a random forest with 10000 trees 
rf <- randomForest(Rented.Bike.Count~.-Date, data = train, importance = TRUE, ntree=10000) 

# calculate how many trees are needed to reach the minimum error estimate
which.min(rf$mse)

# plot rf to see the estimated error as a function of the number of trees 
plot(rf) 

# calculate the importance of each variable 
imp <- as.data.frame(sort(importance(rf)[,1],decreasing = TRUE),optional = T) 
names(imp) = "% Inc MSE" 
imp 

# which variables are the most important?
varImpPlot(rf)

# predict and evaluate on the test set 
test.pred.forest <- predict(rf,test) 

RMSE.forest <- sqrt(mean((test.pred.forest-test$Rented.Bike.Count)^2)) 
RMSE.forest 
MAE.forest <- mean(abs(test.pred.forest-test$Rented.Bike.Count)) 
MAE.forest 

# create a data frame with the error metrics for each method 
accuracy <- data.frame(Method = c("Baseline","Linear Regression3","Full tree","Random forest"), 
                       RMSE = c(RMSE.baseline,RMSE.LIN3,RMSE.rtree,RMSE.forest), 
                       MAE = c(MAE.baseline,MAE.LIN3,MAE.rtree,MAE.forest))

# round the values and print the table 
accuracy$RMSE <- round(accuracy$RMSE,4) 
accuracy$MAE <- round(accuracy$MAE,4) 
accuracy 

# create a data frame with the predictions for each method 
all.predictions <- data.frame(actual = test$Rented.Bike.Count, 
                              baseline = best.guess, 
                              linear.regression = predict.LIN3, 
                              full.tree = test.pred.rtree, 
                              random.forest = test.pred.forest) 

# first six observations 
head(all.predictions) 

# gather the prediction variables (columns) into a single row
all.predictions <- gather(all.predictions,key = model,value = predictions,2:5) 
head(all.predictions) 
tail (all.predictions) 
summary(all.predictions)

# plot predicted vs. actual for each model 
ggplot(data = all.predictions,aes(x = actual, y = predictions)) + 
  geom_point(colour = "blue") + 
  geom_abline(intercept = 0, slope = 1, colour = "red") + 
  facet_wrap(~ model,ncol = 2) + 
  coord_cartesian(xlim = NULL,ylim = NULL) + 
  ggtitle("Predicted vs. Actual, by model") 
