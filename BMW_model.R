# Model BMW for R (from scratch): main code
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 7 

# Version: 30 May 2019; revised: 6 November 2022

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
nPeriods = 150

#Number of scenarios
nScenarios=6 

################################################################################

#STEP 2: SET THE COEFFICIENTS (EXOGENOUS VARIABLES AND PARAMETERS)
alpha2=0.1 #Propensity to consume out of wealth
delta=0.1 #Depreciation rate
gamma=0.15 #Reaction speed of adjustment of capital to its target value
alpha1r = 0.5 #Propensity to consume out of wages if c_d=c_d(r)
alpha1w = 0.75 #Propensity to consume out of interests if c_d=c_d(r)
alpha0=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Set autonomous component of consumption as a matrix (for shocks) 
alpha1=matrix(data=0.75,nrow=nScenarios,ncol=nPeriods) #Set autonomous propensity to consume out of income as a matrix (for shocks) 
kappa=matrix(data=1,nrow=nScenarios,ncol=nPeriods)  #Capital-output ratio
rl_bar=matrix(data=0.04,nrow=nScenarios,ncol=nPeriods)  #Rate of interests on bank loans - exogenously set

################################################################################

#STEP 3: CREATE VARIABLES AND ATTRIBUTE INITIAL VALUES
af=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Create variables and attribute values to stocks
c_d=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Consumption goods demand by households
c_s=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Consumption goods supply
da=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Depreciation allowances
k=matrix(data=0,nrow=nScenarios,ncol=nPeriods)  #Stock of capital
kt=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Target stock of capital
l_d=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Demans for bank loans 
l_s=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Supply of bank loans 
i_d=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Demand for Investment
i_s=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Supply of Investment
mh=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Bank deposits held by households
ms=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Supply of bank deposits
n_s=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Supply of labour
n_d=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Demand for labour
pr=matrix(data=1,nrow=nScenarios,ncol=nPeriods) #Labour productivity
rl=matrix(data=rl_bar,nrow=nScenarios,ncol=nPeriods) #Rate of interests on banks loans
rm=matrix(data=rl,nrow=nScenarios,ncol=nPeriods) #Rate of interests on bank deposits
w=matrix(data=0.86,nrow=nScenarios,ncol=nPeriods) #Wage rate
wb_d=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Wage Bill
wb_s=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Supply of Wages
y=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Income
y_star=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Steady-state income
yd=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Disposal Income of households
       

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
      
      #Initial shock to autonomous consumption
      if (i>=2){alpha0[j,i]=25}    
      
      #Scenario 2: positive shock to target capital stock
      if (i>=52 & j==2){kappa[j,i]=1.1}
      
      #Scenario 3: negative shock to target capital stock
      if (i>=52 & j==3){kappa[j,i]=0.9}
      
      #Scenario 4: shock to autonomous consumption
      if (i>=52 & j==4){alpha0[j,i]=28}
      
      #Scenario 5: shock to interest rate with c_d = c_d(r)
      if (i>=52 & j==5){rl_bar[j,i]=0.05}
      
      #Scenario 6: increase in propensity to save
      if (i>=52 & j==6){alpha1[j,i]=0.74}
      
      
      #STEP 4.C: DEFINE THE SYSTEM OF EQUATIONS        
      
      
      #Behavioural equations and equilibrium condition
      
        #Supply of consumption goods - eq. 7.1
        c_s[j,i] = c_d[j,i]
        #Supply of investment goods - eq. 7.2
        i_s[j,i] = i_d[j,i]
        #Supply of labour - eq. 7.3
        n_s[j,i] = n_d[j,i]
        #Supply of loans - eq. 7.4
        l_s[j,i] = l_s[j,i-1] + (l_d[j,i] - l_d[j,i-1])   
      
      #Transactions of the firms
      
        #GDP - eq. 7.5
        y[j,i] = c_s[j,i] + i_s[j,i]
        #Wage bill - eq. 7.6
        wb_d[j,i] = y[j,i] - rl[j,i-1]*l_d[j,i-1] - af[j,i]   
        #Depreciation allowances - eq. 7.7
        af[j,i] = da[j,i]
        #Demand for bank loans - eq. 7.8
        l_d[j,i] = l_d[j,i-1] + i_d[j,i] - af[j,i] 
      
      #Transactions of households
      
        #Disposable income - eq. 7.9
        yd[j,i] = wb_d[j,i] + rm[j,i-1]*mh[j,i-1]
      
        #Bank deposits held by households - eq. 7.10
        mh[j,i] = mh[j,i-1] + yd[j,i] - c_d[j,i]
      
      #Transactions of the banks  
      
        #Supply of deposits - eq. 7.11
        ms[j,i] = ms[j,i-1] + (l_s[j,i] - l_s[j,i-1])
      
        #Rate of interest on deposits - eq. 7.12
        rm[j,i] = rl[j,i]
      
      #The wage bill  
      
        #"Supply" of wages - eq. 7.13
        wb_s[j,i] = w[j,i]*n_s[j,i]         
      
        #Labour demand - eq. 7.14
        n_d[j,i] = y[j,i]/pr[j,i]        
      
        #Wage rate - eq. 7.15
        w[j,i] = wb_d[j,i]/n_d[j,i]       
      
      #Household behaviour
      
        #Demand for consumption goods - eq. 7.16 (and 7.16A)
        if (j==5){ c_d[j,i] = alpha0[j,i] + alpha1w*wb_s[j,i] + alpha1r*rm[j,i-1]*mh[j,i-1] + alpha2*mh[j,i-1]}
             else{ c_d[j,i] = alpha0[j,i] + alpha1[j,i]*yd[j,i] + alpha2*mh[j,i-1]}
      
      #The investment behaviour
      
        #Accumulation of capital - eq. 7.17
        k[j,i] = k[j,i-1] + i_d[j,i] - da[j,i]
      
        #Depreciation allowances - eq. 7.18
        da[j,i] = delta*k[j,i-1]
      
        #Capital stock target - eq. 7.19
        kt[j,i] = kappa[j,i]*y[j,i-1]
      
        #Demand for investment goods - eq. 7.20
        i_d[j,i] = gamma*(kt[j,i] - k[j,i-1]) + da[j,i]
      
      #The behaviour of banks
      
        #Interest rate on loans - eq. 7.21
        rl[j,i] = rl_bar[j,i]
      
      #Additional equation for calculating y steady-state value
        y_star[j,i] = alpha0[j,i]/((1-alpha1[j,i])*(1-delta*kappa[j,i])-alpha2*kappa[j,i])       
      
    }
  }
}

