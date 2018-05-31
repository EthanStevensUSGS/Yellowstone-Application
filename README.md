# Yellowstone-Application

## Table of Contents

1.	**[Introduction](https://github.com/EthanStevensUSGS/Yellowstone-Application/blob/Updates/README.md#introduction)**
2.	**Purpose**
3.	**Main Software Layout**
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

 **2a. ui.R**
  
  UI stands for user interface and this file sets up exactly that. The ui.R file is much smaller than its counterpart as no calculations   are done within this file. Buttons, date inputs, and plot placements are all created and controlled here. The main jobs of the ui are   too set up how the page looks, take in information from the user, and output/visualize the data made by the server.
  
 * 2b. server.R
  
  This is a much larger file consisting of the real bulk of the coding. This file controls what happens when those buttons are pushed,     what the program does with date inputs, and also creates the plots and the corresponding data. The main job of the server is too make   sense of user inputs and organize, calculate, and plot data based on those inputs. 
