FASTA=$1
ALIGN_1=$2
ALIGN_2=$3
MODE=$4
OUTPUT_PATH=$5

########## MetaCC and ImputeCC Single ##########
cd ${OUTPUT_PATH}
out=${MODE}

python /project/fsun_106/yuqiuwang/BENCHMARK/MetaCC_SR/MetaCC.py norm \
    -e MluCI -e Sau3AI \
    -v  ${FASTA} ${ALIGN_1} ${ALIGN_2} ${out} --cover 

# python /project/fsun_106/yuqiuwang/BENCHMARK/ImputeCC/ImputeCC.py pipeline \
#     ${FASTA} \
#     ${out}/contig_info.csv \
#     ${out}/Normalized_contact_matrix.npz \
#     ${out} --cover