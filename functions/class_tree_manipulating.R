verifyingPhylo = function(x){
    return(class(x)=="phyDat")
}

convertingPhyDat2Numerical = function(df){
        m = PhyDatToMatrix(df)
        taxones = rownames(m)
        df = as.data.frame(lapply(as.data.frame(m),
                function(x) as.numeric(as.factor(x))))
        rownames(df) = taxones
        return(df)
}

calculatingTree = function(df, tree){
    if(tree=="WARD"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "ward.D"))
    }
    if(tree=="WARD2"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "ward.D2"))
    }
    if(tree=="SINGLE"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "single"))
    }
    if(tree=="COMPLETE"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "complete"))
    }
    if(tree=="UPGMA-hclust"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "average"))
    }
    if(tree=="UPGMA-ape"){
        arb = upgma(dist.ml(df))
    }
    if(tree=="WPGMA"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "mcquitty"))
    }
    if(tree=="WPGMC"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "median"))
    }
    if(tree=="UPGMC"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df)
        arb = as.phylo(hclust(dist_df, method = "centroid"))
    }
    if(tree=="NEIGHBOR JOINING"){
        arb = nj(dist.ml(df))
    }
#    arb = ladderize(arb, right=F)
    return(arb)
}
