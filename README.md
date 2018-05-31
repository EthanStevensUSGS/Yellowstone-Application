# Yellowstone-Application

## Table of Contents

1.	**Introduction**
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


### Introduction

Shiny is an R, HTML interface that allows users to easily create web interfaces and applications for R based code. Shiny has built in widgets and page layouts that can all be coded for in R, as well as allowing the user to input HTML code wherever they see fit.  Most all of the code besides some style elements were written in R for this current version of the application. 
