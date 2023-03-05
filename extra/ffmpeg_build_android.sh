#!/bin/bash

function build() {
    echo "=====> 进入编译ffmpeg脚本  CPU=$CPU"
    # NDK路径
    NDK_PATH=/Users/hezhubo/Library/Android/sdk/ndk/25.2.9519653
    # 平台编译 $NDK_PATH/toolchains/llvm/prebuilt/ 下的文件夹名称
    HOST_PLATFORM=darwin-x86_64
    TOOLCHAINS=$NDK_PATH/toolchains/llvm/prebuilt/$HOST_PLATFORM/bin
    SYSROOT=$NDK_PATH/toolchains/llvm/prebuilt/$HOST_PLATFORM/sysroot
    CC=$TOOLCHAINS/$PLATFORM-linux-$ANDROID$API-clang
    CXX=$TOOLCHAINS/$PLATFORM-linux-$ANDROID$API-clang++
    # 输出路径
    PREFIX=$(pwd)/android/$ABI
    # 日志输出目录
    CONFIG_LOG_PATH=${PREFIX}/log

    echo "=====> make clean"
    make clean

    echo "=====> log file path : $CONFIG_LOG_PATH/config.log"
    # 创建日志输出目录
    mkdir -p "$CONFIG_LOG_PATH"

    echo "=====> running configure..."
    ./configure \
        --logfile="$CONFIG_LOG_PATH/config.log" \
        --prefix="$PREFIX" \
        --target-os=android \
        --arch="$ARCH" \
        --cpu="$CPU"  \
        --sysroot="$SYSROOT" \
        --cc="$CC" \
        --cxx="$CXX" \
        --extra-cflags="-DVK_ENABLE_BETA_EXTENSIONS=0 -fPIC" \
        --enable-cross-compile \
        --enable-runtime-cpudetect \
        --enable-hwaccels \
        --enable-gpl \
        --enable-neon \
        --enable-asm \
        --enable-small \
        --enable-shared \
        --disable-static \
        --disable-debug \
        --disable-doc \
        --disable-programs \
        --disable-avdevice \
        --enable-avcodec \
        --enable-avformat \
        --enable-avutil \
        --enable-swresample \
        --enable-swscale \
        --enable-avfilter \
        --enable-network \
        --enable-bsfs \
        --enable-postproc \
        --enable-filters \
        --enable-encoders \
        --enable-decoders \
        --enable-muxers \
        --enable-demuxers \
        --enable-parsers \
        --enable-protocols \
        --enable-jni \
        --enable-mediacodec \
        --enable-decoder=h264_mediacodec \
        --enable-decoder=hevc_mediacodec \
        --enable-decoder=mpeg4_mediacodec \
        --enable-decoder=vp9_mediacodec \
        $EXTRA_OPTIONS

    echo "=====> make -j16"
    make -j16
    echo "=====> make install"
    make install
	echo "编译结束！"
}

echo "
#############################
 1、ABI=armeabi-v7a
 2、ABI=arm64-v8a
 3、ABI=x86
 4、ABI=x86_64
#############################
"
read -p "please select API num：" num
case $num in
    1)
        ABI=armeabi-v7a
        ARCH=arm
        CPU=armv7-a
        API=19
        PLATFORM=armv7a
        ANDROID=androideabi
        EXTRA_OPTIONS="--enable-neon"
        build
    ;;
    2)
        ABI=arm64-v8a
        ARCH=aarch64
        CPU=armv8-a
        API=21
        PLATFORM=aarch64
        ANDROID=android
        EXTRA_OPTIONS="--enable-neon"
        build
    ;;
    3)
        ABI=x86
        ARCH=x86
        CPU=i686
        API=19
        PLATFORM=i686
        ANDROID=android
        EXTRA_OPTIONS="--disable-asm"
        build
    ;;
    4)
        ABI=x86_64
        ARCH=x86_64
        CPU=x86_64
        API=21
        PLATFORM=x86_64
        ANDROID=android
        EXTRA_OPTIONS=
        build
    ;;
    *)
        echo "please input [1|2|3|4] to build ffmpeg!"
    ;;
esac