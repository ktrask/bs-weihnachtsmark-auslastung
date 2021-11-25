#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            #sliderInput("bins",
            #            "Number of bins:",
            #            min = 1,
            #            max = 50,
            #            value = 30),
            dateRangeInput("daterange3", "Date range:",
                           start  = "2021-11-24",
                           end    = Sys.Date(),
                           min    = "2021-11-24",
                           max    = "2021-12-28",
                           format = "dd.mm.yyyy",
                           separator = " - "),
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        #input$bins
        print(input$daterange3)
        library(ggplot2)
        library(anytime)
        library(ggthemes)
        csv <- read.csv("~/progs/weihnachtsmark2021/auslastung.csv")
        
        auslastung <- data.frame(
            Zeit = anytime(c(
                csv$burgplatz_time,
                csv$ruh_time,
                csv$domplatz_time,
                csv$rathaus_time
            )),
            Auslastung = c(
                csv$bugplatz_auslastung,
                csv$ruh_austlastung,
                csv$domplatz_auslastung,
                csv$rathaus_auslastung
            ),
            Ort = c(
                rep.int("Burgplatz", nrow(csv)),
                rep.int("Ruhfäutchenplatz", nrow(csv)),
                rep.int("Domplatz", nrow(csv)),
                rep.int("Platz der deutschen\nEinheit", nrow(csv))
            )
        )
        auslastung
        anytime(auslastung$Zeit)
        g <- ggplot(
            subset(auslastung,
                   Zeit > anytime(input$daterange3[1]) &
                   Zeit < (anytime(input$daterange3[2])+60*60*24))
        ) + 
            geom_line(
                aes(Zeit,Auslastung,group=Ort,colour=Ort)
            ) +
            scale_colour_colorblind() + 
            theme(
                legend.position = c(0.2, 0.85),
                legend.background = element_rect(colour = "transparent", fill = "#ffffff88")
            )
        print(g)
        return(g)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
