# App libraries
library(shinydashboard)
library(shinycssloaders)
library(magrittr)
library(RColorBrewer)
# Phylogenetic analysis libraries
#library(TreeTools)
#library(TreeSearch)
library(phytools)
library(phangorn)
#library(ggtree)# Plotting fancy trees with ggplot
library(phylotools)
library(ape)
library(seqinr)
#library(FactoMineR)
#library(factoextra)
library(rworldmap)
#library(mapdata)

source("functions/phylo.to.map.R")
source("functions/verifying.phylo.R")
#source("https://raw.githubusercontent.com/liamrevell/phytools/master/R/phylo.to.map.R")
distrib = c("Normal","Uniform","Beta")
