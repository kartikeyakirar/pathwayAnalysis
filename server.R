shinyServer(function(input, output, session){
    
    source("program/plot_utils.R", local = TRUE)
    source("program/main_func.R", local = TRUE)
    
    # Reactive values
    userInput <- reactiveValues()
    userInput$genesetData <- NULL
    userInput$sGs <- global$genesetList[["TURASHVILI_BREAST_DUCTAL_CARCINOMA_VS_DUCTAL_NORMAL_DN"]] 
    userInput$sigIndex <-  NULL
    
    updateSelectizeInput(session, "geneVec",
                         choices  = global$genes,
                         selected = global$genes[1:15],
                         server   = TRUE)
    
    output$network <-renderCanvasXpress({
        networkChart(genesets = global$genesetList,
                     genes    = input$geneVec,
                     geneDT   = userInput$genesetData,
                     network  = global$networkMatrix, 
                     sGs      = userInput$sGs)
    })
    
    output$bubble <-renderCanvasXpress({
        dat <- bubbleChartData(global$obj, input$r_val, input$q_val, userInput$sigIndex)
        bubbleChart(dat)
    })
    
    observeEvent(c(input$r_val, input$q_val), {
        
        userInput$sigIndex <- sigIdx(global$obj, R = input$r_val, Q = input$q_val)
        userInput$genesetData <- returnGeneSet(global$obj, R = input$r_val, Q = input$q_val, sigIndex = userInput$sigIndex)
        
    })
    
    output$geneListTab <- renderDataTable({
        datatable(data       = userInput$genesetData,
                  rownames   = FALSE,
                  extensions = c("Scroller", "Buttons"),
                  options    = list(pageLength = 5,
                                    scrollX    = TRUE,
                                    scrollX    = TRUE),
                  selection  = "single",
                  escape     = FALSE,
                  width = "80%",
                  caption = htmltools::tags$caption(
                      style = 'font-family: Arial, Helvetica, sans-serif; text-align: left; color: grey',
                      htmltools::em('Select row select geneset')
                  )
        ) %>% formatStyle(columns = colnames(userInput$genesetData), fontSize = '12px')
        
    },server = TRUE)
    
    observeEvent(input$geneListTab_rows_selected, {
        if (!is.null(userInput$genesetData)) {
            userInput$sGs <- global$genesetList[[rownames(userInput$genesetData)[input$geneListTab_rows_selected]]]
        }
    })
})