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
#Read from BCMaps - conservancy, EcoRegions
#Read from disk THLB, BEC
#Read in BEC
spatialLibDir <- file.path('/Users/darkbabine/Dropbox (BVRC)/Library/GISFiles/BC/Shapefiles/')

BECin <-
  read_sf(file.path(spatialLibDir,'BEC_BIOGEOCLIMATIC_POLY/BEC_POLY_polygon.shp')) %>%
  st_transform(wet_crs)

BEC <- ESI %>%
  st_intersection(BECin) %>%
  #Clean up topology problems in BEC by applying 0 buffer
  # https://gis.stackexchange.com/questions/163445/getting-topologyexception-input-geom-1-is-invalid-which-is-due-to-self-intersec
  sf::st_buffer(dist = 0) %>%
  st_make_valid()
#Test for topological validity - shoudld not return any FALSE
unique(st_is_valid(BEC))

saveRDS(BEC, file = 'tmp/BEC')

