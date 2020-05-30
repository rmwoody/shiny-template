homeUI <- function(id){
  ns = NS(id)
  tagList(
    div(class ="container-fluid",
        style = 'padding:0;',
        div(class = "jumbotron", style = "color:white;width:100%;",
            h1(class = "display-3","Shiny Me Yes"),
            p("This is a simple hero unit, a simple jumbotron-style component"),
            hr(),
            p("It uses utility classes for typography and spacing to make things look cool."),
            a(class="btn btn-primary btn-lg" ,href="#" ,role="button","Learn More")
        )
    ),
    div(class ="container-fluid", style = 
    'padding:75px;width:90%;max-width:1400px;background-color:#fff;',
        htmlOutput(ns("markdownContent"))
        #uiOutput(ns('toRender'))
        # Option for an html file
        # tags$iframe(src = "./markdowns/home.md", # put myMarkdown.html to /www
        #             width = '100%', 
        #             frameborder = 0, scrolling = 'auto'
        # )
        #https://bootstrap.build/app
        #<style type="text/css">
        #@import "https://highlightjs.org/static/demo/styles/tomorrow.css";
    )
  )
}

home <- function(input, output, session){
  ns = session$ns
  # observeEvent(input$color,{
  #   runjs("document.querySelectorAll('pre code').forEach((block) => {
  #   hljs.highlightBlock(block);
  # });")
  # })
  output$markdownContent <- renderUI({
    content = includeMarkdown("./markdowns/home.md")
    tagList(content,
            tags$script("$(document).ready(function() {
       $('pre code').each(function(i, e) {hljs.highlightBlock(e)});
       });" )
    )
  })
}



