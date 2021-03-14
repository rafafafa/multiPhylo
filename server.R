server = function(input, output, session){
    # Handling input file
    df = reactive({
        df = read.phyDat("datasets/data_eric.phy", format = "phylip")
#        df = read.phyDat("/home/rafa/Documents/datametrix/2021/clase_kleyton/clases/clase_7/data_eric.fas", format = "fasta")
        #req(input$file1)
        #tryCatch({
        #    df = read.phyDat(input$file1$datapath, format="phylip")
        #    },
        #    error = function(e) stop(safeError(e))
        #)
        return(df)
    })
    # SHOWING DATA
    output$contents = renderTable({
        df()
    })
    # EXAMINING DATA
    output$examination = renderPlot({
        par(mar=c(0,8,1,0))
        image(df())
    })
    # TREE COMPARISSON
    arb1 = reactive({upgma(dist.ml(df()))})
    arb2 = reactive({nj(dist.ml(df()))})
    
    output$tree_comp = renderPlot({
        arboles = function(x){
            x = dist.ml(x)
            arb1 = upgma(x)
            arb2 = nj(x)
#            assoc = as.matrix(data.frame(df0_fasta[,1],df0_fasta[,1]))
            arb12 = cophylo(arb1,arb2,rotate.multi=T)
            n = length(arb1$tip.label)
            paleta = 2
            plot(arb12,link.lwd=4,link.lty="solid",link.col=rep(brewer.pal(n,paste0("Set",paleta)),ceiling(n/length(brewer.pal(n,paste0("Set",paleta))))),main="UPGMA vs NJ")
#            title("UPGMA vs NJ",outer=T)
        }
        par(mar=c(0,0,0,1))
        arboles(df())
    })
    output$parsimony_upgma = renderUI({
        infoBox(
            "PARSIMONY SCORE UPGMA",
            #c(parsimony(upgma(df())),
            parsimony(arb1(),data=df()),
            fill=T,
            width=6)
    })

    output$parsimony_nj = renderUI({
        infoBox(
            "PARSIMONY SCORE NJ",
            parsimony(arb2(),data=df()),
            fill=T,
            width=6)
    })

    # MODEL TESTING
    mt = eventReactive(input$run_mod_test, {
        mt = modelTest(df())
        mt = mt[order(mt$AIC, decreasing=F),]

    })
    output$model_testing = renderTable({
        mt()
    })
    # TREE OVER A MAP
    output$tree_map = renderPlot({
        phylo.to.map(arb1())
#        phylo.to.map(World.tree,World,plot=FALSE)
    })
    
}
