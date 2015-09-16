#!/bin/bash

# Run parallel MACSE on a cluster using the SLURM scheduler.

# Workaround for module programs not being available in SLURM scripts.
source /etc/profile.d/modules.sh
module load parallel || { echo "Could not load module 'parallel'!"; exit 1; }

if ! [ -a "$1" ]; then
    echo "Usage: $(basename $0) TSV_FILE"
    echo
    echo "\"$1\" is not a TSV_FILE"
    exit 1
fi
TSV_FILE=$1

sbatch_opts="
 --job-name=$(basename ${TSV_FILE})
 --partition=IvyBridge
 --nodes=1
 --ntasks=6
"

email=$(git config --global user.email)
if [ -n "${email}" ]; then
    sbatch_opts="${sbatch_opts}
 --mail-type=All
 --mail-user=${email}
"
else
      echo "Git user.email is not set; will not send job status e-mails." >&2
fi

sbatch ${sbatch_opts} ./parallel-macse.sh ${TSV_FILE}
