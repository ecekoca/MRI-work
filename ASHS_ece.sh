#!/bin/bash
#!
#! By: Ece K


ashs_root="/imaging/ek01/ntad/scripts/from_coco/ashs-1.0.0"
home="/imaging/projects/cbu/ntad/MTL_partial_T2"
atlas="/imaging/ek01/atlases/ashs_atlas_upennpmc_20170810"

subjfile="/imaging/ek01/ntad/scripts/from_coco/ASHS_subjects.txt"
idfile=$(grep ${ntadid} "${subjfile}" | awk -F',' '{print $1}')

for i in ${ntadid};do

    nohup "${ashs_root}/bin/ashs_main.sh" -I ${i} -a "${atlas}/" -g "${home}/BL/${i}/T1.nii" -f "${home}/BL/${i}/T2_MTL.nii" -w "${home}/BL/${i}/" &

done

