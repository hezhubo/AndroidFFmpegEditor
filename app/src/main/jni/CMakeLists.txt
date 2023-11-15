cmake_minimum_required(VERSION 3.22.1)

project(FFMPEG_CMD)

# 支持c++11
set(CMAKE_CXX_FLAGS "-std=gnu++11 ${CMAKE_CXX_FLAGS}")

# 定义ffmpeg库和头文件目录
#set(ffmpeg_dir /Users/hezhubo/project/github/FFmpeg) #修改路径
#set(ffmpeg_lib_dir ${ffmpeg_dir}/android/${CMAKE_ANDROID_ARCH_ABI}/lib)
set(ffmpeg_lib_dir ${CMAKE_SOURCE_DIR}/libs/${CMAKE_ANDROID_ARCH_ABI})
set(ffmpeg_head_dir ${CMAKE_SOURCE_DIR}/include)

# 添加ffmpeg库
add_library(avcodec
        SHARED
        IMPORTED)
set_target_properties(avcodec
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libavcodec.so)

add_library(avfilter
        SHARED
        IMPORTED)
set_target_properties(avfilter
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libavfilter.so)

add_library(avformat
        SHARED
        IMPORTED)
set_target_properties(avformat
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libavformat.so)

add_library(avutil
        SHARED
        IMPORTED)
set_target_properties(avutil
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libavutil.so)

add_library(postproc
        SHARED
        IMPORTED)
set_target_properties(postproc
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libpostproc.so)

add_library(swresample
        SHARED
        IMPORTED)
set_target_properties(swresample
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libswresample.so)

add_library(swscale
        SHARED
        IMPORTED)
set_target_properties(swscale
        PROPERTIES IMPORTED_LOCATION
        ${ffmpeg_lib_dir}/libswscale.so)

# ffmpeg库集合
set(ffmpeg-libs
        avformat
        avcodec
        avfilter
        avutil
        swresample
        swscale
        postproc)

# 添加头文件目录
include_directories(${ffmpeg_head_dir})

# 使用到的系统库集合
set(native-libs
        android
        OpenSLES
        log
        m
        z)

# 添加动态库
add_library(ffmpegCmd
        SHARED
        ffmpeg_cmd.cpp)

# 链接库
target_link_libraries(ffmpegCmd
        ${ffmpeg-libs}
        ${native-libs})