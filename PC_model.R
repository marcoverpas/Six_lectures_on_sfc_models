# Model PC for R: main code
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 30 May 2019; revised: 6 November 2023

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

#STEP 1: PREPARE THE WORK-SPACE

#Clear environment
rm(list=ls(all=TRUE))

#Clear plots
if(!is.null(dev.list())) dev.off()

#Clear console
cat("\014")

#Number of periods
nPeriods = 90

#Number of scenarios
nScenarios=3 

################################################################################

#STEP 2: SET THE COEFFICIENTS (EXOGENOUS VARIABLES AND PARAMETERS)
alpha1=matrix(data=0.6,nrow=nScenarios,ncol=nPeriods) #Propensity to consume out of income
alpha2=0.4 #Propensity to consume out of wealth
lambda0 = 0.635 #Autonomous share of bills
lambda1 = 5 #Elasticity of bills demand to interest rate
lambda2 = 0.01 #Elasticity of bills demand to yd/v
theta=0.2 #Tax rate on income
r_bar=matrix(data=0.025,nrow=nScenarios,ncol=nPeriods) #Interest rate as policy instrument

################################################################################

#STEP 3: CREATE VARIABLES AND ATTRIBUTE INITIAL VALUES
b_cb=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Government bills held by Central Bank
b_h=matrix(data=64.87,nrow=nScenarios,ncol=nPeriods) #Government bills held by households
b_s=matrix(data=21.62+64.87,nrow=nScenarios,ncol=nPeriods) #Government bills supplied by government
cons=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Consumption 
g=matrix(data=20,nrow=nScenarios,ncol=nPeriods) #Government expenditure
h_h=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Cash money held by households
h_s=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Cash money supplied by central bank
r=matrix(data=r_bar,nrow=nScenarios,ncol=nPeriods) #Interest rate on government bills
t=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Taxes
v=matrix(data=64.87+21.62,nrow=nScenarios,ncol=nPeriods) #Households wealth
y=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Income = GDP
yd=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Disposable income of households

################################################################################

#STEP 4: RUN THE MODEL

#STEP 4.A: DEFINE THE LOOPS

#Choose scenario
for (j in 1:nScenarios){
  
  #Define time loop
  for (i in 2:nPeriods){
    
    #Define iterations
    for (iterations in 1:100){
      
      
      #STEP 4.B: ADD ALTERNATIVE SCENARIOS  
      
      #Shock 1: higher interest rate
      if (i>=10 && j==2){r_bar[j,i]=0.035}
      
      #Shock 2: higher propensity to consume out of income
      if (i>=10 && j==3){alpha1[j,i]=0.7}
      
      
      #STEP 4.C: DEFINE THE SYSTEM OF EQUATIONS        
      
      #Determination of output - eq. 4.1
      y[j,i] = cons[j,i] + g[j,i]
      
      #Disposable income - eq. 4.2
      yd[j,i] = y[j,i] - t[j,i] + r[j,i-1]*b_h[j,i-1]
      
      #Tax payments - eq. 4.3
      t[j,i] = theta*(y[j,i] + r[j,i-1]*b_h[j,i-1])
      
      #Wealth accumulation - eq. 4.4
      v[j,i] = v[j,i-1] + (yd[j,i] - cons[j,i])
      
      #Consumption function - eq. 4.5
      cons[j,i] = alpha1[j,i]*yd[j,i] + alpha2*v[j,i-1]
      
      #Cash money - eq. 4.6
      h_h[j,i] = v[j,i] - b_h[j,i]
      
      #Demand for government bills - eq. 4.7
      b_h[j,i] = v[j,i]*(lambda0 + lambda1*r[j,i] - lambda2*(yd[j,i]/v[j,i]))
      
      #Supply of government bills - eq. 4.8
      b_s[j,i] = b_s[j,i-1] + (g[j,i] + r[j,i-1]*b_s[j,i-1]) - (t[j,i] + r[j,i-1]*b_cb[j,i-1])
      
      #Supply of cash - eq. 4.9
      h_s[j,i] = h_s[j,i-1] + b_cb[j,i] - b_cb[j,i-1]
      
      #Government bills held by the central bank - eq. 4.10
      b_cb[j,i] = b_s[j,i] - b_h[j,i]
      
      #Interest rate as policy instrument - eq. 4.11
      r[j,i] = r_bar[j,i]
      
      
        }
      }
    }

