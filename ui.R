ui = dashboardPage(
    skin = "purple",
    title = "multiPhylo",
    ##########
    # Header #
    ##########
    dashboardHeader(
        title = span(img(src = "tejido_maya_0.jpg", height = 50), "multiPhylo")
    ),
    ###########
    # Sidebar #
    ###########
    dashboardSidebar(
        sidebarMenu(
            menuItem(tabName = "load_data", "LOADING DATA", icon=icon("database"))
        ),
        sidebarMenu(
            menuItem(tabName = "examine_data", "EXAMINING DATA", icon=icon("glasses"))
        ),
        sidebarMenu(
            menuItem(tabName = "tree_comp", "DISTANCE BASED TREES", icon=icon("robot"))
        ),
        sidebarMenu(
            menuItem(tabName = "parsimony_optim", "OPTIMIZING BY NEW TECHNOLOGIES", icon=icon("tree"))
        ),        
        sidebarMenu(
            menuItem(tabName = "mod_test", "MODEL TEST", icon=icon("vials"))
        ),
        sidebarMenu(
            menuItem(tabName = "map_tree", "TREE MAP", icon=icon("globe-americas"))
        ),
        sidebarMenu(
            menuItem(tabName = "prob_dist", "PROBABILITY DISTRIBUTIONS", icon=icon("chess-board"))
        )

    ),
    ########
    # Body #
    ########
    dashboardBody(

        tabItems(
            # LOADING DATA
            tabItem(tabName = "load_data",
                fluidRow(
#                    verbatimTextOutput("path"),
                    box(
                        fileInput("file1", "UPLOAD FILE (fasta, nexus, phylip)",
                                multiple = F,
                                accept = c(".fas", ".phy", ".nex", ".ph", ".fasta", ".dna")
                        )
                    ),
                    br(),
                    box(title = "SEQUENCES", 
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="overflow-x: scroll;overflow-y: scroll; height: 350px;",
                            tableOutput("contents") %>%
                            withSpinner(color="#0dc5c1")
                        )
                    )
                )
            ),
            #EXAMINING DATA
            tabItem(tabName = "examine_data",
                fluidRow(
                    box(title = "NUCLEOTIDES", 
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="height = 600px;",
                            plotOutput("examination")
                        )
                    )
                )
            ),
            # TREE COMPARISSON
            tabItem(tabName = "tree_comp",
                fluidRow(
                    box(width = 12,
                        column(width = 4,
                            selectInput("tree1", "CLUSTERING CRITERIA",
                            choices=clustering, selected=clustering[6])
                        ),
                        column(width = 4,
                            selectInput("distance", "CHOOSE DISTANCE MEASURE",
                            choices=distancias, selected=distancias[1])
                        ),
                        column(width = 4,
                            selectInput("tree2", "CLUSTERING CRITERIA",
                            choices=clustering, selected=clustering[10])
                        )
                    ),
                    box(solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="height = 600px;",
                            plotOutput("tree_comp")
                        )
                    ),
                    uiOutput("parsimony1"),
                    uiOutput("tree_dist"),
                    uiOutput("parsimony2")
                )
            ),
            # OPTIMIZE TREE
            tabItem(tabName = "parsimony_optim",
                fluidRow(
                    box(solidHeader = T,
                        selectInput("optim_criteria", "OPTIMIZATION METHOD:",
                        choices = optimization, selected = optimization[1])
                    ),
                    box(solidHeader = T, 
                        title = "NEAREST NEIGHBOR INTERCHANGE VS PRATCHET",
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="height = 600px;",
                            plotOutput("optim_tree")
                        )
                    )#,
#                    box(width = 6,
#                        title = "CHOOSE YOUR TREE",
#                        collapsible = T,
#                        collapsed = F
#                    ),
#                    box(width = 6,
#                        title = "OPTIMIZED TREE",
#                        collapsible = T,
#                        collapsed = F
#                    )
                )
            ),
            # MODEL TEST
            tabItem(tabName = "mod_test",
                fluidRow(
                    box(title = "BEST SUBSTITUION MODEL",
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        actionButton("run_mod_test","RUN"),
                        div(style="height = 650px;",
                            tableOutput("model_testing") %>%
                            withSpinner(color="#0dc5c1")
                        )
                    )
                )
            ),
            # TREE MAP
            tabItem(tabName = "map_tree",
                fluidRow(
                    box(title = "MAP",
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="height = 600px;",
                            plotOutput("tree_map")
                        )
                    )
                )
            ),
            # PROBABILITY DISTRIBUTIONS #
            tabItem(tabName = "prob_dist",
                fluidRow(
                    box(width= 12,
                        column(6,
                            selectInput("dist1", "CHOOSE PRIOR DISTRIBUTIONS", 
                                         choices=catPriorConj$prior,
                                         selected="Normal")
                        ),
                        column(6,
                            uiOutput("conjugate_prior")
                        )
                    ),
                    box(title = "DIFFERENT PROBABILITY DISTRIBUTIONS",
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="height = 600px;",
                            column(width = 6,
                                plotOutput("dist1_prob")
                            ),
                            column(width = 6,
                                plotOutput("dist2_prob")
                            )
                        )
                    )
                )
            )
        )
    )
)
