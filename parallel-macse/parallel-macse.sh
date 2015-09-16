#!/bin/bash

# Usage: parallel-macse.sh [--dryrun] TSV_FILE
#
# Options:
# --dryrun  Print the job to run on stdout, but do not run the job.
#
# Do not run this file directly on the cluster, even though it uses
# the scheduler with `srun`, because it will clutter up the `sacct`
# history.  Instead, run this file using `sbatch`.
#
# MACSE [1] is a single-threaded program for aligning sequences.
# Therefore, to parallelize it, we must use slurm's `srun` command [2]
# with GNU Parallel [3].
#
# [1] http://bioweb.supagro.inra.fr/macse/
# [2] http://www.ceci-hpc.be/slurm_tutorial.html
# [3] https://rcc.uchicago.edu/docs/tutorials/kicp-tutorials/running-jobs.html

# Parse all arguments.
# 
while [[ $# > 0 ]]; do
    case "$1" in
	--dryrun) DRYRUN=1; shift;;
	*) TSV_FILE="$1"; shift;;
    esac
done

# Name the parallel joblog file according to the input file name.
# Like a Makefile, a joblog prevents multiple runs of the same task,
# as well as logging excellent statistics about each task, which we
# can check while the job is running with `tail -f JOBLOG`.
#
tsv_basename=$(basename ${TSV_FILE}) # Remove directories from tsv_file
tsv_no_ext="${tsv_basename##*.}"     # Strip the extension

# UConn's BECAT cluster usage policy limits us to 48 cpu cores on the
# standard queue.
#
parallel="parallel
 --delay 0.2
 --jobs 48
 --joblog parallel-${tsv_no_ext}.log
 --resume-failed
 --arg-file ${TSV_FILE}
 --header :
"

srun="srun
 --exclusive
 --nodes=1
 --ntasks=1
"

# Make the assumption that the tsv_file is at the root of fasta files.
# 
data_dir=$(dirname ${TSV_FILE})

# We get the {family} column from tsv_file using parallel's
# `--header`.  Basically, `parallel --header : --arg-file FILE COMMAND
# {HEADER_NAME}` does the job of `cut` in the shell, but it is
# infinitely nicer since it uses named fields.
#
fasta_prefix="${data_dir}/DN/{family}/{family}"

java="java
 -verbose:gc
 -Xmx20480m
 -jar macse_v1.01b.jar
 -prog alignSequences
 -seq ${fasta_prefix}_pa.fasta.paml
 -seq_lr ${fasta_prefix}_pg.fasta.paml
 -fs_lr 10
 -stop_lr 10
"

# Run all the things!
#
if [ -n "${DRYRUN}" ]; then
    parallel="${parallel} --dryrun"
    ${parallel} ${java}
else
    ${parallel} ${srun} ${java}
fi

