# Yellowstone-Application

## Table of Contents

1.	**[Introduction](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/Updates/README.md#introduction)**
2.	**[Purpose](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/Updates/README.md#2purpose)**
3.	**[Main Software Layout](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/Updates/README.md#3main-softwarelayout)**
     * *ui.R*
     * *server.R*
4.	**Input Files**
   - 4a. Offline Data Files
	    * *SiteOfflineData.csv*
	    * *SiteAverageLoad.csv*
	    * *SiteWaterYears.csv*
   - 4b. 
      * *Miscellaneous Files*
      * *www folder*
      * *rsconnect folder*
5.	**ui.R logic**
   - 5a. Libraries
   - 5b. navbarPage()
      * *Tabs (Plot/Data, Summary)*
   - 5c. sidebarPanel()
      * *Input Widgets*
   - 5d. mainPanel()
   - 5e. fluidPage()
   - 5f. Embedded HTML 

6.	**server.R logic**
   - 6a. Main Function
     * *Input & Output Calls*
   - 6b. observeEvent()
      * *Changing the Dates Available Dialogue*
   - 6c. Correlation Assignments
     * *URL assignments*
     * *Online Data Parsing Assignments*
   - 6d. Function Offline Data Sort
   - 6e. Function Online Data Sort
     * *NWIS/water data*
     * *Padding*
   - 6f. Overlapping Data (Online & Offline)
   - 6g. CFS conversion 
   - 6h. Compatibility Handling
   - 6i. Miscellaneous Data Management 
   - 6j. Load Function
     * *Average Load Function*
     * *Overlay Function*
   - 6k. Discharge vs. Specific Conductance Plot
   - 6L. Summary Tab
     * *Water Years Function*
7.	**Deploying**
8.	**Addition of River Sites**
     * *Making an offline site online*
9. **Addition of Constituents**


### 1.Introduction

Shiny is an R, HTML interface that allows users to easily create web interfaces and applications for R based code. Shiny has built in widgets and page layouts that can all be coded for in R, as well as allowing the user to input HTML code wherever they see fit.  Most all of the code besides some style elements were written in R for this current version of the application. 

### 2.Purpose

The purpose of this program was to organize all the water data from an ongoing research project taking place in the Yellowstone National Park. This data was collected over many years, using several methods, and needed to be compiled into one place, with ease of access in order to maintain efficiency. The program needed to be an online web application so that researchers from several departments could access all the collected data without needing to have the data files on their own computers. Should the user want the data on their own machine, they can easily download the data from the server. Now the data will be consistent across departments, easily visualized, and only a click away.

### 3.Main Software Layout

The basic layout of any Shiny App is a server.R and ui.R file, although they can be combined into the same script with some extra commands. For this application the two files were separated and both need to exist in the same working directory, as well as several other files. The server and ui file work together using inputs and outputs. Note that the file names (server, ui) are incredibly important and cannot be changed.

 **3a. ui.R**
  
UI stands for user interface and this file sets up exactly that. The ui.R file is much smaller than its counterpart as no calculations   are done within this file. Buttons, date inputs, and plot placements are all created and controlled here. The main jobs of the ui are   too set up how the page looks, take in information from the user, and output/visualize the data made by the server.
  
 **3b. server.R**
  
This is a much larger file consisting of the real bulk of the coding. This file controls what happens when those buttons are pushed,    what the program does with date inputs, and also creates the plots and the corresponding data. The main job of the server is too make   sense of user inputs and organize, calculate, and plot data based on those inputs. 
  
  ### 4.Input Files
  
Besides ui.R and server.R there are several other incredibly important files needed for this program. Since the program accesses data   both online and offline, the offline data needs to be pushed online when the program is deployed (see section 7). 

  **4a. Offline Data Files**

  Currently there are nine sites within the application, with three of those being “live” sites with online data on the NWIS site. All     sites have some offline data, as many of the sites were being monitored with Aqua Troll 100s long before real time data was available.   Each of these sites has three files, Offline Data, Average Load Data, and Water Year Data. **These files should exist in the working       directory in a folder labeled “Data”**. Note that column names are not as important, and all that really matters is position and      format.   These columns will be described in detail below. 
	
   **_SiteDataOffline.csv_**
    
   This file holds the bulk of information used for the program and the name of the file should be the site name followed by 	   	    DataOffline, no spaces. If you are in need of adding additional sites no already implemented please see section (4a & 6c). The 	    file should be of .csv format (you should set up in excel then convert), and should consist of three columns.

   Column 1) Date-Time, format= mm-dd-YYYY HH:MM
   Column 2) Discharge, liters per minute (l/m)
   Column 3) Specific Conductance, µS/cm
 
   Important: Column one must be in the specified format via excel, after you change the formatting of the column save as a .csv 	    and exit and then leave the file alone. If the file is appended or edited, the column’s format will no longer be in the 		    specified form and the program will give you the error: “Warning in min(x) : no non-missing arguments to min; returning Inf”. 	    This can be fixed by re-formatting the Date-Time column and saving. 

   Note: Column 2, 3 have intervals of 15 minutes. 
   
**_SiteAverageLoad.csv:_**

