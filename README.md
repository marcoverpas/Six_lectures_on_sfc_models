# Six lectures on SFC models

Codes used in the 6 lectures on SFC models delivered on November-December 2023, namely, R files reproducing PC, PC-EX1, BMW, and REG models from Goodley and Lavoie, "Monetary Economics", including additional features. An empirically-calibrated version (named EMP), an input-output version (named IO-PC), and an ecosystem-augmented version (named ECO-PC) of Model PC are provided too. 

## Table of Contents

- [Introduction](#Introduction)
- [Model_PC](#Model_PC)
- [Model_BMW](#Model_BMW)
- [Model_REG](#Model_REG)
- [Model_IO-PC](#Model_IO-PC)
- [Model_ECO-PC](#Model_ECO-PC)
- [Model_EMP](#Model_EMP)

## Introduction

In the laste three decades, macroeconomic modelling has been dominated by Dynamic Stochastic General Equilibrium (DSGE). However, dissatisfaction with these models has been growing since the mid-2000s. Three primary weaknesses have been identified in DSGE models: unrealistic assumptions, a limited range of considerations, and poor data fit, including logical inconsistencies and empirical non sequitur in aggregate production functions.

In response to these shortcomings, alternative models have emerged, each aiming to address specific deficiencies. Computable General Equilibrium (CGE) models, though sharing assumptions with DSGE, attempt to broaden the scope. Leontief-like Input-Output (IO) models provide more room for a sound economic analysis but still face limitations. Heterogeneous agent-based models, network analysis, and other complexity models offer novel perspectives. Notably, Stock-Flow Consistent (SFC) models have gained traction, finding applications in empirical research by institutions like the Bank of England and the Italian Ministry of Economy and Finance.

The resurgence of interest in SFC models can be traced back to Wynne Godley's successful predictions of the U.S. crises in 2001 and 2007. Godley's work, culminating in the seminal "Monetary Economics: An Integrated Approach" (2007), laid the foundation for SFC modelling. SFC models, rooted in national accounts and flow of funds, integrate financial and real aspects of the economy, allowing for the identification of unsustainable processes.

SFC models serve as system dynamics models, analysing complex systems over time, tracking flows, stocks, and utilising feedback loops. Basic SFC models have evolved into various forms, including Open-Economy or Multi-Area SFC models (MA-SFC), Ecological SFC models (ECO-SFC), Interacting Heterogeneous Agent-Based SFC models (AB-SFC), Input-output SFC Models (IO-SFC), and Empirical SFC Models (E-SFC).

Crucially, SFC models adhere to four accounting principles: flow consistency, stock consistency, stock-flow consistency, and quadruple book-keeping. The economy is divided into sectors, each represented by accounting matrices and dynamic equations reflecting the System of National Accounts.

## Model_PC

[in progress]

## Model_BMW

[in progress]

## Model_REG

[in progress]

## Model_IO-PC

[in progress]

## Model_ECO-PC

[in progress]

## Model_Emp

[in progress]

```R
# Install required packages
install.packages(bimets)

# Load the package
library(bimets)

```

[in progress]

![fig1_emp](https://raw.githubusercontent.com/marcoverpas/figures/main/fig_1_emp.png)
