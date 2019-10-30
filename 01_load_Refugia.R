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

#1st set of refugia metrics - species refugia
#Reference: Stralberg, D, Carroll, C., Wilsey, C., Pedlar, J., McKenney, D. & Nielsen, S. 2018. "Macrorefugia for North American trees and songbirds: climatic limiting factors and multi-scale topographic influences. Global Ecology and Biogeography. https://doi.org/10.1111/geb.12731
#Data Page: https://adaptwest.databasin.org/pages/climatic-macrorefugia-for-trees-and-songbirds
#Data Description: distribution of potential climatic refugia given projected
# end-of-century climate conditions. Refugia indices are based on calculations of
# individual species’ niche-based velocity (biotic velocity), which are derived
# from species distribution model projections for 324 tree species
# (McKenney et al. 2011b) and 268 songbird species (Distler et al. 2015).

#Read set of AdaptWest grids into a stars data structure, where each dimension is a layer
#Combo refugia,
AW_Refugia_Rasters<-c('Original_Rasters/Refugia/RCP85_Combined/NA_combo_refugia_sum85.tif',
                      'Original_Rasters/Refugia/RCP85_Combined/NA_combo_refugia_rankdiff85.tif',
                      'Original_Rasters/Refugia/RCP85_Songbirds/NA_songbird_refugia_combo85.tif')
AW_Refugia_RastersTrees<-c('Original_Rasters/Refugia/RCP85_Trees/NAtreerefugia_combo85.tif')
#Use stars methods to read AW, transpose and add to list of rasters
#ref1<-raster(file.path(AdaptWestDir,AW_Refugia_Rasters[4]))
Refugia_RastersOther <- read_stars(file.path(AdaptWestDir,AW_Refugia_Rasters), quiet = TRUE)
Refugia_RastersTrees <- read_stars(file.path(AdaptWestDir,AW_Refugia_RastersTrees), quiet = TRUE)
st_crs(Refugia_RastersOther)<-AWcrs
st_crs(Refugia_RastersTrees)<-AWcrs
#crop to buffered Province bounding box
Refugia_RastersOther_crop<-Refugia_RastersOther[Prov_AW]
Refugia_RastersTrees_crop<-Refugia_RastersTrees[Prov_AW]
Refugia_RastersOther_BC<-st_warp(Refugia_RastersOther_crop,ProvRastNoBuf_S,cellsize=100)
Refugia_RastersTrees_BC<-st_warp(Refugia_RastersTrees_crop,ProvRastNoBuf_S,cellsize=100)
Refugia_Rasters_BC<-c(Refugia_RastersOther_BC,Refugia_RastersTrees_BC)
write_stars(Refugia_Rasters_BC[1],dsn=file.path(spatialOutDir,'Refugia_Rasters_BC.tif'))
#Write a stars blob
saveRDS(Refugia_Rasters_BC, file = './tmp/Refugia_Rasters_BC')
#Refugia_Rasters_BC<-readRDS(file='./tmp/Refugia_Rasters_BC')

#clip to provincial boundary without buffer - not working
#Refugia_Rasters_Alb_BC<-st_intersects(Refugia_Rasters_Alb,ProvNoBuff, as_points=TRUE)


#2nd set of refugia metrics - climate refugia
#Reference: Michalak, J. L., Lawler, J. J., Roberts, D. R. and Carroll, C. (2018), Distribution and protection of climatic refugia in North America. Conservation Biology. doi: 10.1111/cobi.13130
#Data Page: https://adaptwest.databasin.org/pages/distribution-and-protection-climatic-refugia
#Data Description: These data represent the distribution of potential climatic
# refugia and locations with potentially disappearing regional climates given
# projected mid- and end-of-century climate conditions. Refugia are defined as
# locations with increasingly rare climatic conditions.

#Read set of AdaptWest grids into a stars data structure, where each dimension is a layer
AW_CRefugia_Rasters<-c('Original_Rasters/Michalaketal2018/Refugia/AllSpCombined/2080s/Refugia_RCP85_2080s_GFDLCM3_allsptypes.tif',
                       'Original_Rasters/Michalaketal2018/Disappearing/AllSpCombined/2080s/Disappear_RCP85_2080s_GFDLCM3_allsptypes.tif')

#Use stars methods to read AW, transpose and add to list of rasters
CRefugia_Rasters <- read_stars(file.path(AdaptWestDir,AW_CRefugia_Rasters), quiet = TRUE)
st_crs(CRefugia_Rasters)<-AWcrs
#crop to buffered Province bounding box
CRefugia_Rasters_crop<-CRefugia_Rasters[Prov_AW]
CRefugia_Rasters_BC<-st_warp(CRefugia_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
write_stars(CRefugia_Rasters_BC[1],dsn=file.path(spatialOutDir,'CRefugia_Rasters_BC.tif'))
#Write a stars blob
saveRDS(CRefugia_Rasters_BC, file = './tmp/CRefugia_Rasters_BC')
#CRefugia_Rasters_BC<-readRDS(file='./tmp/CRefugia_Rasters_BC')



