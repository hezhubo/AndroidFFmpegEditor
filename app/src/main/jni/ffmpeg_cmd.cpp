#include <jni.h>

extern "C" {

    #include "include/libavcodec/avcodec.h"

    JNIEXPORT jstring JNICALL
    Java_com_hezb_ffmpeg_FFmpegCmd_getConfiguration(JNIEnv *env, jobject thiz) {
        char info[10000] = {0};
        sprintf(info, "%s\n", avcodec_configuration());
        return env->NewStringUTF(info);
    }

}

