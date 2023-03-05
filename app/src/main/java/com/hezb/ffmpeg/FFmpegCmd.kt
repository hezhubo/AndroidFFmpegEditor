package com.hezb.ffmpeg

import androidx.annotation.Keep

/**
 * Project Name: AndroidFFmpegEditor
 * File Name:    FFmpegCmd
 *
 * Description: 运行ffmpeg命令.
 *
 * @author  hezhubo
 * @date    2022年11月30日 15:59
 */
@Keep
object FFmpegCmd {

    init {
        System.loadLibrary("avformat")
        System.loadLibrary("avcodec")
        System.loadLibrary("avfilter")
        System.loadLibrary("avutil")
        System.loadLibrary("swresample")
        System.loadLibrary("swscale")
        System.loadLibrary("postproc")
        System.loadLibrary("ffmpegCmd")
    }

    external fun getConfiguration(): String

    // TODO run ffmpeg command

}