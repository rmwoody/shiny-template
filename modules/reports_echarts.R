reports_echartsUI <- function(id){
  ns = NS(id)
  tagList(br(),
          div(class ="container-fluid", style = 'padding:35px;',
              column(6,
                     dashboardCard(id = NULL,h6("Bar Chart"),hr(),
                                   echarts4rOutput(ns("chart1")))
              ),
              column(6,dashboardCard(id = NULL,h6("Scatter Chart"),hr(),
                                     echarts4rOutput(ns("chart2"))
              )),
              column(12, dashboardCard(id = NULL,h6("Mixed Chart"),hr(),
                                       echarts4rOutput(ns("chart3")))
              ),
              column(12, dashboardCard(id = NULL,h6("Line Chart"),hr(),
                                       echarts4rOutput(ns("chart4")))
              ),
              column(12, dashboardCard(id = NULL,h6("Heat Map"),hr(),
                                       echarts4rOutput(ns("chart5")))
              ),
              column(12, dashboardCard(id = NULL,h6("Word Cloud"),hr(),
                                       echarts4rOutput(ns("chart6")))
              )
              
          )
  )
  
  
}

reports_echarts <- function(input, output, session){
  ns = session$ns
  source("moduleUtils/reports_echarts_utils.R")
  # Really good example of using modules with shiny and waiter
  # https://waiter.john-coene.com/#/examples
  library(nycflights13)
  #e_common(font_family = "helvetica", theme = "westeros")
  w <- Waiter$new(id = c(ns("chart1"),
                         ns("chart2"),
                         ns("chart3"),
                         ns("chart4"))#,
                  #html = spin_throbber()
  ) # Could lapply here
  flightData <- reactive({
    w$show()
    library(nycflights13)
    return(flights)
    w$hide()
  })
  
  cars <- reactive({
    w$show()
    return(mtcars)
    w$hide()
  })
  
  output$chart1 <- renderEcharts4r({
    cars() %>% mutate(cyl = as.character(cyl))  %>%
      group_by(cyl) %>% 
      summarise(Count = n()) %>% 
      e_charts(cyl) %>%
      e_bar(Count) 
    
  })
  
  output$chart2 <-renderEcharts4r({
    cars() %>% group_by(cyl) %>% 
      e_charts(mpg) %>% 
      e_scatter(hp,wt)
  })
  
  output$chart3 <- renderEcharts4r({
    flightsCorrPlot(flightData())
  })
  
  output$chart4 <-renderEcharts4r({
    flightsTimePlot(flightData())
  })
  
  output$chart5 <-renderEcharts4r({
    dates <- seq.Date(as.Date("2018-01-01"), as.Date("2018-12-31"), by = "day")
    values <- rnorm(length(dates), 20, 6)
    year <- data.frame(date = dates, values = values)
    year %>%
      e_charts(date) %>%
      e_calendar(range = "2018") %>%
      e_heatmap(values, coord_system = "calendar") %>%
      e_visual_map(max = 30)
  })
  
  output$chart6 <- renderEcharts4r({
    tf <- flightData() %>% 
      count(dest, sort = TRUE) %>% 
      head(50)
    tf %>% 
      e_color_range(n, color) %>% 
      e_charts() %>% 
      e_cloud(
        word = dest, 
        freq = n, 
        color = color, 
        shape = "circle",
        rotationRange = c(0, 0),
        sizeRange = c(8, 100)
      ) %>% 
      e_tooltip() %>% 
      e_title("Flight destinations")
  })
  
}