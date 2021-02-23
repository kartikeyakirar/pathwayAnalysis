shinyUI(
    fluidPage(
        tags$style(type="text/css", ".well {font-size:xx-small}"),
        navbarPage(title = "Pathway Analysis",
                   id = "navbar",
                   selected = "home",
                   fluid = TRUE,
                   home,
                   pathway,
                   about
        )
    )
)