# Model REG for R: main code
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 6 

# Version: 31 October 2023

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
nPeriods = 80

#Number of scenarios
nScenarios = 4 

################################################################################

#STEP 2: SET THE COEFFICIENTS (EXOGENOUS VARIABLES AND PARAMETERS)

#Identify parameters
alpha1_n = matrix(data=0.6,nrow=nScenarios,ncol=nPeriods) #Propensity to consume out of income: North
alpha1_s = matrix(data=0.7,nrow=nScenarios,ncol=nPeriods) #Propensity to consume out of income: South
alpha2_n = 0.4 #Propensity to consume out of wealth: North
alpha2_s = 0.3 #Propensity to consume out of wealth: South
lambda0_n = 0.635 #Autonomous share of bills: North
lambda0_s = 0.67 #Autonomous share of bills: South
lambda1_n = 5 #Elasticity of bills demand to interest rate: North
lambda1_s = 6 #Elasticity of bills demand to interest rate: South
lambda2_n = 0.01 #Elasticity of bills demand to yd/v: North
lambda2_s = 0.07 #Elasticity of bills demand to yd/v: South
mu_n = matrix(data=0.18781,nrow=nScenarios,ncol=nPeriods) #Propensity to import: North
mu_s = matrix(data=0.18781,nrow=nScenarios,ncol=nPeriods) #Propensity to import: South
theta = 0.2 #Tax rate on income
r_bar = 0.025 #nterest rate as policy instrument

################################################################################

