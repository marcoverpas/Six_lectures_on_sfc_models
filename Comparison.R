#Spot and highlight difference between two R files

#Install/recall package
#install("diffobj")
library("diffobj")

#Examples

#Run the comparison for file no. 1
diffFile("PC_model.R","PCEX1_model.R")

