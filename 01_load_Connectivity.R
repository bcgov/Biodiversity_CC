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

#1st set of connectivity metrics - climate corridors - using circuitscape (graph theory)
#Reference:  Littlefield, C. E., McRae, B. H., Michalak, J., Lawler, J. J. and Carroll, C. (2017), Connecting today's climates to future analogs to facilitate species movement under climate change. Conservation Biology, 31: 1397-1408. doi:10.1111/cobi.12938.
#Data Page: https://adaptwest.databasin.org/pages/climate-connectivity-priorities-omniscape
#Data Description:
# Current-flow centrality values representing connectivity between current
#  (1981-2010 period) to future (2071-2100 period) climate analogs under RCP8.5. - currentflow
# Forward shortest-path centrality values representing connectivity between current
#  (1981-2010 period) to future (2071-2100 period) climate analogs under RCP8.5. - fwdshortestpath
# Backward shortest-path centrality values representing connectivity between current
#  (1981-2010 period) to future (2071-2100 period) climate analogs under RCP8.5. - bwdshortestpath

AW_corridor_Rasters<-c('Original_Rasters/centrality/bwdshortestpath.tif',
                         'Original_Rasters/centrality/currentflow.tif',
                         'Original_Rasters/centrality/fwdshortestpath.tif')

AW_corridor_crs<-"+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

#Use stars methods to read AW, transpose and add to list of rasters
corridor_Rasters <- read_stars(file.path(AdaptWestDir,AW_corridor_Rasters), quiet = TRUE)
st_crs(corridor_Rasters)<-AW_corridor_crs
write_stars(corridor_Rasters[1],dsn=file.path(spatialOutDir,'corridor_Rasters.tif'))#to check
#crop to buffered provincial boundary's bounding box
corridor_Rasters_crop<-corridor_Rasters[Prov_AW]
#Warp to Albers projection and intersect with Province on hectares BC grid base
corridor_Rasters_BC<-st_warp(corridor_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
saveRDS(corridor_Rasters_BC, file = './tmp/corridor_Rasters_BC')
write_stars(corridor_Rasters_BC[1],dsn=file.path(spatialOutDir,'corridor_Rasters_BC.tif'))#to check
#corridor_Rasters_BC<-readRDS(file='./tmp/corridor_Rasters_BC')

#2nd set of connectivity metrics - climate connectivity
# Reference: Carroll, C. , Parks, S. A., Dobrowski, S. Z. and Roberts, D. R. (2018), Climatic, topographic, and anthropogenic factors determine connectivity between current and future climate analogs in North America. Global Change Biology. In press Accepted Author Manuscript. doi:10.1111/gcb.14373
#Data Page: https://adaptwest.databasin.org/pages/climate-connectivity-north-america
#Data Description:
# These datasets represent potential movement routes of organisms which will need to
# shift their range in response to climate change. Conserving the areas which hold a
# high number of potential movement routes can help facilitate these range shifts and
# thus reduce loss of biodiversity as climate changes.
#
# 1. potential movement including resistance and climate, values range from 0-1
# (scaled using max raw value of 830,863 amps) - g_clim_res
# 2. potential movement including resistance and NO climate, values range from 0-1
# (scaled using max raw value of 9,457,290 amps) - g_noclim_res
# 3. the connectivity impact of including climate projections (computed by
# subtracting #1 from #2), values range from -0.74-0.57 -g_diff

AW_connectivity_Rasters<-c('Original_Rasters/GFDL_CM3_scaled/g_clim_res.tif',
                         'Original_Rasters/GFDL_CM3_scaled/g_noclim_res.tif',
                         'Original_Rasters/GFDL_CM3_scaled/g_diff.tif')

#Unknown crs????
AW_connectivity_crs<-"+proj=lcc +lat_1=49 +lat_2=77 +lat_0=0 +lon_0=-95 +x_0=0 +y_0=0 +ellps=GRS80 +units=m +no_defs"

#Use stars methods to read AW, transpose and add to list of rasters
connectivity_Rasters <- read_stars(file.path(AdaptWestDir,AW_connectivity_Rasters), quiet = TRUE)
st_crs(connectivity_Rasters)<-AW_connectivity_crs
write_stars(connectivity_Rasters[1],dsn=file.path(spatialOutDir,'connectivity_Rasters.tif'))#to check
#crop to buffered provincial boundary's bounding box
connectivity_Rasters_crop<-connectivity_Rasters[Prov_AW]
#Warp to Albers projection and intersect with Province on hectares BC grid base
connectivity_Rasters_BC<-st_warp(connectivity_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
saveRDS(connectivity_Rasters_BC, file = './tmp/connectivity_Rasters_BC')
write_stars(connectivity_Rasters_BC[1],dsn=file.path(spatialOutDir,'connectivity_Rasters_BC.tif'))#to check
#connectivity_Rasters_BC<-readRDS(file='./tmp/connectivity_Rasters_BC')