#STEP 3: CREATE VARIABLES AND ATTRIBUTE INITIAL VALUES
y_n = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #North GDP
y_s = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #South GDP
im_n = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #North import
im_s = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #South import
x_n = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #North export
x_s = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #South export
yd_n = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #North disposable income
yd_s = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #South disposable income
t_n = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #North taxes
t_s = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #South taxes
v_n = matrix(data=86.487,nrow=nScenarios,ncol=nPeriods) #North wealth
v_s = matrix(data=86.487,nrow=nScenarios,ncol=nPeriods) #South wealth
cons_n = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #North consumption
cons_s = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #South consumption 
b_h_n = matrix(data=64.865,nrow=nScenarios,ncol=nPeriods) #North households bills
b_h_s = matrix(data=64.865,nrow=nScenarios,ncol=nPeriods) #South households bills
b_cb = matrix(data=43.244,nrow=nScenarios,ncol=nPeriods) #CB bills
t = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Total tax revenue
g = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Total government spending
h_h_n = matrix(data=v_n - b_h_n,nrow=nScenarios,ncol=nPeriods) #North households cash
h_h_s = matrix(data=v_s - b_h_s,nrow=nScenarios,ncol=nPeriods) #South households cash
b_h = matrix(data=b_h_n + b_h_s,nrow=nScenarios,ncol=nPeriods) #Total household bills
h_h = matrix(data=h_h_n + h_h_s,nrow=nScenarios,ncol=nPeriods) #Total household cash
b_s = matrix(data=b_h + b_cb,nrow=nScenarios,ncol=nPeriods) #Bills supply
h_s = matrix(data=h_h,nrow=nScenarios,ncol=nPeriods) #Cash supply
r = matrix(data=r_bar,nrow=nScenarios,ncol=nPeriods) #Interest rate
g_n = matrix(data=20,nrow=nScenarios,ncol=nPeriods) #North government expenditure (exogenous)
g_s = matrix(data=20,nrow=nScenarios,ncol=nPeriods) #South government expenditure (exogenous)
g = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Total government expenditure

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
      
    #Shock 1: increase in the propensity to import of Region S
    if (i>=30 && j==2){mu_s[j,i]=0.20781}      
    
    #Shock 2: increase in government expenditure in Region S
    if (i>=30 && j==3){g_s[j,i]=25}      
    
    #Shock 3: increase in household saving propensity Region S
    if (i>=30 && j==4){alpha1_s[j,i]=0.6}      
      
    
    #STEP 4.C: DEFINE THE SYSTEM OF EQUATIONS   
      
    # Determination of national income in Region N - eq. 6.1
    y_n[j,i] = cons_n[j,i] + g_n[j,i] + x_n[j,i] - im_n[j,i]

    # Determination of national income in Region S - eq. 6.2
    y_s[j,i] = cons_s[j,i] + g_s[j,i] + x_s[j,i] - im_s[j,i]

    # Imports in Region N - eq. 6.3
    im_n[j,i] = mu_n[j,i]*y_n[j,i]

    # Imports in Region S - eq. 6.4
    im_s[j,i] = mu_s[j,i]*y_s[j,i]

    # Exports of Region N - eq. 6.5
    x_n[j,i] = im_s[j,i]
  
    # Exports of Region S - eq. 6.6
    x_s[j,i] = im_n[j,i]

    # Disposable income in Region N - eq. 6.7
    yd_n[j,i] = y_n[j,i] - t_n[j,i] + r[j,i-1]*b_h_n[j,i-1]

    # Disposable income in Region S - eq. 6.8
    yd_s[j,i] = y_s[j,i] - t_s[j,i] + r[j,i-1]*b_h_s[j,i-1]

    # Tax payments in Region N - eq. 6.9
    t_n[j,i] = theta*(y_n[j,i] + r[j,i-1]*b_h_n[j,i-1])

    # Tax payments in Region S - eq. 6.10
    t_s[j,i] = theta*(y_s[j,i] + r[j,i-1]*b_h_s[j,i-1])

    # Wealth accumulation in Region N - eq. 6.11
    v_n[j,i] = v_n[j,i-1] + (yd_n[j,i] - cons_n[j,i])

    # Wealth accumulation in Region S - eq. 6.12
    v_s[j,i] = v_s[j,i-1] + (yd_s[j,i] - cons_s[j,i])

    # Consumption function in Region N - eq. 6.13
    cons_n[j,i] = alpha1_n[j,i]*yd_n[j,i] + alpha2_n*v_n[j,i-1]

    # Consumption function in Region S - eq. 6.14
    cons_s[j,i] = alpha1_s[j,i]*yd_s[j,i] + alpha2_s*v_s[j,i-1]

    # Cash money held in Region N - eq. 6.15
    h_h_n[j,i] = v_n[j,i] - b_h_n[j,i]

    # Cash money held in Region S - eq. 6.16
    h_h_s[j,i] = v_s[j,i] - b_h_s[j,i]

    # Demand for government bills in Region N - eq. 6.17
    b_h_n[j,i] = v_n[j,i]*lambda0_n + v_n[j,i]*lambda1_n*r[j,i] - lambda2_n*(yd_n[j,i])

    # Demand for government bills in Region S - eq. 6.18
    b_h_s[j,i] = v_s[j,i]*lambda0_s + v_s[j,i]*lambda1_s*r[j,i] - lambda2_s*(yd_s[j,i])

    # Overall tax payments - eq. 6.19
    t[j,i] = t_n[j,i] + t_s[j,i]

    # Overall government expenditure - eq. 6.20
    g[j,i] = g_n[j,i] + g_s[j,i]

    # Total bills outstanding - eq. 6.21
    b_h[j,i] = b_h_n[j,i] + b_h_s[j,i]

    # Total cash outstanding - eq. 6.22
    h_h[j,i] = h_h_n[j,i] + h_h_s[j,i]

    # Supply of government bills - eq. 6.23
    b_s[j,i] = b_s[j,i-1] + (g[j,i] + r[j,i-1]*b_s[j,i-1]) - (t[j,i] + r[j,i-1]*b_cb[j,i-1])

    # Supply of cash - eq. 6.24
    #h_s = b_cb
    h_s[j,i] = h_s[j,i-1] + b_cb[j,i] - b_cb[j,i-1]
    
    # Government bills held by the central bank - eq. 6.25
    b_cb[j,i] = b_s[j,i] - b_h[j,i]

    # Interest rate as policy instrument - eq. 6.26
    r[j,i] = r_bar

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
layout(matrix(c(1,2,3,4,5,6,7,8,9), 3, 3, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))
plot(h_s[1,2:nPeriods]-h_h[1,2:nPeriods], type="l", col="green",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main=expression("Consistency check (baseline scenario): " * italic(H[phantom("")]["s"]) - italic(H[phantom("")]["h"])),
     cex.axis=1.5,cex.lab=1.5,ylab = '£',
     xlab = 'Time',ylim = range(-1,1))

################################################################################

#STEP 6: CREATE AND DISPLAY GRAPHS

#Change layout
#layout(matrix(c(1,2), 1, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))

#Figure 1
plot(y_n[2,28:80],type="l",col=2,lwd=3,lty=1,font.main=1,cex.main=1.5,cex.axis=1.5,cex.lab=1.5,
     main="Figure 1  Evolution of GDP in the N and S Region following \n an increase in the import propensity of the S Region",
     ylab = '£',xlab = 'Time',ylim=range(102,111))
