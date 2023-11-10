# Model ECO-PC for R: main code

# Version: 10 November 2023

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

#Number of industries ***
nIndustries = 2

################################################################################

#STEP 2: SET THE COEFFICIENTS (EXOGENOUS VARIABLES AND PARAMETERS)
a0=matrix(data=0.6,nrow=nScenarios,ncol=nPeriods) #Autonomous component of propensity to consume out of income
a1=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Climate-change elasticity of propensity to consume out of income
alpha1=matrix(data=a0,nrow=nScenarios,ncol=nPeriods) #Propensity to consume out of income
alpha2=0.4 #Propensity to consume out of wealth
lambda0 = 0.635 #Autonomous share of bills
lambda1 = 5 #Elasticity of bills demand to interest rate
lambda2 = 0.01 #Elasticity of bills demand to yd/v
theta=0.2 #Tax rate on income
r_bar=matrix(data=0.025,nrow=nScenarios,ncol=nPeriods) #Interest rate as policy instrument
p1_bar=1.02 #Price of industry 1 products
p2_bar=0.98 #Price of industry 2 products
beta1_c_bar=0.50 #Household consumption share of product 1
beta1_g_bar=0.48 #Government consumption share of product 1

################################################################################

#STEP 3: CREATE VARIABLES AND ATTRIBUTE INITIAL VALUES

#Use 'array' function to create 3-dimension variables
x=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Gross output by industry (real)
d=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Demand by industry (real)
beta_c=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Real consumption composition
beta_g=array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Real government expenditure composition
p=array(data=1,dim=c(nScenarios,nPeriods,nIndustries)) #Unit prices

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

#Ecosystem variables and coefficients

#Variables
x_mat = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Production of material goods 
mat = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Extracted matter  
rec = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Recycled socio-economic stock  
dis = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Discarded socioeconomic stock            
kh = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Socio-economic stock       
en = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Total energy required for production
ren = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Renewable energy
nen = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Non-renewable energy                         
co2_cum = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Cumulative emissions
wa = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Waste by industry
temp = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Atmospheric temperature 
k_m=matrix(data=6000,nrow=nScenarios,ncol=nPeriods) #Matter reserves
conv_m=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Conversion of matter resources into reserves
res_m=matrix(data=388889,nrow=nScenarios,ncol=nPeriods) #Matter resources
k_e=matrix(data=37000,nrow=nScenarios,ncol=nPeriods) #Energy reserves
conv_e=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Conversion of energy resources into reserves
res_e=matrix(data=542000,nrow=nScenarios,ncol=nPeriods) #Energy resources
dc = array(data=0,dim=c(nScenarios,nPeriods,nIndustries)) #Stock of durable goods by industry/product
emis = matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Annual emissions by industry
cen=matrix(data=0,nrow=nScenarios,ncol=nPeriods) #Carbon mass of energy
o2= matrix(data=emis-cen,nrow=nScenarios,ncol=nPeriods) #Mass of oxygen 

#Coefficients
rho_dis = 0.2 #Recycling rate
beta_e = 0.07 #C=2 intensity of non-renewable enargy sources
tcre=0.0001 #Transient climate response to cumulative carbon emissions
fnc=0.5 #Non-CO2 fraction of total anthropocentric forcing
sigma_m=0.0005 #Conversion rate of matter resources into reserves
car=3.67 #Coefficient converting Gt of carbon into Gt of CO2
sigma_e=0.003 #Conversion rate of energy resources into reserves
mu_mat = matrix(data=c(0.4,0.6),nrow=nIndustries,ncol=1) #Material intensity coefficients by industry
zeta_dc = matrix(data=c(0.015,0.025),nrow=nIndustries,ncol=1) #Percentages of discarded socio-economic stock by industry
eps_en = matrix(data=c(4,6),nrow=nIndustries,ncol=1) #Energy intensity coefficients by industry                                          
eta_en = matrix(data=c(0.13,0.15),nrow=nIndustries,ncol=1) #Shares of renewable energy in total energy by industry       



################################################################################

#STEP 4: RUN THE MODEL

#STEP 4.A: DEFINE THE LOOPS

