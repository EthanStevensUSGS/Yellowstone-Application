
### Yellowstone National Park River Load Web Application (Hybrid) ####
# Server.R                                                 
# Updated 5/23/2018                                        
# Questions= etst8408@colorado.edu                          
#
# Notes: This is the hybrid version of the YNP app, there
#  is 3 sites with live data associated with this program, rest of data comes 
#  from user created csv files. 
#
# File format= 3 columns, .csv 
#   column 1: datetime "mm-dd-YYYY H:M"
#   column 2: Discharge(l/min)
#   column 3: SC (microSiemens/cm)
#
# File names= "YellowstoneOfflineData", "GardnerOfflineData", "FireholeOfflineData", etc.
#              These can be ammened with more data. 
#
# IMPORTANT: This programs pulls data from active working directory, please put file
#            path to directory (where the files are) in line ____ in setwd() 
#
# V1.0 Padding Fixed
#      Overlapping online/offline data
#      NWIS URL updated for >120 days
#      All Constituents added
#      NA Bug Fixed
#      Average Load (Cl) added to Madison
#     
#      Future fixes: -Addition of Arsenic Correlation for Gardner R.
#                    -Leap year average
#                    -Average Load for rest of sites
#                    -NO DATA for Falls R. or Firehole near Old Faithful
#      
#      Bugs: NA Bugs with subsetting based on date range. (not critical)
# ____________________________________________________________________________________________
# 
# Note :Warning in min(x) : no non-missing arguments to min; returning Inf
#                           Warning in max(x) : no non-missing arguments to max; returning -Inf
#                 
# **THIS MEANS YOU DID NOT CHANGE THE FORMAT OF DATE IN EXCEL TO mm-dd-YYYY HH:MM or the date is out of range
#
# Note: The NWIS site will be reworked in the following months, meaning the way we download data will have to change. 
#       Currently the URL used to download the data is being printed to the console, if ever you get an error regarding
#       "Undefined Columns Selected" it is most likely to do with either the NWIS site being down, or they have updated the site.
#       A quick way to check this is to plug in the printed URL into the browser.
#                 
#_______________________________________________________________________________________#

# This calls the server function, both server.R and ui.R need to be in working directory for program to initiate,
# this will close at end of program.

