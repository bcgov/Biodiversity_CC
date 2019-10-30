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

#Reference: Carroll, C., D. R. Roberts, J. L. Michalak, et al. 2017. Scale-dependent complementarity of climatic velocity and environmental diversity for identifying priority areas for conservation under climate change. (See also associated supplementary information file). Global Change Biology Early View. https://doi.org/10.1111/gcb.13679 #Data Page: https://adaptwest.databasin.org/pages/adaptwest-landfacets
#Data Description:
# Diversity metrics represent different types of environmental diversity metrics
# that can be used to help identify climate change refugia. Some approaches to
# identifying areas that will be refuges for biodiversity under climate change are
# based on predicting future climate. Other approaches use only information on the
# current environment, finding areas where there are steep elevation gradients or other
# factors which might allow species to find climate refuges nearby.

#Read set of AdaptWest grids into a stars data structure, where each dimension is a layer
#Forward, backward velocity,
AW_Diversity_Rasters<-c('Original_Rasters/Diversity/landfacetdiversity.asc',
                      'Original_Rasters/Diversity/hlidiversity.asc',
                    'Original_Rasters/Diversity/elevationaldiversity.asc',
                    'Original_Rasters/Diversity/ecotypicdiversity.asc',
                    'Original_Rasters/Diversity/currentclimatediversity.asc',
                    'Original_Rasters/Diversity/bwvelocityrefugiaindex.asc',
                    'Original_Rasters/Diversity/climatezones.asc')

#Use stars methods to read AW, transpose and add to list of rasters
Diversity_Rasters <- read_stars(file.path(AdaptWestDir,AW_Diversity_Rasters), quiet = TRUE)
st_crs(Diversity_Rasters)<-AWcrs
write_stars(Diversity_Rasters[1],dsn=file.path(spatialOutDir,'Diversity_Rasters.tif'))#to check
#crop to buffered provincial boundary's bounding box
Diversity_Rasters_crop<-Diversity_Rasters[Prov_AW]
#Warp to Albers projection and intersect with Province on hectares BC grid base
Diversity_Rasters_BC<-st_warp(Diversity_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
saveRDS(Diversity_Rasters_BC, file = './tmp/Diversity_Rasters_BC')
write_stars(Diversity_Rasters_BC[1],dsn=file.path(spatialOutDir,'Diversity_Rasters_BC.tif'))#to check
#Diversity_Rasters_BC<-readRDS(file='./tmp/Diversity_Rasters_BC')