#Choose scenario
for (j in 1:nScenarios){
  
  #Define time loop
  for (i in 2:nPeriods){
  
    #Choose industry ***
    for (z in 1:nIndustries){
    
     #Define iterations
     for (iterations in 1:100){
      
      
      #STEP 4.B: ADD ALTERNATIVE SCENARIOS  
      
      #Shock 1: higher interest rate
      if (i>=10 && j==2){a1[j,i]=5}
      
      #STEP 4.C: DEFINE THE SYSTEM OF EQUATIONS        
      #Note: numbers refer to Model PC; *** = new or modified equation 
      
       
      #A) Define prices and consumption shares 
       
       #Set unit price of output of industry 1 ***  p[1] = (w/pr) + (p[1]*A[1] + p[2]*A[2])*(1 + mu) 
       p[j,i,1] = p1_bar
       
       #Set unit price of output of industry 2 ***  p[2] = (w/pr) + (p[1]*A[3] + p[2]*A[4])*(1 + mu)
       p[j,i,2] = p2_bar
      
       #Household real consumption share of product 1 ***
       beta_c[j,i,1] = beta1_c_bar
      
       #Household real consumption share of product 2 ***
       beta_c[j,i,2] = 1 - beta1_c_bar
      
       #Government real consumption share of product 1 ***
       beta_g[j,i,1] = beta1_g_bar
      
       #Government real consumption share of product 2 ***
       beta_g[j,i,2] = 1 - beta1_g_bar
      
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
      
       #Tax payments - eq. 4.3 
       t[j,i] = theta*(y[j,i] + r[j,i-1]*b_h[j,i-1])
      
       #Supply of government bills - eq. 4.8 ***
       b_s[j,i] = b_s[j,i-1] + ( p_g[j,i]*g[j,i] + r[j,i-1]*b_s[j,i-1]) - (t[j,i] + r[j,i-1]*b_cb[j,i-1])
      
      
      #F) Central bank
      
       #Supply of cash - eq. 4.9
       h_s[j,i] = h_s[j,i-1] + b_cb[j,i] - b_cb[j,i-1]
      
       #Government bills held by the central bank - eq. 4.10
       b_cb[j,i] = b_s[j,i] - b_h[j,i]
      
       #Interest rate as policy instrument - eq. 4.11
       r[j,i] = r_bar[j,i]
      
      
      #G) Ecosystem
      
       #Extraction of matter and waste
       
        #Production of material goods 
        x_mat[j,i] = t(mu_mat[,]) %*% x[j,i,]
        
        #Extraction of matter                                       
        mat[j,i] = x_mat[j,i] - rec[j,i]                                             
        
        #Recycled matter (of socioeconomic stock + industrial waste)
        rec[j,i] = rho_dis*dis[j,i]         
        
        #Discarded socioeconomic stock            
        dis[j,i] = t(mu_mat[,]) %*% (zeta_dc[,] * dc[j,i-1,])
        
        #Stock of durable consumption goods                 
        dc[j,i,] = dc[j,i-1,] + beta_c[j,i,]*cons[j,i] - zeta_dc[,] * dc[j,i-1,]    
        
        #Socioeconomic stock
        kh[j,i] = kh[j,i-1] + x_mat[j,i] - dis[j,i]       
        
        #Wasted socio-economic stock
        wa[j,i] = mat[j,i] - (kh[j,i]-kh[j,i-1])                                                                     
       
        
       #Use of energy, emissions and temperature
        
        #Energy required for production
        en[j,i] = t(eps_en[,]) %*% x[j,i,]                                          
        
        #Renewable energy at the end of the period
        ren[j,i] = t(eps_en[,]) %*% (eta_en[,]*x[j,i,])                         
        
        #Non-renewable energy
        nen[j,i] = en[j,i] - ren[j,i]                                                
        
        #C02 emissions
        emis[j,i] = beta_e*nen[j,i]   
        
        #Cumulative emissions
        co2_cum[j,i] = co2_cum[j,i-1] + emis[j,i]
       
        #Atmospheric temperature 
        temp[j,i] = (1/(1-fnc))*tcre*(co2_cum[j,i])
       
        
      #Resources and reserves  
        
        #Stock of material reserves
        k_m[j,i] = k_m[j,i-1] + conv_m[j,i] - mat[j,i]                      
        
        #Material resources converted to reserves 
        conv_m[j,i] = sigma_m*res_m[j,i]                                    
        
        #Stock of material resources
        res_m[j,i] = res_m[j,i-1] - conv_m[j,i]                            
        
        #Carbon mass of non-renewable energy 
        cen[j,i] = emis[j,i]/car                                            
        
        #Mass of oxygen 
        o2[j,i] = emis[j,i] - cen[j,i]                                      
        
        #Stock of energy reserves
        k_e[j,i] = k_e[j,i-1] + conv_e[j,i] - en[j,i]                       
        
        #Energy resources converted to reserves 
        conv_e[j,i] = sigma_e*res_e[j,i]                                    
        
        #Stock of energy resources
        res_e[j,i] = res_e[j,i-1] - conv_e[j,i]                             
        
        
      #Climate related damages / changes
        
        #Endogenous propensity to consume out of income
        alpha1[j,i] = a0[j,i] - a1[j,i] * (temp[j,i] - temp[j,i-1])   
      
        #Other: e.g. beta_c[j,i,1] = b0 + b1 * temp[j,i-1]
        
        #Besides, we can connect waste accumulation with other variables...
        
      }
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
layout(matrix(c(1,2,3,4,5,6), 3, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))
plot(h_s[1,2:nPeriods]-h_h[1,2:nPeriods], type="l", col="green",lwd=3,lty=1,font.main=1,cex.main=1.5,
     main=expression("Consistency check (baseline scenario): " * italic(H[phantom("")]["s"]) - italic(H[phantom("")]["h"])),
     cex.axis=1.5,cex.lab=1.5,ylab = '£',
     xlab = 'Time',ylim = range(-1,1))

################################################################################

#STEP 6: CREATE AND DISPLAY GRAPHS

#Set layout
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
par(mar = c(5.1+1, 4.1+1, 4.1+1, 2.1+1))

#Figure 1
plot(y[2,2:nPeriods],type="l", col=2, lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 1  National income (GDP) following climate-change \n induced reduction in propensity to consume",
     ylab = '£',xlab = 'Time',ylim = range(95,110),cex.axis=1.5,cex.lab=1.5)
abline(h=y[2,2],col="green",lty=2,lwd=2)
abline(h=y[2,60],col="blue",lty=2,lwd=2)
legend("bottomright",c("National income","Old steady state","New steady state"),  bty = "n",
       cex=1.5, lty=c(1,2,2), lwd=c(3,2,2), col = c(2,"blue","green"), box.lty=0)

#Figure 2
stacked_values <- rbind(beta_e*eps_en[1,]*x[2,2:30,1]*(1-eta_en[1,]), beta_e*eps_en[2,]*x[2,2:30,1]*(1-eta_en[2,]))
barplot(stacked_values, beside = FALSE, col = c("dodgerblue", "goldenrod3"), 
        names.arg = 2:30,main = "Figure 2  CO2 emissions following climate-change \n induced reduction in propensity to consume",
        font.main=1,cex.main=1.55,ylab = 'Gt', xlab = 'Time', ylim = c(0, 45),
        cex.axis = 1.5, cex.lab = 1.5, border = "white",xaxt = "n", 
        legend.text = c("Industry 1", "Industry 2"))
axis(1, at = seq(0, 40, by = 10), labels = seq(0, 40, by = 10),cex.axis = 1.5)

#Figure 3
plot(100*(mat[2,2:30]/k_m[2,1:29])-100*(mat[1,2:30]/k_m[1,1:29]),type="l",
    col="coral3", lwd=3, lty=1, font.main=1,cex.main=1.5,
    main="Figure 3  Reserves depletion rates following climate-change \n induced reduction in propensity to consume",
    ylab = 'Index (%)',xlab = 'Time',cex.axis=1.5,cex.lab=1.5,ylim = range(-0.15,0))
lines(100*(en[2,2:30]/k_e[2,1:29])-100*(en[1,2:30]/k_e[1,1:29]),col="cyan4", lwd=3, lty=1)
legend("bottomright",c("Matter","Energy"),  bty = "n",
       cex=1.5, lty=c(1,1), lwd=c(3,3), col = c("coral3","cyan4"), box.lty=0)

#Figure 4
plot(temp[2,1:29]-temp[1,1:29],type="l",
     col="cornflowerblue", lwd=3, lty=1, font.main=1,cex.main=1.5,
     main="Figure 4  Change in atm. temperature following climate-change \n induced reduction in propensity to consume",
     ylab = 'C',xlab = 'Time',cex.axis=1.5,cex.lab=1.5,ylim = range(-0.005,0))
