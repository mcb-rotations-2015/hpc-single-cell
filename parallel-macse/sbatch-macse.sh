# Run parallel MACSE on a cluster using the SLURM scheduler.

if ! [ -a "$1" ]; then
    echo "Usage: $(basename $0) TSV_FILE"
    echo
    echo "\"$1\" is not a TSV_FILE"
    exit 1
fi
TSV_FILE=$1

sbatch_opts="
 --job-name=$(basename ${TSV_FILE})
 --ntasks=48
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