lines(y_s[2,28:80],type="l",lwd=3,lty=2,col=3)
abline(h=106.485,col="gray50")
legend("right",c("North Region GDP","South Region GDP"),
       bty = "n",cex = 1.5,lty=c(1,2),lwd=c(3,3),col=c(2,3),box.lwd=0)

#Figure 2
plot(v_s[2,28:80]-v_s[2,27:79],type="l",col=2,lwd=3,lty=1,font.main=1,cex.main=1.5,cex.axis=1.5,cex.lab=1.5,
     main="Figure 2  Evolution of balances in the S Region following \n an increase in import propensity of the S region",
     ylab = '£',xlab = 'Time',ylim=range(-1.2,0.2))
lines(t_s[2,28:80]-(g_s[2,28:80]+r[2,28:80]*b_h_s[2,27:79]),type="l",lwd=3,lty=2,col=3)
lines(x_s[2,28:80]-im_s[2,28:80],type="l",lwd=3,lty=3,col=4)
abline(h=0,col="gray50")
legend("right",c("Change in households wealth - S Region","Government balance with the S Region","Trade balance - S Region"),
       bty="n",cex = 1.5,lty=c(1,2,3),lwd=c(2,2,2),col=c(2,3,4),box.lwd=0)

#Figure 3
plot(y_n[3,28:80],type="l",col=2,lwd=3,lty=1,font.main=1,cex.main=1.5,cex.axis=1.5,cex.lab=1.5,
     main="Figure 3  Evolution of GDP in the N and S Region following \n an increase in govt. expenditure of the S Region",
     ylab = '£',xlab = 'Time',ylim=range(102,125))
lines(y_s[3,28:80],type="l",lwd=3,lty=2,col=3)
abline(h=106.485,col="gray50")
legend("right",c("North Region GDP","South Region GDP"),
       bty="n",cex=1.5,lty=c(1,2),lwd=c(3,3),col=c(2,3),box.lwd=0)

#Figure 4
plot(v_s[3,28:80]-v_s[3,27:79],type="l",col=2,lwd=3,lty=1,font.main=1,cex.main=1.5,cex.axis=1.5,cex.lab=1.5,
     main="Figure 4  Evolution of balances in the S Region following \n an increase in govt. expenditure of the S Region",
     ylab = '£',xlab = 'Time',ylim=range(-4,3))
lines(t_s[3,28:80]-(g_s[3,28:80]+r[3,28:80]*b_h_s[3,27:79]),type="l",lwd=3,lty=2,col=3)
lines(x_s[3,28:80]-im_s[3,28:80],type="l",lwd=3,lty=3,col=4)
abline(h=0,col="gray50")
legend("topright",c("Change in households wealth - S Region","Government balance with the S Region","Trade balance - S Region"),
       bty="n",cex=1.5,lty=c(1,2,3),lwd=c(2,2,2),col=c(2,3,4),box.lwd=0)

#Figure 5
plot(y_n[4,28:80],type="l",col=2,lwd=3,lty=1,font.main=1,cex.main=1.5,cex.axis=1.5,cex.lab=1.5,
     main="Figure 5  Evolution of GDP in the N and S Region following \n an increase in the saving propensity of the S Region",
     ylab = '£',xlab = 'Time',ylim=range(92,109))
lines(y_s[4,28:80],type="l",lwd=3,lty=2,col=3)
abline(h=106.485,col="gray50")
legend("right",c("North Region GDP","South Region GDP"),
       bty="n",cex = 1.5,lty=c(1,2),lwd=c(3,3),col=c(2,3),box.lwd=0)

#Figure 6
plot(v_s[4,28:80]-v_s[4,27:79],type="l",col=2,lwd=3,lty=1,font.main=1,cex.main=1.5,cex.axis=1.5,cex.lab=1.5,
     main="Figure 6  Evolution of balances in the S Region following \n an increase in the saving propensity of the S Region",
     ylab = '£',xlab = 'Time',ylim=range(-3.2,4.4))
lines(t_s[4,28:80]-(g_s[4,28:80]+r[4,28:80]*b_h_s[4,27:79]),type="l",lwd=3,lty=2,col=3)
lines(x_s[4,28:80]-im_s[4,28:80],type="l",lwd=3,lty=3,col=4)
abline(h=0,col="gray50")
legend("topright",c("Change in households wealth - S Region","Government balance with the S Region","Trade balance - S Region"), 
       bty="n",cex=1.5,lty=c(1,2,3),lwd=c(2,2,2),col=c(2,3,4),box.lwd=0)
