# Model EMP for R: in-sample predictions
# equations taken from Model PC
# Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 9 November 2023

################################################################################

#A) INSAMPLE PREDICTION (NO ADJUSTMENT)

# Define exogenisation list to 2021
exogenizeList <- list(  r = TRUE  )    #Interest rate
                                  
# In-sample prediction (no add factors)
PC_model <- SIMULATE(PC_model
                     ,simType='STATIC'
                     ,TSRANGE=c(1998,1,2021,1)
                     ,simConvergence=0.00001
                     ,simIterLimit=100
                     ,Exogenize=exogenizeList
                     ,quietly=TRUE)

#PLOTS FOR VISUAL INSPECTION 
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

# GDP
plot(PC_model$simulation$y,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="a) Italy GDP (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$y*0.95),max(PC_model$simulation$y*1.05)))
lines(PC_modelData$y,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="b) Italy consumption (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$cons*0.95),max(PC_model$simulation$cons*1.05)))
lines(PC_modelData$cons,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="c) Italy tax revenue (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$t*0.95),max(PC_model$simulation$t*1.05)))
lines(PC_modelData$t,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

# Bills held by househeolds
plot(PC_model$simulation$b_h,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="d) Italy bills holdings (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$b_h*0.95),max(PC_model$simulation$b_h*1.05)))
lines(PC_modelData$b_h,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

################################################################################

#CONSISTENCY CHECK

#Create consistency statement 
aerror=0
error=0
for (i in 1:23){error = error + (PC_model$simulation$h_s[i]-PC_model$simulation$h_h[i])^2}
aerror = error/23
if ( aerror<0.01 ){cat(" *********************************** \n Good news! The model is watertight! \n", "Average error =", aerror, "< 0.01 \n", "Cumulative error =", error, "\n ***********************************")} else{
  if ( aerror<1 && aerror<1 ){cat(" *********************************** \n Minor issues with model consistency \n", "Average error =", aerror, "> 0.01 \n", "Cumulative error =", error, "\n ***********************************")}
  else{cat(" ******************************************* \n Warning: the model is not fully consistent! \n", "Average error =", aerror, "> 1 \n", "Cumulative error =", error, "\n *******************************************")} }      

#Plot redundant equation
layout(matrix(c(1), 1, 1, byrow = TRUE))
plot(PC_model$simulation$h_s-PC_model$simulation$h_h, type="l", col="green",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main=expression("Consistency check (baseline scenario, no adj.): " * italic(H[phantom("")]["s"]) - italic(H[phantom("")]["h"])),
     cex.axis=1.5,cex.lab=1.5,ylab = '£',
     xlab = 'Time',ylim = range(-1,1))

################################################################################

#B) INSAMPLE PREDICTION (ADJUSTMENT)

# Define new exogenisation list to 2021
exogenizeList <- list(
  
  r = TRUE,                     #Interest rate
  t = TRUE,                     #Taxes
  cons = TRUE,                  #Consumption
  b_h = TRUE                    #Bills held by households
  
)

# Simulate model
PC_model <- SIMULATE(PC_model
                    ,simType='STATIC'
                    ,TSRANGE=c(1998,1,2021,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=100
                    ,Exogenize=exogenizeList
                    ,quietly=TRUE)

#PLOTS FOR VISUAL INSPECTION 
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

# GDP
plot(PC_model$simulation$y,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="a) Italy GDP (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$y*0.95),max(PC_model$simulation$y*1.05)))
lines(PC_modelData$y,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="b) Italy consumption (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$cons*0.95),max(PC_model$simulation$cons*1.05)))
lines(PC_modelData$cons,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="c) Italy tax revenue (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$t*0.95),max(PC_model$simulation$t*1.05)))
lines(PC_modelData$t,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)

# Bills held by households
plot(PC_model$simulation$b_h,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="d) Italy bills holdings (curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$b_h*0.95),max(PC_model$simulation$b_h*1.05)))
lines(PC_modelData$b_h,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)
