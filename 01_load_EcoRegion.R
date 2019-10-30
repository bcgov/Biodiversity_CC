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

#Reference: Ecoregional projection data as: Stralberg, D. 2018. Climate-projected distributional shifts and refugia for North American ecoregions [Data set]. http://doi.org/10.5281/zenodo.1407176. Available at https://adaptwest.databasin.org.
#           Ecoregional refugia data as: Stralberg, D. 2019. Velocity-based macrorefugia for North American ecoregions [Data set]. Zenodo. http://doi.org/10.5281/zenodo.2579337. Available at https://adaptwest.databasin.org.#Data Description:
#Data Page: https://adaptwest.databasin.org/pages/ecoregion-displacement-and-refugia
#Data Description: To evaluate potential ecosystem changes at a finer scale, the change
# in climate space was projected for level III ecoregions (Commission for
# Environmental Cooperation 1997) as surrogates for multiple associated species and
# ecological communities. Based on a random forest model was developed to predict
# ecoregion class from bioclimatic variables, using 1-km interpolated climate data
# for the 1969-1990 normal period.

#Read set of AdaptWest grids into a stars data structure, where each dimension is a layer
#Forward, backward velocity,
AW_EcoR_Rasters<-c('Original_Rasters/EcoRegions/EcoregionProjections/_pred_rcp85_2080s.tif',
                    'Original_Rasters/EcoRegions/EcoregionProjections/_pred_current.tif')
AWcrs_EcoR<-"+proj=lcc +lat_1=49 +lat_2=77 +lat_0=0 +lon_0=-95 +x_0=0 +y_0=0 +ellps=GRS80 +units=m +no_defs"

Prov_AW_EcoR <- st_transform(Prov, crs=AWcrs_EcoR)

#Use stars methods to read AW, transpose and add to list of rasters
EcoR_Rasters <- read_stars(file.path(AdaptWestDir,AW_EcoR_Rasters), quiet = TRUE)
st_crs(EcoR_Rasters)<-AWcrs_EcoR
write_stars(EcoR_Rasters[1],dsn=file.path(spatialOutDir,'EcoR_Rasters.tif'))#to check
#crop to buffered provincial boundary's bounding box
EcoR_Rasters_crop<-EcoR_Rasters[Prov_AW_EcoR]
#Warp to Albers projection and intersect with Province on hectares BC grid base
EcoR_Rasters_BC<-st_warp(EcoR_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
saveRDS(EcoR_Rasters_BC, file = './tmp/EcoR_Rasters_BC')
write_stars(EcoR_Rasters_BC[1],dsn=file.path(spatialOutDir,'EcoR_Rasters_BC.tif'))#to check
#EcoR_Rasters_BC<-readRDS(file='./tmp/EcoR_Rasters_BC')

