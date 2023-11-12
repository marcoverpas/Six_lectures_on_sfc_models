# Model BMW for R: balance-sheet and transactions-flow matrix
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 7 

# Version: 8 November 2023

################################################################################

#Create BS and TFM tables

#Upload libraries
library(knitr)

#Choose a year
yr=50

#Choose a scenario (note: 1 = baseline)
scen=1

################################################################################
################################################################################

#Create row names for BS matrix
rownames<-c( "Deposits",
             "Loans",
             "Fixed capital",
             "Balance (net worth)",
             "Column total")

################################################################################

#Create households aggregates
H <-c( round(mh[scen,yr], digits = 2),                                                                    
       "",                                                                    
       "",                                                                    
       round(-mh[scen,yr], digits = 2),
       round(mh[scen,yr]-mh[scen,yr], digits = 2)
)                                                                    

#Create table of results
H_BS<-as.data.frame(H,row.names=rownames)

#Print firms column
kable(H_BS)

################################################################################

#Create firms aggregates
P <-c( "",                                                                    
       round(-l_d[scen,yr], digits = 2),                                                                    
       round(k[scen,yr], digits = 2),                                                                    
       0,
       round(-l_d[scen,yr]+k[scen,yr], digits = 2)
)                                                                    

#Create table of results
F_BS<-as.data.frame(P,row.names=rownames)

#Print firms column
kable(F_BS)

################################################################################

#Create banks aggregates
B  <-c( round(-ms[scen,yr], digits = 2),                                                                    
        round(l_s[scen,yr], digits = 2),                                                                    
        "",
        0,
        round(ms[scen,yr]-l_s[scen,yr], digits = 2)
)                                                                    

#Create table of results
B_BS<-as.data.frame(B,row.names=rownames)

#Print firms column
kable(B_BS)

################################################################################

#Create "row total" column
Tot  <-c( round(mh[scen,yr]-ms[scen,yr], digits = 2),                                                                    
          round(-l_d[scen,yr]+l_s[scen,yr], digits = 2),                                                                    
          round(k[scen,yr], digits = 2),
          round(-mh[scen,yr], digits = 2),
          round(k[scen,yr]-mh[scen,yr], digits = 2)
)                                                                    

#Create table of results
Tot_BS<-as.data.frame(Tot,row.names=rownames)

#Print firms column
kable(Tot_BS)

################################################################################

