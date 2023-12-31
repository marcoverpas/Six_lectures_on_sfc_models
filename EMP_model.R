# Model EMP for R: main code
# equations taken from Model PC
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 8 November 2023

################################################################################

#STEP 1: PREPARE THE WORK-SPACE

#Clear environment
rm(list=ls(all=TRUE))

#Clear plots
if(!is.null(dev.list())) dev.off()

#Clear console
cat("\014")

################################################################################

#STEP 2: UPLOAD LIBRARIES AND DATA

#Upload libraries
library(mFilter)
library(bimets)
library(knitr)

#Upload data: time series for transactions-flow matrix and balance sheet
Data_PC <- read.csv("https://www.dropbox.com/scl/fi/ei74ev9i5yx91qwu9xz5f/PC_data.csv?rlkey=5t0leh5zxwqq2m07va8brq9yc&dl=1") 
#Data_PC <- read.csv("C:/.../PC_data.csv")

#Source: (our elaboration on) Eurostat data on Italy, December 2021

##############################################################################

#B) DEFINE MODEL EQUATIONS

S_model.txt="MODEL

COMMENT> GDP - eq. 4.1
IDENTITY> y
EQ> y = cons + g                      

COMMENT> Disposable income - eq. 4.2
IDENTITY> yd
EQ> yd = y - t + TSLAG(r,1)*TSLAG(b_h,1)

COMMENT> Tax revenues - eq. 4.3
BEHAVIORAL> t
TSRANGE 1998 1 2021 1
EQ> t = theta*(TSLAG(y,1) + TSLAG(r,1)*TSLAG(b_h,1))
COEFF> theta

COMMENT> Wealth accumulation - eq. 4.4
IDENTITY> v
EQ> v = TSLAG(v,1) + (yd - cons)

COMMENT> Household consumption - eq. 4.5
BEHAVIORAL> cons
TSRANGE 1998 1 2021 1
EQ> cons = alpha1*TSLAG(yd,1) + alpha2*TSLAG(v,1)  
COEFF> alpha1 alpha2

COMMENT> Cash money - eq. 4.6
IDENTITY> h_h
EQ> h_h = v - b_h

COMMENT> Demand for government bills - eq. 4.7
BEHAVIORAL> b_h
TSRANGE 1998 1 2021 1
EQ> b_h = lambda0*v + lambda1*r*v + lambda2*yd
COEFF> lambda0 lambda1 lambda2

COMMENT> Supply of government bills - eq. 4.8
IDENTITY> b_s
EQ> b_s = TSLAG(b_s,1) + (g + TSLAG(r,1)*TSLAG(b_s,1)) - (t + TSLAG(r,1)*TSLAG(b_cb,1))

COMMENT> Supply of cash - eq. 4.9
IDENTITY> h_s
EQ> h_s = TSLAG(h_s,1) + b_cb - TSLAG(b_cb,1)

COMMENT> Government bills held by the central bank - eq. 4.10
IDENTITY> b_cb
EQ> b_cb = b_s - b_h

COMMENT> Interest rate as policy instrument - eq. 4.11
BEHAVIORAL> r
TSRANGE 1998 1 2021 1
EQ> r = par0 + par1*TSLAG(r,1)
COEFF> par0 par1

END"

##############################################################################

#D) LOAD THE MODEL AND ESTIMATE COEFFICIENTS

#Load the model
PC_model=LOAD_MODEL(modelText = S_model.txt)

#Attribute values to model variables and coefficients
PC_modelData=list(  
  
  y = TIMESERIES(c(Data_PC$Y),START=c(1995,1),FREQ=1),
  
  cons = TIMESERIES(c(Data_PC$CONS),START=c(1995,1),FREQ=1),
  
  g = TIMESERIES(c(Data_PC$GOV),START=c(1995,1),FREQ=1),
  
  yd = TIMESERIES(c(Data_PC$YD),START=c(1995,1),FREQ=1),
  
  t = TIMESERIES(c(Data_PC$TAX),START=c(1995,1),FREQ=1),
  
  r = TIMESERIES(c(Data_PC$Rb),START=c(1995,1),FREQ=1),
  
  r_bar = TIMESERIES(c(Data_PC$Rb),START=c(1995,1),FREQ=1),
  
  b_h = TIMESERIES(c(Data_PC$Bh),START=c(1995,1),FREQ=1),
  
  b_s = TIMESERIES(c(Data_PC$Bs),START=c(1995,1),FREQ=1),
  
  b_cb = TIMESERIES(c(Data_PC$Bcb),START=c(1995,1),FREQ=1),
  
  v = TIMESERIES(c(Data_PC$NVh ),START=c(1995,1),FREQ=1),
  
  h_h = TIMESERIES(c(Data_PC$Hh),START=c(1995,1),FREQ=1),
  
  h_s = TIMESERIES(c(Data_PC$Hs),START=c(1995,1),FREQ=1)
  
)


#Load the data into the model
PC_model=LOAD_MODEL_DATA(PC_model,PC_modelData)

#Estimate model coefficients
PC_model=ESTIMATE(PC_model
                 ,TSRANGE=c(1998,1,2019,1)            #Choose time range for estimations
                 ,forceTSRANGE = TRUE
                 ,CHOWTEST = TRUE                     #Chow test: stability analysis
)
