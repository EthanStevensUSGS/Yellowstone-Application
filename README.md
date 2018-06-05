# Yellowstone-Application

## Table of Contents

1.	**[Introduction](https://github.com/EthanStevensUSGS/Yellowstone-Application#1introduction)**
2.	**[Purpose](https://github.com/EthanStevensUSGS/Yellowstone-Application#2purpose)**
3.	**[Main Software Layout](https://github.com/EthanStevensUSGS/Yellowstone-Application#3main-software-layout)**
     * *ui.R*
     * *server.R*
4.	**[Input Files](https://github.com/EthanStevensUSGS/Yellowstone-Application#4input-files)**
   - 4a. Offline Data Files
	    * *SiteOfflineData.csv*
	    * *SiteAverageLoad.csv*
	    * *SiteWaterYears.csv*
   - 4b. Miscellaneous Files
      * *www folder*
      * *rsconnect folder*
5.	**[ui.R logic](https://github.com/EthanStevensUSGS/Yellowstone-Application#5-uir-logic)**
   - 5a. Libraries
   - 5b. navbarPage()
      * *Tabs (Plot/Data, Summary)*
   - 5c. sidebarPanel()
      * *Input Widgets*
   - 5d. mainPanel()
   - 5e. fluidPage()
   - 5f. Embedded HTML 

6.	**[server.R logic](https://github.com/EthanStevensUSGS/Yellowstone-Application#6serverr-logic)**
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
   - 6k. Discharge vs. Specific Conductance Plo
   - 6L. Summary Tab
     * *Water Years Function*
7.	**[Deploying](https://github.com/EthanStevensUSGS/Yellowstone-Application#7-deploying)**
8.	**[Addition of River Sites](https://github.com/EthanStevensUSGS/Yellowstone-Application#8adding-river-sites)**
     * *Making an offline site online*
9. **[Addition of Constituents](https://github.com/EthanStevensUSGS/Yellowstone-Application#9-coming-soon)**


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

### 5. ui.R Logic
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

![5c](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/5c.png)

The first thing done was to call the sidebarPanel, and label it along with providing a width. Note that the width should not be changed as there are HTML elements dependent on it. After the panel call we can now start to populate the panel with widgets, our first widget being a date input box. 
		
**_Input Widgets:_**

When we create widgets we are essentially placing an object that allows the user to give us feedback. Whether it be a checkbox, date input, or drop down menu the data is saved in the form [input$____], with the name following the $ being the name of the widget. This name is the first argument after the widget call, inside of the parenthesis. In the example above the name of the widget is “dateStart” and we can access the date input by the user by calling [input$dateStart] within the server.R.
There are many widgets Shiny can use, please refer to the Shiny widgets gallery for more information. https://shiny.rstudio.com/gallery/widget-gallery.html
	
**5d. mainPanel()**

The main panel makes up the rest of the interface within the “Plot/Data” tab. Within this panel we are outputting our graphs created on the server side. We can output these graphs by the code, [plotOutput("veiw",click = "Load_click")]. “View” refers to the plot label that is created on the server side. On the server side all the axes, labels, and formatting for the plot is created, we simply print it out in the main panel ui.  The “click” refers to a function created on the server side that allows the user to hover over the graph and click on points. The points the user clicks on will be displayed in the sidebar using another output, [verbatimTextOutput("click_info")]. Note the text output is under the sidebarPanel(). 

**5e. fluidPage()**

As we move on to the second tab, “Summary”, we change the layout quite a bit. Instead of using a side bar panel and main panel as done on the previous tab we are going to use a more custom layout. Fluid page allows for the user to have more control over the layout by using a grid layout 12 columns wide. We can call [column()] or [fluidrow()] and nest ui elements within them to set up our page. The catch is that the 12 column wide grid is “fluid” meaning that if we decided to put another row within our page nested in the previous row, it must add up to 12, even if the previous row only took up 6. The idea of fluid is that column length is more of a percentage of 12 than a sum to 12. This is very confusing at first and I would advise you to read [?fluidpage()]. Since this is so confusing I have decided to explain this part of the code in detail, as updating it to include more elements may be tricky. 

![5e](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/5e.png)

The first call of fluid Row sets up our first row, we also define the column length of 6 (out of the possible 12, since this is the first row and not nested). Once we set up our area we print out a plot too that area, this takes up half the page, and nothing is below it, yet.

Now we nest the second row under the first, notice we call a new fluid row without closing the first column () function. By doing this we nest the second row in the first, now we define our column as 12, which is 100% of the column length of the parent in which it is nested. In this case we have made a second area which takes up half of the page, since its length is 100% (12) of half of the page (6). We print a data table here that composes our water years, and it sits under the above graph. Note we don’t need to define vertical length. 

For our last call we want to put another data table in the first row that takes up half of the page. In order to do this we need to include it in the original fluidRow() call since that defines the first row. So we simple close out everything previous to the first row call and then call the rest of our column, since we have half of the page left over (6). The page knows that we want to take up the remaining six columns automatically so there is no need to offset.

**5f. Embedded HTML**

Since Shiny is a platform for R to be converted to HTML, the user is allowed to directly write HTML code into the R script using [tags$head()]. When this command is called the user can call several other functions that code HTML directly into the script. During the creation of this program it was necessary to use some HTML for stylistic choices and ui element sizing. Colors, well size, navigation bar size, and logo placement were all done within HTML code which is included in the ui. 
Colors used were generated by bootstrap codes. 

### 6.server.R Logic

The server is the workhorse of the program, as it is the one dealing with the data and calculations which makes it much more complicated. The overarching job of the server for this application is to gather the data requested from the user, and export it for them to visualize or download. 
	
**6a. Main Function**

The first thing the server does is define itself with, `server<-function(input$output)`, this allows the server to take in information from the ui inputs, as well as output the data once it is ready. 

**_Input Call:_**

When the server needs access to a variable defined in the ui.R, it is done so by calling, [input$input_name]. The input name is usually the first argument defined.
e.g. `datestring1<-(input$dateStart)` this assigns the start date to datestring1

**_Output call:_**

When the server wants to output data back to the ui.R it needs to output to an existing area defined in the ui.R with `output$ui_element`. This command is usually assigned/followed by a function such as `renderPlot({})`. 

e.g. 

![6a](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/6a.png)

**6b. observeEvent()**

Since the user is allowed to change many things within the ui.R, the server must be able to adapt and change variables as well. This is why we create what is called a reactive environment which can be done with observeEvent(). Just as it sounds, it observes the inputs to the interface and reacts accordingly. In this application this is first called in order to assign variables based on the site.
  	
e.g. `observeEvent(input$river,{……}) `

This checks to see what the user has chosen for the river site, and prints to the interface what dates are available.

**_Changing the Dates Available Dialogue: _**

If you append any of the input files to include more data, or a site becomes available online you will want to change the available dates dialogue you see when you change sites. In order to do this simply find the site within the server under the subsection, “Available Dates Dialogue”, and change the dates. Note if you do not do this nothing detrimental will happen, but it is nice to keep the user informed of what is available. 

The second time we see observeEvent() is when it is used to start a series of events upon the user pressing the search button. The `input$Go` is the input to the search button as defined in the ui.R. Once this button is pressed basically everything in the server under this line is carried out.

**6c. Correlation Assignments**

After the user presses “search” one of the first things executed is the assignment of correlations based on the river. This is fairly straightforward intentionally since these correlations are changing with new data and may need to be updated frequently. In order to update the values simply head to the server, in the subsection, “River Input User + Correlations”. Here you can simply find the river site you are looking for and change the values used in the correlations. 

Note that the system used is (A*SC^2)+(B*SC)+C to find the concentration of the given species. All of the species and sites have an A value even if they do not have a true value, this is due to some of the sites having A values and needing the longer formula and some not. If the site does not have a true A value, the value will be set to 0, in turn making the formula (B*SC)+C. 

##### SC= Specific Conductance (µS/cm)

_For more information regarding how these values are applied, please see section (6j.)_

**_URL Assignments:_**

Three of the sites, Madison R., Firehole R., and the Yellowstone R. are considered to be live, meaning that we can get updated data on them every fifteen minutes from the NWIS website. Since these sites are online a custom URL must be built around the site number, state, data type, and date requested. In order to do this we must assign certain variables that will be used to construct this custom URL.  If you need to change any sites variables (if the URL has changed), this is where you would do it. 

The URL assignments are as follows,
* cb<-"data_type_number" (00060=Dis, 00095=SC)
* no<-"sites_number"
* state<-"mt, wy, etc."

**_Online Data Parsing Assignments:_**

There are also parsing variables (variable used to sift through the data) that are assigned in this section. Their job will be described further in section (6e.) 

The Parsing Assignments are as follows,
* SiteCheck<-"Discharge_Column_Header_#"
* SiteCheck2<-" SC_Column_Header_#"

_Note: URL and Parsing assignments will be the most likely cause of error when there are updates to the NWIS website._

**6d. Function Offline Data Sort**

Function Inputs: DataFile

Once the program takes in the user date inputs (start and end), the program decides how it is going to get the data. For truly offline sites, ones with no online data, this is quite simple and as for the sites a bit more complicated. The first thing the program does is checks to see what site was selected and what dates. If the user selected a river site with only offline data, the program will advance the OfflineDataSort() function. The function input “DataFile” is assigned based on site, and tells the function where to pull the data from. “DataFile” is the name of the SiteOfflineData.csv file, with a “./Data/”  before it due to all the data being in a subdirectory. 

For example if the Firehole River is selected, then the program will assign, "./Data/FireholeDataOffline.csv", to the DataFile function input. 

The function then begins to read the file, and assign names to the columns for easier use. The input dates from the user (datestring1 & datestring2, format (mm/dd/YYYY)) need to have HH:MM times assigned to them so that we can compare them to the data in the file. The dates in the data file are date-times (mm-dd-YYYY HH:MM) and after the datestrings are amended to be similar to these date-times, they data can be sorted. The data is sorted by comparing start and end dates to the whole input file which contains all the data. Data that falls between start and end date is returned to the function call variable. 

**6e. Function Online Data Sort**

Function Inputs: N/A

MadisonOnlineDate, YellowstoneOnlineDate, and FireholdOnlineDate are variables that are assigned outside of the function. Theses variables define when these sites switch from offline to online data. If the user-input start date is greater than the sites assigned OnlineDate, then the OnlineDataSort Function will be implemented. 

**_NWIS and water data:_**

The National Water Information System is the online data base used to download requested discharge and specific conductance data older than 120 days old, “https://nwis.waterdata.usgs.gov/”. If the data is not greater than 120 days, than the program will use https://waterdata.usgs.gov/..... The only difference between these two URLs is simply the prefix of nwis for data older than 120 days. The Madison, Yellowstone, and Firehole are the only three sites currently on this site will both discharge and SC, and thus are the only “live” sites. 

Once the program knows what database to pull the data from it begins creating a custom URL used to fetch the data. Creating this URL involves using variables assigned earlier in the program (see section 6c. URL Assignments). Once the URL is created it is run by a [getURL()] function, and the data is now in the program. Note that the data may take a while to download based on the amount of data that is requested. A day of data should only take several seconds and if the wait is longer the waterdata/NWIS site may be down or there may be a problem with the connection. 

The only difference between the SC and Discharge downloads is the variable “cb”. Discharge is downloaded and then SC. 
Now the program has the data but needs to format it in order to efficiently work with it. The formatting used is below
1. Parse data out by assigned variable, SiteCheck
2. Remove extra row from top, [Discharge<-newdata[-c(1),,drop=F]]
3. Rename either Discharge or SC
4. If discharge, convert to numeric object and convert from CFS to l/min
5. Put data with date time column into a data frame and convert date time to POSIXct for padding (see below). 

**_Padding:_**

Padding is the process of checking to see that all the required data points are present. This is incredibly important for both clarity of the data and compatibility of our specific conductance and discharge data. Later in the program the SC and Discharge will have to be put into one data frame, if they are of different length the program will crash. For our purposes we check to see if the data has a point every 15 minutes, and if not, the date-time is added to the data frame and N/A is assigned as the data. A start padding date and end padding date are used in the pad() argument to make sure that both data frames (SC, Dis) are sure to have the same amount of data points. The padR() package which this function comes from was also recently updated to include daylight savings time.

The final step of this function is to take the now same length discharge and specific conductance data and combine them into a data frame, which uses the discharge’s date-time column. This data frame is then returned to the function call. 

**6f. Overlapping Data (Online & Offline)**

Sometimes the user-input start date is before the data becomes available online, and the user-input end date is after the data is online, this means the program has to include both online and offline data in the final output. 
In a previous section of code the program checked the user-input start date and acted accordingly using either the online or offline data sort. I like to think of this as the programs basic data assignment tool, as it only checks for the start date and how that compares to the OnlineDate, but not if the end date is past the OnlineDate. So if this situation arises the program will have already assigned offline data using the offline data sort function, and we simply need to append it with any data online from the OnlineDate to the user-input end date. 

The program uses an if/else statement to check how the start and end dates compare to the OnlineDate, and if the situation described above is true, the program is allowed to run this section. The program adds a day to the OnlineDate and then assigns it as datestring1. Once assigned, the program runs the online data sort function with the newly assigned start date (datestring1), this avoids overlap. Once the function runs, the newly downloaded only portion of the data is then bound to the previously downloaded offline data and our final data frame is created. The data leading up to the online date is offline and anything after the online date is online. 
Note this is only in use for the Madison and Yellowstone sites, as all the Firehole river site data is online, and the rest of the sites are all offline. 

**6g. CFS conversion**

All the discharge data at this point in the program is in liters/minute (l/min), with the offline data already in that form in the input files, and the offline data being converted from CFS to l/min in the online data sort function. This was done so all the discharge data in the program would be in l/min once it reached this point. For the Discharge & SC graph plotted later in the program we need CFS data, and so we copy the discharge data as a new variable and convert it to CFS. The new CFS data is put in a new data frame with copied date-time column (converted to POSIXct), and saved for later use. 

**6h. Compatibility Handling**

Since the rest of the program is the same for both online, offline, and overlapping data it is important to make sure everything going through will be of the same format. This section while redundant in some ways makes sure names and column formatting is set so no matter what comes through it all looks the same to the program. 

**6i. Miscellaneous Data Management**

This section places the data in a numerical form in order to proceed with load calculations in the next section, the more important job is to assign maximum values for the discharge vs. SC plot. By looking at the maximum of both the SC and Discharge data we can assign values to be later used as the maximum for the Y-axes on the Discharge vs. SC plot.

**6j. Load Function**

Logical Trigger: Always runs upon user requesting data

Function Inputs: A, B, C, Name, ConcName, Y_N
* A - from correlation
* B - from correlation
* C - from correlation
* Name – Character string, used on graphs and outputs, format= “Constituent Load (g/min)”
* ConcName - Character string, used on graphs and outputs, format= "Concentration Constituent (g/min)"
* Y_N – A true or false telling program if Chloride Load is requested, used to run another part of program that assigns average loads. 

This is by far the most complex part of the entire program as it has four nested functions and many more arguments passed. The overall idea of this function and the nested functions is to calculate the loads based on input data, plot those loads, make the plot interactive, and create a way for the user to download the data.
	
**_Load Calculations:_**

The first thing that is done by the program is to calculate the concentration, this is done with the assigned variables, 
Concentration (mg/min) = (A*SC^2) + (B*SC) + C 

Note A may be zero for many sites/constituents. Once the concentration is calculated the program then calculates load, 
Load (g/min) =Concentration (mg/l)*Discharge (l/min)/1000. 

The function then proceeds with some basic data handling, creates the “final” data frame with date-time and load, creates the file to be downloaded, and saves a version of the final data frame for the click function.
	
**_Average Plot Function:_**

Logical Trigger: Y_N=T

Function Inputs: AverageLoadFile, GraphType, LoadAverageYears
* AverageLoadFile = Character file path leading to average load input file for the given site.
* GraphType = Character, e.g “l”, “p”, denotes graph type.
* LoadAverageYears = Character, number of years that went into calculations of average load.

This is our first nested function inside the Load Function.

For many of the sites in this program we have an average load that we can compare them too. In order to do this we must match the two data sets based on date and then plot them to the same graph on the interface. 
The average load data is read in from an offline data file and then the date-time column is formatted to be a POSIXct object with format, mm-dd HH:MM. After this a copy of the load data date-time column is made to be saved for later. Using the “final” data frame, FinDf, the date-time column of this data frame is also converted to POSIXct, and formatted mm-dd HH:MM. Note that we have gotten rid of the year, as we want the average data to have the same format as the FinDf data.

Now both of these data frames are made data tables for easier merging. Once done, they are merged based on date-times, and saved as FinDf. FinDf’s date-time column is then replaced with the saved copy from the original FinDf data frame to restore the year to the date. 
After this is done we now have a data frame with date-time, load, and average load. From this we extract the max and min from the load and average load. We compare these max and mins to see what is the lowest and highest value and these are then set as the Y-axis. It was important to have only one Y-Axis on the graph since these sets of data are to be directly compared.

Once the Y-Axis min and max are set the load data is plotted against the date-time. In order to plot the average load data, we will invoke another function to control how visible the average data is since they are both graphed on the same plot.
Overlay Function:
Logical Trigger: Always runs when Average Load Function Runs
Function Inputs: percentOVER
percentOVER= Numerical, out of 1.0 how much overlay. 
This function is nested inside of the Average Load Function, which in turn is nested inside the Load Function. The purpose of this function is to change the transparency of the average load data plotted on the graph. 
Within the function itself, all the plotting of the average load data is happening, a legend is created, as well as coloring. 
Outside the function (now back in the average plot function), there is an if/else statement reading in the input of the slider in the ui and applying an overlay based on the input.

_Load Function cont._

If Y_N=F, the constituent selected is not chloride, than a basic approach is taken that plots the data as it would any data. 

**_Download Data Function:_**

Logical Trigger: Download button is pressed

Function Input: N/A

This nested function allows us to download the data, DownDf, which was created in the first part of the Load Function. The function allows us to create a filename based on several of the inputs to the Load Function, and then export the data as a .csv file.

**_Click Output:_**

This section allows us to click on point plotted on the load graph and a value is spit out back to the interface. Using a nearpoints() argument the program prints based off of the x and y variables that are existent in both the graph and the data frame. Since there needs to be consistency in naming on the graph labels AND the data frame it was necessary to use a copied version of FinDf so I would be able to label the graph however I please without messing up calculations. For this reason, FinDf2 is used in the click functionality. 

_This is the end of the Load Function, as we return FinDf back to the main program and continue on._

**6k. Discharge vs. Specific Conductance Plot**

This section plots the discharge versus specific conductance. The plot can either be a line or scatter plot which is determined with an if/else statement reading in input variables from the interface. 
First the discharge data vs. date-time is plotted, using a y max that was previously made and then a [par(new=TRUE)] is called in order to allow us to plot a second series on the same graph. The SC data is then plotted using the same X-Axis and the axes from the second series are suppressed. A second Y-axis is called and colored blue as well as set to the previously determined max (see section 6i). Text is overlaid on the right side of the graph to provide a label for the secondary (SC) Y-axis, and finally a legend is created. 
Note: The values for pch determine the shape of the points, google pch. 

**6L. Summary Tab**

The right side of the interface of the summary tab is simply an output of the data frame that is FinDf in a data table. The left side is made up of water year data which comes in from input files. This is described below.
	
**Water Year Function:**

Logical Trigger: Always run on user requesting data

Function Inputs: YearFileName, SiteName
* YearFileName= Character, file path to SiteWaterYears.csv
* SiteName= Character, creates title, format = “Site Water Years” 
	
This function reads in a SiteWaterYear.csv file based on the site selected. Then a second function, Water Year Constituent Calculations and Reading function completes its work before the function continues (see next section). After the second function is completed this function bar graphs the data and prints a table of the data below.
 		
**Water Year Constituent Calculations and Reading:**

Logical Trigger: Run within water year function

Function Inputs: A, B, C, and GraphTitle
* A: A from correlations section
* B: B from correlations section
* C: C from correlations section
* GraphTitle: Character, Main title for graph
	
This function loops through the Water Year data loaded into the program by the water year function. The function loops through the data collecting years, and the discharge & SC. Once these values are saved, concentrations then loads are calculated, and multiplied by 15 to get grams. Once done, the year loads are summed, and assigned to their respective year. The function then returns a data frame with Year, and Load in a data frame, YearLoad. 


### 7. Deploying

**_Offline:_**

Before deploying the application please make sure all input files are in the correct folders and that they are formatted correctly. When ready to deploy please pull up the ui.R and server.R within RStudio. Once both scripts are present, press Run App.

**_Online:_**

Follow the same steps as described above, and the press “publish” in the upper right hand corner. From here you will need to make and then link a ShinyApps.io account at
https://www.shinyapps.io/admin/#/login?redirect=%2Fdashboard 

Once an account has been made, a special code will be created that will allow the user to link their program with their account. After the program has been linked to the account publishing is as simple as pressing the publishing button, selecting files to publish, and then go. 

An important note is to make sure you select the correct files and folders you want to publish.  Make sure all the input files are being published otherwise the program will not be able to access the data.


### 8.Adding River Sites

**_For example purposes our site is FooRiver_**

Step 1) In the ui.R add the river site to the choices within the selectInput() function. Assign the next consecutive number. 

![8.1](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/8.1.png)

•	Everything else will be in the server.R code

Step 2) Addition of new site in available date dialogue section, input dates available inside an else if() statement for the new site. 
e.g.
 
![8.2](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/8.2.png)

Step 3) Addition of new site in River Input + Correlations section, assign variables for correlations. Make sure to add a “no” variable even to the offline sites, since this will be used later. If an offline site assign “no” as the site name (character). 
Once done, if data is offline proceed to step 4, if online see below. 

If an online site assign cb, no, state, SiteCheck, SiteCheck2. 
* cb = either 00095 (SC), or 00060 (Discharge)
* no = site number assigned by NWIS/water data
* state = two letter code assigned by NWIS/water data (e.g. “mt”, “wy”)
* SiteCheck = custom column name for discharge data assigned by NWIS/water data, check tab separated value table on site. (do not forget   the x, “X####_#####”)
* SiteCheck2 = custom column name for SC data assigned by NWIS/water data, check tab separated value table on site. (e.g.     “X82346_00060”)

_Tip: Go to the NWIS site for the particular river and look at the URL, and headers when requesting tab separated data. You are trying to recreate the URL, so make sure you have the correct variables. Also note that R may read in headers differently than they appear on the NWIS site, check for the header names with [print<-names(data)] once the data is loaded into R._


Step 4) Make sure input files follow naming format described in section 4a. as well as making sure the files are in the correct folder.

Step 5) Addition of site in Data Organization/Assignments based on River section, if offline we only need to add one else if() line defining the input$river, if online see below.

![8.5](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/8.5.png)
 
If data is online as well, an OnlineDate must be assigned (the date the data switched from online to offline).  Once the online date is assigned, we will then create two else if() lines of code. The else if()’s should define the input$river and how the start date (datestring1) compares to the online date. We need arguments for both start dates before (offline data, invoke offlinedatasort()) and after (online data, invoke onlinedatasort()) the online date. See the code for the Madison in this section for an example.

Step 6) If data is both online and offline please see below, otherwise go to step 7.
If data is overlapping online and offline we need to add our site to this section, use the Madison in this section as a guide, and see section 6f. for logic. 
 
![8.6](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/8.6.png)

Step 7) The next section we need to add this new site too is the Function Load, graph section. We need to add two else if() lines here telling the program to plot either a line or scatter plot. Use the “no” assigned in the correlations section, Y_N=T, and input$Graphtype=1 or 2. The first two lines of the if/else statement handling plotting for all sites when chloride is not the constituent, when chloride is the constituent we need to separately call since the average load data needs to be plotted as well.  Use any of the sites as a guide. Make sure to change the file path to the site specific average load file. 

![8.7](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/8.7.png)
 

Step 8) Our last step is to add the site to the water year section on the summary tab, this is simply adding the site to the if/else argument with input$river, and then defining the file path to get the water year data. See the other sites as guides.

![8.8](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/master/GitHub%20Pics/8.8.png)
 
_Note: If the site being added does not have all three input files, only the SiteOfflineData is cruicial to the program, though the available dates dialogue can be set to “none”, and the user will know not to request data from the site as there is none._

**_If site becomes available online:_**
If a once offline site becomes online, we need to make that available. If this is a completely new site not already implemented in the program please see all of section 8. 

To make a site “live” please see steps 3, 5, 6, and 7 in the main section of 8. And do the online subsection. 


### 9. Coming soon..
