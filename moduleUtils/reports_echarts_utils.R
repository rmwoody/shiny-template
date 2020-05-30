
set.seed(123)
flightsCorrPlot <- function(flights){
flights_sm <- flights %>% 
  filter(complete.cases(.)) %>% 
  sample_n(1000)

flights_sm %>% 
  e_charts(x = dep_delay) %>% 
  e_scatter(arr_delay, name = "Flight") %>% 
  e_lm(arr_delay ~ dep_delay, name = "Linear model") %>% 
  e_axis(x = "Departure delay", y = "Arrival delay") %>%
  e_title(
    text = "Arrival delay vs. departure delay",
    subtext = "The later you start, the later you finish"
  ) %>% 
  e_x_axis(
    nameLocation = "center", 
    splitArea = list(show = FALSE),
    axisLabel = list(margin = 3),
    axisPointer = list(
      show = TRUE, 
      lineStyle = list(
        color = "#999999",
        width = 0.75,
        type = "dotted"
      )
    )
  ) %>% 
  e_y_axis(
    nameLocation = "center", 
    splitArea = list(show = FALSE),
    axisLabel = list(margin = 0),
    axisPointer = list(
      show = TRUE, 
      lineStyle = list(
        color = "#999999",
        width = 0.75,
        type = "dotted"
      )
    )
  )
}

flightsTimePlot <- function(flights){
  flights_ts <- flights %>% 
    transmute(week = as.Date(cut(time_hour, "week")), dep_delay, origin) %>% 
    group_by(origin, week) %>% # works with echarts
    summarise(dep_delay = sum(dep_delay, na.rm = TRUE))
  ts_base <- flights_ts %>% 
    e_charts(x = week) %>% 
    e_datazoom(
      type = "slider", 
      toolbox = FALSE,
      bottom = -5
    ) %>% 
    e_tooltip() %>% 
    e_title("Departure delays by airport") %>% 
    e_x_axis(week, axisPointer = list(show = TRUE))
  
  ts_base %>% e_line(dep_delay)
}
