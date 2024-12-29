FASTA=$1
ALIGN=$2
MODE=$3
OUTPUT_PATH=$4

########## MetaCC and ImputeCC Pair ##########
cd ${OUTPUT_PATH}
out=${MODE}
python /project/fsun_106/yuqiuwang/BENCHMARK/MetaCC/MetaCC.py norm \
    -e MluCI -e Sau3AI \
    -v  ${FASTA} ${ALIGN} ${out} --cover

# python /project/fsun_106/yuqiuwang/BENCHMARK/ImputeCC/ImputeCC.py pipeline \
#     ${FASTA} \
#     ${out}/contig_info.csv \
#     ${out}/Normalized_contact_matrix.npz \
#     ${out} --cover