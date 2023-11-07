# Model REG for R: Sankey diagram of transactions
# from Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 6 

# Version: 31 October 2023

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

#Sankey diagram of money transactions-flow and nominal changes in stocks

#Upload libraries for Sankey diagram
library(networkD3)
library(htmlwidgets)
library(htmltools)

#Create nodes: source, target and flows
nodes = data.frame("name" = 
                     c("N households outflow", # Node 0
                       "N firms outflow", # Node 1
                       "S households outflow", # Node 2
                       "S firms outflow", # Node 3
                       "Government outflow", # Node 4
                       "CB outlow", # Node 5
                       
                       "N households inflow", # Node 6
                       "N firms inflow", # Node 7
                       "S households inflow", # Node 8
                       "S firms inflow", # Node 9
                       "Government inflow", # Node 10
                       "CB inflow", # Node 11
                       
                       "Consumption", # Node 12                       
                       "Government expenditure", # Node 13                    
                       "N export to S", # Node 14
                       "S export to N", # Node 15
                       "Income (GDP)", # Node 16
                       "Interest payments", # Node 17
                       "CB profits", # Node 18
                       "Taxes", # Node 19
                       
                       "Change in cash", # Node 20
                       "Change in bills" # Node 21
                       
                     )) 

#Select period
yr=5

#Create the flows
links = as.data.frame(matrix(c(
  
  0, 12, cons_n[1,yr],
  2, 12, cons_s[1,yr],
  12, 7, cons_n[1,yr],
  12, 9, cons_s[1,yr],
  
  4, 13, g[1,yr],
  13, 7, g_n[1,yr],
  13, 9, g_s[1,yr],
  
  3, 14, x_n[1,yr],
  14, 7, x_n[1,yr],
  1, 15, x_s[1,yr],
  15, 9, x_s[1,yr],
  
  1, 16, y_n[1,yr],
  16, 6, y_n[1,yr],
  3, 16, y_s[1,yr],
  16, 8, y_s[1,yr],
  
  4, 17, r[1,yr-1]*b_s[1,yr-1],
  17, 6, r[1,yr-1]*b_h_n[1,yr-1],
  17, 8, r[1,yr-1]*b_h_s[1,yr-1],
  17, 11, r[1,yr-1]*b_cb[1,yr-1],
  
  5, 18, r[1,yr-1]*b_cb[1,yr-1],
  18, 10, r[1,yr-1]*b_cb[1,yr-1],
  
  0, 19, t_n[1,yr],
  2, 19, t_s[1,yr],
  19, 10, t[1,yr],
  
  0, 20, h_h_n[1,yr]-h_h_n[1,yr-1],
  2, 20, h_h_s[1,yr]-h_h_s[1,yr-1],
  20, 11, h_h[1,yr]-h_h[1,yr-1],
  
  0, 21, b_h_n[1,yr]-b_h_n[1,yr-1],
  2, 21, b_h_s[1,yr]-b_h_s[1,yr-1],
  5, 21, b_cb[1,yr]-b_cb[1,yr-1],
  21, 10, b_s[1,yr]-b_s[1,yr-1]
  
  
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
