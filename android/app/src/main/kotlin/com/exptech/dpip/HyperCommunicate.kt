package com.exptech.dpip

import NotificationHelper
import android.Manifest
import android.content.Context
import android.graphics.drawable.Icon
import android.os.Bundle
import android.widget.RemoteViews
import androidx.annotation.RequiresPermission
import com.hyperfocus.api.FocusApi
import com.hyperfocus.api.IslandApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import androidx.core.app.NotificationManagerCompat
import com.hyperfocus.api.info.ProgressInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;

class HyperCommunicate : MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var notificationHelper: NotificationHelper  // 延遲初始化
    fun registerWith(flutterEngine: FlutterEngine, context: Context) {
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hypercommunicate")
        channel.setMethodCallHandler(this)
        this.context = context
        notificationHelper = NotificationHelper(context)
    }


    @RequiresPermission(Manifest.permission.POST_NOTIFICATIONS)
    override fun onMethodCall(call: MethodCall, result: Result) {

        when (call.method) {
            "eew" -> {
                val args = call.arguments as Map<*, *>
                var time = args["time"] as Int
                val input = call.argument<String>("input")
                val sendNotification = notificationHelper.sendNotification("地震速報", "地震速報")
                val remoteViews = RemoteViews(context.packageName, R.layout.hyper_notify_eew)
                val pic = IslandApi.picInfo(
                    autoplay = true, effectColor = "#33B5E5", effectSrc = "inEffectSrc", pic = "pro"
                )
                val bigIslandArea = IslandApi.bigIslandArea(
                    imageTextInfoLeft = IslandApi.imageTextInfo(
                        textInfo = IslandApi.TextInfo(
                            turnAnim = true, title = "地震還有"
                        ), type = 1, picInfo = IslandApi.picInfo(
                            autoplay = true,
                            effectColor = "#33B5E5",
                            effectSrc = "inEffectSrc",
                            pic = "pro"
                        )
                    ), sameWidthDigitInfo = IslandApi.sameWidthDigitInfo(
                        digit = "11",
                        content = "後抵達",
                    )
                )

                val smallIslandArea = IslandApi.SmallIslandArea(
                    combinePicInfo = IslandApi.combinePicInfo(
                        picInfo = pic,
                        smallPicInfo = JSONObject(),
                        progressInfo = IslandApi.progressInfo(
                            colorReach = "#ff003c",
                            colorUnReach = "#000000",
                            progress = 50,
                        )
                    )
                )

                val islandTemplate = IslandApi.IslandTemplate(
                    highlightColor = "#FF47FF",
                    bigIslandArea = bigIslandArea,
                    smallIslandArea = smallIslandArea,
                    expandedTime = 60,
                    dismissIsland = false,
                    islandTimeout = 60,
                )
                val picProfiles = FocusApi.addpics(
                    "pro", Icon.createWithResource(context, R.drawable.res_app_icon)
                )
                val pica = FocusApi.addpics(
                    "abc", Icon.createWithResource(context, R.drawable.res_app_icon)
                )
                val pics = Bundle()
                pics.putAll(picProfiles)
                pics.putAll(pica)
                val focus = FocusApi.sendDiyFocus(
                    rv = remoteViews,
                    rvNight = remoteViews,
                    rvAod = remoteViews,
                    island = islandTemplate,
                    ticker = "地震測試",
                    outEffectSrc = "charger_light_wave",
                    enableFloat = false,
                    picticker = Icon.createWithResource(
                        this.context, R.drawable.res_app_icon
                    ),
                    addpics = pics
                )
                sendNotification.addExtras(focus)
                NotificationManagerCompat.from(context).notify(1, sendNotification.build())
                result.success(1)
            }

            else -> result.notImplemented()
        }
    }
}
