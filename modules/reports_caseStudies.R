reports_caseStudiesUI <- function(id){
  ns = NS(id)
  tagList(
    div(class ="container-fluid", style = 'padding:25px;max-width:900px;',
        h1("Case Studies"),
        p("This is a collection of case studies that explore a particular topic
            in great detail."),
        hr(),
        br(),
        br(),
        simple_card('article1',"Analytics at Scale","Don't let size slow you down",
                    p("This article summarizes trends in voting over the past 10 years
                        at the county level and identifies what primary indicators can be used
                        to determine a canidate that a precinct elects."),
                    tags$a(class="btn btn-secondary btn-md shiny-bound-input",
                           href="#",
                           role="button",
                           "Read Post")
        ),br(),
        simple_card('article2',"R or Python","Don't let size slow you down",
                    p("This article summarizes trends in voting over the past 10 years
                        at the county level and identifies what primary indicators can be used
                        to determine a canidate that a precinct elects."),
                    tags$a(class="btn btn-secondary btn-md shiny-bound-input",
                           href="#",
                           role="button",
                           "Read Post")
        ),br(),
        simple_card('article3',"Geospatial Spark","Don't let size slow you down",
                    p("This article summarizes trends in voting over the past 10 years
                        at the county level and identifies what primary indicators can be used
                        to determine a canidate that a precinct elects."),
                    tags$a(class="btn btn-secondary btn-md shiny-bound-input",
                           href="#",
                           role="button",
                           "Read Post")
        ),br(),
        simple_card('article4',"Customize Leaflet","Don't let size slow you down",
                    p("This article summarizes trends in voting over the past 10 years
                        at the county level and identifies what primary indicators can be used
                        to determine a canidate that a precinct elects."),
                    tags$a(class="btn btn-secondary btn-md shiny-bound-input",
                           href="#",
                           role="button",
                           "Read Post")
        ),br(),
        simple_card('article5',"Geocomputation","Don't let size slow you down",
                    p("This article summarizes trends in voting over the past 10 years
                        at the county level and identifies what primary indicators can be used
                        to determine a canidate that a precinct elects."),
                    tags$a(class="btn btn-secondary btn-md shiny-bound-input",
                           href="#",
                           role="button",
                           "Read Post")
        )
    )
  )
  
}

reports_caseStudies <- function(input, output, session){
  ns = session$ns
  output$ui1 = renderUI({
    tagList(h1("Hello"),
            h2("More dynamic content"))
  })
  
}