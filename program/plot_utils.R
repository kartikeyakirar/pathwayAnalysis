sigIdx <- function(obj, R, Q) {
    idx <- NULL
    pv  <- obj$`netGO+P`
    pvh <- obj$FisherP
    qv  <- obj$`netGO+Q`
    qvh <- obj$FisherQ
    
    names(pv) <- names(pvh) <- obj$`gene-set`
    names(qv) <- names(qvh) <- obj$`gene-set`
    
    if (!is.null(Q)) {
        idx <- which(qv <= Q | qvh <= Q)
    }
    if (!is.null(R)) {
        idx2 <- which(rank(pv, ties.method = "first") <= R |
                      rank(pvh, ties.method = "first") <= R)
        
        if(!exists('idx')){
            idx <- idx2
        } else {
            idx = union(names(idx),names(idx2))
            idx = sapply(idx, function(i){which(obj$`gene-set`==i)})
        }
    }
    return(idx)
}

buildCol <- function(obj, R, Q) {
    set1 <- set2 <- c()
    if (!is.null(Q)) {
        set1 <- unname(which(obj$`netGO+Q` <= Q))
        set2 <- unname(which(obj$FisherQ <= Q))
    }
    
    if(!is.null(R)){
        if(length(set1)){
            set1 = union(set1, unname(which(rank(obj$`netGO+P`, ties.method = "first") <= R)))
        }
        else{
            set1 = unname(which(rank(obj$`netGO+P`, ties.method = "first") <= R))
        }
        if(length(set2)){
            set2 = union(set2, unname(which(rank(obj$FisherP, ties.method = "first") <= R)))
        }
        else{
            set2 = unname(which(rank(obj$FisherP, ties.method = "first") <= R))
        }
    }
    
    set3 <- intersect(set1, set2)
    res <- rep("NONE", length(obj$`netGO+Q`))
    names(res) = obj$`gene-set`
    if (length(set1)) {
        res[set1] <- "netGO+"
    }
    if (length(set2)) {
        res[set2] <- "Fisher"
    }
    if (length(set3)) {
        res[set3] <- "Both"
    }
    
    res[which(res!='NONE')]
}



getIntersect <- function(gene, geneset, network) {
    elements <- matrix()
    gs <- intersect(geneset, rownames(network))
    g <- intersect(gene, rownames(network))
    
    edges <- matrix(,nrow = 0,ncol = 2)
    nwe <- c()
    
    for (i in 1:length(g)) {
        E <- network[g[i], names(which(network[g[i], gs] > 0))]
        if (length(E) > 0) {
            if (length(E) == 1) {
                
                n <- names(which(network[g[i], gs] > 0))
                edges <- rbind(edges, c(g[i], n))
                    
                nwe <- c(nwe, n)
                next
            }
            for (j in 1:length(E)) {
                edges <- rbind(edges, c(g[i], names(E)[j]))
                nwe <- c(nwe, names(E)[j])
            }
        }
    }
    
    list(elements = edges, nwe = unique(nwe))
}