function(input, output) {
  
########## Available Dates Dialog ##########

observeEvent(input$river,{  

# Madison R. 
if(input$river==1){
output$ADate<-renderText("Dates Available 9/23/2010-Present")

# Yellowstone R.
}else if (input$river==2){
output$ADate=renderText("Dates Available 9/19/2012-Present")

# Firehole R. (WestY)
}else if (input$river==3){
output$ADate=renderText("Dates Available 5/13/2010-9/30/2010, 5/16/2015-Present")  

# Gibbon R.
}else if (input$river==4){
output$ADate=renderText("Dates Available 9/23/2010-9/30/2011 
                        & 5/15/2014-5/6/2018")   

# Firehole (OldF)
}else if (input$river==5){
output$ADate=renderText("Dates Available NONE")     

# Snake River
}else if (input$river==6){
output$ADate=renderText("Dates Available 9/28/2012-9/13/2017")     

# Falls R.
}else if (input$river==7){
output$ADate=renderText("Dates Available 6/29/2016-9/23/2017")     

# Gardner R.
}else if (input$river==8){
output$ADate=renderText("Dates Available 5/24/2012-5/17/2018")    

  # Tantalus Cr.
}else if (input$river==9){
  output$ADate=renderText("Dates Available NONE")    

}
}) # Closes Observe, Showing Dates Available to show

# This function allows us to update the program when the user presses the search button. 

  observeEvent(input$Go, {

# This is simply a function/loop that initiates a dialog (progress bar) to inform user of progress.
# The progress bar is updated at set points in the code called "incProgress"

    withProgress(message = 'Searching data', value = 0, {
  
########## River Input User + Correlations ##########

# If/else loop checking to see which river was selected in dropdown menu, and then assigns correlating values.
# The values assigned are important for the download handler & calculations, if for some reason the url of 
# these sites is changed, this would be a good place to compare.
    
# Madison 
if(input$river==1){
  cb<-"00060"
  no<-"06037500"
  state<-"mt"
  SiteCheck<-"X82346_00060"
  SiteCheck2<-"X82347_00095"
  Acl=0
  Bcl=.13
  Ccl=-2.9
  Aars=0
  Bars=.00056
  Cars=.01
  Aalk=0
  Balk=.13
  Calk=-2.9
  Aso4=-0.000056
  Bso4=0.054
  Cso4=-0.35
  Af=0
  Bf=.02
  Cf=-1.3
  Aca=0
  Bca=.01
  Cca=2.1
  Asio2=0
  Bsio2=.2
  Csio2=4.3
  Ana=0
  Bna=.18
  Cna=.97
  Ak=0
  Bk=.015
  Ck=.98
  Ali=0
  Bli=.0012
  Cli=-.022
  Ab=0
  Bb=.0015
  Cb=.0094
    
# Yellowstone
} else if (input$river==2){
  cb<-"00060" 
  no<-"06191500"
  state<-"mt"
  SiteCheck<-"X82655_00060"
  SiteCheck2<-"X82656_00095"
  Acl=0
  Bcl=.0652400942125718
  Ccl=-3.98853584248785
  Aars=0
  Bars=.000166
  Cars=-.008899
  Aalk=-0.000233
  Balk=0.31906638
  Calk=14.81886906
  Aso4=0.00020404
  Bso4=0.09839272
  Cso4=-4.15840946
  Af=0
  Bf=0.004316
  Cf=-0.185743
  Aca=0
  Bca=0.0600172041011319
  Cca=2.51876415434996
  Asio2=0.00018782
  Bsio2=-0.00635588
  Csio2=15.64593999
  Ana=0
  Bna=0.108352860643617
  Cna=-4.00783947476938
  Ak=0
  Bk=0.0219651148687611
  Ck=-0.642752890887274
  Ali=0
  Bli=0.00063496228630335
  Cli=-0.0410803963883455
  Ab=0
  Bb=0.00271429571124869
  Cb=-0.200117186408371
  
#Firehole (WestY)
} else if (input$river==3){
  cb<-"00060" 
  no<-"06036905"
  state<-"mt"
  SiteCheck<-"X82330_00060"
  SiteCheck2<-"X82335_00095"
  Acl=0
  Bcl=.15
  Ccl=-6.5
  Aars=0
  Bars=.00077
  Cars=.010
  Aalk=0
  Balk=.15
  Calk=-6.5
  Aso4=0
  Bso4=0.023
  Cso4=0.71
  Af=0
  Bf=.018
  Cf=-.11
  Aca=0
  Bca=.0074
  Cca=1.3
  Asio2=0
  Bsio2=.2
  Csio2=2.8
  Ana=0
  Bna=.2
  Cna=-4.4
  Ak=0
  Bk=.013
  Ck=1.3
  Ali=0
  Bli=.0012
  Cli=-.07
  Ab=0
  Bb=.0017
  Cb=-.055
  
  
# Gibbon R.
} else if (input$river==4){
  no="gibbon" #NA
  Acl=0
  Bcl=0.13
  Ccl=-4.1
  Aars=0
  Bars=0.00029
  Cars=0.016
  Aalk=0
  Balk=.13
  Calk=-4.1
  Aso4=0
  Bso4=0.05
  Cso4=4.3
  Af=0
  Bf=.011
  Cf=-.035
  Aca=0
  Bca=.015
  Cca=2
  Asio2=0
  Bsio2=.18
  Csio2=7.3
  Ana=0
  Bna=.17
  Cna=-2.2
  Ak=0
  Bk=.017
  Ck=1.4
  Ali=0
  Bli=.001
  Cli=-.03
  Ab=0
  Bb=.0019
  Cb=-.058
  
# Firehole (OldF)
} else if (input$river==5){
  Acl=0
  Bcl=0.13
  Ccl=-1.7
  Aars=0
  Bars=0.310
  Cars=0.933
  Aalk=0
  Balk=.13
  Calk=-1.7
  Aso4=0
  Bso4=0.49
  Cso4=4.3
  Af=0
  Bf=.028
  Cf=-.26
  Aca=0
  Bca=.031
  Cca=.55
  Asio2=0
  Bsio2=.54
  Csio2=.01
  Ana=0
  Bna=.15
  Cna=-1.1
  Ak=0
  Bk=.025
  Ck=.73
  Ali=0
  Bli=.00073
  Cli=-.014
  Ab=0
  Bb=.0016
  Cb=-.02
  
# Snake River
} else if (input$river==6){
  no="snake"
  Acl=0
  Bcl=0.0739
  Ccl=-5.05
  Aars=0
  Bars=0.000172
  Cars=-0.0107
  Aalk=0
  Balk=.261
  Calk=21.2
  Aso4=0
  Bso4=0.142
  Cso4=-9.08
  Af=0
  Bf=.0077
  Cf=-.324
  Aca=0
  Bca=.0531
  Cca=5.47
  Asio2=-0.00016
  Bsio2=0.161
  Csio2=-1.36
  Ana=0
  Bna=.126
  Cna=-6.13
  Ak=0
  Bk=.016
  Ck=-.43
  Ali=0
  Bli=0.00066
  Cli=-.037
  Ab=0
  Bb=.0012
  Cb=-.079

  
# Falls R.
} else if (input$river==7){
  no<-"falls"
  Acl=0
  Bcl=0.0681
  Ccl=-0.851
  Aars=0
  Bars=0.000172
  Cars=-0.0107
  Aalk=0
  Balk=0.0681
  Calk=-0.8507
  Aso4=0
  Bso4=0.0171
  Cso4=0.0738
  Af=0
  Bf=.0184
  Cf=-.154
  Aca=0
  Bca=.0179
  Cca=2.34
  Asio2=-0.0021
  Bsio2=0.657
  Csio2=-11.8
  Ana=0
  Bna=.1648
  Cna=-1.77
  Ak=0
  Bk=.0153
  Ck=.679
  Ali=0
  Bli=0.000859
  Cli=-0.0287
  Ab=0
  Bb=0.001497
  Cb=-0.0311
  
  # Gardner R.  
} else if (input$river==8){
  no="gardner"
  Acl=0.00002788
  Bcl=0.0397349
  Ccl=-4.346373
  Aars=0 #NA
  Bars=0 #NA
  Cars=0 #NA
  Aalk=-0.00014384
  Balk=0.36483269
  Calk=16.28129138
  Aso4=0.0000700
  Bso4=0.17080057
  Cso4=-18.0
  Af=-0.00000134
  Bf=0.00330168
  Cf=-0.20232825
  Aca=0
  Bca=0.105459642459947
  Cca=2.99291104177561
  Asio2=0
  Bsio2=0.0356021901161892
  Csio2=7.29329999518076
  Ana=0
  Bna=0.0650595637253489
  Cna=-7.73984064543351
  Ak=0
  Bk=0.023213594950243
  Ck=-2.74302083735067
  Ali=0
  Bli=0.00066613931063801
  Cli=-0.0989745798283023
  Ab=0
  Bb=0.00154515
  Cb=-0.2192205

  # Tantalus Cr. 
} else if (input$river==9){
  Acl=0.238478796945126
  Bcl=-52.8498241161165
  Aars=0
  Bars=0.0012921678091717 
  Cars=-1.13203596064488 
  Aalk=0 #NA
  Balk=0 #NA
  Calk=0 #NA
  Aso4=0
  Bso4=0.033620814794738
  Cso4=83.9
  Af=0
  Bf=0.00132875635511097
  Cf=-1.40
  Aca=0
  Bca=0.00142573563647595
  Cca=0.439748329707918
  Asio2=0
  Bsio2=0.222023225045062
  Csio2=-120.446549006979
  Ana=0
  Bna=0.148121205415797
  Cna=-29.7717451778034
  Ak=0
  Bk=0.0353013769989997
  Ck=-17.0508906402397
  Ali=0
  Bli=0.00317920348882773
  Cli=-3.14167693636986
  Ab=0
  Bb=0.00454091889059458
  Cb=-2.65497528900691


} # Closes reading of user river selection & corr. values assignments 

########## Date Input from User ##########
    
  # Assigns dates in the form of strings (text/characters), from our date input in the UI.
  datestring1<-(input$dateStart)
  datestring2<-(input$dateEnd)
  
  # Updating progress bar... (1/5) *note this can be changed to any interval
  incProgress(1/6, detail = paste("Downloading Discharge"))
  
  
########## Set Working Directory ##########
  
  # CHANGE PATH FOR USER
  ##setwd("~/WebDevelopment/OfflineYNPapp")
  

########## User Defined Function ##########

# This is one of R's strengths, we can basically create a function that does whatever we
# want it to do. We simply create it by defining it below. This was not used in the online program, as there 
# were not many sites.

# Defines we want a function named OfflineDataSort, DataFile is our x in f(x), in our case x will
# be the name of the file we want to work with depending on the site. Look at next section for use.
OfflineDataSort<- function(DataFile, envir = .GlobalEnv, encoding = "UTF-8"){

Data <-read.csv(DataFile)
names(Data)<-c("datetime","Discharge","SC")

datestring1<-paste(datestring1,"00:00")
datestring2<-paste(datestring2,"23:45")

datestring1<-as.POSIXct(datestring1, format="%Y-%m-%d %H:%M")
datestring2<-as.POSIXct(datestring2, format="%Y-%m-%d %H:%M")

print(datestring1)
print(datestring2)

Data$datetime<-as.POSIXct(Data$datetime, format="%m-%d-%Y %H:%M")

#BUG: Creating NA values for Yellowstone, Madison & Firehole?
return(Data<-Data[Data$datetime >= datestring1 & Data$datetime <= datestring2,])

  
} #Closes User Defined Function
  
OnlineDataSort<-function(){
  
  ### Download Data ###
  dateCHECK<-as.POSIXct(datestring1, format="%Y-%m-%d")
  
  #Check for data >120 days old, if so uses the NWIS server instead of waterdata server.(The future holds mystery regarding this section,
  # in a couple months the NWIS site will be completly rewoked and in turn this section will need to be completly reworked.)
  if(Sys.Date()-120<=dateCHECK){
  URL='https://waterdata.usgs.gov/'
  } else{
  URL='https://nwis.waterdata.usgs.gov/'  
  }
  State<-state
  URL2='/nwis/uv/?cb_'
  CB<-cb
  URL3='=on&format=rdb&site_no='
  NO<-no
  URL4='&period=&begin_date='
  URL5='&end_date='
  
  #Discharge Download
  urlfetch <- paste(URL, State, URL2, CB , URL3, NO, URL4, datestring1, URL5, datestring2, sep='')
  print(urlfetch)
  urlcontent<- getURL(urlfetch)
  urlcontent <- gsub('<tr />', '', urlcontent)
  dischargeDATA<- read.table(textConnection(urlcontent), header=T, sep = '\t')
  head(dischargeDATA)
  newdata<-subset(dischargeDATA[SiteCheck])
  Discharge<-newdata[-c(1),,drop=F]
  names(Discharge)<-"Discharge"
  
  Discharge<-Discharge[,1]
  
  Discharge<-as.numeric(as.character(Discharge))

  TimeRawDis<-dischargeDATA["datetime"]
  TimeDis<-TimeRawDis[-c(1),,drop=F]
  names(TimeDis)<"Time"
  
  # Convert to (l/min) + put back into POSIXct for padding
  DischargeFin<-(Discharge*60)*28.3169
  DisDf<-data.frame(TimeDis,DischargeFin)
  names(DisDf)<-c("datetime","Discharge")
  
  DisDf$datetime<-as.POSIXct(DisDf$datetime, format="%Y-%m-%d %H:%M")
  
  #Debugging
  ##write.table(DisDf, "Discharge.csv", row.names=F, sep=",",col.names=T)
  
  # Update progress bar......
  incProgress(2/6, detail = paste("Downloading SC"))
  
  #SC Download
  cb="00095"
  urlfetch2 <- paste(URL, State, URL2, cb , URL3, NO, URL4, datestring1, URL5, datestring2, sep='')
  urlcontent2<- getURL(urlfetch2)
  urlcontent2 <- gsub('<tr />', '', urlcontent2)
  SCDATA<- read.table(textConnection(urlcontent2), header=T, sep = '\t')
  head(SCDATA)
  newdata<-subset(SCDATA[SiteCheck2])
  SC<-newdata[-c(1),,drop=F]
  TimeSC<-SCDATA["datetime"]
  TimeSC<-TimeSC[-c(1),,drop=F]
  names(TimeSC)<"datetime"
  SCDf<-data.frame(TimeSC,SC)
  SCDf$datetime<-as.POSIXct(SCDf$datetime, format="%Y-%m-%d %H:%M")
  names(SCDf)<-c("Datetime","SC")
  
  # Add HH:MM for help with strt/end_values for padding
  datestring1<-paste(datestring1,"00:00")
  datestring2<-paste(datestring2,"23:45")
  datestring1<-as.POSIXct(datestring1, format="%Y-%m-%d %H:%M")
  datestring2<-as.POSIXct(datestring2, format="%Y-%m-%d %H:%M")
  
  # Padding
  SCDf<-pad(SCDf, interval='15 min',start_val=datestring1, end_val = datestring2)
  SC<-SCDf["SC"]
  
  # Padding
  DisDf<-pad(DisDf, interval='15 min',start_val=datestring1, end_val = datestring2)
  
  #Debugging
  ##write.table(SCDf, "SC.csv", row.names=F, sep=",",col.names=T)
  
  #Create Fin Data Frame
  Data<-data.frame(DisDf,SC)
  
  #Data$datetime<-as.POSIXct(Data$datetime,format="%m-%d-%Y %H:%M")
  
  return(Data)
  
}
########## Data Orginazation/Assignments based on River ##########

#Farthest our online data goes back for live sites  
MadisonOnlineDate<-as.POSIXct("11-17-2014", format="%m-%d-%Y")

#Note no data before this
YellowstoneOnlineDate<-as.POSIXct("01-15-2018", format="%m-%d-%Y") 

#Note no data before this
FireholeOnlineDate<-as.POSIXct("05-13-2010", format="%m-%d-%Y")

#MADISON R.
if(input$river==1 & datestring1<= MadisonOnlineDate){
Data<-OfflineDataSort("./Data/MadisonDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]

}else if (input$river==1 & datestring1>= MadisonOnlineDate){ 
  Data<-OnlineDataSort()
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]

#YELLOWSTONE R.
}else if(input$river==2 & datestring1<YellowstoneOnlineDate){
  # Currently all data is online back to 3/26/2016, though a file is present if the user wants to append before the given date
  Data <-OfflineDataSort("./Data/YellowstoneDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]

}else if(input$river==2 & datestring1>= YellowstoneOnlineDate){
  Data<-OnlineDataSort()
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]


#FIREHOLE R. (WestY)    
}else if(input$river==3 & datestring1<FireholeOnlineDate){
  #Currently all data is online back to 5-13-2010, though a file is present if the user wants to append before the given date
  Data <-OfflineDataSort("./Data/FireholeDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]
  
}else if(input$river==3 & datestring1>=FireholeOnlineDate){
  Data <-OnlineDataSort()
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]
  
# Gibbon R.     
}else if(input$river==4){
  Data <-OfflineDataSort("./Data/GibbonDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1] 

# Firehole R. (OldF)
}else if(input$river==5){
  Data <-OfflineDataSort("./Data/PLACEHOLDER.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1] 

# Snake R. 
}else if (input$river==6){
  Data <-OfflineDataSort("./Data/SnakeDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]   

# Falls R.
}else if (input$river==7){
  Data <-OfflineDataSort("./Data/FallsDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]   

# Gardner R.  
}else if(input$river==8){
  Data <-OfflineDataSort("./Data/GardnerDataOffline.csv")
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]   
  
} # Closes Orgnaization of Data based on River

##### Overlapping Data (Offline/Online) #####

if(input$river==1 & datestring2>= MadisonOnlineDate & datestring1<= MadisonOnlineDate){
  
  #Adds a day (in seconds since POSIXct works in seconds), adding a day prevents overlap of data
  datestring1<-MadisonOnlineDate+86400
  DataOnlineOverlap<-OnlineDataSort()
  
  
  #Append all data together to get total data frame
  Data <- rbind(Data, DataOnlineOverlap)
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]
  
}else if(input$river==2 & datestring2>= YellowstoneOnlineDate & datestring1<=YellowstoneOnlineDate){
  
  #Adds a day (in seconds since POSIXct works in seconds), adding a day prevents overlap of data
  datestring1<-YellowstoneOnlineDate+86400
  DataOnlineOverlap<-OnlineDataSort()
  
  
  #Append all data together to get total data frame
  Data <- rbind(Data, DataOnlineOverlap)
  Discharge<-Data[,2]
  SC<-Data[,3]
  TimeDis<-Data[,1]
  TimeSC<-Data[,1]
} else{}

# Note if a user appends either the Yellowstone or Firehole before the online data (or another online site is added), 
# and places data in offline file, the program will read in the data but will not be able to overlap online & offline data. 
# In order to do this use the above code with the new sites to allow for overlapping.



########## CFS Discharge Data for DIS/SC graph ##########  
  
  # Creating a duplicate data frame of our discharge data, but not converting this one to CFS from l/min
  DischargeCFS<-(Discharge/60)/28.3169
  
  CFSdf<-data.frame(TimeDis,DischargeCFS)
  
  names(CFSdf)<-c("datetime","CFS")
  
  
  # Reformats the time column attached to a POSIXct object, useful
  # for date-time numbers. 
  CFSdf$datetime<-as.POSIXct(CFSdf$datetime, format="%m-%d-%Y %H:%M")
  
  
########## Compatibility, SC and Dis Handling ######
  
  #__________Unit Conversion (l/min) SUSPENDED, input data is coming in as l/min
  
  # l/min
  DischargeFin<-Discharge
  
  #__________Discharge Data Frame
  
  # Put our new l/min discharge data into a data.frame with our previously saved time data *note data is numerical 
  DisDf<-data.frame(TimeDis,DischargeFin)
  
  # Re-name columns
  names(DisDf)<-c("datetime","Discharge")
  
  # Again, converting our time data to POSIXct object, this time in our l/min discahrge data frame.
  DisDf$datetime<-as.POSIXct(DisDf$datetime, format="%m-%d-%Y %H:%M")
  
  
  # Combine Time and SC data into data frame
  SCDf<-data.frame(TimeSC,SC)
  
  # Re-name columns
  names(SCDf)<-c("datetime","SC")

  # Convert time column into POSIXct **(need this for padding and properly graphing date-time)
  SCDf$datetime<-as.POSIXct(SCDf$datetime, format="%m-%d-%Y %H:%M")
  
  # Re-name
  names(SCDf)<-c("Datetime","SC")
  
########## Miscellanous Data Managment ##########

  # Extracting all neccesary components from data.frames to work with later (SC, Dis, & Time)
  SC<-SCDf["SC"]
  Discharge<-DisDf["Discharge"]
  Time<-DisDf["datetime"]
  
  # May be redundant (for Dis), but changing SC and Discharge to numeric for load calculations
  Discharge<-as.numeric(as.character(DisDf$Discharge))
  SC<-as.numeric(as.character(SCDf$SC))
  
  # Creates a Ymax for Dis/Sc Graph, uses the maximum values + 400 to create a YMAX
  DisYtest<-any(is.na(CFSdf$CFS))
  if(DisYtest==T){
  DisYresult<-na.omit(CFSdf$CFS)  
  } else if (DisYtest==F){
  DisYresult<-CFSdf$CFS  
  }

  DisYMAX<-max(DisYresult)+400
  
  
  SCYtest<-any(is.na(SC))
  if(SCYtest==T){
    SCYresult<-na.omit(SC)  
  } else if (SCYtest==F){
    SCYresult<-SC  
  }
  SCYMAX<-max(SCYresult)+400
  
  # Debugging purposes 
  print(SCYMAX)
  print(DisYMAX)


  
############### Function Loads #################
  
Loadfunction<-function(A,B,C, Name, ConcName,Y_N,envir = .GlobalEnv){
  
  # Concentration Calc. (See values for A and B above...)
  Conc<-(SC^2*A)+(B*SC)+C
 
  # Load Calc 
  Load<-Conc*Discharge/1000
  
  # Puts Cl Load and Time into data frame
  FinDf<-data.frame(Time,Load)
  
  # Saves second copy of Cl Load/Time data frame for summary & click function (Not getting returned!)
  FinDf2<-FinDf
  names(FinDf2)<-c("Date-Time(MDT)",Name)
  
  # Creates data frame which user can download, has all components.
  DownDf<-data.frame(Time,Load,Conc,Discharge,SC)
  names(DownDf)<-c("Date-Time(MDT)",Name,ConcName,
                   "Discharge(l/min)","SC (microSiemens/cm)")
  
## Average plot function (for chloride)
  
  AveragePlot<-function(AverageLoadFile,GraphType, LoadAverageYears){
    
    AverageLoad<-read.csv(AverageLoadFile)
    names(AverageLoad)<-c("datetime","AverageLoad")
    
    AverageLoad$datetime<-as.POSIXct(AverageLoad$datetime, format="%m-%d %H:%M")
    
    AverageLoad$datetime<-format(AverageLoad$datetime, format="%m-%d %H:%M")
    
    #PROBLEM  LIES HERE
    datetimeOG<-FinDf[,1]
    names(datetimeOG)<-("datetime")
    
    FinDf$datetime<-as.POSIXct(FinDf$datetime, format="%m-%d %H:%M")
    
    
    FinDf$datetime<-format(FinDf$datetime, format="%m-%d %H:%M")
    
    
    setDT(FinDf)
    setDT(AverageLoad)
    
    
    FinDf = FinDf[AverageLoad, c("Load", "AverageLoad") := .(Load, AverageLoad), on=("datetime")]
    
    
    
    FinDf$datetime<-datetimeOG
    
    AvgMax<-max(FinDf$AverageLoad,na.rm=T)
    AvgMin<-min(FinDf$AverageLoad,na.rm=T)
    Min<-min(FinDf$Load,na.rm=T)
    Max<-max(FinDf$Load,na.rm=T)
    
    print(AvgMax)
    print(Max)
    
    if(Min>=AvgMin){
    ymin<-AvgMin
    }else{ymin<-Min}
    
    if(Max>=AvgMax){
    ymax<-Max
    }else{ymax<-AvgMax}

    plot(FinDf$datetime,FinDf$Load,xaxt="n",xlab="Date-Time(MDT)",ylab=Name, pch=19, type=GraphType, ylim=c(ymin,ymax))
    
    #allows plot on same plot
    par(new=TRUE)
    
    # Sets up the slider overlay amount + plots the average load
    Overlay<-function(percentOVER){     
      cols=("dodgerblue4")
      
      
      plot(FinDf$datetime, FinDf$AverageLoad, axes = FALSE, bty = "n", xlab = "", ylab = "", col = alpha(cols, percentOVER),
           pch=2, ylim=c(ymin,ymax), type=GraphType)
      
      legend("topleft",legend=c("Load",LoadAverageYears),
             text.col=c("black","black"),pch=c(19,2),col=c("black","dodgerblue4"), xpd=TRUE, inset=c(0,-.2))
      
      axis.POSIXct(1, FinDf$datetime, format="%m-%d-%Y %H:%M", labels = T)
      
      names(FinDf)<-c("Date-Time(MDT)","Chloride Load (g/min)", LoadAverageYears)
    }
    
    #Plots  
    if(input$overlay==3){
      
      
      Overlay(1.0)
      
    
    }else if (input$overlay==2){
      
      Overlay(0.6)
      
    }else if (input$overlay==1){
      
      Overlay(0.2)
      
    }else{
      
      Overlay(0.0)
      
    }
    
    
  } # Closes Average Load Function
  
 
  ########## Function Graph (Load) ##########
  
  # Outputting to our UI labeled veiw, rendering a plot for this main panel
  output$veiw <-renderPlot({
    
    # If/else statement regarding which plot type was selected, then using base plot functions plots,
    # labels axis, and reassigns the x axis to axis.POSIXct axis. Note xaxt deletes default x axis.
  
    # NON-Chloride graphs for all sites, no Average Data
    if(input$GraphType==1 & Y_N==F){plot(FinDf$datetime,FinDf$Load,xaxt="n",xlab="Date-Time(MDT)",ylab=Name)
      axis.POSIXct(1, FinDf$datetime, format="%m/%d/%Y %H:%M", labels = T)
      
     
    }else if(input$GraphType==2 & Y_N==F){plot(FinDf$datetime,FinDf$Load,xaxt="n",xlab="Date-Time(MDT)",ylab=Name,type="l")
      axis.POSIXct(1, FinDf$datetime, format="%m/%d/%Y %H:%M", labels = T)
    
    # Chloride Graphs, average data appened to graph as second series.
    
    # Note: We use the site number defined in the "River Input User+ Correlations" section to differentiate sites, as this
    #       value does not change until the user has again pressed the search button. If we instead used input$river, the
    #       plot would try to show our average for whatever site was selected 2nd versus the original searched data.
     
    #Madison 
    }else if(input$GraphType==1 & Y_N==T & no=="06037500"){
       AveragePlot("./Data/MadisonAverageLoad.csv", "p","Average Load (7yr.)")
    }else if(input$GraphType==2 & Y_N==T & no=="06037500"){
      AveragePlot("./Data/MadisonAverageLoad.csv","l","Average Load (7yr.)")
    
      #Yellowstone
    }else if(input$GraphType==1 & Y_N==T & no=="06191500"){
      AveragePlot("./Data/YellowstoneAverageLoad.csv","p","Average Load (5yr.)")
    }else if(input$GraphType==2 & Y_N==T & no=="06191500"){
      AveragePlot("./Data/YellowstoneAverageLoad.csv","l","Average Load (5yr.)")
    
      #Firehole   
    } else if (input$GraphType==1 & Y_N==T & no=="06036905"){
      AveragePlot("./Data/FireholeAverageLoad.csv", "p","Average Load (3yr.)")
    }else if (input$GraphType==2 & Y_N==T & no=="06036905"){
      AveragePlot("./Data/FireholeAverageLoad.csv", "l","Average Load (3yr.)")
    
      #Gibbon
    }else if (input$GraphType==1 & Y_N==T & no=="gibbon"){
      AveragePlot("./Data/GibbonAverageLoad.csv", "p","Average Load (4yr.)")
    }else if (input$GraphType==2 & Y_N==T & no=="gibbon"){
      AveragePlot("./Data/GibbonAverageLoad.csv", "l","Average Load (4yr.)")
    
      #Snake
    }else if (input$GraphType==1 & Y_N==T & no=="snake"){
      AveragePlot("./Data/SnakeAverageLoad.csv", "p","Average Load (4yr.)")
    }else if (input$GraphType==2 & Y_N==T & no=="snake"){
      AveragePlot("./Data/SnakeAverageLoad.csv", "l","Average Load (4yr.)")
    
      #Gardner
    }else if (input$GraphType==1 & Y_N==T & no=="gardner"){
      AveragePlot("./Data/GardnerAverageLoad.csv", "p","Average Load (5yr.)")
    }else if (input$GraphType==2 & Y_N==T & no=="gardner"){
      AveragePlot("./Data/GardnerAverageLoad.csv", "l","Average Load (5yr.)")
    
      #Firehole (Note this is a workaround to make sure we plot this since we don't have an average load for this site)
    }else if (input$GraphType==1 & Y_N==T & no=="falls"){
      plot(FinDf$datetime,FinDf$Load,xaxt="n",xlab="Date-Time(MDT)",ylab=Name)
      axis.POSIXct(1, FinDf$datetime, format="%m/%d/%Y %H:%M", labels = T)
    }else if (input$GraphType==2 & Y_N==T & no=="falls"){
      plot(FinDf$datetime,FinDf$Load,xaxt="n",xlab="Date-Time(MDT)",ylab=Name,type="l")
      axis.POSIXct(1, FinDf$datetime, format="%m/%d/%Y %H:%M", labels = T)
      
    
    }else{}
    
########## Function Download Data ##########
    #*Still under plot Function since Load Type 1 enviroment needed
    
    # Downloads Data for user, .csv to be opened with excel
    output$downloadData <- downloadHandler(
      
      # Sets filename in form of a function using previously defined date
      filename = function() {
        paste('Loads-', datestring1, " to ",datestring2, '.csv', sep="")
      }, # Closes Filname Function
      
      # Creates download file, contents defined above in DownDf
      content = function(con) {
        write.table(DownDf,row.names = FALSE,col.names=T,sep=",",con)
      },
      contentType="csv"
    )
  
  #If we choose to return the FinDf insdie this function, it will be the merged version  
    
    ########## Function Click Output  ##########
    
    # Click Output, allows user ot click on graph and get points near pointer, uses FinDf replica FinDf2,
    # since the click function relys on the xvar & yvar. 
    
    output$click_info <- renderPrint({
      nearPoints(FinDf2, input$Load_click, xvar = "Date-Time(MDT)", yvar = Name)
    })
    
  }) # Closes Load Plot 
  
  
 
  return(FinDf) #The important One! Not Merged Since it is not being returned from the Load Plot, but instead the overall Load Function,
                #FinDf gets merged during the Average Load Plot function, which is nested whithin the Load Plot (renderPlot) function.
  
}# Closes Load Function
  
  
  



  
  
  
  
  
incProgress(3/6, detail = paste("Calcualtions..."))

########## 1) Calculations Cl Load ##########
  
  if(input$LoadType==1){
  
    
   FinDf<-Loadfunction(Acl,Bcl,Ccl, "Chloride Load (g/min)" , Y_N=T, "Concentration Chloride (g/min)")
   
   

########## 2) Arsenic Load Calculations ##########  
  
    # Reads user input as As, load calculations for As, and replica Df for click function
  }else if(input$LoadType==2){
    
    FinDf<-Loadfunction(Aars,Bars,Cars, "Arsenic Load (g/min)" , Y_N=F, "Concentration Arsenic (g/min)")
    
    
######## 3) Alkalinity Load Calculations #####

  }else if(input$LoadType==3){
      
    FinDf<-Loadfunction(Aalk,Balk,Calk, "Alkalinity Load (g/min)" , Y_N=F,"Concentration Alkalinity (g/min)")
    
####### 4) SO4 Load Calculations ########
  } else if(input$LoadType==4){
    
    FinDf<-Loadfunction(Aso4,Bso4,Cso4, "Sulfate Load (g/min)" ,Y_N=F, "Concentration Sulfate (g/min)")
    
  
###### 5) Flouride Load Calculations ######
  } else if(input$LoadType==5){
      
    FinDf<-Loadfunction(Af,Bf,Cf, "Flouride Load (g/min)" ,Y_N=F, "Concentration Flouride (g/min)")
      
  
###### 6) Calcium Load Calculations ######
  } else if(input$LoadType==6){
      
    FinDf<-Loadfunction(Aca,Bca,Cca, "Calcium Load (g/min)" ,Y_N=F, "Concentration Calcium (g/min)")
      
###### 7) SiO2 Load Calculations ######
  } else if(input$LoadType==7){
      
    FinDf<-Loadfunction(Asio2,Bsio2,Csio2, "SiO2 Load (g/min)" ,Y_N=F, "Concentration SiO2 (g/min)")
      
###### 8) Sodium Load Calculations ######
    } else if(input$LoadType==8){
      
      FinDf<-Loadfunction(Ana,Bna,Cna, "Sodium Load (g/min)" ,Y_N=F, "Concentration Sodium (g/min)")

###### 9) Potassium Load Calculations ######
    } else if(input$LoadType==9){
      
      FinDf<-Loadfunction(Ak,Bk,Ck, "Potassium Load (g/min)" ,Y_N=F, "Concentration Potassium (g/min)")
    
###### 10) Lithium Load Calculations ######
    } else if(input$LoadType==10){
      
      FinDf<-Loadfunction(Ali,Bli,Cli, "Lithium Load (g/min)" ,Y_N=F, "Concentration Lithium (g/min)")
      
###### 11) Boron Load Calculations ######
    } else if(input$LoadType==11){
      
      FinDf<-Loadfunction(Ab,Bb,Cb, "Boron Load (g/min)" ,Y_N=F, "Concentration Boron (g/min)")
      
    }

########## Discharge/SC Plot ##########
  
incProgress(4/6, detail = paste("Plotting..."))

  # Creating our Dis/SC plot for the Loadtype="1" (Cl) function
  output$Dis_SC<-renderPlot({
  
    
    if(input$GraphType==1){
      # Define Sizing of Plot (margins)
      par(mar = c(5, 4, 4, 4) + 0.3)
      
      # Plot using baseplot tools, plotting Discharge vs Datetime, SC added soon... *note y max set to DisYMAX
      plot(CFSdf$datetime,CFSdf$CFS, xaxt="n",xlab = "Date-Time(MDT)",ylab = "Discharge(CFS)",ylim =c(0,DisYMAX))
      
      # This code allows us to add a secondary set of data to the same plot
      par(new=TRUE)
      
      # Plot, leaving axis labels blank to not interfere with orignal plot. * second Y axis max set to SCYMAX
      plot(CFSdf$datetime, SC, axes = FALSE, bty = "n", xlab = "", ylab = "", col="blue",
           pch=6,ylim =c(0,SCYMAX))
      
      # Calls secondary y axis, and changes colors
      axis(side=4,col="blue",col.ticks="blue",col.axis="blue",col.lab="blue")
      
      # Labels X-Axis with POSIXct labels instead of deafault
      axis.POSIXct(1, CFSdf$datetime, format="%m/%d/%Y %H:%M", labels = T)
      
      # Labels secondary Y axis
      mtext("Specific Conductance (microSiemens)", side=4, line=3)
      
      # Adds legend to diffrentiate SC and Dis. **Note "pch" is the icon shape, can be changed 
     legend("topleft",legend=c("Discharge","SC"),
             text.col=c("black","black"),pch=c(1,6),col=c("black","blue"), xpd=TRUE, inset=c(0,-.2))
     
    }else if(input$GraphType==2){
      # Define Sizing of Plot (margins)
      par(mar = c(5, 4, 4, 4) + 0.3)
      
      # Plot using baseplot tools, plotting Discharge vs Datetime, SC added soon... *note y max set to DisYMAX
      plot(CFSdf$datetime,CFSdf$CFS, xaxt="n",xlab = "Date-Time(MDT)",ylab = "Discharge(CFS)",ylim =c(0,DisYMAX), 
           type="l")
      
      # This code allows us to add a secondary set of data to the same plot
      par(new=TRUE)
      
      # Plot, leaving axis labels blank to not interfere with orignal plot. * second Y axis max set to SCYMAX
      plot(CFSdf$datetime, SC, axes = FALSE, bty = "n", xlab = "", ylab = "", col="blue",
           pch=9,ylim =c(0,SCYMAX),type="l")
      
      # Calls secondary y axis, and changes colors
      axis(side=4,col="blue",col.ticks="blue",col.axis="blue",col.lab="blue")
      
      # Labels X-Axis with POSIXct labels instead of deafault
      axis.POSIXct(1, CFSdf$datetime, format="%m/%d/%Y %H:%M", labels = T)
      
      # Labels secondary Y axis
      mtext("Specific Conductance (microSiemens)", side=4, line=3)
      
      # Adds legend to diffrentiate SC and Dis. **Note "pch" is the icon shape, can be changed 
      legend("topleft",legend=c("Discharge","SC"),
             text.col=c("black","blue"),pch=c(1,9),col=c("black","blue"))
    }
    
  }) # Closes Dis/SC Plot
  
  
########## Summary Tab ##########
  incProgress(5/6, detail = paste("Finishing..."))
  
  # This section represents the code going onto our second tab in the UI, simply a summary of the data
  
  # Simple, outputs the data.frame replica, no formatting needed.
  names(FinDf)<-c("Date-Time(MDT)","Load (g/min)")
  output$Summary<-renderDataTable({FinDf
  })
  
####### Water Year ######
  Water_Year<-function(YearFileName,SiteName){
    YearLoad<-read.csv(YearFileName)
    names(YearLoad)<-c("Year","LoadTot")
    YearLoad$LoadTot<-as.numeric(YearLoad$LoadTot)
    yearmax<-max(YearLoad$LoadTot, na.rm = T)
    additionmax<-yearmax/10
    yearmax<-yearmax+additionmax
    
    output$year<-renderPlot({
    plot(YearLoad$Year,YearLoad$LoadTot, xlab = "Water Year",ylab = "Load Total (g/year)",type="o",main=SiteName,
         col=c("dodgerblue4"),pch=16)
    
    YearLoad$LoadTot<-prettyNum(YearLoad$LoadTot,big.mark=",", preserve.width="none")
    names(YearLoad)<-c("Water Year","Load Total (g)")
    output$yeartable<-renderDataTable({YearLoad}) 
    
    
 })#Closes Water Year Plot
}# Closes Water_Year Function
  
if(input$river==1){
Water_Year("./Data/Madison_WaterYears.csv","Madison River Water Years") 

}else if(input$river==2){
  Water_Year("./Data/Yellowstone_WaterYears.csv","Yellowstone River Water Years")

}else if(input$river==3){
Water_Year("./Data/Firehole_WaterYears.csv","Firehole River Water Years") 
  
}else if(input$river==4){
  Water_Year("./Data/Gibbon_WaterYears.csv","Gibbon River Water Years") 

}else if(input$river==6){
  Water_Year("./Data/Snake_WaterYears.csv","Snake River Water Years") 

  #Currently no water years for falls R
# }else if(input$river==7){
#  Water_Year("./Data/Falls_WaterYears.csv","Falls River Water Years") 
  
}else if(input$river==8){
  Water_Year("./Data/Gardner_WaterYears.csv","Gardner River Water Years")
  

}else{}


    
  
  
  
  
  
  
  
  
  
########## Finale ##########
  
  # This section closes any overlying functions we opened, the location of these at the end of the code is crucial
  # since we needed to be working whithin these functions with everything we did.
  
} # Closes Button Observe Function
)} # Closes Progress Bar
) # Closes Button Observe Parent Function
} # Close Function (input,output)


