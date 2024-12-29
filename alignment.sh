assembly=$1
read1=$2
read2=$3
OUTPUT_PATH=$4


########## Alignment ##########
mkdir -p ${OUTPUT_PATH}
cd ${OUTPUT_PATH}

###########Bowtie2 sr sensitive###############
out='bowtie2_sr_sensitive'
mkdir ${out}

echo "---bowtie2-build---" >> time.log
{ time bowtie2-build \
	${assembly} \
	${out}/bowtie2_index ; } 2>> time.log


echo "---Bowtie2 sr sensitive for---" >> time.log
{ time bowtie2 \
	-x ${out}/bowtie2_index -p 60 \
	${read1} --very-sensitive-local --no-unal -S ${out}/for.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/for.sam > ${out}/for.bam
samtools sort -@ 59 -n ${out}/for.bam -o ${out}/for_sorted.bam

echo "---Bowtie2 sr sensitive rev---" >> time.log
{ time bowtie2 \
	-x ${out}/bowtie2_index -p 60 \
	${read2} --very-sensitive-local --no-unal -S ${out}/rev.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/rev.sam > ${out}/rev.bam
samtools sort -@ 59 -n ${out}/rev.bam -o ${out}/rev_sorted.bam


###########Bowtie2 sr def###############
out='bowtie2_sr_def'
mkdir ${out}
mv bowtie2_sr_sensitive/bowtie2_index* ${out}

echo "---Bowtie2 sr def for---" >> time.log
{ time bowtie2 -x ${out}/bowtie2_index -p 60 \
	${read1} -S ${out}/for.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/for.sam > ${out}/for.bam
samtools sort -@ 59 -n ${out}/for.bam -o ${out}/for_sorted.bam

echo "---Bowtie2 sr def rev---" >> time.log
{ time bowtie2 -x ${out}/bowtie2_index -p 60 \
	${read2} -S ${out}/rev.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/rev.sam > ${out}/rev.bam
samtools sort -@ 59 -n ${out}/rev.bam -o ${out}/rev_sorted.bam


#############BWA aln sr def################
out='bwa_aln_sr'
mkdir ${out}

echo "---BWA index---" >> time.log
{ time bwa index ${assembly} ; } 2>> time.log
echo "---BWA aln sr def for---" >> time.log
{ time bwa aln -t 60 \
	${assembly} \
	${read1} \
	> ${out}/for.sai ; } 2>> time.log

echo "---BWA samse sr def for---" >> time.log
{ time bwa samse ${assembly} \
	${out}/for.sai \
	${read1} > ${out}/for.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/for.sam > ${out}/for.bam
samtools sort -@ 59 -n ${out}/for.bam -o ${out}/for_sorted.bam

echo "---BWA aln sr def rev---" >> time.log
{ time bwa aln -t 60 \
	${assembly} \
	${read2} \
	> ${out}/rev.sai ; } 2>> time.log

echo "---BWA samse sr def rev---" >> time.log
{ time bwa samse ${assembly} \
	${out}/rev.sai \
	${read2} > ${out}/rev.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/rev.sam > ${out}/rev.bam
samtools sort -@ 59 -n ${out}/rev.bam -o ${out}/rev_sorted.bam


#############BWA mem pr default################
out='bwa_mem_pr_def'
mkdir ${out}

echo "---BWA mem pr default---" >> time.log
{ time bwa mem -t 60 \
	${assembly} \
	${read1} \
	${read2} \
	> ${out}/aln.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/aln.sam > ${out}/aln.bam
samtools sort -@ 59 -n ${out}/aln.bam -o ${out}/aln_sorted.bam


#############BWA mem pr 5SP################
out='bwa_mem_pr_5sp'
mkdir ${out}

echo "---BWA mem pr 5SP---" >> time.log
{ time bwa mem -t 60 -5SP \
	${assembly} \
	${read1} \
	${read2} \
	> ${out}/aln.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/aln.sam > ${out}/aln.bam
samtools sort -@ 59 -n ${out}/aln.bam -o ${out}/aln_sorted.bam


#############Minimap2 paired################
out='minimap2_pr_def'
mkdir ${out}

echo "---Minimap2 paired---" >> time.log
{ time minimap2 -ax sr -t 60\
	${assembly} \
	${read1} \
	${read2} \
	> ${out}/aln.sam ; } 2>> time.log

samtools view -bS -@ 59 ${out}/aln.sam > ${out}/aln.bam
samtools sort -@ 59 -n ${out}/aln.bam -o ${out}/aln_sorted.bam



###############Chromap###############
mkdir chromap
chromap -i -r ${assembly} -o chromap/index

chromap --preset hic -x chromap/index -t 60 \
	-r ${assembly} \
	-1 ${read1} \
	-2 ${read2} \
	--SAM -o chromap/aln.sam

samtools view -bS -@ 59 chromap/aln.sam > chromap/aln.bam
samtools sort -@ 59 -n chromap/aln.bam -o chromap/aln_sorted.bam
