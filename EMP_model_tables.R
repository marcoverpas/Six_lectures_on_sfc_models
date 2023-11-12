# Model EMP for R: balance-sheet and transactions-flow matrix
# equations taken from Model PC
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 8 November 2023

################################################################################

#Create BS and TFM tables using observed time series

#Upload libraries
library(knitr)

#Choose a year - NOTE: 27 = 2021
yr=27

#Choose a scenario (note: 1 = baseline)
#scen=1

################################################################################
################################################################################

#Create row names for BS matrix
rownames<-c( "Cash (money)",
             "Bills",
             "Wealth",
             "Column total")

################################################################################

#Create households aggregates
H <-c( round(PC_modelData$h_h[yr], digits = 2),                                                                    
       round(PC_modelData$b_h[yr], digits = 2),                                                                    
       round(-PC_modelData$v[yr], digits = 2),                                                                    
       round(-PC_modelData$v[yr]+PC_modelData$h_h[yr]+PC_modelData$b_h[yr], digits = 2)
)                                                                    

#Create table of results
H_BS<-as.data.frame(H,row.names=rownames)

#Print households column
kable(H_BS)

################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

#Create BS matrix
BS_Matrix<-cbind(H_BS,F_BS,CB_BS,G_BS,Tot_BS)
kable(BS_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

#Create TFM matrix
TFM_Matrix<-cbind(H_TFM,F_TFM,CB_TFM,G_TFM,Tot_TFM)
kable(TFM_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

#Create html and latex tables

#Upload libraries
library(kableExtra)

#Create captions
caption1 <- paste("Table 1. Balance sheet of Model EMP for Italy in ", yr+1994, "(thous. eur, curr. p.)")
caption2 <- paste("Table 2. Transactions-flow matrix of Model EMP for Italy in ",yr+1994, "(thous. eur, curr. p.)")

#Create html table for BS
BS_Matrix %>%
  kbl(caption=caption1,
      format= "html",
      #format= "latex",
      col.names = c("Households","Firms","Central bank","Government","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")

#Create html table for TFM
TFM_Matrix %>%
  kbl(caption=caption2,
      format= "html",
      #format= "latex",
      col.names = c("Households","Firms","Central bank","Government","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")
