### Yellowstone National Park River Load Web Application ####
##                                                         ##
## Ui.R                                                    ##
## Questions? estevens@usgs.gov                            ##
##_________________________________________________________##


#### Main UI/Intro ####

# Simply calling all neccesary packages
library(shiny)
library(zoo)
library(lubridate)
library(xts)
library(RCurl)
library(padr)
library(ggplot2)
library(shinythemes)
library(nnet)
library(shinydashboard)
library(dplyr)
library(data.table)
library(scales)
library(profvis)
library(shinyjs)
library(rvest)
library(XML)
library(shinyalert)


# Defining a list of sites used for this application
sites<-c("Yellowstone", "Gardner", "Madison")


# Call Ui function, this is mainly the layout of the page including the user inputs.
ui <- 
  

# Set up a navBar page, specific to shiny, allows us to have tabs. 
navbarPage(
  

#### HTML Code & Styling ####  
  
  # Sets the upper left image, this image needs to be located in folder named "www", img name needs to match
  title=div(img(src="logo.png"),"Yellowstone National Park River Loads"),
                 
               
                

      
                 # Defines our first tab, named Plot/Data
                 tabPanel("Plot/Data",
                          
                          #Creates GitHub Logo with link to repository
                          #tags$a(href="https://github.com/EthanStevensUSGS/Yellowstone-Application",
                          #       (img(src='GitHubLogo.png', align = "right",width = "40px", height = "40px"))),
                          
                          # tags$head allows us to directly input html code into R, this sections mainly
                          # defines style choices such as color of various sections. This is using a bootstrap
                          # set up. Go to https://pikock.github.io/bootstrap-magic/ for further information. 
                    tags$head(
                            
                        # Styling NavBar ( color ) HTML Code
                          tags$style(type = 'text/css','.navbar {
                                            background-color: #00244a;
                                            color: #00881f;
                                            }',
                                       
                                            '.navbar-dropdown { background-color: #262626;
                                            font-family: Arial;
                                            font-size: 13px;
                                            color: #FF0000; }',
                                       
                                            '.navbar-default .navbar-brand {
                                            color: #ffffff;
                                           }'
                                     
                                       
                )),
                       #Height of nav-bar
                       tags$head(
                         tags$style(type='text/css', 
                           ".container-fluid {min-height: 90px} "
                           
               )),
                   
                      #Navbar tab padding
                      tags$head(
                       tags$style(type='text/css', 
                             ".navbar-nav {padding-left: 25px;
                                           padding-top: 39.5px} "
                             
                      
                        
               )),
               
                    # Coloring Tabs (note HTML not CSS)
                    tags$head(
                      tags$style(HTML(
                            ".navbar-default .navbar-nav > .active > a, .navbar-default .navbar-nav > 
                             .active > a:focus, .navbar-default .navbar-nav > .active > a:hover {
                            background-color: #ffffff;
                            color: #00244a;
                            outline: 4px solid white
                            
                            
                            } "
                            
                            
                            
              ))),
              
      #             # Create Right Side Text
      #              tags$script(HTML("var header = $('.navbar > .container-fluid');
      #               header.append('<div style=\"float:right\"><h3>Follow us on GitHub</h3></div>');
      #                       console.log(header)"
      #       )),
             
                  # Create Right Side GitHub Logo
                    tags$script(HTML("var header = $('.navbar > .container-fluid');
                              header.append('<div style=\"float:right\"><a href=\"https://github.com/EthanStevensUSGS/Yellowstone-Application\"><img src=\"GitHubLogo.png\" alt=\"GitHub\" style=\"float:right; width:30px; height:36px;padding-top:10px;\"> </a></div>');
                              console.log(header)")
              ),
             
                   #Style Right Side Text
                   tags$head(
                      tags$style(type='text/css','.h3, h3 {
                                font-size: 14px;
                                color: #ffffff;
                                padding-left: 8px
                                }'
                                
            )),
            
            
                 # Create Right Side Sciencebase Logo
                  tags$script(HTML("var header = $('.navbar > .container-fluid');
                             header.append('<div style=\"float:right\"><a href=\"https://www.sciencebase.gov/catalog/item/58d3f0bbe4b0d4ac7e32a416\"><img src=\"SBlogo.png\" alt=\"SB\" style=\"float:right; width:44px; height:40px;padding-top:8px;padding-right:10px;\"> </a></div>');
                             console.log(header)")
            ),
          
            
                   # Styling Column 4  
                    tags$head(
                      tags$style(type = 'text/css','.col-sm-4 {
                                           background-color: #ffffff;
                                           color: #ffffff;
                                          }'
          )),
            
            
  
              
                    # Styling Well  
                    tags$head(
                      tags$style(type = 'text/css','.well {
                                         background-color: #00244a;
                                          }'
                )),
              
                    # Styling navbar, (increasing height)
                    tags$head(
                      tags$style(type = 'text/css','.navbar {
                                         min-height: 80px;
                                         font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
                                         font-size: 14px;
                                        }'
                
                )), # HTML CODE CLOSED 
                