#Create BS matrix
BS_Matrix<-cbind(H_BS,F_BS,B_BS,Tot_BS)
kable(BS_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

#Create row names for TFM
rownames<-c( "Consumption",
             "Investment",
             "Production",
             "Wages",
             "Depreciation",
             "Interests on loans",
             "Interests on deposits",
             "Change in loans",
             "Change in deposits",
             "Column total")

################################################################################

#Create households aggregates
H <-c( round(-c_d[scen,yr], digits = 2),
       "",
       "",
       round(wb_d[scen,yr], digits = 2),                                                                    
       "",
       "",
       round(rm[scen,yr-1]*mh[scen,yr-1], digits = 2),
       "",
       round(-mh[scen,yr]+mh[scen,yr-1], digits = 2),
       round(-c_d[scen,yr]+wb_d[scen,yr]+rm[scen,yr-1]*mh[scen,yr-1]-mh[scen,yr]+mh[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
H_TFM<-as.data.frame(H,row.names=rownames)

#Print firms column
kable(H_TFM)

################################################################################

#Create firms (current) aggregates
Fc <-c( round(c_s[scen,yr], digits = 2),
        round(i_d[scen,yr], digits = 2),
        paste("[",round(y[scen,yr], digits = 2),"]"),                                                                      
        round(-wb_s[scen,yr], digits = 2),
        round(-da[scen,yr], digits = 2),
        round(-rl[scen,yr-1]*l_d[scen,yr-1], digits = 2),
        "",
        "",
        "",
        round(c_s[scen,yr]+i_d[scen,yr]-wb_s[scen,yr]-da[scen,yr]-rl[scen,yr-1]*l_d[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
Fc_TFM<-as.data.frame(Fc,row.names=rownames)

#Print firms column
kable(Fc_TFM)

################################################################################

#Create firms (capital) aggregates
Fk <-c( "",
        round(-i_d[scen,yr], digits = 2),
        "",                                                                      
        "",
        round(da[scen,yr], digits = 2),
        "",
        "",
        round(l_d[scen,yr]-l_d[scen,yr-1], digits = 2),
        "",
        round(-i_d[scen,yr]+da[scen,yr]+l_d[scen,yr]-l_d[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
Fk_TFM<-as.data.frame(Fk,row.names=rownames)

#Print firms column
kable(Fk_TFM)

################################################################################

#Create banks aggregates
B   <-c( "",
         "",
         "",                                                                      
         "",
         "",
         round(rl[scen,yr-1]*l_s[scen,yr-1], digits = 2),
         round(-rm[scen,yr-1]*ms[scen,yr-1], digits = 2),
         round(-l_s[scen,yr]+l_s[scen,yr-1], digits = 2),
         round(ms[scen,yr]-ms[scen,yr-1], digits = 2),
         round(rl[scen,yr-1]*l_s[scen,yr-1]-rm[scen,yr-1]*ms[scen,yr-1]+
               -l_s[scen,yr]+l_s[scen,yr-1]+ms[scen,yr]-ms[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
B_TFM<-as.data.frame(B,row.names=rownames)

#Print firms column
kable(B_TFM)

################################################################################

#Create "row total" column
Tot   <-c(round(c_d[scen,yr]-c_s[scen,yr], digits = 2),
          round(i_d[scen,yr]-i_s[scen,yr], digits = 2),
          "",                                                                    
          round(wb_d[scen,yr]-wb_s[scen,yr], digits = 2),
          round(-da[scen,yr]+af[scen,yr], digits = 2),
          round(-rl[scen,yr-1]*l_d[scen,yr-1]+rl[scen,yr-1]*l_s[scen,yr-1], digits = 2),
          round(rm[scen,yr-1]*mh[scen,yr-1]-rm[scen,yr-1]*ms[scen,yr-1], digits = 2),
          round((l_d[scen,yr]-l_d[scen,yr-1])-(l_s[scen,yr]-l_s[scen,yr-1]), digits = 2),
          round(-(mh[scen,yr]-mh[scen,yr-1])-(ms[scen,yr]-ms[scen,yr-1]), digits = 2),
          round(wb_d[scen,yr]-wb_s[scen,yr]-da[scen,yr]+af[scen,yr]+
                -rl[scen,yr-1]*l_d[scen,yr-1]+rl[scen,yr-1]*l_s[scen,yr-1]+
                rm[scen,yr-1]*mh[scen,yr-1]-rm[scen,yr-1]*ms[scen,yr-1]+
                (l_d[scen,yr]-l_d[scen,yr-1])-(l_s[scen,yr]-l_s[scen,yr-1])+
                -(mh[scen,yr]-mh[scen,yr-1])-(ms[scen,yr]-ms[scen,yr-1]), digits = 2)
)                                                                    

#Create table of results
Tot_TFM<-as.data.frame(Tot,row.names=rownames)

#Print firms column
kable(Tot_TFM)

################################################################################

#Create TFM matrix
TFM_Matrix<-cbind(H_TFM,Fc_TFM,Fk_TFM,B_TFM,Tot_TFM)
kable(TFM_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

#Create html and latex tables

#Upload libraries
library(kableExtra)

#Create captions
caption1 <- paste("Table 1. Balance sheet of Model PC in period", yr, "under scenario", scen)
caption2 <- paste("Table 2. Transactions-flow matrix of Model PC in period ",yr, "under scenario", scen)

#Create html table for BS
BS_Matrix %>%
  kbl(caption=caption1,
      format= "html",
      #format= "latex",
      col.names = c("Households","Firms","Banks","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")

#Create html table for TFM
TFM_Matrix %>%
  kbl(caption=caption2,
      format= "html",
      #format= "latex",
      col.names = c("Households","Firms (current)","Firms (capital)","Banks","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")
