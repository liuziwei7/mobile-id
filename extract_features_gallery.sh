#!/usr/bin/env sh
# 

TOOLS=./caffe/build/tools
MODELS=./models
GALLERY=./data/gallery/lfw
UTILS=./utils

NUM_IMG=13143
BATCH_SIZE=256
DIM_FEATURE=422

$TOOLS/extract_features.bin $MODELS/mobile_id.caffemodel $MODELS/mobile_id_gallery.prototxt ip3 $GALLERY/features_gallery_leveldb 103 leveldb GPU
python $UTILS/leveldb2mat.py $GALLERY/features_gallery_leveldb 26286 422 $GALLERY/features_gallery_mat.mat
