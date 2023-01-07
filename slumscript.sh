#!/bin/bash
#SBATCH --nodes=1
#SBATCH --job-name=demo
#SBATCH --time=1:30:00
#SBATCH --gres=gpu:1
#SBATCH --output=demo_%j_.out
#SBATCH --error=demo_%j_.err
 #nsys profile ./a.out
 module load nvhpc/nvhpc/22.3
ncu -kernel-name mat_mat_mul --launch-skip 0 --launch-count 1 "./a.out"