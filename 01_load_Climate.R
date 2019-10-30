# Copyright 2019 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

source ('header.R')
source('01_load.R')

#Reference: AdaptWest Project. 2015. Gridded current and projected climate data for North America at 1km resolution, interpolated using the ClimateNA v5.10 software (T. Wang et al., 2015). Available at adaptwest.databasin.org.
#Data Page: https://adaptwest.databasin.org/pages/adaptwest-climatena
#Data Description:
# Monthly_netCDF- 48 monthly temperature and precipitation variables
# Bioclim_netCDF- 27 biologically  variables, including seasonal and annual means,
#  extremes, growing and chilling degree days, snow fall, potential evapotranspiration,
#  and a number of drought indices
#  Full desctiption below
#

#Use the stars package to read in the climate data
Monthly_netCDFdir <- file.path(AdaptWestDir,'Original_Rasters/NA_ENSEMBLE_rcp85_2080s_Monthly_netCDF')
Monthly_netCDF_files <- list.files(Monthly_netCDFdir, pattern = ".nc", full.names = TRUE)
# Cant do all 48 layers at once in a stars object - runs out of memory - can run at command line
#
#Monthly_netCDF_Alb<-c()
for (i in 1:(length(Monthly_netCDF_files))) {
  Monthly_netCDF <- read_stars(Monthly_netCDF_files[i], quiet = TRUE)
  st_crs(Monthly_netCDF)<-AWcrs_Climate
  Monthly_netCDF_BC<-Monthly_netCDF[Prov_AW_Climate]
  Monthly_netCDF_Albin<-st_warp(Monthly_netCDF_BC, ProvRastNoBuf_S, cellsize=100)
  write_stars(Monthly_netCDF_Albin,dsn=paste('./tmp/Monthly_netCDF_Alb_',i,'.tif',sep=''))
  gc()
}
Monthly_netCDF_files_tmp <- list.files('./tmp', pattern = "Monthly_netCDF_Alb", full.names = TRUE)
Monthly_netCDF_BC <- read_stars(Monthly_netCDF_files_tmp, quiet = TRUE)
saveRDS(Monthly_netCDF_BC, file = './tmp/Monthly_netCDF_BC')
#Monthly_netCDF_BC<-readRDS(file='./tmp/Monthly_netCDF_BC')


Bioclim_netCDFdir <- file.path(AdaptWestDir,'Original_Rasters/NA_ENSEMBLE_rcp85_2080s_Bioclim_netCDF')
Bioclim_netCDF_files <- list.files(Bioclim_netCDFdir, pattern = ".nc", full.names = TRUE)
# Cant do all 48 layers at once in a stars object - runs out of memory - can run at command line
#
for (i in 1:(length(Bioclim_netCDF_files))) {
  Bioclim_netCDF <- read_stars(Bioclim_netCDF_files[i], quiet = TRUE)
  st_crs(Bioclim_netCDF)<-AWcrs_Climate
  Bioclim_netCDF_BC<-Bioclim_netCDF[Prov_AW_Climate]
  Bioclim_netCDF_Albin<-st_warp(Bioclim_netCDF_BC, ProvRastNoBuf_S, cellsize=100)
  #Monthly_netCDF_Alb<-c(Monthly_netCDF_Alb,Monthly_netCDF_Albin)
  write_stars(Bioclim_netCDF_Albin,dsn=paste('./tmp/Bioclim_netCDF_Alb_',i,'.tif',sep=''))
  gc()
}
Bioclim_netCDF_files_tmp <- list.files('./tmp', pattern = "Bioclim_netCDF_Alb", full.names = TRUE)
Bioclim_netCDF_BC <- read_stars(Bioclim_netCDF_files_tmp, quiet = TRUE)
saveRDS(Bioclim_netCDF_BC, file = './tmp/Bioclim_netCDF_BC')
#Bioclim_netCDF_BC<-readRDS(file='./tmp/Bioclim_netCDF_BC')

#Variable Decriptions
#Monthly variables:
#Tmin: minimum temperature for a given month (°C)
#Tmax: maximum temperature for a given month (°C)
#Tave: mean temperature for a given month (°C)
#Ppt:  total precipitation for a given month (mm)

#Bioclimatic variables:
#MAT:  mean annual temperature (°C)
#MWMT: mean temperature of the warmest month (°C)
#MCMT: mean temperature of the coldest month (°C)
#TD:   difference between MCMT and MWMT, as a measure of continentality (°C)
#MAP:  mean annual precipitation (mm)
#MSP:  mean summer (May to Sep) precipitation (mm)
#AHM:  annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
#SHM:  summer heat moisture index, calculated as MWMT/(MSP/1000)
#DD_0: degree-days below 0°C (chilling degree days)
#DD5: degree-days above 5°C (growing degree days)
#DD_18: degree-days below 18°C
#DD18: degree-days above 18°C
#NFFD: the number of frost-free days
#bFFP: the julian date on which the frost-free period begins
#eFFP: the julian date on which the frost-free period ends
#FFP: frost-free period
#PAS:  precipitation as snow (mm)
#EMT:  extreme minimum temperature over 30 years
#EXT: extreme maximum temperature over 30 years
#Eref: Hargreave's reference evaporation
#CMD:  Hargreave's climatic moisture index
#MAR: mean annual solar radiation (MJ m-2 d-1) (excludes areas south of US)
#RH: mean annual relative humidity (%)

#Tave_wt: winter (Dec to Feb) mean temperature (°C)
#Tave_sm: summer (Jun to Aug) mean temperature (°C)
#PPT_wt:  winter (Dec to Feb) precipitation (mm)
#PPT_sm:  summer (Jun to Aug) precipitation (mm)
