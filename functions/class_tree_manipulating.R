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

calculatingTree = function(df, tree, distancia){
    distancia = tolower(distancia)
    if(tree=="WARD"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "ward.D"))
    }
    if(tree=="WARD2"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "ward.D2"))
    }
    if(tree=="SINGLE"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "single"))
    }
    if(tree=="COMPLETE"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "complete"))
    }
    if(tree=="UPGMA-hclust"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "average"))
    }
    if(tree=="UPGMA-ape"){
        arb = upgma(dist.ml(df))
    }
    if(tree=="WPGMA"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "mcquitty"))
    }
    if(tree=="WPGMC"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "median"))
    }
    if(tree=="UPGMC"){
        df = convertingPhyDat2Numerical(df)
        dist_df = dist(df, method = distancia)
        arb = as.phylo(hclust(dist_df, method = "centroid"))
    }
    if(tree=="NEIGHBOR JOINING"){
        arb = nj(dist.ml(df))
    }
#    arb = ladderize(arb, right=F)
    return(arb)
}

distributionPlotter = function(dist){
        if(dist=="Normal"|dist=="Multivariate Normal"){
            hist(rnorm(100), col = "red", border="white", main=dist)
        }
        if(dist=="Beta"){
            hist(rbeta(100,1,2), col = "blue", border="white", main=dist)
        }
        if(dist=="Uniform"){
            hist(runif(100), col = "orange", border="white", main=dist)
        }else{
            NULL
        }
}

dataLoader = function(path){
    df =  NULL
    if(is.character(path)){
       if(grepl(path, pattern="\\.nex$")){
            df = read.phyDat(path, format="nexus")
        }
       if(grepl(path, pattern="\\.fas$|\\.fasta$")){
            lista_seq = seqinr::read.fasta(path)
            longitudes = unlist(lapply(lista_seq,length))
            tabla = table(longitudes)
            long_comun = as.numeric(names(tabla)[which(tabla==max(tabla))])[1]
            taxones = names(lista_seq)
            lista_seq0 = lista_seq[longitudes == long_comun]
            print(length(lista_seq0))
            taxones = taxones[longitudes == long_comun]
            df = as.data.frame(lapply(lista_seq0, function(x)as.character(x)))
            df = phyDat(df)
        }
        formatos = c("interleaved","phylip","nexus","fasta","sequential","clustal","")
        numero = 0
        while(is.null(df)){
            numero = numero + 1
            df = tryCatch(read.phyDat(path, format=formatos[numero]),
                      error = function(cond)NULL,#message(cond),
                      warning = function(cond)NULL)#message(cond))
            if(numero==6) break
        }
    }
    return(df)
}

coplottingTrees = function(arb1, arb2){
    arb12 = cophylo(arb1,arb2,rotate.multi=T)
    n = length(arb1$tip.label)
    paleta = 2
    plot(arb12,
        link.lwd = 4,
        link.lty = "solid",
        link.col = rep(brewer.pal(n,paste0("Set",paleta)),
        ceiling(n/length(brewer.pal(n,paste0("Set",paleta)))))
    )
}

