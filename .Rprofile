# Set environment variables to point to installations of geospatial libraries ----
# Get the existing value of 'LD_LIBRARY_PATH'
old_ld_path <- Sys.getenv("LD_LIBRARY_PATH") 

# Append paths to GDAL and PROJ to 'LD_LIBRARY_PATH'
Sys.setenv(LD_LIBRARY_PATH = paste(old_ld_path,
                                   "/usr/gdal34/lib",
                                   "/usr/proj81/lib",
                                   sep = ":"))

rm(old_ld_path)

## Specify additional proj path in which pkg-config should look for .pc files ----
Sys.setenv("PKG_CONFIG_PATH" = "/usr/proj81/lib/pkgconfig")

## Specify the path to GDAL data ----
Sys.setenv("GDAL_DATA" = "/usr/gdal34/share/gdal")

## Load the geospatial libraries ----
dyn.load("/usr/gdal34/lib/libgdal.so")
dyn.load("/usr/geos310/lib64/libgeos_c.so", local = FALSE)