This file holds the average load based on the month and day. This data was calculated using the offline & online (if any) data available and calculating an average load for the given day over a number of years. All these calculations were done in excel, and exclude 2/29 due to leap years. The actual files containing the calculations are not included with the online package, but exist with the originators. The file should consist of two columns.

Column 1) Date-Time, format= mm-dd HH:MM
Column 2) Average Load, liters per minute (l/min) 

Note: Column 1 does not include year, as the average data will be matched with the requested data based on month, day, and time alone. 

Note: Column 2 has intervals of 15 minutes. 

**_SiteWaterYears.csv:_**

This file holds the sum total for a given water year, October 1st to September 29th for any full years we have available for a given site. These values were calculated off the data in the Offline Data File, by multiplying by 15 (to get grams from g/min, since the interval of data was 15 minutes), and then summing the data in the water year. The file should consist of two columns.

Column 1) Water Year, format=YYYY
Column 2) Total Load, grams per year (g/yr)

Note: Do not include commas in Column 2 as R will assign the data as a character and not a numeric object. 
	
**4b. Miscellaneous Files**

**_Folder “www”:_**

This folder simply contains the USGS logo which is used by the ui.R to place it at the top   left-hand corner of the interface. The logo is saved as logo.png, and is the only file in the www folder in this version. If a new logo is chosen for the application, use the same name and format (.png), although it will most likely not fit perfectly and some HTML styling will need to be done in the ui.R for a proper fit. 

**_Folder “rsconnect”:_**

This folder simply contains code that allows the program to be published, note this is not made by the user or programmer but the shinyapp.io server. If this folder is not in your directory it is not a problem, as if you are deploying this application yourself it will be created in the process. Please see section 7 for how to deploy the program.

### 5. ui.R Logic**
Since the details on every line of code is already included as comments within the code itself, it will not be covered in this manual. Instead, this section will cover the logic and reasoning behind the events taking place within the ui and how it relates to the program as a whole. 
	
**5a. Libraries**

Libraries call R packages previously downloaded to the users’ desktop. The libraries, if not called,   will not allow certain sections of the code to be run since these packages contain functions used throughout the program. For a full list of packages and citations please see section: Citations. To install these packages, use command, [install.packages(”packagename”)]. 

**5b. navbarPage()**

This is the first line of code after the ui call. navbarPage is a pre-defined layout from Shiny that allows us to have a navigation bar at the top of the page, which in turn also has two tabs (Plot/Data, Summary). These two tabs can be written to by calling, [tabPanel("Plot/Data",….)]. Anything in the parenthesis is going to be included within that tab. This navbarPage is further broken down as explained in the next section (4c.).

**_Tabs ui breakdown:_**
* Plot/Data: Allows user to search for data across all sites, ui described in 5c & 5d.
* Summary: Allows user to see tables of data and water year data, ui described in 5e.
See [?tabPanel()] for arguments 

**5c. sidebarPanel()**

SidebarPanel is a pre-defined module by Shiny, this sets up a side bar on the side of the page which we fill with many input widgets to gain information from the user. When we call this module we automatically set up the interface for the page in two sections, the sidebar, and the main panel (section 4d.). Within our side bar we can start to create widgets.

e.g.

The first thing done was to call the sidebarPanel, and label it along with providing a width. Note that the width should not be changed as there are HTML elements dependent on it. After the panel call we can now start to populate the panel with widgets, our first widget being a date input box. 
		
**_Input Widgets:_**

When we create widgets we are essentially placing an object that allows the user to give us feedback. Whether it be a checkbox, date input, or drop down menu the data is saved in the form [input$____], with the name following the $ being the name of the widget. This name is the first argument after the widget call, inside of the parenthesis. In the example above the name of the widget is “dateStart” and we can access the date input by the user by calling [input$dateStart] within the server.R.
There are many widgets Shiny can use, please refer to the Shiny widgets gallery for more information. https://shiny.rstudio.com/gallery/widget-gallery.html
	
**5d. mainPanel()**

The main panel makes up the rest of the interface within the “Plot/Data” tab. Within this panel we are outputting our graphs created on the server side. We can output these graphs by the code, [plotOutput("veiw",click = "Load_click")]. “View” refers to the plot label that is created on the server side. On the server side all the axes, labels, and formatting for the plot is created, we simply print it out in the main panel ui.  The “click” refers to a function created on the server side that allows the user to hover over the graph and click on points. The points the user clicks on will be displayed in the sidebar using another output, [verbatimTextOutput("click_info")]. Note the text output is under the sidebarPanel(). 

**5e. fluidPage()**

As we move on to the second tab, “Summary”, we change the layout quite a bit. Instead of using a side bar panel and main panel as done on the previous tab we are going to use a more custom layout. Fluid page allows for the user to have more control over the layout by using a grid layout 12 columns wide. We can call [column()] or [fluidrow()] and nest ui elements within them to set up our page. The catch is that the 12 column wide grid is “fluid” meaning that if we decided to put another row within our page nested in the previous row, it must add up to 12, even if the previous row only took up 6. The idea of fluid is that column length is more of a percentage of 12 than a sum to 12. This is very confusing at first and I would advise you to read [?fluidpage()]. Since this is so confusing I have decided to explain this part of the code in detail, as updating it to include more elements may be tricky. 

