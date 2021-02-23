returnGeneSet <- function(obj, R, Q, sigIndex) {
        geneDT <- NULL
        if (!is.null(sigIndex)) {
                geneDT <- cbind(names(sigIndex), round(subset(x = obj,
                                                              select = cbind(`netGO+Q`, FisherQ), 
                                                              subset = (`gene-set` %in% names(sigIndex))),
                                                       4))
                geneDT <- data.frame(geneDT, stringsAsFactors = FALSE)
                colnames(geneDT) <- c("Gene-set name", "netGO+<br>q-value", "Fisher<br>q-value")
                
                if (!is.null(obj$netGOQ)) {
                        geneDT <- cbind(names(sigIndex), round(subset(x = obj,
                                                                      select = cbind(`netGO+Q`, `netGOQ`, FisherQ), 
                                                                      subset = (`gene-set` %in% names(sigIndex))),
                                                               4))
                        geneDT <- data.frame(geneDT, stringsAsFactors = FALSE)
                        colnames(geneDT) <- c("Gene-set name", "netGO+<br>q-value", "netGO<br>q-value", "Fisher<br>q-value")
                }
                
                for(i in 2:ncol(geneDT)){
                        geneDT[,i] = as.numeric(geneDT[,i])
                }
                
                rownames(geneDT) <- geneDT[, 1]
                geneDT <- geneDT %>% arrange(`netGO+<br>q-value`)
                
        }
        return(geneDT)
}

#network value
bubbleChartData <- function(obj, R, Q, sigIndex) {
        myData <- NULL
        if (!is.null(sigIndex)) {
                myData <- data.frame(name = names(sigIndex),
                                     overlap = unname(sapply(names(sigIndex), function(i) {
                                             obj$OverlapScore[which(obj$`gene-set` == i)]
                                     })),
                                     network = unname(sapply(names(sigIndex), function(i) {
                                             obj$NetworkScore[which(obj$`gene-set` == i)]
                                     })),
                                     qvalue_log10 = sapply(names(sigIndex), function(i) {
                                             as.numeric(-log10(as.numeric(obj$`netGO+P`[which(obj$`gene-set` == i)])))
                                     }),
                                     significant = buildCol(obj, R = R, Q = Q)
                )
                
                myData <- myData[order(myData[, "significant"], decreasing = TRUE), ]
        }
        return(myData)
}

bubbleChart <- function(myData) {
        cx.data <- subset(myData, select = c(overlap, network))
        var.annot <- subset(myData, select = c(qvalue_log10, significant))
        canvasXpress(
                data = cx.data,
                varAnnot = var.annot,
                graphType = "Scatter2D",
                showTransition = FALSE,
                colorBy = "significant",
                sizeBy = "qvalue_log10"
        )
}

#network
networkChart<- function(genesets, genes, geneDT, network, sGs){
        cxplot <- NULL
        if (!is.null(geneDT) && !is.null(genes)) {
                set1<-setdiff(genes, sGs)
                set2<-intersect(sGs, genes)
                nwSet <- getIntersect(genes,sGs, network)
                edges <- as.data.frame(nwSet$elements,stringsAsFactors = FALSE)
                colnames(edges) <- c("id1","id2")
                
                
                nodes <- data.frame(nodes = unique(c(edges$id1,edges$id2))) %>%
                        mutate(type = rep(NA, length(n())))
                
                nodes$type[nodes$nodes %in% set1] <- "Input genes"
                nodes$type[nodes$nodes %in% set2] <- "Gene-set members"
                nodes$type[nodes$nodes %in% nwSet$nwe] <- "Intersection"
                
                colnames(nodes) <- c("id", "Type")
                colnames(edges) <- c("id1", "id2")
                
                cxplot <- canvasXpress::canvasXpress(data              = list(nodeData = nodes, edgeData = edges),
                                                     graphType         = "Network",
                                                     colorNodeBy       = "Type",
                                                     nodeSize          = 30,
                                                     showAnimation     = TRUE,
                                                     networkLayoutType = "forceDirected",
                                                     showLegendTitle   = FALSE)
        } else {
                cxplot <- canvasXpress(destroy = TRUE)
        }
        return(cxplot)
}