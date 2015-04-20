#!/usr/bin/env python

import gdal
import osr
import numpy as np
import scipy.io
from gdalconst import *
import math
mat = scipy.io.loadmat('landmaskna.mat')
lat = mat['latvalsna']
lon = mat['lonvalsna']
landmask = mat['landnafp']

driver = gdal.GetDriverByName('GTiff')
ds = driver.Create('landmask_gcs.tif',landmask.shape[1],landmask.shape[0],
    1, GDT_Byte)
dlon = (lon[0,1:]-lon[0,0:-1]).mean()
dlat = (lat[0,1:]-lat[0,0:-1]).mean()
ds.SetGeoTransform([lon[0,0],dlon,0,lat[0,0], 0, dlat])
srs = osr.SpatialReference()
srs.SetWellKnownGeogCS('WGS84')
ds.SetProjection(srs.ExportToWkt())

import pdb; pdb.set_trace()  # XXX BREAKPOINT
raster = 1-np.isnan(landmask).astype(np.byte)
ds.GetRasterBand(1).WriteArray(raster)
ds = None
