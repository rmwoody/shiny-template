reports_echartsUI <- function(id){
  ns = NS(id)
  tagList(br(),
          div(class ="container-fluid", style = 'padding:25px;',
              
#               e_theme_register('{"color":["#440154FF","481B6DFF" ,"#46337EFF" ,"#3F4889FF",
#                 "#365C8DFF", "#2E6E8EFF", "#277F8EFF","#21908CFF" ,"#1FA187FF", "#2DB27DFF",
#                 "#4AC16DFF", "#71CF57FF", "#9FDA3AFF","#CFE11CFF",
# "#FDE725FF"]}', name = "myTheme"),    
              column(4,dcard0(id = NULL,
                                     h6("Bar Chart"),
                                     hr(),echarts4rOutput(ns("chart1a")))),
              column(4,dcard0(id = NULL,h6("Scatter Chart"),hr(),
                                     echarts4rOutput(ns("chart1b"))
              
              )),
              column(4,dcard0(id = NULL,h6("Scatter Chart"),hr(),
                                     echarts4rOutput(ns("chart1c"))
                                     
              )),
              column(12, dcard0(id = NULL,h6("Mixed Chart"),hr(),
                                       echarts4rOutput(ns("chart2")))
              ),
              column(12, dcard0(id = NULL,h6("Line Chart"),hr(),
                                       echarts4rOutput(ns("chart3")))
              ),
              column(12, dcard0(id = NULL,h6("Heat Map"),hr(),
                                       echarts4rOutput(ns("chart4")))
              ),
              column(12, dcard0(id = NULL,h6("Word Cloud"),hr(),
                                       echarts4rOutput(ns("chart5")))
              ),
              column(4,dcard1(id = NULL,title = "Title",
                              hr(),echarts4rOutput(ns("chart2a")))),
              
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
  w <- Waiter$new(id = c(ns("chart1a"),
                         ns("chart1b"),
                         ns("chart1c"),
                         ns("chart2"),
                         #ns("chart3"),
                         #ns("chart4"),#,
                         ns("chart5")))
                  #html = spin_throbber() # Could lapply here
  flightData <- reactive({
    w$show()
    library(nycflights13)
    return(flights)
  })
  
  cars <- reactive({
    w$show()
    return(mtcars)
  })
  
  output$chart1a <- renderEcharts4r({
    cars() %>% mutate(cyl = as.character(cyl))  %>%
      group_by(cyl) %>% 
      summarise(Count = n()) %>% 
      e_charts(cyl) %>%
      e_bar(Count) %>% 
      e_theme("myTheme")
    
  })
  
  output$chart1b <-renderEcharts4r({
    cars() 
    mtcars %>% group_by(cyl) %>% 
      e_charts(mpg) %>% 
      e_scatter(hp,wt)%>% 
      e_theme("myTheme")
  })
  
  output$chart1c <- renderEcharts4r({
    cars() %>% mutate(cyl = as.character(cyl))  %>%
      group_by(cyl) %>% 
      summarise(Count = n()) %>% 
      e_charts(cyl) %>%
      e_bar(Count) %>% 
      e_theme("myTheme")
    
  })
  
  output$chart2 <- renderEcharts4r({
    flightsCorrPlot(flightData())
  })
  
  output$chart3 <-renderEcharts4r({
    flightsTimePlot(flightData())
  })
  
  output$chart4 <-renderEcharts4r({
    dates <- seq.Date(as.Date("2018-01-01"), as.Date("2018-12-31"), by = "day")
    values <- rnorm(length(dates), 20, 6)
    year <- data.frame(date = dates, values = values)
    year %>%
      e_charts(date) %>%
      e_calendar(range = "2018") %>%
      e_heatmap(values, coord_system = "calendar") %>%
      e_visual_map(max = 30)
  })
  
  output$chart5 <- renderEcharts4r({
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
      e_title("Flight destinations")%>% 
      e_theme("myTheme")
    
    
  })
  
  
  output$chart2a <- renderEcharts4r({
    cars() %>% mutate(cyl = as.character(cyl))  %>%
      group_by(cyl) %>% 
      summarise(Count = n()) %>% 
      e_charts(cyl) %>%
      e_bar(Count)  %>% 
      e_theme("myTheme")
    
  })
  
}