################################################################################

#STEP 5: CONSISTENCY CHECK (REDUNDANT EQUATION)

#Create consistency statement 
aerror=0
error=0
for (i in 2:(nPeriods-1)){error = error + (h_s[1,i]-h_h[1,i])^2}
aerror = error/nPeriods
if ( aerror<0.01 ){cat(" *********************************** \n Good news! The model is watertight! \n", "Average error =", aerror, "< 0.01 \n", "Cumulative error =", error, "\n ***********************************")} else{
  if ( aerror<1 && aerror<1 ){cat(" *********************************** \n Minor issues with model consistency \n", "Average error =", aerror, "> 0.01 \n", "Cumulative error =", error, "\n ***********************************")}
  else{cat(" ******************************************* \n Warning: the model is not fully consistent! \n", "Average error =", aerror, "> 1 \n", "Cumulative error =", error, "\n *******************************************")} }      

#Plot redundant equation
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))
plot(h_s[1,2:nPeriods]-h_h[1,2:nPeriods], type="l", col="green",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main=expression("Consistency check (baseline scenario): " * italic(H[phantom("")]["s"]) - italic(H[phantom("")]["h"])),
     cex.axis=1.5,cex.lab=1.5,ylab = '£',
     xlab = 'Time',ylim = range(-1,1))

################################################################################

#STEP 6: CREATE AND DISPLAY GRAPHS

#Set layout
#layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))

#Figure 1
plot(100*h_h[2,2:25]/v[2,2:25],type="l", col=1, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 1  Evolution of shares of bills and money following \n an increase in 100 points in the rate of interest on bills",
     ylab = '%',xlab = 'Time',ylim = range(20,25),cex.axis=1.5,cex.lab=1.5)
par(new=T)
plot(100*b_h[2,2:25]/v[2,2:25],type="l",lwd=3,lty=2,col=rgb(0,187,110,max=255),axes=F, ylab=NA,
     xlab=NA,ylim=range(75,80))
axis(side = 4,cex.axis=1,cex.lab=1.5)
legend("right",c("Share of money balances","Share of bills (right axis)"),  bty = "n",
       cex=1.5, lty=c(1,2), lwd=c(3,3), col = c(1,rgb(0,187,110,max=255)), box.lty=0)

#Figure 2
plot(yd[2,2:45],type="l", col=1, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 2  Evolution of household disposable income and consumption \n following an increase in 100 points in the rate of interest on bills",
     ylab = '£',xlab = 'Time',ylim = range(86,91),cex.axis=1.5,cex.lab=1.5)
lines(cons[2,2:45],type="l",lwd=3,lty=2,col=4)
legend("right",c("Disposable income","Consumption"),  bty = "n",
       cex=1.5, lty=c(1,2), lwd=c(3,3), col = c(1,4), box.lty=0)

#Figure 3 - Note: different from 4.5 as expectations are not included
plot(y[3,2:60],type="l", col=2, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 3  Evolution of national income (GDP) following an increase in \n the propensity to consume out of expected disposable income",
     ylab = '£',xlab = 'Time',ylim = range(105,126),cex.axis=1.5,cex.lab=1.5)
abline(h=y[3,2],col="green",lty=2,lwd=2)
abline(h=y[3,60],col="blue",lty=2,lwd=2)
legend("right",c("National income","Old steady state","New steady state"),  bty = "n",
       cex=1.5, lty=c(1,2,2), lwd=c(3,2,2), col = c(2,"blue","green"), box.lty=0)