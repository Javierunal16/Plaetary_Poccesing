#!/bin/sh
#Changing the extension of all files to be .IMG
for f in *.img; do mv -- "$f" "${f%.img}.IMG"; done
#Listing all files in a lsit, to do the batch proccesing
ls *.IMG | sed s/.IMG// > Imputs.lis
#Transofmration from IMG to cubes
lronac2isis from=\$1.IMG to=\$1.cub -batchlist=Imputs.lis
#Actualization of cubes kernels
spiceinit from=\$1.cub -batchlist=Imputs.lis
#Calibrate to I/F
lronaccal from=\$1.cub to=\$1_lv1.cub -batchlist=Imputs.lis
#Some NAC-ONLY correction
lronacecho from=\$1_lv1.cub to=\$1_lv1echo.cub -batchlist=Imputs.lis
#Map projection, maptemplate needed to be preivously created
cam2map from=\$1_lv1echo.cub map=Equirectangular.map to=\$1_lv2.cub PIXRES=map -batchlist=Imputs.lis
#Photometric correction (NAC not neccesary), the .pvl should contain the information for the operation (use high band tolerance)
#Put all the level two cubes with path in a text file
#ls -d "$PWD"/*_lv2.cub > List.txt
#Equalizer to match the color and contrast of the images
#equalizer fromlist=List.txt
#ls -d "$PWD"/*_lv2.equ.cub > List2.txt
#Mosaic, Remember to change the maximum file size in Isisperferences file (somtimes them osaic excceds the default 12 GB)
#noseam from=List2.txt to=Final.cub samples=333 lines=333
#Formar Transformation
#gdal_translate Final.cub Final.tif
#Delete intermedial fies
#find . -maxdepth 1 -not -name 'Final.cub' -name "*.cub" -type f -delete

