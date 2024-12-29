WGS_FILE_1=$1
WGS_FILE_2=$2
HIC_FILE_1=$3
HIC_FILE_2=$4
BBTOOLS_PATH=$5
OUTPUT_PATH=$6

########## Preprocessing ##########
# cd /project/fsun_106/yuqiuwang/BENCHMARK/SLURM/bbmap/
cd ${BBTOOLS_PATH}

# hic
./bbduk.sh  in1=${HIC_FILE_1} in2=${HIC_FILE_2} out1=${OUTPUT_PATH}/HIC_1_AQ.fastq.gz out2=${OUTPUT_PATH}/HIC_2_AQ.fastq.gz ref=${BBTOOLS_PATH}/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 minlen=50 tpe tbo
# metagenome
./bbduk.sh  in1=${WGS_FILE_1} in2=${WGS_FILE_2} out1=${OUTPUT_PATH}/WGS_1_AQ.fastq.gz out2=${OUTPUT_PATH}/WGS_2_AQ.fastq.gz ref=${BBTOOLS_PATH}/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 minlen=50 tpe tbo

# hic
./bbduk.sh  in1=${OUTPUT_PATH}/HIC_1_AQ.fastq.gz in2=${OUTPUT_PATH}/HIC_2_AQ.fastq.gz out1=${OUTPUT_PATH}/HIC_1_CL.fastq.gz out2=${OUTPUT_PATH}/HIC_2_CL.fastq.gz trimq=10 qtrim=r ftm=5 minlen=50
# metagenome
./bbduk.sh  in1=${OUTPUT_PATH}/WGS_1_AQ.fastq.gz in2=${OUTPUT_PATH}/WGS_2_AQ.fastq.gz out1=${OUTPUT_PATH}/WGS_1_CL.fastq.gz out2=${OUTPUT_PATH}/WGS_2_CL.fastq.gz trimq=10 qtrim=r ftm=5 minlen=50

# hic
./bbduk.sh in1=${OUTPUT_PATH}/HIC_1_CL.fastq.gz in2=${OUTPUT_PATH}/HIC_2_CL.fastq.gz out1=${OUTPUT_PATH}/HIC_1_trim.fastq.gz out2=${OUTPUT_PATH}/HIC_2_trim.fastq.gz  ftl=10
# metagenome
./bbduk.sh in1=${OUTPUT_PATH}/WGS_1_CL.fastq.gz in2=${OUTPUT_PATH}/WGS_2_CL.fastq.gz out1=${OUTPUT_PATH}/WGS_1_trim.fastq.gz out2=${OUTPUT_PATH}/WGS_2_trim.fastq.gz ftl=10

# hic
./clumpify.sh in1=${OUTPUT_PATH}/HIC_1_trim.fastq.gz in2=${OUTPUT_PATH}/HIC_2_trim.fastq.gz out1=${OUTPUT_PATH}/HIC_1_dedup.fastq.gz out2=${OUTPUT_PATH}/HIC_2_dedup.fastq.gz dedupe
