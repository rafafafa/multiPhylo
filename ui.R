ui = dashboardPage(
    skin = "red",
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
            menuItem(tabName = "mod_test", "MODEL TEST", icon=icon("ethernet"))
        ),
        sidebarMenu(
            menuItem(tabName = "map_tree", "TREE MAP", icon=icon("globe-americas"))
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
                    fileInput("file1", "Choose FASTA/PHYLO file",
                            multiple = F,
                            accept = c(".fas", ".phy")
                            ),
                    br(),
                    box(title = "SEQUENCES", 
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="overflow-x: scroll;overflow-y: scroll; height: 350px;",
                            tableOutput("contents")
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
                    box(title = "UPGMA VS NJ",
                        solidHeader = T, 
                        width = 12,
                        collapsible = T,
                        collapsed = F,
                        div(style="height = 600px;",
                            plotOutput("tree_comp")
                        )
                    )
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
                        div(style="height = 600px;",
                            tableOutput("model_testing")
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
            )

        )
    )
)
