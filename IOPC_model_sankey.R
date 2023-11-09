# Model IO-PC for R: Sankey diagram of transactions and cross-industry relations
# aggregate equations taken from Model PC
# Wynne Godley and Marc Lavoie
# Monetary Economics
# Chapter 4 

# Version: 9 November 2023

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

#Upload libraries for Sankey diagram
library(networkD3)
library(htmlwidgets)
library(htmltools)

################################################################################

#A) Sankey diagram of money transactions-flow and nominal changes in stocks

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
yr=5

#Create the flows
links = as.data.frame(matrix(c(
  0, 6, p_c[1,yr]*cons[1,yr]+p_g[1,yr]*g[1,yr],  
  1, 7, p_c[1,yr]*cons[1,yr] ,
  1, 8, t[1,yr],
  1, 10, h_h[1,yr]-h_h[1,yr-1],
  2, 9, p_g[1,yr]*g[1,yr],
  6, 4, p_c[1,yr]*cons[1,yr]+p_g[1,yr]*g[1,yr],
  7, 3, p_c[1,yr]*cons[1,yr],
  8, 5, t[1,yr],
  9, 3, p_g[1,yr]*g[1,yr],
  2, 11, r[1,yr-1]*b_h[1,yr-1],
  11, 4, r[1,yr-1]*b_h[1,yr-1],
  10, 14, h_s[1,yr]-h_s[1,yr-1],
  12, 5, b_s[1,yr]-b_s[1,yr-1],
  1, 12, b_h[1,yr]-b_h[1,yr-1],
  13, 12, b_cb[1,yr]-b_cb[1,yr-1]
  
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


################################################################################

#B) Sankey diagram of cross-industry relations

#Create nodes: source, target and flows
nodes = data.frame("name" = 
                     c("a) Industry 1 output", # Node 0
                       "b) Industry 2 output", # Node 1
                       
                       "c) Industry 1 inputs", # Node 2
                       "d) Industry 2 inputs", # Node 3
                       
                       "e) Final demand for product 1", # Node 4
                       "f) Final demand for product 2", # Node 5
                       
                       "g) Market for product 1", # Node 6
                       "h) Market for product 2" # Node 7
                              
                     )) 

#Select period
yr=5

#Create the flows
links = as.data.frame(matrix(c(
  0, 6, x[1,yr,1]*p[1,yr,1],
  6, 2, x[1,yr,1]*A[1]*p[1,yr,1],
  6, 3, x[1,yr,2]*A[3]*p[1,yr,1],
  6, 4, d[1,yr,1]*p[1,yr,1],
  
  1, 7, x[1,yr,2]*p[1,yr,2],
  7, 2, x[1,yr,1]*A[2]*p[1,yr,2],
  7, 3, x[1,yr,2]*A[4]*p[1,yr,2],
  7, 5, d[1,yr,2]*p[1,yr,2]
  
), 

#Note: each row represents a link. The first number represents the node being
#connected from. The second number represents the node connected to. The third
#number is the value of the node.  

byrow = TRUE, ncol = 3))
names(links) = c("source", "target", "value")
my_color <- 'd3.scaleOrdinal() .domain([]) .range(["darkgreen","blue","mediumseagreen","turquoise","palegreen","skyblue","seagreen","royalblue"])'

#Create and plot the network
sankeyNetwork(Links = links, Nodes = nodes,
              Source = "source", Target = "target",
              Value = "value", NodeID = "name", colourScale=my_color,
              fontSize= 25, nodeWidth = 30)
