#!/bin/bash
echo "进入编译ffmpeg脚本"
NDK=/Users/hezhubo/soft/android-ndk-r14b
#5.0
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
SYSROOT=$NDK_PATH/platforms/android-21/arch-arm

#输出路径
PREFIX=./android/$CPU
function buildFF {
    echo "开始编译ffmpeg"
    ./configure \
        --prefix=$PREFIX \
        --target-os=android \
        --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
        --arch=arm \
        --cpu=$CPU  \
        --sysroot=$SYSROOT \
        --extra-cflags="$CFLAG" \
        --cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
        --nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
        --enable-shared \
        --enable-runtime-cpudetect \
        --enable-gpl \
        --enable-small \
        --enable-cross-compile \
        --disable-debug \
        --disable-static \
        --disable-doc \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-ffserver \
        --disable-postproc \
        --disable-avdevice \
        --disable-symver \
        --disable-stripping \
        $ADD

    make -j16
    make install
    echo "编译结束！"

    # --enable-static 编译静态库时，把库进行合并
    echo "=====> 准备合并.a 输出libffmpeg.so"

    $TOOLCHAINS/ld \
        -rpath-link="$SYSROOT/usr/lib" \
        -L$SYSROOT/usr/lib \
        -L$PREFIX/lib \
        -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
        $PREFIX/libffmpeg.so \
        libavcodec/libavcodec.a \
        libavfilter/libavfilter.a \
        libswresample/libswresample.a \
        libavformat/libavformat.a \
        libavutil/libavutil.a \
        libswscale/libswscale.a \
        libpostproc/libpostproc.a \
        -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
        $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a

    echo "合并完成！"
}

###########################################################
echo "编译支持neon和硬解码"
CPU=armv7-a
PREFIX=./android/$CPU-neon-hard
CFLAG="-I$SYSROOT/usr/include -fPIC -DANDROID -mfpu=neon -mfloat-abi=softfp "
ADD="--enable-asm \
 --enable-neon \
 --enable-jni \
 --enable-mediacodec \
 --enable-decoder=h264_mediacodec \
 --enable-hwaccel=h264_mediacodec "
buildFF

###########################################################
echo "编译不支持neon和硬解码"
CPU=armv7-a
PREFIX=./android/$CPU
CFLAG="-I$SYSROOT/usr/include -fPIC -DANDROID -mfpu=vfp -mfloat-abi=softfp "
ADD=""
buildFF