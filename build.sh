#!/bin/bash

convert_latest_radar_image () {

    RADAR_NAME=$1
    FILE_EXTENSION=$2

    CROP_DIMENSION=$3
    RESIZE_DIMENSION=$4

    RADAR_URL="https://data.rainviewer.com/images/${RADAR_NAME}/"

    DEST_SOURCE_FILE="./public/${RADAR_NAME}_source.${FILE_EXTENSION}"
    DEST_DONE_FILE="./public/${RADAR_NAME}.png"

    LATEST_SCAN=`curl -0 ${RADAR_URL}0_products.json | jq -r ".products[0].scans | last | .name"`
    IMG_URL_FROM_JSON=${RADAR_URL}${LATEST_SCAN/_2_map.png/_0_source.${FILE_EXTENSION}}

    wget -O ${DEST_SOURCE_FILE} ${IMG_URL_FROM_JSON}

    # Crop and resize radar image on file
    convert ${DEST_SOURCE_FILE}             \
        -crop ${CROP_DIMENSION} +repage     \
        -resize ${RESIZE_DIMENSION} +repage \
        ${DEST_DONE_FILE}

    # Resize images
    # to 450x450
    convert ${DEST_DONE_FILE} \
        -resize 450x450       \
        -background Black     \
        -gravity center       \
        -extent 450x450       \
        ${DEST_DONE_FILE}

    rm ${DEST_SOURCE_FILE}

}

# THTP3 radar - https://data.rainviewer.com/images/THTP3/
convert_latest_radar_image "THTP3" "gif" "614x614+0+0" "614x614"

# THKT2 radar - https://data.rainviewer.com/images/THKT2/
convert_latest_radar_image "THKT2" "jpeg" "756x787+43+0" "756x787"

# THMP3 radar - https://data.rainviewer.com/images/THMP3/
convert_latest_radar_image "THMP3" "gif" "767x786+32+0" "767x786"

# THNN radar - https://data.rainviewer.com/images/THNN/
convert_latest_radar_image "THNN" "webp" "607x607+0+0" "614x614"

# THTR radar - https://data.rainviewer.com/images/THTR/
convert_latest_radar_image "THTR" "webp" "799x799+0+0" "799x799"

###
### TODO remove
###
# RADAR_URL="https://data.rainviewer.com/images/THTP3/"
# LATEST_SCAN=`curl -0 ${RADAR_URL}0_products.json | jq -r ".products[0].scans | last | .name"`
# wget -O ./public/THTP3_source.gif ${RADAR_URL}${LATEST_SCAN/_2_map.png/_0_source.gif}
# convert ./public/THTP3_source.gif -crop 614x614+0+0 +repage -resize x614 +repage ./public/THTP3.webp
# convert ./public/THTP3.webp -resize 450x450 -background Black -gravity center -extent 450x450 ./public/THTP3.png
# rm ./public/THTP3_source.gif
#
# # THKT2 radar
# # https://data.rainviewer.com/images/THKT2/
# RADAR_URL="https://data.rainviewer.com/images/THKT2/"
# LATEST_SCAN=`curl -0 ${RADAR_URL}0_products.json | jq -r ".products[0].scans | last | .name"`
# wget -O ./public/THKT2_source.jpeg ${RADAR_URL}${LATEST_SCAN/_2_map.png/_0_source.jpeg}
# convert ./public/THKT2_source.jpeg -crop 756x787+43+0 +repage -resize 756x787 +repage ./public/THKT2.webp
# convert ./public/THKT2.webp -resize 450x450 -background Black -gravity center -extent 450x450 ./public/THKT2.png
# rm ./public/THKT2_source.jpeg
#
# # THMP3 radar
# # https://data.rainviewer.com/images/THMP3/
# RADAR_URL="https://data.rainviewer.com/images/THMP3/"
# LATEST_SCAN=`curl -0 ${RADAR_URL}0_products.json | jq -r ".products[0].scans | last | .name"`
# wget -O ./public/THMP3_source.gif ${RADAR_URL}${LATEST_SCAN/_2_map.png/_0_source.gif}
# convert ./public/THMP3_source.gif -crop 767x786+32+0 +repage -resize 767x786 +repage ./public/THMP3.webp
# convert ./public/THMP3.webp -resize 450x450 -background Black -gravity center -extent 450x450 ./public/THMP3.png
# rm ./public/THMP3_source.gif
#
# # THNN radar
# # https://data.rainviewer.com/images/THNN/
# RADAR_URL="https://data.rainviewer.com/images/THNN/"
# LATEST_SCAN=`curl -0 ${RADAR_URL}0_products.json | jq -r ".products[0].scans | last | .name"`
# wget -O ./public/THNN_source.webp ${RADAR_URL}${LATEST_SCAN/_2_map.png/_0_source.webp}
# convert ./public/THNN_source.webp -crop 607x607+0+0 +repage -resize x614 +repage ./public/THNN.webp
# convert ./public/THNN.webp -resize 450x450 -background Black -gravity center -extent 450x450 ./public/THNN.png
# rm ./public/THNN_source.webp
#
# # THTR radar
# # https://data.rainviewer.com/images/THTR/
# RADAR_URL="https://data.rainviewer.com/images/THTR/"
# LATEST_SCAN=`curl -0 ${RADAR_URL}0_products.json | jq -r ".products[0].scans | last | .name"`
# wget -O ./public/THTR_source.webp ${RADAR_URL}${LATEST_SCAN/_2_map.png/_0_source.webp}
# convert ./public/THTR_source.webp -crop 799x799+0+0 +repage -resize x799 +repage ./public/THTR.webp
# convert ./public/THTR.webp -resize 450x450 -background Black -gravity center -extent 450x450 ./public/THTR.png
# rm ./public/THTR_source.webp $

emacs -Q --script build-site.el
