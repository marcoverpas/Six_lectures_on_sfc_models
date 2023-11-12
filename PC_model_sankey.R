# Model PC for R: Sankey diagram of transactions
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 30 May 2019; revised: 6 November 2023

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

#Select period
period=5

#Create the flows
links = as.data.frame(matrix(c(
  0, 6, cons[1,period]+g[1,period],  
  1, 7, cons[1,period] ,
  1, 8, t[1,period],
  1, 10, h_h[1,period]-h_h[1,period-1],
  2, 9, g[1,period],
  6, 4, cons[1,period]+g[1,period],
  7, 3, cons[1,period],
  8, 5, t[1,period],
  9, 3, g[1,period],
  2, 11, r[1,period-1]*b_h[1,period-1],
  11, 4, r[1,period-1]*b_h[1,period-1],
  10, 14, h_s[1,period]-h_s[1,period-1],
  12, 5, b_s[1,period]-b_s[1,period-1],
  1, 12, b_h[1,period]-b_h[1,period-1],
  13, 12, b_cb[1,period]-b_cb[1,period-1]
  
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
