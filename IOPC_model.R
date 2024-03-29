# Model IO-PC for R: main code
# aggregate equations taken from Model PC
# Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 9 November 2023

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

#Number of industries ***
nIndustries = 2

################################################################################

#STEP 2: SET THE COEFFICIENTS (EXOGENOUS VARIABLES AND PARAMETERS)
alpha1=matrix(data=0.6,nrow=nScenarios,ncol=nPeriods) #Propensity to consume out of income
alpha2=0.4 #Propensity to consume out of wealth
lambda0 = 0.635 #Autonomous share of bills
lambda1 = 5 #Elasticity of bills demand to interest rate
lambda2 = 0.01 #Elasticity of bills demand to yd/v
theta=0.2 #Tax rate on income
r_bar=matrix(data=0.025,nrow=nScenarios,ncol=nPeriods) #Interest rate as policy instrument
p1_bar=1.02 #Price of industry 1 products
p2_bar=0.98 #Price of industry 2 products
beta1_c_bar=0.50 #Household consumption share of product 1
beta2_c_bar=0.50 #Household consumption share of product 2
beta1_g_bar=0.48 #Government consumption share of product 1
beta2_g_bar=0.52 #Government consumption share of product 2

################################################################################

#STEP 3: CREATE VARIABLES AND ATTRIBUTE INITIAL VALUES

#Use 'array' function to create 3-dimension variables
x=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Gross output by industry (real)
d=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Demand by industry (real)
beta_c=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Real consumption composition
beta_g=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Real government expenditure composition
p=array(data=1,dim=c(nScenarios,nPeriods,nIndustries)) #Unit prices
k=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Inputs by industry

#Other 2-dimension variables
b_cb=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Government bills held by Central Bank
b_h=matrix(data=64.87,nrow=nScenarios,ncol=nPeriods) #Government bills held by households
b_s=matrix(data=21.62+64.87,nrow=nScenarios,ncol=nPeriods) #Government bills supplied by government
h_h=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Cash money held by households
h_s=matrix(data=21.62,nrow=nScenarios,ncol=nPeriods) #Cash money supplied by central bank
r=matrix(data=r_bar,nrow=nScenarios,ncol=nPeriods) #Interest rate on government bills
t=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Taxes
v=matrix(data=64.87+21.62,nrow=nScenarios,ncol=nPeriods) #Households wealth
yd=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Disposable income of households
cons=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Consumption (real)
g=matrix(data=20,nrow=nScenarios,ncol=nPeriods) #Government expenditure (real)
y=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Value of net output (GDP)
p_c=matrix(data=1,nrow=nScenarios,ncol=nPeriods) #Average price for the consumers
p_g=matrix(data=1,nrow=nScenarios,ncol=nPeriods) #Average price for the government
A=matrix(data=c(0.11,0.21,0.12,0.22),nrow=nIndustries,ncol=nIndustries) #Matrix of technical coefficients
I = diag(x=1, nrow=nIndustries, ncol=nIndustries) #Diagonal matrix
infl=matrix(data=1,nrow=nScenarios,ncol=nPeriods) #Inflation tax (see Godley and Lavoie, 9.2.4 and 9.3.1)

################################################################################

#STEP 4: RUN THE MODEL

#STEP 4.A: DEFINE THE LOOPS

