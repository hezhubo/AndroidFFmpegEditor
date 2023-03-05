# FFmpeg编译说明
## 编译环境
* MacOS 13.0.1

* FFmpeg 5.1

* NDK r25c 25.2.9519653


## 准备工作
* 下载FFmpeg源码
  ```shell
  git clone https://github.com/FFmpeg/FFmpeg.git
  git checkout -b release/5.1 origin/release/5.1
  ```
* 修改so后缀（编译动态库时）
  默认编译出来so是个软链接，真正so名字后缀带有一长串主版本号与子版本号，这样的so名字在Android平台无法识别，需要修改根目录下的`configure`配置文件
  
  ```shell
  # SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'
  # LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
  # SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'
  # SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'
  # 使用以下配置替换上面配置
  SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'
  LIB_INSTALL_EXTRA_CMD='$$(RANLIB)"$(LIBDIR)/$(LIBNAME)"'
  SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'
  SLIB_INSTALL_LINKS='$(SLIBNAME)'
  ```
* 编译脚本
  把`ffmpeg_build_android.sh`复制到FFmpeg根目录，修改脚本文件的NDK路径，修改脚本文件的执行权限(chmod 777)

## 编译输出
执行`ffmpeg_build_android.sh`，编译成功后，so库输出在当前目录下的*./android/$CPU/lib*文件夹中

## 脚本配置说明
早在NDK-r18b版本就已移除GCC，此处脚本使用Clang/LLVM进行编译（网上大部分博客都是基于GCC去编译的，请参阅[Clang迁移说明](https://android.googlesource.com/platform/ndk/+/refs/heads/master/docs/ClangMigration.md)）  
而NDK的更新说明，请参阅[NDK修订历史记录](https://developer.android.google.cn/ndk/downloads/revision_history?hl=zh)  
当配置 **--target-os=android** 时，默认使用Clang编译  
GCC的一些配置可以无需设置，如 **--extra-cflags**、**--extra-ldflags**、**--cross-prefix**  

以下列出configure的常用配置说明（查看完整配置在根目录下执行 **./configure --help**）

| 配置                   | 描述                                                |
| ---------------------- | --------------------------------------------------- |
| --disable-static       | 不构建静态库                                        |
| --enable-shared        | 编译生成动态库                                      |
| --enable-small         | 降低库体积                                          |
|                        |                                                     |
| --disable-programs     | 不构建命令行程序(指ffmpeg、ffplay以及ffprobe)       |
| --disable-ffmpeg       | 不构建ffmpeg程序（转换器）                          |
| --disable-ffplay       | 不构建ffplay程序（播放器）                          |
| --disable-ffprobe      | 不构建ffprobe程序（查看多媒体文件的信息）           |
|                        |                                                     |
| --disable-doc          | 不产生文档                                          |
| --disable-htmlpages    | 不产生HTML类型的文档                                |
| --disable-manpages     | 不产生manpage类型的文档                             |
| --disable-podpages     | 不产生POD类型的文档                                 |
| --disable-txtpages     | 不产生text类型的文档                                |
|                        |                                                     |
| --disable-avdevice     | 不构建libavdevice库                                 |
| --disable-avcodec      | 不构建libavcodec库                                  |
| --disable-avformat     | 不构建libavformat库                                 |
| --disable-swresample   | 不构建libswresample库                               |
| --disable-swscale      | 不构建libswcale库                                   |
|                        |                                                     |
| --logfile              | 编译日志输出文件                                    |
| --enable-cross-compile | 开启交叉编译                                        |
| --enable-pic           | 生成位置无关代码                                    |
| --disable-asm          | 禁止所有汇编优化(默认开启的，关闭同时neon也关闭)    |
| --disable-neon         | 禁止NEON优化(一般情况下对于ARM架构推荐开启NEON优化) |
| --disable-debug        | 禁止调试符号(脚本中默认开启)                        |
| --prefix               | 设置动/静态库的输出位置                             |
| --target-os            | 运行系统                                            |
| --arch                 | 运行环境的CPU架构                                   |
| --cpu                  | CPU型号                                             |
| --sysroot              | 编译时指定逻辑目录                                  |
| --cc                   | 指定c编译器                                         |
| --cxx                  | 指定c++编译器                                       |
|                        |                                                     |

## 库裁剪

FFmpeg支持按需编译，减少库体积。可以使用 **--disable-everything** 关闭所有模块

* encoder/decoder（编解码器）
* protocol（协议）
* muxer/demuxer（封装/解封装器）
* parser（解析器）
* bsf（位流过滤器）
* filter（滤镜）
* hwaccel（硬件加速器）
* indev/outdev（输入/输出设备）

可以通过  **./configure --list-xxxs** 查看对应模块支持的格式/功能等

## 硬件加速配置

```shell
--enable-jin \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-decoder=hevc_mediacodec \
--enable-decoder=mpeg4_mediacodec \
--enable-decoder=vp9_mediacodec \
```

## 遇到问题

* /Users/hezhubo/Library/Android/sdk/ndk/25.1.8937393/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include/vulkan/vulkan.h:89:10:**fatal error:** 'vulkan_beta.h' file not found

  \#include "vulkan_beta.h"

  解决方案：

  1、禁用vulkan： **--disable-vulkan**

  2、配置 **--extra-cflags** 时添加 **-DVK_ENABLE_BETA_EXTENSIONS=0**，防止引用vulkan_beta.h头文件

## 关于第三方库

* Https (openssl)

  *         --enable-openssl \
            --enable-nonfree \  # 允许用户使用非开源的第三库
            --enable-protocol=https \

* Mp3lame

  * --enable-libmp3lame \

* X264

  * --enable-libx264 \

## 关于CMake

> CMake脚本命令查询：https://cmake.org/cmake/help/v3.22/manual/cmake-commands.7.html

注意库路径和头文件设置是否正确！！！

在使用ffmpeg编译出的静态库时（想要整合所有ffmpeg库编译出一个so），JNI代码中调用`avcodec_configuration`出现编译错误`ld: error: undefined symbol: avcodec_configuration`（可能编译的静态库有问题，暂时没有找到解决方案）

