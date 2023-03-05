package com.hezb.ffmpeg

import android.os.Bundle
import android.os.PersistableBundle
import android.text.method.ScrollingMovementMethod
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

/**
 * Project Name: AndroidFFmpegEditor
 * File Name:    MainActivity
 *
 * Description: Main.
 *
 * @author  hezhubo
 * @date    2022年12月25日 16:08
 */
class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<TextView>(R.id.tv_test).let {
            it.movementMethod = ScrollingMovementMethod.getInstance()
            it.text = FFmpegCmd.getConfiguration()
        }

    }

}