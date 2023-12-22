#!/usr/bin/env bash

#julia_dir = "$(pwd)julia-${JULIA_VERSION}"

# get the julia version
git clone https://github.com/JuliaLang/julia $JULIA_DIR
cd ${JULIA_DIR}
git checkout ${JULIA_VERSION}

# build julia
make -j${JULIA_NUM_THREADS}

chown ${NB_USER} ${JULIA_DIR}
fix-permissions ${JULIA_DIR}

# link to executable
ln -fs "${JULIA_DIR}/julia" "/usr/local/bin/julia"

# Tell Julia where conda libraries are
mkdir -p /etc/julia
echo 'push!(Libdl.DL_LOAD_PATH,"'${CONDA_DIR}'/lib")' > /etc/julia/juliarc.jl

#create user libraries
mkdir -p ${JULIA_PKGDIR}
chown ${NB_USER} ${JULIA_PKGDIR}
fix-permissions ${JULIA_PKGDIR}
cd -
