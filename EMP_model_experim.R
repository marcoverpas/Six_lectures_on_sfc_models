# Model EMP for R: experiments
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

#A) CREATE BASELINE SCENARIO

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

#Attribute values to selected variables
y_0=PC_model$simulation$y
cons_0=PC_model$simulation$cons
t_0=PC_model$simulation$t
b_h_0=PC_model$simulation$b_h

################################################################################
#B) CREATE ALTERNATIVE SCENARIO

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
  t    = TIMESERIES(30000,30000,30000,30000,30000,30000,30000,30000,START=c(2021,1), FREQ='A')  #Shock to taxes
  
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

#Set layout
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

#Create custom colours
mycol1 <- rgb(0,255,0, max = 255, alpha = 80)
mycol2 <- rgb(255,0,0, max = 255, alpha = 30)

# GDP
plot(PC_model$simulation$y,col="red1",lty=1,lwd=2,font.main=1,cex.main=1,main="a) Italy GDP (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$y*0.85),max(y_0)))
lines(y_0,col="deepskyblue4",lty=2,lwd=2)
lines(PC_modelData$y,col="deepskyblue4",lty=1,lwd=2)
abline(v=2021,col=mycol1)
legend("bottom",c("Baseline","Shock (increase in taxation)"),  bty = "n", cex=1, lty=c(1,1), lwd=c(2,2),
       col = c("deepskyblue4","red1"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="red1",lty=1,lwd=2,font.main=1,cex.main=1,main="b) Italy consumption (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$cons*0.85),max(cons_0)))
lines(cons_0,col="deepskyblue4",lty=2,lwd=2)
lines(PC_modelData$cons,col="deepskyblue4",lty=1,lwd=2)
abline(v=2021,col=mycol1)
legend("bottom",c("Baseline","Shock (increase in taxation)"),  bty = "n", cex=1, lty=c(1,1), lwd=c(2,2),
       col = c("deepskyblue4","red1"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="red1",lty=1,lwd=2,font.main=1,cex.main=1,main="c) Italy tax revenue (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$t*0.85),max(t_0)))
lines(t_0,col="deepskyblue4",lty=2,lwd=2)
lines(PC_modelData$t,col="deepskyblue4",lty=1,lwd=2)
abline(v=2021,col=mycol1)
legend("bottom",c("Baseline","Shock (increase in taxation)"),  bty = "n", cex=1, lty=c(1,1), lwd=c(2,2),
       col = c("deepskyblue4","red1"), box.lty=0)

# Bills held by households
plot(PC_model$simulation$b_h,col="red1",lty=1,lwd=2,font.main=1,cex.main=1,main="d) Italy bills holdings (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$b_h*0.85),max(b_h_0)))
lines(b_h_0,col="deepskyblue4",lty=2,lwd=2)
lines(PC_modelData$b_h,col="deepskyblue4",lty=1,lwd=2)
abline(v=2021,col=mycol1)
legend("bottom",c("Baseline","Shock (increase in taxation)"),  bty = "n", cex=1, lty=c(1,1), lwd=c(2,2),
       col = c("deepskyblue4","red1"), box.lty=0)
