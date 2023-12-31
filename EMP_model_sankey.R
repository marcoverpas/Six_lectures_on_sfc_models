# Model EMP for R: Sankey diagram of transactions
# equations taken from Model PC
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 8 November 2023

################################################################################

#Sankey diagram of money transactions-flow and nominal changes in stocks

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
