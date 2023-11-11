# Six lectures on SFC models

This repository includes the codes used in the 6 lectures on SFC models delivered in November-December 2023 at the [Central University of Finance and Economics](https://www.cufe.edu.cn/), Beijing, China. Specifically, it contains the R files that replicate [PC](#Model_PC), [PC-EX1](#Model_PC), [BMW](#Model_PC), and [REG](#Model_REG) (toy) models from Godley and Lavoie, "[Monetary Economics. An Integrated Approach to Credit, Money, Income, Production and Wealth](https://link.springer.com/book/10.1007/978-1-137-08599-3)", including additional features. An empirically-calibrated version (named [EMP](#Model_EMP)), an input-output version (named [IO-PC](#Model_IO-PC)), and an ecosystem-augmented version (named [ECO-PC](#Model_ECO-PC)) of Model PC are provided too. 

## Table of Contents

- [1 Introduction](#1_Introduction)
- [2 Model PC](#2_Model_PC)
- [3 Model BMW](#3_Model_BMW)
- [4 Model REG](#4_Model_REG)
- [5 Model IO-PC](#5_Model_IO-PC)
- [6 Model ECO-PC](#6_Model_ECO-PC)
- [7 Model EMP](#7_Model_EMP)
    - [7.1 Introduction](#7_1_Introduction)
    - [7.2 Model and data](#7.2_Model_and_data)
    - [7.3 In-sample predictions](#7.3_In-sample_predictions)
    - [7.4 Out-of-sample predictions](#7.4_Out-of-sample_predictions)
    - [7.5 In-sample predictions](#7.5_SFC_tables)
    - [7.6 Sankey diagram](#7.6_Sankey_diagram)
    - [7.7 Experiments](#7.3_Experiments)
- [8 Useful links](#8_Useful_links)

## 1_Introduction

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


## 2_Model_PC

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

## 3_Model_BMW

[in progress]

## 4_Model_REG

[in progress]

## 5_Model_IO-PC

[in progress]

## 6_Model_ECO-PC

[in progress]

## 7_Model_EMP

### 7_1_Introduction

Empirical SFC Models are SFC models whose coefficients are calibrated or estimated based on observed data. They are usually developed for studying national economies. There are two branches of Empirical SFC models:

- Type I or data-to-theory models: these models are tailored to the country-specific sectoral balance sheets and flow of funds statistics of the economy under investigation.

- Type II or theory-to-data models: these models are developed based on a theoretical SFC model, and then data are collected and adequately reclassified to estimate the coefficients of the model.

[Bimets](https://cran.r-project.org/web/packages/bimets/index.html) is a software framework for R designed for time series analysis and econometric modeling. It allows creating and manipulating time series, specifying simultaneous equation models, performing model estimation, structural stability analysis, deterministic and stochastic simulation, forecasting, and performing optimal control. It can be conveniently used to develop, estimate, and simulate empirical SFC models, especially Type II models.

[in progress]

Model EMP has been developed by reclassifying Eurostat data for Italy (1995-2021) to align with Model PC equations. In contrast to previous models, EMP has been coded using a dedicated R package ([Bimets](https://cran.r-project.org/web/packages/bimets/index.html)). The model code is organised into five different files:

### 7.2_Model_and_data

The first file, named [EMP_model.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model.R), allows creating the system of difference equations, uploading the observed series, and estimating model coefficients. As usual, the first step is to prepare the workspace:

```R
#Clear environment
rm(list=ls(all=TRUE))

#Clear plots
if(!is.null(dev.list())) dev.off()

#Clear console
cat("\014")
```

The next step is to upload data from a folder. This code takes the observed series from a Dropbox folder, containing Eurostat data for Italy over the period 1995-2021. Alternatively, one can download the data from [here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_data.csv). Note that the observed series have been adequately reclassified to fit the PC simplified structure.

```R
#Upload libraries
library(bimets)
library(knitr)

#Upload data: time series for transactions-flow matrix and balance sheet from Dropbox
Data_PC <- read.csv("https://www.dropbox.com/scl/fi/ei74ev9i5yx91qwu9xz5f/PC_data.csv?rlkey=5t0leh5zxwqq2m07va8brq9yc&dl=1") 

#Alternatively, upload data from your folder
#Data_PC <- read.csv("C:/.../PC_data.csv")
```

We can now define the system of identities and behavioural equations as a txt file. Bimets' syntax is quite intuitive. The reference manual can be found [here](https://cran.r-project.org/web/packages/bimets/bimets.pdf). 

```R
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
```

The next step is to upload the observed series into the model. 

```R
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
```
We can now estimate model coefficients 

```R
#Estimate model coefficients
PC_model=ESTIMATE(PC_model
                 ,TSRANGE=c(1998,1,2019,1)            #Choose time range for estimations
                 #,forceTSRANGE = TRUE                 #Force same time range for all estimations
                 #,CHOWTEST = TRUE                     #Perform Chow test: stability analysis
)
```

When the CHOWTEST argument is set to TRUE, the model conducts a structural stability analysis to identify breaks. 

### 7.3_In-sample_predictions

The second file, named [EMP_model_insample.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_insample.R), performs in-sample predictions to check EMP's fit on actual data and enables the user to adjust predicted series to observed ones.

More precisely, the first step is to run the model to assess its fit with observed series. In this case, endogenous variables should not be exogenised, except for the policy tools (the policy rate, *r*, in this simplified model). Since we are conducting an in-sample simulation, we choose a static prediction approach, implying that historical values for the lagged endogenous variables are utilised in the solutions of subsequent periods.

```R
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
```

We can now plot the simulated series against the observed series.

```R
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
```

![fig_1_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_1_emp.png)

A consistency check, based on the redundant equation, can be conducted too (we refer to the [complete code](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_insample.R)). After that, in-sample predictions can be adjusted to the observed series using prediction errors, that is, by exogenising the endogenous variables of the model. 

```R
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
```

Simulated series now perfectly match observed ones over the considered period.

```R
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

![fig_2_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_2_emp.png)

### 7.4_Out-of-sample_predictions

The third file, named [EMP_model_outofsample.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_outofsample.R), performs out-of-sample predictions, of both deterministic and stochastic nature, which can be used as the baseline scenario. 

The first step is to extend exogenous variables up to the end of the forecasting period, which, in this exercise, is 2028. Similar to what we did for adjusted in-sample predictions, the second step is to create an "exogenization list", encompassing all the endogenous variables of the model. These variables are adjusted up to 2021 and then set free to follow the dynamics implied by the model equations. Afterward, we can simulate the model out of sample using either the function DYNAMIC (employing simulated values for the lagged endogenous variables in the solutions of subsequent periods) or the function FORECAST (similar to the previous one, but setting the starting values of endogenous variables in a period equal to the simulated values of the previous period).

```R
# Extend exogenous and conditionally-evaluated variables up to 2028
PC_model$modelData <- within(PC_model$modelData,{ g = TSEXTEND(g,  UPTO=c(2028,1)) })

# Define exogenisation list
exogenizeList <- list(
  
  r = TRUE,                     #Interest rate (whole period)
  t = c(1998,1,2021,1),         #Taxes
  cons = c(1998,1,2021,1),      #Consumption
  b_h = c(1998,1,2021,1)        #Bills held by households
  
)

# Simulate model
PC_model <- SIMULATE(PC_model
                    ,simType='DYNAMIC' #try also: 'FORECAST'
                    ,TSRANGE=c(1998,1,2028,1)
                    ,simConvergence=0.00001
                    ,simIterLimit=1000
                    ,Exogenize=exogenizeList
                    #,ConstantAdjustment=constantAdjList
                    ,quietly=TRUE)

#PLOTS FOR VISUAL INSPECTION
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

# GDP
plot(PC_model$simulation$y,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="a) Italy GDP (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$y*0.85),max(PC_model$simulation$y*1.05)))
lines(PC_modelData$y,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

# Consumption
plot(PC_model$simulation$cons,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="b) Italy consumption (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$cons*0.85),max(PC_model$simulation$cons*1.05)))
lines(PC_modelData$cons,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

# Tax revenue
plot(PC_model$simulation$t,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="c) Italy tax revenue (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$t*0.85),max(PC_model$simulation$t*1.05)))
lines(PC_modelData$t,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)

# Bills held by househeolds
plot(PC_model$simulation$b_h,col="deepskyblue4",lty=1,lwd=1,font.main=1,cex.main=1,main="d) Italy bills holdings (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_model$simulation$b_h*0.85),max(PC_model$simulation$b_h*1.05)))
lines(PC_modelData$b_h,col="darkorchid4",lty=3,lwd=3)
legend("bottom",c("Observed","Simulated (adjusted)"),  bty = "n", cex=1, lty=c(3,1), lwd=c(3,1),
       col = c("darkorchid4","deepskyblue4"), box.lty=0)
```
![fig_3_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_3_emp.png)

The simulations above are deterministic in nature. However, Bimets also allows conducting stochastic simulations using the STOCHSIMULATE function. This enables the analysis of forecast errors in structural econometric models arising from random disturbances, coefficient estimation errors, etc. More precisely, the model is solved for different values of specified stochastic disturbances, the structure of which is defined by users, specifying probability distributions and time ranges. Mean and standard deviation for each simulated endogenous variable are stored in the output model object.

```R
#Define stochastic structure (disturbances)
myStochStructure <- list(
  
  #Consumption: normally-distributed shocks
  cons=list(
    TSRANGE=c(2022,1,2028,1),
    TYPE='NORM', #UNIF
    PARS=c(0,PC_model$behaviorals$cons$statistics$StandardErrorRegression)
  ),
  
  #Taxes: normally-distributed shocks
  t=list(
    TSRANGE=c(2022,1,2028,1),
    TYPE='NORM', #UNIF
    PARS=c(0,PC_model$behaviorals$t$statistics$StandardErrorRegression)
  )
  
)

# Simulate model again
PC_model <- STOCHSIMULATE(PC_model
                         ,simType='FORECAST'
                         ,TSRANGE=c(2021,1,2028,1)
                         ,StochStructure=myStochStructure
                         ,StochSeed=123
                         ,simConvergence=0.00001
                         ,simIterLimit=1000
                         ,Exogenize=exogenizeList
                         ,ConstantAdjustment=constantAdjList
                         ,quietly=TRUE)
```

It is important to stress that two types of shocks for the stochastic structure of the model can be selected. NORM stands for "normal distribution." In this case, parameters must contain the mean and the standard deviation of the normal distribution. UNIF stands for "uniform distribution." The related parameters must contain the lower and upper bounds of the uniform distribution.

Having specified that, we can now re-plot the charts.

```R
#Set layout
layout(matrix(c(1:4), 2, 2, byrow = TRUE))

#Create custom colours
mycol1 <- rgb(0,255,0, max = 255, alpha = 80)
mycol2 <- rgb(255,0,0, max = 255, alpha = 30)

#Create and dsplay the charts

# GDP
plot(PC_model$stochastic_simulation$y$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="a) Italy GDP (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$y*0.95),max(PC_model$stochastic_simulation$y$mean*1.05)))
lines(PC_model$stochastic_simulation$y$mean+2*PC_model$stochastic_simulation$y$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$y$mean-2*PC_model$stochastic_simulation$y$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$y,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$y$mean + 2 * PC_model$stochastic_simulation$y$sd
y_lower <- PC_model$stochastic_simulation$y$mean - 2 * PC_model$stochastic_simulation$y$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)

# Consumption
plot(PC_model$stochastic_simulation$cons$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="b) Italy consumption (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$cons*0.95),max(PC_model$stochastic_simulation$cons$mean*1.05)))
lines(PC_model$stochastic_simulation$cons$mean+2*PC_model$stochastic_simulation$cons$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$cons$mean-2*PC_model$stochastic_simulation$cons$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$cons,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$cons$mean + 2 * PC_model$stochastic_simulation$cons$sd
y_lower <- PC_model$stochastic_simulation$cons$mean - 2 * PC_model$stochastic_simulation$cons$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)

# Tax revenue
plot(PC_model$stochastic_simulation$t$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="c) Italy tax revenue (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$t*0.95),max(PC_model$stochastic_simulation$t$mean*1.05)))
lines(PC_model$stochastic_simulation$t$mean+2*PC_model$stochastic_simulation$t$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$t$mean-2*PC_model$stochastic_simulation$t$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$t,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$t$mean + 2 * PC_model$stochastic_simulation$t$sd
y_lower <- PC_model$stochastic_simulation$t$mean - 2 * PC_model$stochastic_simulation$t$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)

# Bills held by households
plot(PC_model$stochastic_simulation$b_h$mean,col="deepskyblue4",lty=2,lwd=2,font.main=1,cex.main=1,
     main="d) Italy bills holdings (thous. eur, curr. p.)",
     ylab = 'Million Euro',xlab = '', cex.axis=1,cex.lab=1,xlim=range(1995,2028),
     ylim=range(min(PC_modelData$b_h*0.95),max(PC_model$stochastic_simulation$b_h$mean*1.1)))
lines(PC_model$stochastic_simulation$b_h$mean+2*PC_model$stochastic_simulation$b_h$sd,col=2,lty=1,lwd=2)
lines(PC_model$stochastic_simulation$b_h$mean-2*PC_model$stochastic_simulation$b_h$sd,col=2,lty=1,lwd=2)
lines(PC_modelData$b_h,col="deepskyblue4",lty=1,lwd=2)
x_values <- seq(2021, 2028)
y_upper <- PC_model$stochastic_simulation$b_h$mean + 2 * PC_model$stochastic_simulation$b_h$sd
y_lower <- PC_model$stochastic_simulation$b_h$mean - 2 * PC_model$stochastic_simulation$b_h$sd
polygon(
  c(x_values, rev(x_values)),
  c(y_upper, rev(y_lower)),
  col = mycol2,
  border = NA )
legend("bottom",c("Observed","Simulated mean","Mean +/- 2sd"),  bty = "n", cex=1,
       lty=c(1,2,1), lwd=c(2,2,2), col = c("deepskyblue4","deepskyblue4",2), box.lty=0)
```

![fig_4_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_4_emp.png)

### 7.5_SFC_tables

The fourth file, named [EMP_model_tables.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_tables.R), allows creating the balance sheet and the transactions-flow matrix of the economy, using either observed series or predicted ones.

Both the "knitr" and "kableExtra" packages are required. However, we highly recommend loading the latter after the tables have been created.

We start with the balance-sheet matrix.

```R
#Create BS and TFM tables using observed time series

#Upload libraries
library(knitr)

#Choose a year - NOTE: 27 = 2021
yr=27

#Choose a scenario (note: 1 = baseline)
#scen=1

#Create row names for BS matrix
rownames<-c( "Cash (money)",
             "Bills",
             "Wealth",
             "Column total")

#Create households aggregates
H <-c( round(PC_modelData$h_h[yr], digits = 2),                                                                    
       round(PC_modelData$b_h[yr], digits = 2),                                                                    
       round(-PC_modelData$v[yr], digits = 2),                                                                    
       round(-PC_modelData$v[yr]+PC_modelData$h_h[yr]+PC_modelData$b_h[yr], digits = 2)
)                                                                    

#Create table of results
H_BS<-as.data.frame(H,row.names=rownames)

#Print firms column
kable(H_BS)

#Create firms aggregates
P <-c( "",                                                                    
       "",                                                                    
       "",                                                                    
       0
)                                                                    

#Create table of results
F_BS<-as.data.frame(P,row.names=rownames)

#Print firms column
kable(F_BS)

#Create government aggregates
G   <-c( "",                                                                    
         round(-PC_modelData$b_s[yr], digits = 2),                                                                    
         round(PC_modelData$b_s[yr], digits = 2),                                                                    
         "0"
)                                                                    

#Create table of results
G_BS<-as.data.frame(G,row.names=rownames)

#Print government column
kable(G_BS)

#Create CB aggregates
CB  <-c( round(-PC_modelData$h_s[yr], digits = 2),                                                                    
         round(PC_modelData$b_cb[yr], digits = 2),                                                                    
         "0",
         round(-PC_modelData$h_s[yr]+PC_modelData$b_cb[yr], digits = 2)
)                                                                    

#Create table of results
CB_BS<-as.data.frame(CB,row.names=rownames)

#Print CB column
kable(CB_BS)

#Create "row total" column
Tot  <-c( round(PC_modelData$h_h[yr]-PC_modelData$h_s[yr], digits = 2),                                                                    
          round(PC_modelData$b_h[yr]+PC_modelData$b_cb[yr]-PC_modelData$b_s[yr], digits = 2),                                                                    
          round(-PC_modelData$v[yr]+PC_modelData$b_s[yr], digits = 2),
          round(PC_modelData$h_h[yr]-PC_modelData$h_s[yr]+
                  PC_modelData$b_h[yr]+PC_modelData$b_cb[yr]-PC_modelData$b_s[yr]+
                -PC_modelData$v[yr]+PC_modelData$b_s[yr], digits = 2)
)                                                                    

#Create table of results
Tot_BS<-as.data.frame(Tot,row.names=rownames)

#Print total column
kable(Tot_BS)

#Create BS matrix
BS_Matrix<-cbind(H_BS,F_BS,CB_BS,G_BS,Tot_BS)
kable(BS_Matrix) #Unload kableExtra to use this
```

The commands above allow visualising the BS matrix in the console. However, an HTML version and a LaTeX version of the table can be generated too by adding the following commands.

```R
#Upload libraries
library(kableExtra)

#Create captions
caption1 <- paste("Table 1. Balance sheet of Model EMP for Italy in ", yr+1994, "(thous. eur, curr. p.)")

#Create html table for BS
BS_Matrix %>%
  kbl(caption=caption1,
      format= "html",
      #format= "latex",
      col.names = c("Households","Firms","Central bank","Government","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")
```

![bs_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/bs_emp.png)

We can now move to the transactions-flow matrix.

```R
#Create row names for TFM
rownames<-c( "Consumption",
             "Government expenditure",
             "GDP (income)",
             "Interest payments",
             "CB profit",
             "Taxes",
             "Change in cash",
             "Change in bills",
             "Column total")

#Create households aggregates
H <-c( round(-PC_modelData$cons[yr], digits = 2),
       "",
       round(PC_modelData$y[yr], digits = 2),                                                                    
       round(PC_modelData$r[yr-1]*PC_modelData$b_h[yr-1], digits = 2),
       "",
       round(-PC_modelData$t[yr], digits = 2),
       round(-PC_modelData$h_h[yr]+PC_modelData$h_h[yr-1], digits = 2),
       round(-PC_modelData$b_h[yr]+PC_modelData$b_h[yr-1], digits = 2),
       round(-PC_modelData$cons[yr]+PC_modelData$y[yr]+PC_modelData$r[yr-1]*PC_modelData$b_h[yr-1]-PC_modelData$t[yr]+
              -PC_modelData$h_h[yr]+PC_modelData$h_h[yr-1]-PC_modelData$b_h[yr]+PC_modelData$b_h[yr-1], digits = 2)
)                                                                    

#Create table of results
H_TFM<-as.data.frame(H,row.names=rownames)

#Print households column
kable(H_TFM)

#Create firms aggregates
P <-c( round(PC_modelData$cons[yr], digits = 2),
       round(PC_modelData$g[yr], digits = 2),
       round(-PC_modelData$y[yr], digits = 2),                                                                    
       "",
       "",
       "",
       "",
       "",
       round(PC_modelData$cons[yr]+PC_modelData$g[yr]-PC_modelData$y[yr], digits = 2)
)                                                                    

#Create table of results
F_TFM<-as.data.frame(P,row.names=rownames)

#Print firms column
kable(F_TFM)

#Create government aggregates
G   <-c( "",
         round(-PC_modelData$g[yr], digits = 2),
         "",                                                                    
         round(-PC_modelData$r[yr-1]*PC_modelData$b_s[yr-1], digits = 2),
         round(PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1], digits = 2),
         round(PC_modelData$t[yr], digits = 2),
         "",
         round(PC_modelData$b_s[yr]-PC_modelData$b_s[yr-1], digits = 2),
         round(-PC_modelData$g[yr]+
               -PC_modelData$r[yr-1]*PC_modelData$b_s[yr-1]+
                PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1]+
                PC_modelData$t[yr]+
                 PC_modelData$b_s[yr]-PC_modelData$b_s[yr-1], digits = 2)
)                                                                    

#Create table of results
G_TFM<-as.data.frame(G,row.names=rownames)

#Print government column
kable(G_TFM)

#Create CB aggregates
CB   <-c( "",
         "",
         "",                                                                    
         round(PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1], digits = 2),
         round(-PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1], digits = 2),
         "",
         round(PC_modelData$h_s[yr]-PC_modelData$h_s[yr-1], digits = 2),
         round(-PC_modelData$b_cb[yr]+PC_modelData$b_cb[yr-1], digits = 2),
         round(PC_modelData$h_s[yr]-PC_modelData$h_s[yr-1]-PC_modelData$b_cb[yr]+PC_modelData$b_cb[yr-1], digits = 2)
)                                                                    

#Create table of results
CB_TFM<-as.data.frame(CB,row.names=rownames)

#Print CB column
kable(CB_TFM)

#Create "row total" column
Tot   <-c(round(PC_modelData$cons[yr]-PC_modelData$cons[yr], digits = 2),
          round(PC_modelData$g[yr]-PC_modelData$g[yr], digits = 2),
          round(PC_modelData$y[yr]-PC_modelData$y[yr], digits = 2),                                                                    
          round(PC_modelData$r[yr-1]*PC_modelData$b_h[yr-1]+PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1]-PC_modelData$r[yr-1]*PC_modelData$b_s[yr-1], digits = 2),
          round(PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1]-PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1], digits = 2),
          round(-PC_modelData$t[yr]+PC_modelData$t[yr], digits = 2),
          round(-PC_modelData$h_h[yr]+PC_modelData$h_h[yr-1]+PC_modelData$h_s[yr]-PC_modelData$h_s[yr-1], digits = 2),
          round(-PC_modelData$b_h[yr]+PC_modelData$b_h[yr-1]-PC_modelData$b_cb[yr]+PC_modelData$b_cb[yr-1]+PC_modelData$b_s[yr]-PC_modelData$b_s[yr-1], digits = 2),
          round(PC_modelData$cons[yr]-PC_modelData$cons[yr]+
                  PC_modelData$g[yr]-PC_modelData$g[yr]+
                  PC_modelData$y[yr]-PC_modelData$y[yr]+
                  PC_modelData$r[yr-1]*PC_modelData$b_h[yr-1]+PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1]-PC_modelData$r[yr-1]*PC_modelData$b_s[yr-1]+
                  PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1]-PC_modelData$r[yr-1]*PC_modelData$b_cb[yr-1]+
                  -PC_modelData$t[yr]+PC_modelData$t[yr]+
                  -PC_modelData$h_h[yr]+PC_modelData$h_h[yr-1]+PC_modelData$h_s[yr]-PC_modelData$h_s[yr-1]+
                  -PC_modelData$b_h[yr]+PC_modelData$b_h[yr-1]-PC_modelData$b_cb[yr]+PC_modelData$b_cb[yr-1]+PC_modelData$b_s[yr]-PC_modelData$b_s[yr-1], digits = 2)
)                                                                    

#Create table of results
Tot_TFM<-as.data.frame(Tot,row.names=rownames)

#Print total column
kable(Tot_TFM)

#Create TFM matrix
TFM_Matrix<-cbind(H_TFM,F_TFM,CB_TFM,G_TFM,Tot_TFM)
kable(TFM_Matrix) #Unload kableExtra to use this
```

Once again, a LaTeX version of the table can be generated using "kableExtra".

```R
#Upload libraries
library(kableExtra)

#Create captions
caption2 <- paste("Table 2. Transactions-flow matrix of Model EMP for Italy in ",yr+1994, "(thous. eur, curr. p.)")

#Create html table for TFM
TFM_Matrix %>%
  kbl(caption=caption2,
      format= "html",
      #format= "latex",
      col.names = c("Households","Firms","Central bank","Government","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")
```

![tfm_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/tfm_emp.png)

### 7.6_Sankey_diagram

The fifth file, named [EMP_model_sankey.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_sankey.R), generates the Sankey diagram of cross-sector transactions and changes in financial stocks. A few additional packages are required here.

```R
#Upload libraries for Sankey diagram
library(networkD3)
library(htmlwidgets)
library(htmltools)

#Create nodes: source, target and flows
nodes = data.frame("name" = 
                     c("Firms outflow", # Node 0
                       "Households outflow", # Node 1
                       "Government outflow", # Node 2
                       
                       "Firms inflow", # Node 3
                       "Households inflow", # Node 4
                       "Government inflow", # Node 5
                       
                       "Wages", # Node 6
                       "Consumption", # Node 7
                       "Taxes", # Node 8
                       "Government spending", # Node 9
                       "Money (change)", # Node 10
                       
                       "Interest payments", # Node 11
                       "Bills (change)", # Node 12                       
                       "CB outflow", # Node 13                    
                       "CB inflow" # Node 14                    
                       
                     )) 

#Select a year - NOTE: 27 = 2021
yr=27

#Create the flows
links = as.data.frame(matrix(c(
  0, 6, PC_modelData$cons[yr]+PC_modelData$g[yr],  
  1, 7, PC_modelData$cons[yr] ,
  1, 8, PC_modelData$t[yr],
  1, 10, PC_modelData$h_h[yr]-PC_modelData$h_h[yr-1],
  2, 9, PC_modelData$g[yr],
  6, 4, PC_modelData$cons[yr]+PC_modelData$g[yr],
  7, 3, PC_modelData$cons[yr],
  8, 5, PC_modelData$t[yr],
  9, 3, PC_modelData$g[yr],
  2, 11, PC_modelData$r[yr-1]*PC_modelData$b_h[yr-1],
  11, 4, PC_modelData$r[yr-1]*PC_modelData$b_h[yr-1],
  10, 14, PC_modelData$h_s[yr]-PC_modelData$h_s[yr-1],
  12, 5, PC_modelData$b_s[yr]-PC_modelData$b_s[yr-1],
  1, 12, PC_modelData$b_h[yr]-PC_modelData$b_h[yr-1],
  13, 12, PC_modelData$b_cb[yr]-PC_modelData$b_cb[yr-1]
  
), 

#Note: each row represents a link. The first number represents the node being
#connected from. The second number represents the node connected to. The third
#number is the value of the node.  

byrow = TRUE, ncol = 3))
names(links) = c("source", "target", "value")
my_color <- 'd3.scaleOrdinal() .domain([]) .range(["blue","green","yellow","red","purple","khaki","peru","violet","cyan","pink","orange","beige","white"])'

#Create and plot the network
sankeyNetwork(Links = links, Nodes = nodes,
              Source = "source", Target = "target",
              Value = "value", NodeID = "name", colourScale=my_color,
              fontSize= 25, nodeWidth = 30)
```

![sankey_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/sankey_emp.png)

### 7.7_Experiments

Tha last file, named [EMP_model_experim.R](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/EMP_model_experim.R), imposes exogenous shocks to selected model variables to create alternative scenarios (to be compared with the baseline scenario). Firstly, we rename the values of selected varaibles under the baseline scenario (deterministic out-of-sample simulations).

```R
#Attribute values to selected variables
y_0=PC_model$simulation$y
cons_0=PC_model$simulation$cons
t_0=PC_model$simulation$t
b_h_0=PC_model$simulation$b_h
```

Secondly, we create one or more alternative scenarios by adding exogenous corrections to selected variables through the *constantAdjList* and then re-running the model.

```R
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
```

![fig_5_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_5_emp.png)

## 8_Useful_links

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
