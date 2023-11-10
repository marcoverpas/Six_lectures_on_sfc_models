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

In response to these shortcomings, alternative models have emerged, each aiming to address specific deficiencies. Computable General Equilibrium (CGE) models, though sharing assumptions with DSGE, attempt to broaden the scope. Leontief-like Input-Output (IO) models provide more room for a sound economic analysis but still face limitations. Heterogeneous agent-based models, network analysis, and other complexity models offer novel perspectives. Notably, Stock-Flow Consistent  models ([SFC]([https://en.wikipedia.org/wiki/Stock-flow_consistent_model#:~:text=Stock%2Dflow%20consistent%20models%20(SFC,the%20stocks%20of%20an%20economy.](https://en.wikipedia.org/wiki/Stock-flow_consistent_model#:~:text=Stock%2Dflow%20consistent%20models%20(SFC,the%20stocks%20of%20an%20economy.))) have gained traction, finding applications in empirical research by institutions like the Bank of England and the Italian Ministry of Economy and Finance.

The resurgence of interest in SFC models can be traced back to Wynne Godley's successful predictions of the U.S. crises in 2001 and 2007. Godley's work laid the foundation for SFC modelling. SFC models, rooted in national accounts and flow of funds, integrate financial and real aspects of the economy, allowing for the identification of unsustainable processes.

SFC models serve as system dynamics models, analysing complex systems over time, tracking flows, stocks, and utilising feedback loops. Basic SFC models have evolved into various forms, including Open-Economy or Multi-Area SFC models (MA-SFC), Ecological SFC models (ECO-SFC), Interacting Heterogeneous Agent-Based SFC models (AB-SFC), Input-output SFC Models (IO-SFC), and Empirical SFC Models (E-SFC).

Crucially, SFC models adhere to four accounting principles: flow consistency, stock consistency, stock-flow consistency, and quadruple book-keeping. The economy is divided into sectors, each represented by accounting matrices and dynamic equations reflecting the System of National Accounts.

Standard SFC models typically fall within the range of medium-scale macro-econometric dynamic models. These models are commonly formulated in discrete time using difference equations. However, continuous-time formulations using differential equations are also employed, providing a more nuanced representation of economic processes. The decision between discrete and continuous time depends on the temporal granularity required for the analysis.

The simplicity or complexity of SFC models dictates the approach to solving them. The simplest models, often featuring a limited number of equations, can be solved analytically by finding steady-state solutions. These solutions provide insights into the long-term behavior of the model. More advanced SFC models, characterized by increased complexity and a larger number of equations, necessitate computational methods. Computer simulations become essential for understanding the dynamic interactions within the system. Numerical techniques, such as iterative methods and numerical integration, are employed to capture the intricate dynamics of these models.

![fig_lang](https://raw.githubusercontent.com/marcoverpas/figures/main/languages.png)

Coefficients in SFC models play a crucial role in shaping model behaviour. Researchers have several options for determining these coefficients:

a) Fine-tuning: Coefficients can be fine-tuned to achieve specific baseline scenarios, drawing insights from previous studies or selecting values from a reasonable range.

b) Calibration: Researchers may calibrate coefficients to match the model's predictions with observed data, aligning the model with real-world economic conditions.

c) Estimation: Econometric methods, including Ordinary Least Squares (OLS) and cointegration techniques, enable the estimation of coefficients from observed data, enhancing the model's empirical relevance.

Unlike DSGE models, which often rely on a unified platform like Dynare, SFC modeling lacks a universally adopted program. The pioneering codes used in Godley and Lavoie's work were developed by Gennaro Zezza using EViews and Excel. However, the landscape has evolved over time. R (RStudio) has become the predominant programming environment for SFC modeling, owing to its flexibility and extensive capabilities. Dedicated R packages such as SFCR and Godley provide specialized tools for SFC modeling. Additionally, Bimets, developed by the Bank of Italy, offers a platform for empirical SFC model development. Alternative programming languages, including Matlab (with or without Dynare), Mathematica, Python, and Julia, find applications in SFC modeling, particularly for creating agent-based SFC models. Minsky, a software package developed by Steve Keen, stands out as a tool for visually modeling macroeconomic system dynamics.


## Model_PC

This is a model developed in chapter 4 of Godley and Lavoie, "An Integrated Approach to Credit, Money, Income, Production and Wealth". PC stands for portfolio choice, because households can hold their wealth in terms of cash and/or government bills.
Key assumptions are as follows:

- Closed economy

- Four agents: households, “firms”, government, central bank

- Two financial assets: government bills and outside money (cash)

- No investment (accumulation) and no inventories

- Fixed prices and zero net profits

- No banks, no inside money (bank deposits)

- No ecosystem

Note that model variables have been modelled as matrices, where rows represent different scenarios and columns denote distinct periods. Parameters and exogenous variables are typically represented as scalars. However, variables susceptible to shocks are treated as matrices (as they change over time). Equilibrium solutions for the system of simultaneous equations have been derived without relying on any dedicated package, but rather through a sufficiently high number of iterations. Lastly, the redundant equation is used to double-check model consistency over time in the baseline scenario. 

The main code for reproducing the experiments can be found [here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_model.R). A version in which the economy is started from scratch is available too ([here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PC_model_from_scratch.R)). The expectation-augmented version, named PCECX1, is available ([here](https://github.com/marcoverpas/Six_lectures_on_sfc_models/blob/main/PCEX1_model.R)).

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