################################################################################

#STEP 5: CONSISTENCY CHECK (REDUNDANT EQUATION)

#Create consistency statement 
aerror=0
error=0
for (i in 2:(nPeriods-1)){error = error + (ms[1,i]-mh[1,i])^2}
aerror = error/nPeriods
if ( aerror<0.01 ){cat(" *********************************** \n Good news! The model is watertight! \n", "Average error =", aerror, "< 0.01 \n", "Cumulative error =", error, "\n ***********************************")} else{
  if ( aerror<1 && aerror<1 ){cat(" *********************************** \n Minor issues with model consistency \n", "Average error =", aerror, "> 0.01 \n", "Cumulative error =", error, "\n ***********************************")}
  else{cat(" ******************************************* \n Warning: the model is not fully consistent! \n", "Average error =", aerror, "> 1 \n", "Cumulative error =", error, "\n *******************************************")} }      

#Plot redundant equation
layout(matrix(c(1,2,3,4,5,6,7,8,9), 3, 3, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))
plot(ms[1,2:nPeriods]-mh[1,2:nPeriods], type="l", col="green",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main=expression("Consistency check (baseline scenario): " * italic(M[phantom("")]["s"]) - italic(M[phantom("")]["h"])),
     cex.axis=1.5,cex.lab=1.5,ylab = '£',
     xlab = 'Time',ylim = range(-1,1))

