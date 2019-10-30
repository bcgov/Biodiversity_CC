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

#AdaptWest annd Prov crs strings
AWcrs<-"+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
# projection string for climate data is different than the others + NCD files have a mistake in string so have to set
AWcrs_Climate<-"+proj=lcc +lat_1=49 +lat_0=0 +lon_0=-95 +lat_2=77 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
#Prov_crs<-"+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"
Prov_file <- file.path(spatialOutDir,'Prov.shp')
if (!file.exists(Prov_file)) {
  ProvNoBuff <- bcmaps::bc_bound_hres(class='sf')
  #Buffer the Province for cropping and buffering
  Prov <- st_buffer(ProvNoBuff, 5000)
#write to shape
st_write(ProvNoBuff, file.path(spatialOutDir, "ProvNoBuff.shp"),delete_layer = TRUE)
st_write(Prov, file.path(spatialOutDir, "Prov.shp"),delete_layer = TRUE)
#use mapview to check results
#mapview(list(ProvNoBuff, Prov),
#        color = list('red','green'),
#        zcol = list(NULL, NULL),
#       legend = list(FALSE, FALSE))
} else {
  Prov<-st_read(dsn=Prov_file)
  ProvNoBuff<-st_read(dsn=file.path(spatialOutDir,'ProvNoBuff.shp'))
}
ProvNoBuff_S <- st_as_stars(ProvNoBuff)
Prov_S <- st_as_stars(Prov)
Prov_crs <- crs(Prov)

#Transform Province into AW projection
Prov_AW <- st_transform(Prov, crs=AWcrs)
#Transform Province into AW projection
Prov_AW_Climate <- st_transform(Prov, crs=AWcrs_Climate)
#Transform Province 'stars' into AW projection
Prov_S_AW <- st_transform(Prov_S, crs=AWcrs)
#Transform Province 'stars' into AW climate projection
Prov_S_AW_Climate <- st_transform(Prov_S, crs=AWcrs_Climate)

########
ProvRast_file <- file.path(spatialOutDir,'ProvRast.tif')
if (!file.exists(ProvRast_file)) {
  ProvRast<-raster(nrows=15744, ncols=17216, xmn=159587.5, xmx=1881187.5,
                   ymn=173787.5, ymx=1748187.5,
                   crs=Prov_crs,
                   res = c(100,100), vals = 1)%>%
    extend(500)
  writeRaster(ProvRast, filename=ProvRast_file, format="GTiff", overwrite=TRUE)
  ProvRastNoBuf<-raster(nrows=15744, ncols=17216, xmn=159587.5, xmx=1881187.5,
                   ymn=173787.5, ymx=1748187.5,
                   crs=Prov_crs,
                   res = c(100,100), vals = 1)
  writeRaster(ProvRast, filename=ProvRast_file, format="GTiff", overwrite=TRUE)
  writeRaster(ProvRastNoBuf, filename=file.path(spatialOutDir,'ProvRastNoBuf.tif'), format="GTiff", overwrite=TRUE)
  ProvRast_S<-st_as_stars(ProvRast)
  ProvRastNoBuf_S<-st_as_stars(ProvRastNoBuf)
  write_stars(ProvRast_S,dsn=file.path(spatialOutDir,'ProvRast_S.tif'))
  write_stars(ProvRastNoBuf_S,dsn=file.path(spatialOutDir,'ProvRastNoBuf_S.tif'))
  #ProvRast_AW<-projectRaster(ProvRast, crs=AWcrs)
  #writeRaster(ProvRast_AW, filename=file.path(spatialOutDir,'ProvRast_AW.tif'), format="GTiff", overwrite=TRUE)
  #ProvRast_S_AW<-st_warp(ProvRast_S, crs=AWcrs_Climate)
  #write_stars(ProvRast_S_AW,dsn=file.path(spatialOutDir,'ProvRast_S_AW.tif'))
  #ProvRast_S_AW_Climate<-st_warp(ProvRast_S, crs=AWcrs_Climate)
  #write_stars(ProvRast_S_AW_Climate,dsn=file.path(spatialOutDir,'ProvRast_S_AW_Climate.tif'))
} else {
  ProvRast<-raster(ProvRast_file)
  ProvRastNoBuf<-raster(file.path(spatialOutDir,'ProvRastNoBuf.tif'))
  #ProvRast_AW<-raster(file.path(spatialOutDir,"ProvRast_AW.tif"))
  ProvRast_S<-read_stars(file.path(spatialOutDir,'ProvRast_S.tif'))
  ProvRastNoBuf_S<-read_stars(file.path(spatialOutDir,'ProvRastNoBuf_S.tif'))
  #ProvRast_S_AW<-read_stars(file.path(spatialOutDir,"ProvRast_AW.tif"))
  #ProvRast_S_AW_Climate<-read_stars(file.path(spatialOutDir,"ProvRast_AW_Climate.tif"))
}

BCr_file <- file.path(spatialOutDir,"BCr.tif")
if (!file.exists(BCr_file)) {
  BCr <- fasterize(bcmaps::bc_bound_hres(class='sf'),ProvRast)
  writeRaster(BCr, filename=BCr_file, format="GTiff", overwrite=TRUE)
  BCr_S <-st_as_stars(BCr)
  write_stars(BCr_S,dsn=file.path(spatialOutDir,'BCr_S.tif'))
} else {
  BCr_S <- read_stars(file.path(spatialOutDir,'BCr_S.tif'))
  BCr <- raster(BCr_file)
}

