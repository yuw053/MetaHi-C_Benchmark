WGS_CL_1=$1
WGS_CL_2=$2
OUTPUT_PATH=$3

########## Assembly ##########
mkdir -p ${OUTPUT_PATH}
cd ${OUTPUT_PATH}
megahit --use-gpu -1 ${WGS_CL_1} -2 ${WGS_CL_2} -o ASSEMBLY --min-contig-len 1000 --k-min 21 --k-max 141 --k-step 12 --merge-level 20,0.95