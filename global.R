##-- Pacotes ----
library(dplyr)
library(shiny)
library(shinydashboard)
library(canvasXpress)
library(DT)

suppressMessages(load("program/data/brca.RData"))
suppressMessages(load("program/data/brcaresult.RData"))
suppressMessages(load("program/data/c2gs.RData"))
suppressMessages(load("program/data/genesetVString1.RData"))
suppressMessages(load("program/data/genesetVString2.RData"))
suppressMessages(load("program/data/networkString.RData"))

tab_files <- list.files(path = "tabs", full.names = T, recursive = T)
suppressMessages(lapply(tab_files, source))

global <- list(obj = obj,networkMatrix = network,genesetVString = rbind(genesetV1, genesetV2), genesetList = genesets, genes = brca)
rm(list = c("obj","network", "genesetV1", "genesetV2", "genesets",  "brca"))