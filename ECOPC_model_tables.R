# Model ECO-PC for R: physical flow matrix and physical stock-flow matrix

# Version: 9 November 2023

################################################################################

#Create BS, TFM and IO tables

#Upload libraries
library(knitr)

#Choose a year
yr=20

################################################################################
################################################################################

#Create row names for PFM matrix
rownames<-c( "INPUTS",
             "Extracted matter",
             "Recycled socio-economic stock",
             "Renewable energy",
             "Non-renewable energy",
             "Oxygen",
             "OUTPUTS",
             "Industrial CO2 emissions",
             "Discarded socio-economic stock",
             "Dissipated energy",
             "Change in socio-economic stock",
             "Tot")

################################################################################

#Create matter aggregates
M <-c("", 
      round(mat[1,yr], digits = 2),
      round(rec[1,yr], digits = 2),
      "",
      round(cen[1,yr], digits = 2),
      round(o2[1,yr], digits = 2),
      "",
      round(-emis[1,yr], digits = 2),
      round(-dis[1,yr], digits = 2),
      "",
      round(-kh[1,yr]+kh[1,yr-1], digits = 2),
      round(mat[1,yr]+rec[1,yr]+cen[1,yr]+o2[1,yr]+
              -emis[1,yr]-dis[1,yr]-kh[1,yr]+kh[1,yr-1]  , digits = 2)
       
)                                                                    

#Create table of results
M_PFM<-as.data.frame(M,row.names=rownames)

#Print matter column
kable(M_PFM)

#####################################

#Create energy aggregates
E <-c("", 
      "",
      "",
      round(ren[1,yr], digits = 2),
      round(nen[1,yr], digits = 2),
      "",
      "",
      "",
      "",
      round(-en[1,yr], digits = 2),
      "",
      round(ren[1,yr]+nen[1,yr]-en[1,yr], digits = 2)
      
)                                                                    

#Create table of results
E_PFM<-as.data.frame(E,row.names=rownames)

#Print energy column
kable(E_PFM)

#####################################

#Create PFM matrix
PFM_Matrix<-cbind(M_PFM,E_PFM)
kable(PFM_Matrix) #Unload kableExtra to use this

################################################################################
################################################################################

#Create row names for PSFM matrix
rownames<-c( "INITIAL STOCK",
             "Resources converted into reserves",
             "CO2 emissions",
             "Production of material goods",
             "Extraction of matter / use of energy",
             "Destruction of socio-economi stock",
             "FINAL STOCK",
             "Tot")

################################################################################

#Create matter aggregates
Ma <-c(round(k_m[1,yr-1], digits = 2),
      round(conv_m[1,yr], digits = 2),
      "",
      "",
      round(-mat[1,yr], digits = 2),
      "",
      round(k_m[1,yr], digits = 2),
      round(k_m[1,yr-1]+conv_m[1,yr]-mat[1,yr]-k_m[1,yr], digits = 2)
      
)                                                                    

#Create table of results
Ma_PSFM<-as.data.frame(Ma,row.names=rownames)

#Print matter column
kable(Ma_PSFM)

#####################################

#Create energy aggregates
Ea <-c(round(k_e[1,yr-1], digits = 2),
       round(conv_e[1,yr], digits = 2),
       "",
       "",
       round(-nen[1,yr], digits = 2),
       "",
       round(k_e[1,yr], digits = 2),
       round(k_e[1,yr-1]+conv_e[1,yr]-nen[1,yr]-k_e[1,yr], digits = 2)
       
)                                                                    

#Create table of results
Ea_PSFM<-as.data.frame(Ea,row.names=rownames)

#Print energy column
kable(Ea_PSFM)

#####################################

#Create co2 aggregates
CO2 <-c(round(co2_cum[1,yr-1], digits = 2),
       "",
       round(emis[1,yr], digits = 2),
       "",
       "",
       "",
       round(co2_cum[1,yr], digits = 2),
       round(co2_cum[1,yr-1]+emis[1,yr]-co2_cum[1,yr], digits = 2)
       
)                                                                    

#Create table of results
CO2_PSFM<-as.data.frame(CO2,row.names=rownames)

#Print co2 column
kable(CO2_PSFM)

#####################################

#Create s.e.s. aggregates
SES <-c(round(kh[1,yr-1], digits = 2),
        "",
        "",
        round(x_mat[1,yr], digits = 2),
        "",
        round(-dis[1,yr], digits = 2),
        round(kh[1,yr], digits = 2),
        round(kh[1,yr-1]+x_mat[1,yr]-dis[1,yr]-kh[1,yr], digits = 2)
        
)                                                                    

#Create table of results
SES_PSFM<-as.data.frame(SES,row.names=rownames)

#Print s.e.s. column
kable(SES_PSFM)

#####################################

#Create PSFM matrix
PSFM_Matrix<-cbind(Ma_PSFM,Ea_PSFM,CO2_PSFM,SES_PSFM)
kable(PSFM_Matrix) #Unload kableExtra to use this


################################################################################

#Create html and latex tables

#Upload libraries
library(kableExtra)

#Create captions
caption3 <- paste("Table 4. Physical flow matrix of Model ECO-PC in period", yr, "under baseline (matter = Gt, energy = EJ)")
caption4 <- paste("Table 5. Physical stock-flow matrix matrix of Model ECO-PC in period ",yr, "under baseline (matter = Gt, energy = EJ)")

#Create html table for PFM
PFM_Matrix %>%
  kbl(caption=caption3,
      format= "html",
      #format= "latex",
      col.names = c("Matter","Energy"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")

#Create html table for PSFM
PSFM_Matrix %>%
  kbl(caption=caption4,
      format= "html",
      #format= "latex",
      col.names = c("Material reserves","Energy reserves","CO2 concentration","Socio-economic stock"),
      align="r") %>%
  kable_classic(full_width = F, html_font = "helvetica")