#### Sidebar (Tab-1) ####

# Setting up our sidebar, this will take in most of our user's input
sidebarPanel("Please Select Parameters",width = 4,
               
    # This is a temporary feature, names our tab when implemented on the web, favicon not currently avalible 
    # in Shiny's current state and payment plan, should be updated soon.
    HTML('<script> document.title = "USGS, YNP Loads"; </script>'),

    # Our first input via user, we are allowing the user to select a river, and assigning values 1:3 to that selction.
    # Note: the input is saved as "river", if we want to use this value on the server side we call input$river.
    selectInput("river", label = h2("Select River"), 
      choices = list("Madison R. (Live)" = 1, "Yellowstone R. (Live)" = 2, "Firehole R. (Live)" = 3, "Gibbon R."= 4, 
                    "Firehole R. at Old Faithful" = 5,"Snake R."= 6, "Falls R."=7, "Gardner R."= 8, "Tantalus Cr." = 9), 
      selected = 1),
    
      # Debugging
      textOutput("Yo"),
    
    h6(textOutput("ADate")),
   
   # User input, this will be our start date, input$dateStart. #SET TO LAST DAY IN OFFLINE DATA
   dateInput("dateStart", label = h2("Start Date"), format="mm/dd/yyyy",width=300, value=Sys.Date()),
      
      # Debugging
      textOutput("Ye"),
          
   # User input, end date.
   dateInput("dateEnd", label = h2("End Date"), format="mm/dd/yyyy",width=300, value=Sys.Date()),

      textOutput("Ya"),
  
  # User input, drp[down] for load type, defaulted at 1 (chloride)
  selectInput("LoadType", label = h2("Load Type"),
    choices = list("Chloride" = 1, "Arsenic" = 2, "Alkalinity"=3, "Sulfate"=4, "Flouride"=5, 
                   "Calcium"=6, "Silicon Dioxide"=7, "Sodium"=8, "Potassium"=9, "Lithium"=10, "Boron"=11), 
    selected = 1),
  
  # User input, radio buttons for graph type, defaulted at 1 (scatter)
  radioButtons("GraphType", label = h4("Graph Type"),
               choices = list("Scatter" = 1, "Line" = 2), 
               selected = 1),
  # Debugging 
  textOutput("Yu"),
  
  #Average Overlay
  sliderInput("overlay", "Overlay Transparency:",
              min = 0, max = 3,
              value = 0),
  
  # Creates our button at the bottom of the sidebar, we define the function of this button as our observed event
  # on the server side of things. Therefore the program will understand we want whatever is under the observed
  # event to happen whenever the user presses this button, note input$Go. 
  actionButton("Go", "Search"),
  
  # Printed text to page. 
  h6("Please be patient
     as output times may vary based on amount of data requested."),
  
  # Creates the output of the user click tracker, shows what the user clicked on. This input is coming from server.
  verbatimTextOutput("click_info"),
  
  # Another function defined in the server, allows the user to download the data, input$downloadData.
  downloadButton('downloadData', 'Download to computer')
  
  
  
  
),# Closes Side Panel
  
#### Main Panel (Tab-1) ####

# Defining what is in our main panel, mainly just the graphs.
mainPanel(
  
  useShinyalert(),
    
    # Outputs plots that were created on the server side, and implements the click function, deafult to stack 
    # created graphs vertically due to navbar/sidebar page.
  
    plotOutput("veiw",click = "Load_click"),
    plotOutput("Dis_SC", click = "DisSC_click")
    
   
    
)# Closes Main Panel

),# Closes tab 1

#### Summary (Tab-2) ####

tabPanel("Summary",
         
         
         fluidPage(
           
             
             # Outputs the Summary created on the server side. 
           fluidRow(
            column(6,
            plotOutput("year"),
                fluidRow(
                   column(12,
                    dataTableOutput("yeartable")
                    ))),
           
           column(6,offset = 0,
           dataTableOutput("Summary")
           )
)
           
           
             
      
             




#### Finale ####             

)# Closes Second tab
)# Closes navbar page
)# Closes UI
