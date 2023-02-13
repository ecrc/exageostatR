#!/bin/bash
#SBATCH --job-name=ExaGeoStat200-%j
#SBATCH --output=exact_ibex_%A.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
##SBATCH --partition=group-stsda
#SBATCH --time=01:00:00


export STARPU_SCHED=eager               # Only needed with ExaGeoStat
export STARPU_CALIBRATE=1               # Only needed with ExaGeoStat
export  STARPU_MAX_MEMORY_USE=1         # Only needed with ExaGeoStat
export  STARPU_MEMORY_STATS=1           # Only needed with ExaGeoStat
export  STARPU_STATS=1                  # Only needed with ExaGeoStat
export  STARPU_LIMIT_CPU_MEM=0          # Only needed with ExaGeoStat
export STARPU_LIMIT_MAX_SUBMITTED_TASKS=10000	# Only needed with ExaGeoStat
export STARPU_LIMIT_MIN_SUBMITTED_TASKS=9000	# Only needed with ExaGeoStat
export STARPU_WORKER_STATS=1			# Only needed with ExaGeoStat
export STARPU_WATCHDOG_TIMEOUT=100000000	# Only needed with ExaGeoStat
export STARPU_WATCHDOG_CRASH=1			# Only needed with ExaGeoStat


#cat /proc/cpuinfo

#free -g
srun Rscript your_script.R
