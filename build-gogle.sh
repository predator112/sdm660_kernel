#!/usr/bin/env bash
# Copyright (C) 2020 Mohammad Iqbal (predator112)
# Configured for Redmi Note 5 Pro / whyred custom kernel source
# Simple Local Kernel Build Script

# Clone AnyKernel
if ! [ -d "$PWD/AnyKernel" ]; then
    git clone https://github.com/PREDATOR-project/AnyKernel3.git -b BangBroz-oldcam --depth=1 gcc_build
else
    echo "AnyKernel3 folder is exist, not cloning"
fi

# Main Environment
KERNEL_DIR=/home/loli/kernel
IMAGE=/home/loli/kernel/out/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=/home/loli/kernel/gcc_build
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs
CORES=$(grep -c ^processor /proc/cpuinfo)
THREAD="-j$CORES"

# export
export KBUILD_BUILD_USER=builder
export KBUILD_BUILD_HOST=MohammadIqbal🇮🇩

# compile plox
make O=out ARCH=arm64 predator_defconfig
PATH=home/loli/clang-4691093/bin:home/loli/gcc64/bin:home/loli/gcc32/bin:${PATH} \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi-
           O=out| tee build.log
           if ! [ -a "$IMAGE" ]; then
               finerr
               exit 1
           fi
   cp out/arch/arm64/boot/Image.gz-dtb gcc_build

# Compress to zip file
cd /home/loli/kernel/gcc_build
make clean &>/dev/null
make normal &>/dev/null
cd ..
echo -e "The build is complete, and is in the directory $ZIP_DIR"
