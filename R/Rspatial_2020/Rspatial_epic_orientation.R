'
Rspatial: Raster
EPIC Orientation, 2020
Sushant Banjara
This code intends to introduce raster package and its use for basic manipulation of raster objects.

Running this code does not require pre-organisation of data as the datasets are loaded from web or
downloaded on the go. The downloaded data will be saved on the default working directory of this script,
which can be identified using getwd() or set using setwd()

'

#load libraries
library (raster)
library(sf) #simple feature library is for shapefile manipulation

setwd('C:/Users/sbanjara/Desktop/EPICrspatial')

'===============Cast a marix to a raster and plot it================================================================='
#initialise a matrix
mat <- matrix(1:36, nrow=6) 
mat

#cast a matrix as a raster
rast <- raster(mat) 
plot(rast)
'===================================================================================================================='



'=======================Properties of a raster======================================================================='
#print the raster
rast

#get the precipitation monthly precipitation stack from an online source (worldclim)
#get the data at the resolution of 10 degrees
#this returns a raster stack (list of rasters) select the ones for Jun and Dec
prec <- getData('worldclim', var='prec', res=10)
prec
plot(prec)

#get the december and june precipitation and plot it
prec_dec <- prec[[12]]
prec_jun <- prec[[6]]
prec_dec
plot(prec_dec, main = 'Average December Precipitation')

#get the resolution of the raster
res(prec_dec)

#get the extent of the raster and plot it
ext <- extent(prec_dec)
ext
plot(ext)

#get the values of the raster
values(prec_dec)
unique(prec_dec)

#get the coordinate reference system
crs(prec_dec)
'===================================================================================================================='



'=============================Reprojection===========================================================================
1) Upon a regular raster reprojection, notice that the unique values of original raster changes substantially.
2)This part demonstrates why ngb method is required for reprojectin of rasters with categorical values
 ===================================================================================================================='

#get a cea raster from online source and print its crs and unique values
cea <- raster('/vsicurl/http://download.osgeo.org/geotiff/samples/gdal_eg/cea.tif')
cea
unique(cea)
plot(cea)

#Reproject with the default parameters
project <- projectRaster(cea, crs = crs(prec_dec))
project
unique(project)
plot(project)

#Reproject with appropriate parameters
project <- projectRaster(cea, crs = crs(prec_dec), method = 'ngb')
project
unique(project)
plot(project)
'===================================================================================================================='
'===================================================================================================================='



'========================================Map Algebra=================================================================
1)The chunk below shows are examples of basic algbraeic operations between rasters and between numbers and rasters.
2)Notice the differences between plots resulting from different operations.
3)Make sure all your rasters have same crs and resolution.
 ===================================================================================================================='

plot(prec_jun)
plot(prec_dec)
plot(2*prec_dec) #global operation--values of all pixels increases two folds
plot(prec_jun+2*prec_dec)#local operation--values change on per-pixel basis

slope = terrain(prec_dec, opt = 'slope') #focal operation--pixel value 
                                                #depends on values of 8 connected neighbours
plot(slope)
'===================================================================================================================='
'===================================================================================================================='



'=================================Get shapefile for later use========================================================'

#get the shapefile for USA and cast te data as sf object using st_as_sf
#level 1 indicates state-level shapefile for county level files use 'level = 2'
us <- st_as_sf(getData('GADM', country='USA', level=1))

#extract the shapefiles for Illinois and Wisconsin
#Notice the shapefile can be filtered the same way as a data-frame
il <- us[us$NAME_1 == 'Illinois', ]
wi <- us[us$NAME_1 == 'Wisconsin', ]

#Note: When you only need the shape of an sf and no attributes, cast the shapefile to a geometry object
#Try what happens when you plot without casting sf to a geometry object
plot(st_geometry(il))
'===================================================================================================================='



'====================================Raster Manipulation============================================================='
'===================================================================================================================='

#the code below returns 1 for the pixels with more than 350 mm of rainfall
wet <- (prec_dec > 350)
plot(wet)


#crop precipitation data for illinois
#Notice the cropped raster is not in the shape of Illinois, becase the raster is cropped to extent
il_prec <- crop(prec_dec, il)
wi_prec <- crop(prec_dec, wi)
plot(il_prec)

#Masking doesn't remove pixels from memory but ignores them in any operation
mask_il_prec <- mask(il_prec, il)
mask_wi_prec <- mask(wi_prec, wi)
plot(mask_il_prec)
plot(mask_wi_prec)
#Merging combines two, often overlapping rasters to produce a larger raster
merged <- raster::merge(mask_il_prec, mask_wi_prec)
plot(merged)
'===================================================================================================================='
'===================================================================================================================='



'======================================Raster Reduction==============================================================
 Raster reduction is the process of summarising the values of a raster that overlaps with some shapefile
 ===================================================================================================================='

#the output of extract function can be directly attached as shapefile attribute as shown below
il$total_rainfall <- extract (prec_dec, il, fun = sum, na.rm = TRUE)
plot(il['total_rainfall'])
'===================================================================================================================='
'===================================================================================================================='





'=============================================================Exercise===============================================
 1)Now you have monthly average precipitation data for the entire world and know how to load county level US data.
 2)Using the DEM below, find the county-wise average annual precipitation in Utah for areas below 2500m.
 ===================================================================================================================='

#Use this command to get the Digital Elevation Model for different parts of USA
#Use dem[[1]] for retrieving DEM for coterminous US
dem = getData('alt', country = 'USA')

#Use the command below to acquire precipitation at at high resolution 0.5 degree
#Since the dataset will be large provite lat and long for the required chunk
prec_fine <- getData('worldclim', var='prec', res=0.5, lat = 42.05, lon = -114)



