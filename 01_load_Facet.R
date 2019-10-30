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

#Reference: Michalak, Julia L., Carroll, Carlos, Nielsen, Scott E., & Lawler, Joshua J. (2018). Land facet data for North America at 100m resolution. [Data set]. Zenodo. http://doi.org/10.5281/zenodo.1344637
#Data Page: https://adaptwest.databasin.org/pages/adaptwest-landfacets
#Facet Rationale: https://conbio.onlinelibrary.wiley.com/doi/full/10.1111/cobi.12511
#Data Description:
# Land facets incorporating latitude-adjusted elevation
# Land facets incorporating non-adjusted elevation
# Topofacets incorporating latitude-adjusted elevation
# Topofacets incorporating non-adjusted elevation
# Latitude-adjusted elevation categorized into 10 classes
# Non-adjusted elevation categorized into 5 classes
# Landforms categorized into 9 classes
# Heat load index (HLI) categorized into 3 classes
# Soil Order

#Read set of AdaptWest grids into a stars data structure, where each dimension is a layer
#Forward, backward velocity,
AW_Facet_Rasters<-c('Original_Rasters/Facets/landfacetdiversity.asc',
                      'Original_Rasters/Facets/hlidiversity.asc',
                    'Original_Rasters/Facets/elevationaldiversity.asc',
                    'Original_Rasters/Facets/ecotypicdiversity.asc',
                    'Original_Rasters/Facets/currentclimatediversity.asc',
                    'Original_Rasters/Facets/bwvelocityrefugiaindex.asc',
                    'Original_Rasters/Facets/climatezones.asc')

#Use stars methods to read AW, transpose and add to list of rasters
Facet_Rasters <- read_stars(file.path(AdaptWestDir,AW_Facet_Rasters), quiet = TRUE)
st_crs(Facet_Rasters)<-AWcrs
write_stars(Facet_Rasters[1],dsn=file.path(spatialOutDir,'Facet_Rasters.tif'))#to check
#crop to buffered provincial boundary's bounding box
Facet_Rasters_crop<-Facet_Rasters[Prov_AW]
#Warp to Albers projection and intersect with Province on hectares BC grid base
Facet_Rasters_BC<-st_warp(Facet_Rasters_crop,ProvRastNoBuf_S,cellsize=100)
saveRDS(Facet_Rasters_BC, file = './tmp/Facet_Rasters_BC')
write_stars(Facet_Rasters_BC[1],dsn=file.path(spatialOutDir,'Facet_Rasters_BC.tif'))#to check
#Facet_Rasters_BC<-readRDS(file='./tmp/Facet_Rasters_BC')

#Read in facet LUT csv
Landforms_LUTs<-'Original_Rasters/Facets/Landforms.csv'
FacetAdjEl_LUTs<-'Original_Rasters/Facets/FacetAdjEl.csv'
Landforms <- read.csv(file=Landforms_LUTs, header=TRUE, sep=",")
FacetAdjEl <- read.csv(file=FacetAdjEl_LUTs, header=TRUE, sep=",")



