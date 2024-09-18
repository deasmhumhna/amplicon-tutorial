#!/bin/bash
#
# DOWNLOAD DATA FILES
#
echo "### Downloading example data files..."
cd ~
curl -L -o dada2_amplicon_ex_workflow.tar.gz https://ndownloader.figshare.com/files/28773936
tar -xzvf dada2_amplicon_ex_workflow.tar.gz
rm dada2_amplicon_ex_workflow.tar.gz
cd dada2_amplicon_ex_workflow/
#
# FILE OF SAMPLE NAMES
#
echo "### Creating sample list..."
ls *_R1.fq | cut -f1 -d "_" > samples
#
# REMOVE PRIMERS FOR SEQUENCES
#
echo "### Trimming primers..."
for sample in $(cat samples)
do
    echo "On sample: $sample"
    cutadapt -a ^GTGCCAGCMGCCGCGGTAA...ATTAGAWACCCBDGTAGTCC \
             -A ^GGACTACHVGGGTWTCTAAT...TTACCGCGGCKGCTGGCAC \
             -m 215 -M 285 --discard-untrimmed \
             -o ${sample}_sub_R1_trimmed.fq.gz -p ${sample}_sub_R2_trimmed.fq.gz \
             ${sample}_sub_R1.fq ${sample}_sub_R2.fq \
             >> cutadapt_primer_trimming_stats.txt 2>&1
done
#
# VIEW TRIMMING STATISTICS 
#
echo "### Trimming Statistics ###"
paste samples <(grep "passing" cutadapt_primer_trimming_stats.txt | cut -f3 -d "(" | tr -d ")") <(grep "filtered" cutadapt_primer_trimming_stats.txt | cut -f3 -d "(" | tr -d ")")