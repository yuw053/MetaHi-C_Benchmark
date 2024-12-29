FASTA=$1
MODE=$2
OUTPUT_PATH=$3

cd ${OUTPUT_PATH}
python /project/fsun_106/yuqiuwang/BENCHMARK/ImputeCC/ImputeCC.py pipeline \
    ${FASTA} \
    ${MODE}/contig_info.csv \
    ${MODE}/Normalized_contact_matrix.npz \
    ${MODE} --cover