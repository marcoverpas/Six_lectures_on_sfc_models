# Model REG for R: balance-sheet and transactions-flow matrix
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 6 

# Version: 1 November 2023

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

#Create BS and TFM tables

#Upload libraries
library(knitr)

#Choose a year
yr=29

#Choose a scenario (note: 1 = baseline)
scen=1

################################################################################
################################################################################

#Create row names for BS matrix
rownames<-c( "Cash",
             "Bills",
             "Wealth",
             "Column total")

################################################################################

#Create N households aggregates
N_h <-c( round(h_h_n[scen,yr], digits = 2),                                                                    
         round(b_h_n[scen,yr], digits = 2),                                                                    
         round(-v_n[scen,yr], digits = 2),                                                                    
         round(-v_n[scen,yr]+h_h_n[scen,yr]+b_h_n[scen,yr], digits = 2)
)                                                                    

#Create table of results
N_h_BS<-as.data.frame(N_h,row.names=rownames)

#Print firms column
kable(N_h_BS)

################################################################################

#Create S households aggregates
S_h <-c( round(h_h_s[scen,yr], digits = 2),                                                                    
         round(b_h_s[scen,yr], digits = 2),                                                                    
         round(-v_s[scen,yr], digits = 2),                                                                    
         round(-v_s[scen,yr]+h_h_s[scen,yr]+b_h_s[scen,yr], digits = 2)
)                                                                    

#Create table of results
S_h_BS<-as.data.frame(S_h,row.names=rownames)

#Print firms column
kable(S_h_BS)

################################################################################

#Create government aggregates
G   <-c( "",                                                                    
         round(-b_s[scen,yr], digits = 2),                                                                    
         round(b_s[scen,yr], digits = 2),                                                                    
         "0"
)                                                                    

#Create table of results
G_BS<-as.data.frame(G,row.names=rownames)

#Print firms column
kable(G_BS)

################################################################################

#Create CB aggregates
CB  <-c( round(-h_s[scen,yr], digits = 2),                                                                    
         round(b_cb[scen,yr], digits = 2),                                                                    
         "0",
         round(-h_s[scen,yr]+b_cb[scen,yr], digits = 2)
)                                                                    

#Create table of results
CB_BS<-as.data.frame(CB,row.names=rownames)

#Print firms column
kable(CB_BS)

################################################################################

#Create "row total" column
Tot  <-c( round(h_h_n[scen,yr]+h_h_s[scen,yr]-h_s[scen,yr], digits = 2),                                                                    
          round(b_h_n[scen,yr]+b_h_s[scen,yr]+b_cb[scen,yr]-b_s[scen,yr], digits = 2),                                                                    
          round(-v_n[scen,yr]-v_s[scen,yr]+b_s[scen,yr], digits = 2),
          round(h_h_n[scen,yr]+h_h_s[scen,yr]-h_s[scen,yr]+
                b_h_n[scen,yr]+b_h_s[scen,yr]+b_cb[scen,yr]-b_s[scen,yr]+
                -v_n[scen,yr]-v_s[scen,yr]+b_s[scen,yr], digits = 2)
)                                                                    

#Create table of results
Tot_BS<-as.data.frame(Tot,row.names=rownames)

#Print firms column
kable(Tot_BS)

################################################################################

