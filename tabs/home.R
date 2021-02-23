home <- tabPanel(title = "Home", 
                 value = "home",
                 column(width = 7,
                        br(), br(), br(), br(),
                        wellPanel(
                            HTML("<h1><b>Network-integrated pathway enrichment analysis</b></h1>")),
                        box(width = 10,
                            HTML("<span><b>The conventional Fisher&#39;s exact test &#40;FET&#41; considers the extent of overlap between target genes and pathway gene-sets,
while recent network-based analysis tools consider only network interactions between the two. This application implements
an intuitive framework to integrate both the overlap and networks into a single score, and adaptively resamples
genes based on network degrees to assess the pathway enrichment. In benchmark tests for gene expression and
genome-wide association study &#40;GWAS&#41; data, app captured the relevant gene-sets better than existing tools, especially
when analyzing a small number of genes. Specifically, provides user-interactive visualization of the
target genes, enriched gene-set and their network interactions and FET results for further analysis.</b></span>")
                        )
                 ),
                 column(width = 5,
                        br(), br(),
                        img(src = "dna.jpg", height = 800, width = 700)
                 )
)