# Model PC-EX1 for R: main code
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 2 October 2023

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
nScenarios=6 

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
b_cb=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods)#Government bills held by Central Bank
b_h=matrix(data=64.87,nrow=nScenarios,ncol=nPeriods) #Government bills held by households
b_s=matrix(data=b_h+b_cb,nrow=nScenarios,ncol=nPeriods) #Government bills supplied by government
cons=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Consumption 
g=matrix(data=20,nrow=nScenarios,ncol=nPeriods) #Government expenditure
h_h=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Cash money held by households
h_s=matrix(data=h_h,nrow=nScenarios,ncol=nPeriods) #Cash money supplied by central bank
r=matrix(data=r_bar,nrow=nScenarios,ncol=nPeriods) #Interest rate on government bills
t=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Taxes
v=matrix(data=b_h+h_h,nrow=nScenarios,ncol=nPeriods) #Households wealth
y=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Income = GDP
yd=matrix(data=90,nrow=nScenarios,ncol=nPeriods) #Disposable income of households
yd_e=matrix(data=yd,nrow=nScenarios,ncol=nPeriods) #Expected disposable income of households
v_e=matrix(data=v,nrow=nScenarios,ncol=nPeriods) #Expected wealth
b_d=matrix(data=b_h,nrow=nScenarios,ncol=nPeriods) #Demand for bonds
h_d=matrix(data=h_h,nrow=nScenarios,ncol=nPeriods) #Demand for cash

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
      
      #Shock 1: higher propensity to consume out of income
      if (i>=50 && j==2){alpha1[j,i]=0.7}
      
      #Shock 2: higher interest rate from scratch + higher propensity to consume
      if (j==3){r_bar[j,i]=0.035
                if (i>=50) {alpha1[j,i]=0.7}}
      
      #Shock 3: 0 interest rate from scratch + higher propensity to consume
      if (j==4){r_bar[j,i]=0
                if (i>=50) {alpha1[j,i]=0.7}}
      
      #Shock 4: negative interest rate from scratch + higher propensity to consume
      if (j==5){r_bar[j,i]=-0.01
                if (i>=50) {alpha1[j,i]=0.7}}
      
      
      #STEP 4.C: DEFINE THE SYSTEM OF EQUATIONS         
      
      #Determination of output - eq. 4.1
      y[j,i] = cons[j,i] + g[j,i]
      
      #Disposable income - eq. 4.2
      yd[j,i] = y[j,i] - t[j,i] + r[j,i-1]*b_h[j,i-1]
      
      #Tax payments - eq. 4.3
      t[j,i] = theta*(y[j,i] + r[j,i-1]*b_h[j,i-1])
      
      #Wealth accumulation - eq. 4.4
      v[j,i] = v[j,i-1] + (yd[j,i] - cons[j,i])
      
      #Consumption function - eq. 4.5e
      cons[j,i] = alpha1[j,i]*yd_e[j,i] + alpha2*v[j,i-1]
      
      #Demand for government bills - eq. 4.7e
      b_d[j,i] = v_e[j,i]*(lambda0 + lambda1*r[j,i] - lambda2*(yd_e[j,i]/v_e[j,i]))
      
      #Demand for cash money - eq. 4.13
      h_d[j,i] = v_e[j,i] - b_d[j,i]
      
      #Expected wealth - eq. 4.14
      v_e[j,i] = v[j,i-1] + (yd_e[j,i] - cons[j,i])
      
      #Cash money - eq. 4.6
      h_h[j,i] = v[j,i] - b_h[j,i]
      
      #Government bills held by households - eq. 4.15
      b_h[j,i] = b_d[j,i]
      
      #Supply of government bills - eq. 4.8
      b_s[j,i] = b_s[j,i-1] + (g[j,i] + r[j,i-1]*b_s[j,i-1]) - (t[j,i] + r[j,i-1]*b_cb[j,i-1])
      
      #Supply of cash - eq. 4.9
      h_s[j,i] = h_s[j,i-1] + b_cb[j,i] - b_cb[j,i-1]
      
      #Government bills held by the central bank - eq. 4.10
      b_cb[j,i] = b_s[j,i] - b_h[j,i]
      
      #Interest rate as policy instrument - eq. 4.11
      r[j,i] = r_bar[j,i]
      
      #Expected disposable income - eq. 4.16
      yd_e[j,i] = yd[j,i-1]
      
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
#layout(matrix(c(1,2), 1, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))

#Figure 4 - Note: figure 4.5 in the text
plot(y[2,48:88],type="l", col=2, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 4  Rise and fall of national income (GDP) following an increase in \n the propensity to consume out of expected disposable income",
     ylab = '£',xlab = 'Time',ylim = range(104,124),cex.axis=1.5,cex.lab=1.5)
abline(h=y[2,48],col="green",lty=2)
abline(h=y[2,nPeriods],col="blue",lty=2)
legend("right",c("National income","Old steady state","New steady state"),  bty = "n",
       cex=1.5, lty=c(1,2,2), lwd=c(3,1,1), col = c(2,"blue","green"), box.lty=0)

#Figure 5 - Note: figure 4.6 in the text
plot(v[2,48:88],type="l", col=2, lwd=3, lty=1, font.main=1,cex.main=1.5, main="Figure 5  Evolution of C, expected YD and V following \n an increase in the propensity to consume",
     ylab = '£',xlab = 'Time',ylim = range(60,100),cex.axis=1.5,cex.lab=1.5)
lines(yd_e[2,48:88],type="l", col=4, lwd=3, lty=2)
lines(cons[2,48:88],type="l", col=3, lwd=3, lty=3)
abline(h=v[2,48],col="gray50",lty=1)
legend("right",c("Lagged wealth","Expected disposable income","Consumption"),  bty = "n",
       cex=1.5, lty=c(1,2,3), lwd=c(3,3,3), col = c(2,4,3), box.lty=0)

#Figure 4 - Note: figure 4.5 in the text
#layout(matrix(c(1), 1, byrow = TRUE))
plot(100*y[2,48:88]/y[2,48],type="l", col=2, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 6  Rise and fall of national income (GDP) following an increase in \n the propensity to consume out of expected disposable income",
     ylab = 'Index',xlab = 'Time',ylim = range(95,115),cex.axis=1.5,cex.lab=1.5)
lines(100*y[3,48:88]/y[3,48],type="l", col=3, lwd=3, lty=1)
lines(100*y[4,48:88]/y[4,48],type="l", col=4, lwd=3, lty=1)     
lines(100*y[5,48:88]/y[5,48],type="l", col=5, lwd=3, lty=1)     
abline(h=100,col="gray50",lty=1)
legend("topright",c("r = 3.5%","r = 2.5%","r = 0%","r = -1%"),  bty = "n",
       cex=1.5, lty=c(1,1,1,1), lwd=c(3,3,3,3), col = c(3,2,4,5), box.lty=0)
