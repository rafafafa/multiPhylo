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
    
    output$tree_comp = renderPlot({
        arboles = function(x){
            x = dist.ml(x)
            arb1 = upgma(x)
            arb2 = nj(x)
#            assoc = as.matrix(data.frame(df0_fasta[,1],df0_fasta[,1]))
            arb12 = cophylo(arb1,arb2,rotate.multi=T)
            n = length(arb1$tip.label)
            plot(arb12,link.lwd=4,link.lty="solid",link.col=rainbow(n),main="UPGMA vs NJ")
        }
        par(mar=c(0,0,0,0))
        arboles(df())
    })
    # MODEL TESTING
    output$model_testing = renderTable({
#        withCallingHandlers(
#            message = function(m) output$text <- renderPrint(m$message)
            mt = modelTest(df())
#        )
        mt = mt[order(mt$AIC, decreasing=F),]
    })
    # TREE OVER A MAP
    output$tree_map = renderPlot({
        phylo.to.map(arb1())
#        phylo.to.map(World.tree,World,plot=FALSE)
    })
    
}
