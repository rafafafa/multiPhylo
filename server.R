server = function(input, output, session){
    ################
    # SHOWING DATA #
    ################
#    output$path = renderText({
#        cat(system(paste0("cat ", input$file1$datapath)))
#    })

    df = reactive({
        if(is.character(input$file1$datapath)){
            df = NULL
#            if(grepl(input$file1$datapath, pattern="\\.nex$")){
#                df = ape::read.nexus.data(input$file1$datapath)
#            }
            formatos = c("phylip","nexus","fasta","interleaved","sequential","clustal","")
            numero = 0
            while(is.null(df)){
                numero = numero + 1
                df = tryCatch(read.phyDat(input$file1$datapath, format=formatos[numero]), 
                          error = function(cond)message(cond),
                          warning = function(cond)message(cond))
                if(numero==6) break
            }
        }else{
            df = NULL
        }
        return(df)
    })
    # Plotting table
    output$contents = renderTable({
        df()
    })
    ##################
    # EXAMINING DATA #
    ##################
    output$examination = renderPlot({
        print(class(df()))
        if(verifying.phylo(df())){
            par(mar=c(0,8,1,0))
            image(df())
        }else{
            NULL
        }
    })
    ####################
    # TREE COMPARISSON #
    ####################
    arb1 = reactive({
        if(verifying.phylo(df())){
            ladderize(upgma(dist.ml(df())))
        }else{
            NULL
        }
    })
    arb2 = reactive({
        if(verifying.phylo(df())){
            ladderize(nj(dist.ml(df())))
        }else{
            NULL
        }
    })
    # Comparisson between trees
    output$tree_comp = renderPlot({
        if(verifying.phylo(df())){
            arboles = function(x){
                x = dist.ml(x)
                arb1 = upgma(x)
                arb2 = nj(x)
                arb12 = cophylo(arb1,arb2,rotate.multi=T)
                n = length(arb1$tip.label)
                paleta = 2
                plot(arb12,link.lwd=4,link.lty="solid",link.col=rep(brewer.pal(n,paste0("Set",paleta)),ceiling(n/length(brewer.pal(n,paste0("Set",paleta))))),main="UPGMA vs NJ")
            }
            par(mar=c(0,0,0,1))
            arboles(df())
        }else{
            NULL
        }
    })
    # Calculating parsimony and distances
    output$parsimony_upgma = renderUI({
        if(verifying.phylo(df())){
            infoBox(
                "PARSIMONY SCORE UPGMA",
                parsimony(arb1(),data=df()),
                fill=T,
                width=4,
                color = "blue"
            )
        }else{
            NULL
        }
    })
    
    output$tree_dist = renderUI({
        if(verifying.phylo(df())){
            infoBox(
                "DISTANCE BETWEEN TREES",
                paste0(round(as.numeric(treedist(arb1(),arb2())),digits=2),collapse="---"),
                fill = T,
                width = 4,
                color = "orange"
            )
        }else{
            NULL
        }
    })
    output$parsimony_nj = renderUI({
        if(verifying.phylo(df())){
            infoBox(
                "PARSIMONY SCORE NJ",
                parsimony(arb2(),data=df()),
                fill=T,
                width=4,
                color = "red"
            )
        }else{
            NULL
        }
    })
    # MODEL TESTING
    mt = eventReactive(input$run_mod_test, {
        if(verifying.phylo(df())){
            mt = modelTest(df())
            mt = mt[order(mt$AIC, decreasing=F),]
        }else{
            NULL
        }
    })
    output$model_testing = renderTable({
        if(verifying.phylo(df())){
            mt()
        }else{
            NULL
        }
    })
    # TREE OVER A MAP
    output$tree_map = renderPlot({
        if(verifying.phylo(df())){
            phylo.to.map(arb1())
        }else{
            NULL
        }
    })
    # PROBABILITY DISTRIBUTIONS
    output$dist_prob = renderPlot({
#        print(input$dist1)
        if(input$dist1=="Normal"){
            hist(rnorm(100), col = "red", border="white", main=input$dist1)
        }
        if(input$dist1=="Beta"){
            hist(rbeta(100,1,2), col = "blue", border="white", main=input$dist1)
        }
        if(input$dist1=="Uniform"){
            hist(runif(100), col = "orange", border="white", main=input$dist1)
        }else{
            NULL
        }
    })
}