################################################################################

#STEP 6: CREATE AND DISPLAY GRAPHS

#Change layout
#layout(matrix(c(1,2), 1, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))

#Figure 1
plot(y[1,2:45],type="l",col=1,lwd=3,lty=1,font.main=1,cex.main=1.5,
     main="Figure 1  Evolution of national income \n following initial autonomous consumption",
     cex.axis=1.5,cex.lab=1.5,ylab = '£',xlab = 'Time',ylim=range(100,230))
lines(y_star[1,2:45],type="l",lwd=3,lty=2,col=4)
legend("bottomright",c("National income","Steady-state value"),  bty = "n", cex = 1.5,
       lty=c(1,2), lwd=c(3,3), col = c(1,4), box.lwd=0)

#Figure 2
plot(yd[4,48:140],type="l",col="aquamarine",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main="Figure 2  Evolution of disposable income and consumption \n following shock to autonomous consumption",
     cex.axis=1.5,cex.lab=1.5,ylab = '£',xlab = 'Time',ylim=range(180,210))
lines(c_d[4,48:140],type="l",lwd=3,lty=3,col="aquamarine4")
legend("bottomright",c("Disposable income","Consumption"),  bty = "n", cex = 1.5,
       lty=c(1,3), lwd=c(3,3), col = c("aquamarine","aquamarine4"), box.lwd=0)

#Figure 3
plot(i_d[4,48:140],type="l",col="orchid",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main="Figure 3  Evolution of investment and depreciation \n following shock to autonomous consumption",
     cex.axis=1.5,cex.lab=1.5,ylab = '£',xlab = 'Time',ylim=range(20,24))
lines(da[4,48:140],type="l",lwd=3,lty=2,col="gray50")
legend("right",c("Gross investment","Replacement investment \n (capital depreciation)"),  bty = "n", cex = 1.5,
       lty=c(1,2), lwd=c(3,3), col = c("orchid","gray50"), box.lwd=0)

#Figure 4
plot(yd[6,48:140],type="l",col="aquamarine",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main="Figure 4  Evolution of disposable income and consumption \n following increase in propensity to save (paradox ot thrift!)",
     cex.axis=1.5,cex.lab=1.5,ylab = '£',xlab = 'Time',ylim=range(165,180))
lines(c_d[6,48:140],type="l",lwd=3,lty=3,col="aquamarine4")
legend("bottomright",c("Disposable income","Consumption"),  bty = "n", cex = 1.5,
       lty=c(1,3), lwd=c(3,3), col = c("aquamarine","aquamarine4"), box.lwd=0)

#Figure 5
plot(y[2,48:140],type="l",col=4,lwd=3,lty=1,font.main=1,cex.main=1.5,
     main="Figure 5  Evolution of national income \n following change in target capital stock",
     cex.axis=1.5,cex.lab=1.5,ylab = '£',xlab = 'Time',ylim=range(min(y[3,40:150]),max(y[2,40:150])))
mycol3 <- rgb(255,255,0, max = 255, alpha = 40, names = "myyellow")
lines(y[3,48:140],type="l",lwd=3,lty=1,col=3)
lines(y[1,48:51],type="l",lwd=3,lty=1,col=1)
lines(y[1,48:140],type="l",lwd=3,lty=2,col=1)
#rect(xleft=12,xright=150,ybottom=30,ytop=130,col=mycol3,border=NA)
legend(40,105,c("Higher capital/output","Lower capital/output","Baseline value"),  bty = "n", cex = 1.5,
       lty=c(1,1,2), lwd=c(3,3,3), col = c(4,3,1), box.lwd=0)

#Figure 6
plot(y[5,48:140],type="l",col="coral3",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main="Figure 6  Evolution of national income \n following an increase in the interest rate",
     cex.axis=1.5,cex.lab=1.5,ylab = '£',xlab = 'Time',ylim=range(180,190))
abline(h=y[5,48])
