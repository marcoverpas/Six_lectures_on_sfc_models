# Model BMW for R (from scratch): Sankey diagram of transactions
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 7 

# Version: 8 November 2022

#Sankey diagram of money transactions-flow and nominal changes in stocks 

#Upload libraries for Sankey diagram
library(networkD3)
library(htmlwidgets)
library(htmltools)

#Create nodes: source, target and flows
nodes = data.frame("name" = 
                     c("Households outflow", # Node 0
                       "Firms outflow", # Node 1
                       "Banks outflow", # Node 2
                       
                       "Households inflow", # Node 3
                       "Firms inflow", # Node 4
                       "Banks inflow", # Node 5
                       
                       "Consumption", # Node 6
                       "Investment", # Node 7
                       "Wages", # Node 8
                       "Depreciation", # Node 9
                       
                       "Interests on loans", # Node 10
                       "Interests on deposits", # Node 11
                       
                       "Loans (change)", # Node 12                       
                       "Deposits (change)" # Node 13                    
                       
                     )) 

#Select period
yr=5

#Create the flows
links = as.data.frame(matrix(c(
  0, 6, c_d[1,yr],  
  6, 4, c_s[1,yr],
  1, 7, i_d[1,yr],
  7, 4, i_s[1,yr],
  1, 8, wb_s[1,yr],
  8, 3, wb_d[1,yr],
  1, 9, da[1,yr],
  9, 4, da[1,yr],
  1, 10, rl[1,yr-1]*l_d[1,yr-1],
  10, 5, rl[1,yr-1]*l_s[1,yr-1],
  2, 11, rm[1,yr-1]*ms[1,yr-1],
  11, 3, rm[1,yr-1]*mh[1,yr-1],
  0, 13, mh[1,yr]-mh[1,yr-1],
  13, 5, ms[1,yr]-ms[1,yr-1],
  2, 12, l_s[1,yr]-l_s[1,yr-1],
  12, 4, l_d[1,yr]-l_d[1,yr-1]
  
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
