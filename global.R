# App libraries
library(shinydashboard)
library(shinycssloaders)
library(magrittr)
library(RColorBrewer)
# Phylogenetic analysis libraries
library(TreeSearch)# lets see
library(phytools)# see phylotools
library(phangorn)#like ape, powerfoul
#library(ggtree)# Plotting fancy trees with ggplot
library(phylotools)# loading analyzing data
library(ape)# paup
library(seqinr)# load sequencies
library(TreeTools)
#library(FactoMineR)
#library(factoextra)
library(rworldmap)
#library(mapdata)

source("functions/phylo.to.map.R")
#source("functions/verifying.phylo.R")
source("functions/class_tree_manipulating.R")
#source("https://raw.githubusercontent.com/liamrevell/phytools/master/R/phylo.to.map.R")
#distrib = c("Normal",
#            "Uniform",
#            "Beta")
prior = c("Bernoulli","Binomial","Negative Binomial","Poisson",
          "Categorical","Multinomial","Normal","Multivariate Normal","Uniform")
conj_prior = c("Beta","Beta","Beta","Gamma",
               "Dirichlet","Dirichlet","Normal","Multivariate Normal", "Pareto")
catPriorConj = data.frame(prior, conj_prior)
clustering = c("WARD",#ward.d
               "WARD2",#ward.d2
               "SINGLE",#single
               "COMPLETE",#complete
               "UPGMA-hclust",#average
               "UPGMA-ape",#average               
               "WPGMA",#mcquitty
               "WPGMC",#median
               "UPGMC",#centroide
               "NEIGHBOR JOINING")#UPGMC
distancias = c("EUCLIDEAN", "MAXIMUM",
               "MANHATTAN", "CANBERRA",
               "BINARY", "MINKOWSKI")
optimization = c("TREE BISECTION RECONNECTION (TBR)",
                 "SUBTREE PRUNING AND REGRAFTING (SPR)",
                 "NEAREST NEIGHBOR INTERCHANGE (NNI)",
                 "RATCHET")
