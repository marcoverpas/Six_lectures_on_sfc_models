# Model EMP for R: in-sample predictions
# equations taken from Model PC
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 8 November 2023

################################################################################
# Copyright (c) 2023 Marco Veronese Passarella
#
# Permission is hereby granted, free of charge, to any person obtaining a 
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, 
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
# IN THE SOFTWARE.
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
plot(PC_model$simulation$y,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="a) Italy GDP (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$y*0.95),max(PC_model$simulation$y*1.05)))
lines(PC_modelData$y,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="b) Italy consumption (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$cons*0.95),max(PC_model$simulation$cons*1.05)))
lines(PC_modelData$cons,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="c) Italy tax revenue (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$t*0.95),max(PC_model$simulation$t*1.05)))
lines(PC_modelData$t,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)

# Bills held by househeolds
plot(PC_model$simulation$b_h,col="red1",lty=1,lwd=1,font.main=1,cex.main=1,main="d) Italy bills holdings (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$b_h*0.95),max(PC_model$simulation$b_h*1.05)))
lines(PC_modelData$b_h,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (unadjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","red1"), box.lty=0)


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
plot(PC_model$simulation$y,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="a) Italy GDP (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$y*0.95),max(PC_model$simulation$y*1.05)))
lines(PC_modelData$y,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="b) Italy consumption (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$cons*0.95),max(PC_model$simulation$cons*1.05)))
lines(PC_modelData$cons,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="c) Italy tax revenue (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$t*0.95),max(PC_model$simulation$t*1.05)))
lines(PC_modelData$t,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)

# Bills held by households
plot(PC_model$simulation$b_h,col="green4",lty=1,lwd=1,font.main=1,cex.main=1,main="d) Italy bills holdings (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1998,2021),
     ylim=range(min(PC_model$simulation$b_h*0.95),max(PC_model$simulation$b_h*1.05)))
lines(PC_modelData$b_h,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","green4"), box.lty=0)