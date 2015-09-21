#!/bin/bash

# Run parallel MACSE on a cluster using the SLURM scheduler.

# Workaround for module programs not being available in SLURM scripts.
source /etc/profile.d/modules.sh
module load parallel || { echo "Could not load module 'parallel'!"; exit 1; }

if ! [ -n "$1" ]; then
    echo "Usage: bash $(basename $0) COMMAND [ARGUMENTS]"
    exit 1
fi

sbatch_opts="
 --partition=IvyBridge
 --nodes=1
 --ntasks=16
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

sbatch ${sbatch_opts} $*
