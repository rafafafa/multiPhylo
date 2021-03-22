server = function(input, output, session){
    ################
    # SHOWING DATA #
    ################
#    output$path = renderText({
#        cat(system(paste0("cat ", input$file1$datapath)))
#    })
    df = reactive({
        dataLoader(input$file1$datapath)
    })
    # Plotting table
    output$contents = renderTable({
        df()
    })
    ##################
    # EXAMINING DATA #
    ##################
    output$examination = renderPlot({
        print((df()))
        if(verifyingPhylo(df())){
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
        if(verifyingPhylo(df())){
            calculatingTree(df(),input$tree1, input$distance)
        }else{
            NULL
        }
    })
    arb2 = reactive({
        if(verifyingPhylo(df())){
            calculatingTree(df(),input$tree2, input$distance)
        }else{
            NULL
        }
    })
    # Comparisson between trees
    output$tree_comp = renderPlot({
        if(verifyingPhylo(df())){
            par(mar=c(0,0,0,1))
            coplottingTrees(arb1(), arb2())
        }else{
            NULL
        }
    })
    # Calculating parsimony and distances
    output$parsimony1 = renderUI({
        if(verifyingPhylo(df())){
            infoBox(
                paste0("PARSIMONY SCORE ", input$tree1),
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
        if(verifyingPhylo(df())){
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
    output$parsimony2 = renderUI({
        if(verifyingPhylo(df())){
            infoBox(
                paste0("PARSIMONY SCORE ", input$tree2),
                parsimony(arb2(),data=df()),
                fill=T,
                width=4,
                color = "red"
            )
        }else{
            NULL
        }
    })
    ###########################
    # OPTIMIZING BY PARSIMONY #
    ###########################
    arb_opt = reactive({
        if(verifyingPhylo(df())){
            if(parsimony(arb1())<parsimony(arb2())){
                optim.parsimony(arb1(), df())
            }else{
                optim.parsimony(arb2(), df())        
            }
        }else{
            NULL
        }

    })
    
    output$optim_tree = renderPlot({
        if(verifyingPhylo(df())){
            par(mar=c(0,0,0,1))
            coplottingTrees(arb1(), arb_opt())
        }else{
            NULL
        }
    })
    #################
    # MODEL TESTING #
    #################
    mt = eventReactive(input$run_mod_test, {
        if(verifyingPhylo(df())){
            mt = modelTest(df())
            mt = mt[order(mt$AIC, decreasing=F),]
        }else{
            NULL
        }
    })
    output$model_testing = renderTable({
        if(verifyingPhylo(df())){
            mt()
        }else{
            NULL
        }
    })
    ###################
    # TREE OVER A MAP #
    ###################
    output$tree_map = renderPlot({
        if(verifyingPhylo(df())){
            phylo.to.map(arb1())
        }else{
            NULL
        }
    })
    #############################
    # PROBABILITY DISTRIBUTIONS #
    #############################
    output$conjugate_prior = renderUI({
        default = catPriorConj$conj_prior[which(input$dist1==catPriorConj$prior)]
        selectInput("dist2", "PROPER CONJUGATE PRIOR",
                    choices = catPriorConj$conj_prior, selected=default)
    })
    
    output$dist1_prob = renderPlot({
        distributionPlotter(input$dist1)
    })
    
    output$dist2_prob = renderPlot({
        distributionPlotter(input$dist2)
    })

}
