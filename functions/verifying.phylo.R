verifying.phylo = function(x){
    return(class(x)=="phyDat")
}

calculating.tree = function(df){
    if(tree1=="UPGMA"){
        arb = upgma(dist.ml(df))
    }
    if(tree1=="NEIGHBOR JOINING"){
        arb = nj(dist.ml(df)
    }
    arb = ladderize(arb)
    return(arb)
}
