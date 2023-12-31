# Model EMP for R: out-of-sample predictions
# equations taken from Model PC
# Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 9 November 2023

################################################################################

#A) OUT-OF-SAMPLE PREDICTION (DETERMINISTIC)

# Extend exogenous and conditionally-evaluated variables up to 2028
PC_model$modelData <- within(PC_model$modelData,{ g = TSEXTEND(g,  UPTO=c(2028,1)) })

# Define exogenisation list
exogenizeList <- list(
  
  r = TRUE,                     #Interest rate (whole period)
  t = c(1998,1,2021,1),         #Taxes
  cons = c(1998,1,2021,1),      #Consumption
  b_h = c(1998,1,2021,1)        #Bills held by households
  
)

# Define add-factor list (defining exogenous adjustments: policy + available predictions)
constantAdjList <- list(
  
  cons = TIMESERIES(0,0,0,0,0,0,0,0,START=c(2021,1), FREQ='A'),  #Shock to consumption 
  t    = TIMESERIES(0,0,0,0,0,0,0,0,START=c(2021,1), FREQ='A')  #Shock to taxes
  
)

# Simulate model
PC_model <- SIMULATE(PC_model
                    ,simType='DYNAMIC' #try also: 'FORECAST'
                    ,TSRANGE=c(1998,1,2028,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=1000
                    ,Exogenize=exogenizeList
                    ,ConstantAdjustment=constantAdjList
                    ,quietly=TRUE)

#PLOTS FOR VISUAL INSPECTION
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

# GDP
plot(PC_model$simulation$y,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="a) Italy GDP (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$y*0.85),max(PC_model$simulation$y*1.05)))
lines(PC_modelData$y,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="b) Italy consumption (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$cons*0.85),max(PC_model$simulation$cons*1.05)))
lines(PC_modelData$cons,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="c) Italy tax revenue (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$t*0.85),max(PC_model$simulation$t*1.05)))
lines(PC_modelData$t,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

# Bills held by househeolds
plot(PC_model$simulation$b_h,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="d) Italy bills holdings (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$b_h*0.85),max(PC_model$simulation$b_h*1.05)))
lines(PC_modelData$b_h,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

################################################################################

#CONSISTENCY CHECK

#Create consistency statement 
aerror=0
error=0
for (i in 1:30){error = error + (PC_model$simulation$h_s[i]-PC_model$simulation$h_h[i])^2}
aerror = error/30
if ( aerror<0.01 ){cat(" *********************************** \n Good news! The model is watertight! \n", "Average error =", aerror, "< 0.01 \n", "Cumulative error =", error, "\n ***********************************")} else{
  if ( aerror<1 && aerror<1 ){cat(" *********************************** \n Minor issues with model consistency \n", "Average error =", aerror, "> 0.01 \n", "Cumulative error =", error, "\n ***********************************")}
  else{cat(" ******************************************* \n Warning: the model is not fully consistent! \n", "Average error =", aerror, "> 1 \n", "Cumulative error =", error, "\n *******************************************")} }      

#Plot redundant equation
layout(matrix(c(1), 1, 1, byrow = TRUE))
plot(PC_model$simulation$h_s-PC_model$simulation$h_h, type="l", col="green",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main=expression("Consistency check (baseline scenario, o.o.s., det.): " * italic(H[phantom("")]["s"]) - italic(H[phantom("")]["h"])),
     cex.axis=1.5,cex.lab=1.5,ylab = '£',
     xlab = 'Time',ylim = range(-1,1))


################################################################################

#B) OUT-OF-SAMPLE PREDICTION (STOCHASTIC)

#Define stochastic structure (disturbances)
myStochStructure <- list(
  
  #Consumption: normally-distributed shocks
  cons=list(
    TSRANGE=c(2022,1,2028,1),
    TYPE='NORM', #UNIF
    PARS=c(0,PC_model$behaviorals$cons$statistics$StandardErrorRegression)
  ),
  
  #Taxes: normally-distributed shocks
  t=list(
    TSRANGE=c(2022,1,2028,1),
    TYPE='NORM', #UNIF
    PARS=c(0,PC_model$behaviorals$t$statistics$StandardErrorRegression)
  )
  
)

# Simulate model again
PC_model <- STOCHSIMULATE(PC_model
                         ,simType='FORECAST'
                         ,TSRANGE=c(2021,1,2028,1)
                         
                         ,StochStructure=myStochStructure
                         ,StochSeed=123
                         
                         ,simConvergence=0.00001
                         ,simIterLimit=1000
                         ,Exogenize=exogenizeList
                         ,ConstantAdjustment=constantAdjList
                         ,quietly=TRUE)

#PLOTS FOR VISUAL INSPECTION 

#Set layout
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

#Create custom colours
mycol1 <- rgb(0,255,0, max = 255, alpha = 80)
mycol2 <- rgb(255,0,0, max = 255, alpha = 30)

#Create and dsplay the charts

# GDP
plot(PC_model$stochastic_simulation$y$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="a) Italy GDP (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$y*0.95),max(PC_model$stochastic_simulation$y$mean*1.05)))
lines(PC_model$stochastic_simulation$y$mean+2*PC_model$stochastic_simulation$y$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$y$mean-2*PC_model$stochastic_simulation$y$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$y,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$y$mean + 2 * PC_model$stochastic_simulation$y$sd
y_lower <- PC_model$stochastic_simulation$y$mean - 2 * PC_model$stochastic_simulation$y$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)

# Consumption
plot(PC_model$stochastic_simulation$cons$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="b) Italy consumption (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$cons*0.95),max(PC_model$stochastic_simulation$cons$mean*1.05)))
lines(PC_model$stochastic_simulation$cons$mean+2*PC_model$stochastic_simulation$cons$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$cons$mean-2*PC_model$stochastic_simulation$cons$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$cons,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$cons$mean + 2 * PC_model$stochastic_simulation$cons$sd
y_lower <- PC_model$stochastic_simulation$cons$mean - 2 * PC_model$stochastic_simulation$cons$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)

# Tax revenue
plot(PC_model$stochastic_simulation$t$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="c) Italy tax revenue (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$t*0.95),max(PC_model$stochastic_simulation$t$mean*1.05)))
lines(PC_model$stochastic_simulation$t$mean+2*PC_model$stochastic_simulation$t$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$t$mean-2*PC_model$stochastic_simulation$t$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$t,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$t$mean + 2 * PC_model$stochastic_simulation$t$sd
y_lower <- PC_model$stochastic_simulation$t$mean - 2 * PC_model$stochastic_simulation$t$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)

# Bills held by households
plot(PC_model$stochastic_simulation$b_h$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="d) Italy bills holdings (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$b_h*0.95),max(PC_model$stochastic_simulation$b_h$mean*1.1)))
lines(PC_model$stochastic_simulation$b_h$mean+2*PC_model$stochastic_simulation$b_h$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$b_h$mean-2*PC_model$stochastic_simulation$b_h$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$b_h,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$b_h$mean + 2 * PC_model$stochastic_simulation$b_h$sd
y_lower <- PC_model$stochastic_simulation$b_h$mean - 2 * PC_model$stochastic_simulation$b_h$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)
