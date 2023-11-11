# Six lectures on SFC models

This repository includes the codes used in the 6 lectures on SFC models delivered in November-December 2023 at the [Central University of Finance and Economics](https://www.cufe.edu.cn/), Beijing, China. Specifically, it contains the R files that replicate [PC](#Model_PC), [PC-EX1](#Model_PC), [BMW](#Model_PC), and [REG](#Model_REG) (toy) models from Godley and Lavoie, "[Monetary Economics. An Integrated Approach to Credit, Money, Income, Production and Wealth](https://link.springer.com/book/10.1007/978-1-137-08599-3)", including additional features. An empirically-calibrated version (named [EMP](#Model_EMP)), an input-output version (named [IO-PC](#Model_IO-PC)), and an ecosystem-augmented version (named [ECO-PC](#Model_ECO-PC)) of Model PC are provided too. 

## Table of Contents

- [Introduction](#Introduction)
- [Model_PC](#Model_PC)
- [Model_BMW](#Model_BMW)
- [Model_REG](#Model_REG)
- [Model_IO-PC](#Model_IO-PC)
- [Model_ECO-PC](#Model_ECO-PC)
- [Model_EMP](#Model_EMP)
- [Useful_links](#Useful_links)

## Introduction

In the laste three decades, macroeconomic modelling has been dominated by Dynamic Stochastic General Equilibrium (DSGE) models. However, dissatisfaction with these models has been growing since the mid-2000s. Four primary weaknesses have been identified in DSGE models: unrealistic assumptions, a limited range of considerations, poor data fit, and logical inconsistencies and empirical non sequitur in aggregate production functions.

In response to these shortcomings, alternative models have emerged, aiming to address specific deficiencies. Computable General Equilibrium (CGE) models allow for broadening the scope but usually share key neoclassical assumptions with DSGE models. Leontief-like Input-Output (IO) models provide more room for a sound analysis of cross-industry interdependencies and the role of aggregate demand, but they still face limitations (as these models static in nature, and their coverage of financial aspects is usually quite limited). Heterogeneous agent-based models, network analysis, and other complexity models offer novel perspectives. Lastly, Stock-Flow Consistent (SFC) models have gained traction, finding applications in empirical macroeconomic research by institutions like the [Bank of England](https://www.bankofengland.co.uk/-/media/boe/files/working-paper/2016/a-dynamic-model-of-financial-balances-for-the-uk) and the [Italian Ministry of Economy and Finance](https://www.sciencedirect.com/science/article/abs/pii/S0264999322003509).

The resurgence of interest in SFC models can be traced back to Wynne Godley's [successful predictions](https://www.levyinstitute.org/publications/seven-unsustainable-processes) of the U.S. crises in 2001 and 2007. Godley's work laid the foundation for modern SFC modelling. These models, rooted in national accounts and flow of funds, integrate financial and real aspects of the economy, allowing for the identification of unsustainable processes.

SFC models are akin to "system dynamics" models, analysing complex systems over time, tracking flows, stocks, and utilising feedback loops. Basic SFC models have evolved into various forms, including Open-Economy or Multi-Area SFC models (MA-SFC), Ecological SFC models (ECO-SFC), Interacting Heterogeneous Agent-Based SFC models (AB-SFC), Input-output SFC Models (IO-SFC), and Empirical SFC Models (E-SFC).

Crucially, SFC models adhere to four accounting principles: flow consistency, stock consistency, stock-flow consistency, and quadruple book-keeping. The economy is represented by accounting matrices, identities reflecting the System of National Accounts, and dynamic equations defining the behaviour of each sector (usually based on rules of thumb and stock-flow norms).

Standard SFC models typically fall within the range of medium-scale macro-econometric dynamic models. These models are commonly formulated in discrete time using difference equations. However, continuous-time formulations using differential equations are also employed. 

The simplicity or complexity of SFC models dictates the approach to solving them. The simplest models, featuring a limited number of equations, can be solved analytically by finding steady-state solutions. These solutions provide insights into the long-term behaviour of the model. More advanced SFC models, characterised by increased complexity and a larger number of equations, necessitate computational methods. Computer simulations become essential for understanding the dynamic interactions within the system. Numerical techniques, such as iterative methods, are employed to capture the intricate dynamics of these models.

![fig_lang](https://raw.githubusercontent.com/marcoverpas/figures/main/languages.png)

Coefficients in SFC models play a crucial role in shaping model behaviour. Researchers have several options for determining these coefficients:

a) Fine-tuning: coefficients can be fine-tuned to achieve specific baseline scenarios, drawing insights from previous studies or selecting values from a reasonable range.

b) Calibration: researchers may calibrate coefficients to match the model's predictions with observed data, aligning the model with real-world economic conditions.

c) Estimation: econometric methods, including Ordinary Least Squares (OLS) and cointegration techniques, enable the estimation of coefficients from observed data, enhancing the model's empirical relevance.

Unlike DSGE models, which often rely on a unified platform like Dynare, SFC modeling lacks a universally adopted program. The pioneering codes used in Godley and Lavoie's work were developed by [Gennaro Zezza](https://gennaro.zezza.it/software/eviews/gl2006.php) using EViews and Excel. However, the landscape has evolved over time. [R](https://www.r-project.org/) ([RStudio](https://posit.co/blog/rstudio-new-open-source-ide-for-r/)) has become the predominant programming environment for SFC modeling, owing to its flexibility and extensive capabilities. Dedicated R packages such as [SFCR](https://joaomacalos.github.io/sfcr/index.html) and [Godley](https://github.com/gamrot/godley/) provide specialized tools for SFC modeling. Additionally, [Bimets](https://cran.r-project.org/web/packages/bimets/index.html) offers a platform for empirical SFC model development. Alternative programming languages, including Matlab (with or without Dynare), Mathematica, Python, and Julia, find applications in SFC modeling, particularly for creating agent-based SFC models. [Minsky](https://www.kickstarter.com/projects/2123355930/minsky-reforming-economics-with-visual-monetary-mo), a software package developed by Steve Keen, stands out as a tool for visually modeling macroeconomic system dynamics.


## Model_PC

This is one of the simplest SFC toy models. It is developed in chapter 4 of Godley and Lavoie, "[Monetary Economics. An Integrated Approach to Credit, Money, Income, Production and Wealth](https://link.springer.com/book/10.1007/978-1-137-08599-3)". PC stands for portfolio choice, because households can hold their wealth in terms of cash and/or government bills.
Key assumptions are as follows:

- Closed economy

- Four agents: households, “firms”, government, central bank

- Two financial assets: government bills and outside money (cash)

- No investment (accumulation) and no inventories

- Fixed prices and zero net profits

- No banks, no inside money (bank deposits)

- No ecosystem

Note that model variables have been modelled as matrices, where rows represent different scenarios and columns denote distinct periods. Parameters and exogenous variables are typically represented as scalars. However, variables susceptible to shocks are treated as matrices (as they change over time). Equilibrium solutions for the system of simultaneous equations have been derived without relying on any dedicated package, but rather through a sufficiently high number of iterations. Lastly, the redundant equation is used to double-check model consistency over time in the baseline scenario. 

The main code for reproducing the experiments can be found [here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_model.R). A version in which the economy is started from scratch is available too ([here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_model_from_scratch.R)). The expectation-augmented version, named PCEX1, is available ([here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PCEX1_model.R)).

Crucial identities of the model are derived using the balance-sheet matrix and the transaction-flow matrix. These tables are also useful to double-check model consistency in each period. A few additional lines of code are enough to generate these tables automatically, both in HTML and LaTeX format (go to the [code](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_model_tables.R)). 

![fig_tables_pc](https://raw.githubusercontent.com/marcoverpas/figures/main/tables_pc.png)

The code also allows for creating the Sankey diagram of transactions and changes in stocks ([here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_model_sankey.R)).

![fig_sankey_pc](https://raw.githubusercontent.com/marcoverpas/figures/main/sankey_pc.png)

## Model_BMW

[in progress]

## Model_REG

[in progress]

## Model_IO-PC

[in progress]

## Model_ECO-PC

[in progress]

## Model_EMP

Empirical SFC Models are SFC models whose coefficients are calibrated or estimated based on observed data. They are usually developed for studying national economies. There are two branches of Empirical SFC models:

- Type I or data-to-theory models: these models are tailored to the country-specific sectoral balance sheets and flow of funds statistics of the economy under investigation.

- Type II or theory-to-data models: these models are developed based on a theoretical SFC model, and then data are collected and adequately reclassified to estimate the coefficients of the model.

[Bimets](https://cran.r-project.org/web/packages/bimets/index.html) is a software framework for R designed for time series analysis and econometric modeling. It allows creating and manipulating time series, specifying simultaneous equation models, performing model estimation, structural stability analysis, deterministic and stochastic simulation, forecasting, and performing optimal control. It can be conveniently used to develop, estimate, and simulate empirical SFC models, especially Type II models.

[in progress]

Model EMP has been developed by reclassifying Eurostat data for Italy (1995-2021) to align with Model PC equations. In contrast to previous models, EMP has been coded using a dedicated R package ([Bimets](https://cran.r-project.org/web/packages/bimets/index.html)). The model code is organised into five different files:

### 1) [EMP_model.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model.R) allows creating the system of difference equations, uploading the observed series, and estimating model coefficients. 

```R
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
library(bimets)
library(knitr)

#Upload data: time series for transactions-flow matrix and balance sheet from Dropbox
Data_PC <- read.csv("https://www.dropbox.com/scl/fi/ei74ev9i5yx91qwu9xz5f/PC_data.csv?rlkey=5t0leh5zxwqq2m07va8brq9yc&dl=1") 

#Alternatively, upload data from your folder
#Data_PC <- read.csv("C:/.../PC_data.csv")

#Source: (our elaboration on) Eurostat data on Italy, December 2021

##############################################################################

#B) DEFINE MODEL EQUATIONS


S_model.txt="MODEL

COMMENT> FIRMS SECTOR ----------------------------------------------------------

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

```

### 2) [EMP_model_insample.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_insample.R) performs in-sample predictions to check EMP's fit on actual data and enables the user to adjust predicted series to observed ones.

```R
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

```

### 3) [EMP_model_outofsample.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_outofsample.R) performs out-of-sample predictions, of both deterministic and stochastic nature, which can be used as the baseline scenario. 

### 4) [EMP_model_tables.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_tables.R) allows creating the balance sheet and the transactions-flow matrix of the economy, using either observed series or predicted ones.

### 5) [EMP_model_sankey.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_sankey.R) generates the Sankey diagram of cross-sector transactions and changes in financial stocks.

### 6) [EMP_model_experim.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_experim.R) imposes exogenous shocks to selected model variables to create alternative scenarios (to be compared with the baseline scenario).

[in progress]

![fig_1_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_1_emp.png)



## Useful_links

- [Alessandro Bramucci](https://www.alessandrobramucci.com/project/interactive_macro/) 

- [Alessandro Caiani](https://sites.google.com/view/alessandro-caiani/java-macro-ab-simulation-toolkit) 

- [Yannis Dafermos and Maria Nikolaidi](https://yannisdafermos.com/sfc-modelling/) 

- [Michal Gamrot](https://github.com/gamrot/godley/) 

- [Antoine Godin](http://www.antoinegodin.eu/)

- [Karsten Kohler](https://karstenkohler.com/) 

- [Joao Macalos](https://joaomacalos.github.io/sfcr/index.html)

- [Franz Prante and Karsten Kohler](https://macrosimulation.org/) 

- [Marco Veronese Passarella (website)](https://www.marcopassarella.it/en/teaching-2/) 

- [Marco Veronese Passarella (GitHub)](https://github.com/marcoverpas) 

- [Gennaro Zezza](https://gennaro.zezza.it/?page_id=10&lang=en)