#Choose scenario
for (j in 1:nScenarios){
  
  #Define time loop
  for (i in 2:nPeriods){
  
    #Choose industry ***
    #for (z in 1:nIndustries){
    
     #Define iterations
     for (iterations in 1:100){
      
      
      #STEP 4.B: ADD ALTERNATIVE SCENARIOS  
      
      #Shock 1: higher interest rate
      if (i>=10 && j==2){r_bar[j,i]=0.035}
      
      #Shock 2: higher propensity to consume out of income
      if (i>=10 && j==3){alpha1[j,i]=0.7}
      
      
      #STEP 4.C: DEFINE THE SYSTEM OF EQUATIONS        
      #Note: numbers refer to Model PC; *** = new or modified equation 
      
       
      #A) Define prices and consumption shares 
       
       #Set unit price of output of industry 1 ***  p[1] = (w/pr) + (p[1]*A[1] + p[2]*A[2])*(1 + mu) 
       p[j,i,1] = p1_bar
       
       #Set unit price of output of industry 2 ***  p[2] = (w/pr) + (p[1]*A[3] + p[2]*A[4])*(1 + mu)
       p[j,i,2] = p2_bar
      
       #Household real consumption share of product 1 ***
       beta_c[j,i,1]=beta1_c_bar
      
       #Household real consumption share of product 2 ***
       beta_c[j,i,2]=beta2_c_bar
      
       #Government real consumption share of product 1 ***
       beta_g[j,i,1]=beta1_g_bar
      
       #Government real consumption share of product 2 ***
       beta_g[j,i,2]=beta2_g_bar
      
       #Average price for the consumers ***
       p_c[j,i] = t(p[j,i,]) %*% beta_c[j,i,]
      
       #Average price for the government
       p_g[j,i] = t(p[j,i,]) %*% beta_g[j,i,]
      
      
      #B) Define input-output structure
      
       #Real final demand vector by industry ***
       d[j,i,] = beta_c[j,i,]*cons[j,i] + beta_g[j,i,]*g[j,i]
      
       #Real gross output by industry ***
       x[j,i,] = solve(I-A) %*% d[j,i,]
      
       #Value of net output (GDP) ***
       y[j,i] = t(p[j,i,]) %*% d[j,i,]
      
      
      #C) Households
      
       #Disposable income - eq. 4.2
       yd[j,i] = y[j,i] - t[j,i] + r[j,i-1]*b_h[j,i-1]
      
       #Wealth accumulation - eq. 4.4 ***
       v[j,i] = v[j,i-1] + (yd[j,i] - p_c[j,i]*cons[j,i])
      
       #Real consumption function with no monetary illusion - eq. 4.5 ***
       cons[j,i] = alpha1[j,i]*((yd[j,i]/p_c[j,i])-infl[j,i]) + alpha2*v[j,i-1]/p_c[j,i-1]
      
       #Inflation tax for households = infl. rate times * real stock of wealth
       infl[j,i] = ((p_c[j,i]-p_c[j,i-1])/p_c[j,i-1])*(v[j,i-1]/p_c[j,i])
      
      
      #D) Portfolio equations
      
       #Demand for cash money - eq. 4.6
       h_h[j,i] = v[j,i] - b_h[j,i]
      
       #Demand for government bills - eq. 4.7
       b_h[j,i] = v[j,i]*(lambda0 + lambda1*r[j,i] - lambda2*(yd[j,i]/v[j,i]))
      
      
      #E) Government
      
       #Tax payments - eq. 4.3 ***
       t[j,i] = theta*(y[j,i] + r[j,i-1]*b_h[j,i-1])
      
       #Supply of government bills - eq. 4.8
       b_s[j,i] = b_s[j,i-1] + ( p_g[j,i]*g[j,i] + r[j,i-1]*b_s[j,i-1]) - (t[j,i] + r[j,i-1]*b_cb[j,i-1])
      
      
      #F) Central bank
      
       #Supply of cash - eq. 4.9
       h_s[j,i] = h_s[j,i-1] + b_cb[j,i] - b_cb[j,i-1]
      
       #Government bills held by the central bank - eq. 4.10
       b_cb[j,i] = b_s[j,i] - b_h[j,i]
      
       #Interest rate as policy instrument - eq. 4.11
       r[j,i] = r_bar[j,i]
      
      
      #G) Additional calculations
      
       #Inputs required by industry ***
       k[j,i,] = A %*% x[j,i,]
      
      
      }
    #}
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
layout(matrix(c(1,2,3,4,5,6), 3, 2, byrow = TRUE))
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
     main="Figure 1  Shares of bills and money following \n a 100 increase in interest rate",
     ylab = '%',xlab = 'Time',ylim = range(20,25),cex.axis=1.5,cex.lab=1.5)
par(new=T)
plot(100*b_h[2,2:25]/v[2,2:25],type="l",lwd=3,lty=2,col=rgb(0,187,110,max=255),axes=F, ylab=NA,
     xlab=NA,ylim=range(75,80))
axis(side = 4,cex.axis=1,cex.lab=1.5)
legend("right",c("Share of money balances","Share of bills (right axis)"),  bty = "n",
       cex=1.5, lty=c(1,2), lwd=c(3,3), col = c(1,rgb(0,187,110,max=255)), box.lty=0)

#Figure 2
plot(yd[2,2:45],type="l", col=1, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 2  Disposable income and consumption following \n a 100 points increase in interest rate",
     ylab = '£',xlab = 'Time',ylim = range(86,91),cex.axis=1.5,cex.lab=1.5)
lines(cons[2,2:45],type="l",lwd=3,lty=2,col=4)
legend("right",c("Disposable income","Consumption"),  bty = "n",
       cex=1.5, lty=c(1,2), lwd=c(3,3), col = c(1,4), box.lty=0)

#Figure 3 
plot(y[3,2:60],type="l", col=2, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 3  National income (GDP) following an \n increase in the propensity to consume",
     ylab = '£',xlab = 'Time',ylim = range(105,126),cex.axis=1.5,cex.lab=1.5)
abline(h=y[3,2],col="green",lty=2,lwd=2)
abline(h=y[3,60],col="blue",lty=2,lwd=2)
legend("right",c("National income","Old steady state","New steady state"),  bty = "n",
       cex=1.5, lty=c(1,2,2), lwd=c(3,2,2), col = c(2,"blue","green"), box.lty=0)

#Figure 4
plot(k[2,2:45,1]*p[2,2:45,1],type="l", col="dodgerblue", lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 4  Demand for industry 1 products as inputs \n for other industries following each shock",
     ylab = '£',xlab = 'Time',ylim = range(18,23),cex.axis=1.5,cex.lab=1.5)
lines(k[3,2:45,1]*p[2,2:45,1],type="l", col="goldenrod3", lwd=3, lty=1)
legend("topright",c("Higher interest rate","Higher consumption"),  bty = "n",
       cex=1.5, lty=c(1,2,2), lwd=c(3,2,2), col = c("dodgerblue","goldenrod3"), box.lty=0)

#Figure 5
plot(k[2,2:45,2]*p[2,2:45,2],type="l", col="dodgerblue", lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 5  Demand for industry 2 products as inputs \n for other industries following each shock",
     ylab = '£',xlab = 'Time',ylim = range(32,42),cex.axis=1.5,cex.lab=1.5)
lines(k[3,2:45,2]*p[2,2:45,2],type="l", col="goldenrod3", lwd=3, lty=1)
legend("topright",c("Higher interest rate","Higher consumption"),  bty = "n",
       cex=1.5, lty=c(1,2,2), lwd=c(3,2,2), col = c("dodgerblue","goldenrod3"), box.lty=0)

#Redefine layout
layout(matrix(c(1,2), 1, 2, byrow = TRUE))

#Figure 6
stacked_values <- rbind(x[3, 2:45, 1] * A[1] * p[3, 2:45, 1], x[3, 2:45, 2] * A[3] * p[3, 2:45, 1], d[3,2:45,1]*p[3,2:45,1])
barplot(stacked_values, beside = FALSE, col = c("dodgerblue", "goldenrod3","red1"), 
        names.arg = 2:45, main = "Figure 6  Production of industry 1\nfollowing shock to consumption",
        font.main=1, ylab = '£', xlab = 'Time', ylim = c(0, 125),
        cex.axis = 1.25, cex.lab = 1.25, border = "white",xaxt = "n", 
        legend.text = c("Inputs for industry 1", "Inputs for industry 2","Final demand of products 1"))
axis(1, at = seq(0, 60, by = 10), labels = seq(0, 60, by = 10))

#Figure 7
stacked_values <- rbind(x[3, 2:45, 1] * A[2] * p[3, 2:45, 2], x[3, 2:45, 2] * A[4] * p[3, 2:45, 2], d[3,2:45,2]*p[3,2:45,2])
barplot(stacked_values, beside = FALSE, col = c("dodgerblue", "goldenrod3","red1"), 
        names.arg = 2:45, main = "Figure 7  Production of industry 2\nfollowing shock to consumption",
       font.main=1, ylab = '£', xlab = 'Time', ylim = c(0, 125), 
        cex.axis = 1.25, cex.lab = 1.25, border = "white",xaxt = "n", 
        legend.text = c("Inputs for industry 1", "Inputs for industry 2","Final demand of products 2"))
axis(1, at = seq(0, 60, by = 10), labels = seq(0, 60, by = 10))
