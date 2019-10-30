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

# Reference: AdaptWest Project. 2015. Gridded climatic velocity data for
# North America at 1km resolution. Available at adaptwest.databasin.org.

source ('header.R')
source('01_load.R')

#Reference: AdaptWest Project. 2015. Gridded climatic velocity data for North America at 1km resolution. Available at adaptwest.databasin.org.
#Data Page: https://adaptwest.databasin.org/pages/adaptwest-velocitywna
#Data Description:
#  Forward Velocity: what is the rate at which an organism in the current landscape
#   has to migrate to maintain constant climate conditions?
#  Backward Velocity: given the projected future climate habitat of a grid cell,
#   what is the minimum rate of migration for an organism from equivalent climate conditions
#   to colonize this climate habitat?

#Read set of AdaptWest grids into a stars data structure, where each dimension is a layer
#Forward, backward velocity and disapearing climates
AW_Velocity_Rasters<-c("Original_Rasters/Velocity/Bwd_RCP8.5_2085/bwvel_ensemble_rcp85_2085.tif",
             "Original_Rasters/Velocity/Bwd_RCP8.5_2085/bwdisp_ensemble_rcp85_2085.tif",
             "Original_Rasters/Velocity/Fwd_RCP8.5_2085/fwvel_ensemble_rcp85_2085.tif",
             "Original_Rasters/Velocity/Fwd_RCP8.5_2085/fwdisp_ensemble_rcp85_2085.tif")

#Use stars methods to read AW, transpose and add to list of rasters
Velocity_Rasters <- read_stars(file.path(AdaptWestDir,AW_Velocity_Rasters), quiet = TRUE)
st_crs(Velocity_Rasters)<-AWcrs
#write_stars(Velocity_Rasters[1],dsn=file.path(spatialOutDir,'Velocity_Rasters.tif'))#to check
#crop to buffered provincial boundary's bounding box
Velocity_Rasters_crop<-Velocity_Rasters[Prov_AW]
#Warp to Albers projection and intersect with Province on hectares BC grid base
Velocity_Rasters_BC<-st_warp(Velocity_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
saveRDS(Velocity_Rasters_BC, file = './tmp/Velocity_Rasters_BC')
write_stars(Velocity_Rasters_BC[1],dsn=file.path(spatialOutDir,'Velocity_Rasters_BC.tif'))#to check
#Velocity_Rasters_BC<-readRDS(file='./tmp/ Velocity_Rasters_BC')
