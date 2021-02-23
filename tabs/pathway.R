pathway <- tabPanel(title = "Pathway analysis", 
                    value = "pathway",
                    column(width = 5,
                           box(title = "Significant gene-sets",width = 12,
                               wellPanel(
                                 HTML("This panel contains the list of significant gene-sets as well as their Q-values &#40; or P-values &#41; evaluated from netGO, netGO+ and Fisher&#39;s exact test.")
                               ),
                               dataTableOutput("geneListTab")),
                           box(title = "Bubble chart",width = 12,
                               wellPanel(
                                 HTML("<ul>
  <li>This module plots the bubble chart of significant gene-sets for the netGO+ results.</li>
  <li>The overlap &#40;x-axis&#41; and network &#40;y-axis&#41; scores of the significant gene-sets are represented.</li>
  <li>The size of bubbles represents the significance level of each gene-set in -log10 scale &#40;Qvalue&#41;.</li>
  <li>Hovering/Click on each bubble will show corresponding statistical values.</li>
</ul>")
                               ),
                               canvasXpressOutput("bubble", height = "36vh",width = "100%"))),
                    column(width = 7,
                           box(title = NULL,width = 12,
                               column(width = 2,
                                      numericInput(inputId = "r_val", 
                                                   label = "R value", 
                                                   value = 0.5,min = 0
                                      ),
                                      
                                      numericInput(inputId = "q_val", 
                                                   label = "Q value", 
                                                   value = 0.25,min = 0.05,step = 0.05
                                      )),
                               column(width = 4,
                                      selectizeInput(inputId = "geneVec", 
                                                     label = "Selected Genes",choices = NULL ,
                                                     selected = NULL,multiple = TRUE
                                      )),
                               column(width = 6,
                                      wellPanel(
                                        HTML("<ul>
  <li>The network panel displays the input genes, selected gene-set, and the network connections between the two.
<li> Genes without edges will be not be displayed.</li>
<li> The gene-set can be selected by clicking on row of the gene-set name on right panel.</li>
<li> The user can download the graph by hovering over top-left corner of the graph.</li>
</ul>")
                                      ))
                           ),
                           
                           box(title = "network-integrated pathway enrichment analysis.",width = 12,status = "primary", canvasXpressOutput("network", height = "76vh",width = "100%")))
)