#Create BS matrix
BS_Matrix<-cbind(N_h_BS,S_h_BS,G_BS,CB_BS,Tot_BS)
kable(BS_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

#Create row names for TFM
rownames<-c( "Consumption",
             "Government expenditure",
             "N export to S",
             "S export to N",
             "GDP (income)",
             "Interest payments",
             "CB profit",
             "Taxes",
             "Change in cash",
             "Change in bills",
             "Column total")

################################################################################

#Create N households aggregates
N_h <-c( round(-cons_n[scen,yr], digits = 2),
         "",
         "",
         "",
         round(y_n[scen,yr], digits = 2),                                                                    
         round(r[scen,yr-1]*b_h_n[scen,yr-1], digits = 2),
         "",
         round(-t_n[scen,yr], digits = 2),
         round(-h_h_n[scen,yr]+h_h_n[scen,yr-1], digits = 2),
         round(-b_h_n[scen,yr]+b_h_n[scen,yr-1], digits = 2),
         round(-cons_n[scen,yr]+y_n[scen,yr]+r[scen,yr-1]*b_h_n[scen,yr-1]-t_n[scen,yr]+
               -h_h_n[scen,yr]+h_h_n[scen,yr-1]-b_h_n[scen,yr]+b_h_n[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
N_h_TFM<-as.data.frame(N_h,row.names=rownames)

#Print firms column
kable(N_h_TFM)

################################################################################

#Create N firms aggregates
N_f <-c( round(cons_n[scen,yr], digits = 2),
         round(g_n[scen,yr], digits = 2),
         round(x_n[scen,yr], digits = 2),
         round(-im_n[scen,yr], digits = 2),
         round(-y_n[scen,yr], digits = 2),                                                                    
         "",
         "",
         "",
         "",
         "",
         round(cons_n[scen,yr]+g_n[scen,yr]+x_n[scen,yr]-im_n[scen,yr]-y_n[scen,yr], digits = 2)
)                                                                    

#Create table of results
N_f_TFM<-as.data.frame(N_f,row.names=rownames)

#Print firms column
kable(N_f_TFM)

################################################################################

#Create S households aggregates
S_h <-c( round(-cons_s[scen,yr], digits = 2),
         "",
         "",
         "",
         round(y_s[scen,yr], digits = 2),                                                                    
         round(r[scen,yr-1]*b_h_s[scen,yr-1], digits = 2),
         "",
         round(-t_s[scen,yr], digits = 2),
         round(-h_h_s[scen,yr]+h_h_s[scen,yr-1], digits = 2),
         round(-b_h_s[scen,yr]+b_h_s[scen,yr-1], digits = 2),
         round(-cons_s[scen,yr]+y_s[scen,yr]+r[scen,yr-1]*b_h_s[scen,yr-1]-t_s[scen,yr]+
                 -h_h_s[scen,yr]+h_h_s[scen,yr-1]-b_h_s[scen,yr]+b_h_s[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
S_h_TFM<-as.data.frame(S_h,row.names=rownames)

#Print firms column
kable(S_h_TFM)

################################################################################

#Create S firms aggregates
S_f <-c( round(cons_s[scen,yr], digits = 2),
         round(g_s[scen,yr], digits = 2),
         round(x_s[scen,yr], digits = 2),
         round(-im_s[scen,yr], digits = 2),
         round(-y_s[scen,yr], digits = 2),                                                                    
         "",
         "",
         "",
         "",
         "",
         round(cons_s[scen,yr]+g_s[scen,yr]+x_s[scen,yr]-im_s[scen,yr]-y_s[scen,yr], digits = 2)
)                                                                    

#Create table of results
S_f_TFM<-as.data.frame(S_f,row.names=rownames)

#Print firms column
kable(S_f_TFM)

################################################################################

#Create government aggregates
G   <-c( "",
         round(-g[scen,yr], digits = 2),
         "",
         "",
         "",                                                                    
         round(-r[scen,yr-1]*b_s[scen,yr-1], digits = 2),
         round(r[scen,yr-1]*b_cb[scen,yr-1], digits = 2),
         round(t[scen,yr], digits = 2),
         "",
         round(b_s[scen,yr]-b_s[scen,yr-1], digits = 2),
         round(-g[scen,yr]+
               -r[scen,yr-1]*b_s[scen,yr-1]+
                r[scen,yr-1]*b_cb[scen,yr-1]+
                t[scen,yr]+
                b_s[scen,yr]-b_s[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
G_TFM<-as.data.frame(G,row.names=rownames)

#Print firms column
kable(G_TFM)

################################################################################

#Create CB aggregates
CB   <-c( "",
         "",
         "",
         "",
         "",                                                                    
         round(r[scen,yr-1]*b_cb[scen,yr-1], digits = 2),
         round(-r[scen,yr-1]*b_cb[scen,yr-1], digits = 2),
         "",
         round(h_s[scen,yr]-h_s[scen,yr-1], digits = 2),
         round(-b_cb[scen,yr]+b_cb[scen,yr-1], digits = 2),
         round(h_s[scen,yr]-h_s[scen,yr-1]-b_cb[scen,yr]+b_cb[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
CB_TFM<-as.data.frame(CB,row.names=rownames)

#Print firms column
kable(CB_TFM)

################################################################################

#Create "row total" column
Tot   <-c(round(cons_n[scen,yr]+cons_s[scen,yr]-cons_n[scen,yr]-cons_s[scen,yr], digits = 2),
          round(g_n[scen,yr]+g_s[scen,yr]-g[scen,yr], digits = 2),
          round(x_n[scen,yr]-im_s[scen,yr], digits = 2),
          round(x_s[scen,yr]-im_n[scen,yr], digits = 2),
          round(y_n[scen,yr]+y_s[scen,yr]-y_n[scen,yr]-y_s[scen,yr], digits = 2),                                                                    
          round(r[scen,yr-1]*b_h_n[scen,yr-1]+r[scen,yr-1]*b_h_s[scen,yr-1]+r[scen,yr-1]*b_cb[scen,yr-1]-r[scen,yr-1]*b_s[scen,yr-1], digits = 2),
          round(r[scen,yr-1]*b_cb[scen,yr-1]-r[scen,yr-1]*b_cb[scen,yr-1], digits = 2),
          round(-t_n[scen,yr]-t_s[scen,yr]+t[scen,yr], digits = 2),
          round(-(h_h_n[scen,yr]-h_h_n[scen,yr-1]+h_h_s[scen,yr]-h_h_s[scen,yr-1])+h_s[scen,yr]-h_s[scen,yr-1], digits = 2),
          round(-(b_h_n[scen,yr]-b_h_n[scen,yr-1]+b_h_s[scen,yr]-b_h_s[scen,yr-1]+b_cb[scen,yr]-b_cb[scen,yr-1])+b_s[scen,yr]-b_s[scen,yr-1], digits = 2),
          round(cons_n[scen,yr]+cons_s[scen,yr]-cons_n[scen,yr]-cons_s[scen,yr]+
                  g_n[scen,yr]+g_s[scen,yr]-g[scen,yr]+
                  x_n[scen,yr]-im_s[scen,yr]+
                  x_s[scen,yr]-im_n[scen,yr]+
                  y_n[scen,yr]+y_s[scen,yr]-y_n[scen,yr]-y_s[scen,yr]+
                  r[scen,yr-1]*b_h_n[scen,yr-1]+r[scen,yr-1]*b_h_s[scen,yr-1]+r[scen,yr-1]*b_cb[scen,yr-1]-r[scen,yr-1]*b_s[scen,yr-1]+
                  r[scen,yr-1]*b_h_n[scen,yr-1]+r[scen,yr-1]*b_h_s[scen,yr-1]+r[scen,yr-1]*b_cb[scen,yr-1]-r[scen,yr-1]*b_s[scen,yr-1]+
                  r[scen,yr-1]*b_cb[scen,yr-1]-r[scen,yr-1]*b_cb[scen,yr-1]+
                  -t_n[scen,yr]-t_s[scen,yr]+t[scen,yr]+
                  -(h_h_n[scen,yr]-h_h_n[scen,yr-1]+h_h_s[scen,yr]-h_h_s[scen,yr-1])+h_s[scen,yr]-h_s[scen,yr-1]+
                  -(b_h_n[scen,yr]-b_h_n[scen,yr-1]+b_h_s[scen,yr]-b_h_s[scen,yr-1]+b_cb[scen,yr]-b_cb[scen,yr-1])+b_s[scen,yr]-b_s[scen,yr-1], digits = 2)
)                                                                    

#Create table of results
Tot_TFM<-as.data.frame(Tot,row.names=rownames)

#Print firms column
kable(Tot_TFM)

################################################################################

#Create TFM matrix
TFM_Matrix<-cbind(N_h_TFM,N_f_TFM,S_h_TFM,S_f_TFM,G_TFM,CB_TFM,Tot_TFM)
kable(TFM_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

#Create html and latex tables

#Upload libraries
library(kableExtra)

#Create captions
caption1 <- paste("Table 3. Balance sheet of Model REG in period", yr, "under scenario", scen)
caption2 <- paste("Table 2. Transactions-flow matrix of Model REG in period ",yr, "under scenario", scen)

#Create html table for BS
BS_Matrix %>%
  kbl(caption=caption1,
      format= "html",
      #format= "latex",
      col.names = c("N households","S households","Government","Central bank","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")

#Create html table for TFM
TFM_Matrix %>%
  kbl(caption=caption2,
      format= "html",
      #format= "latex",
      col.names = c("N households","N firms","S households","S firms","Government","Central bank","Row total"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")
