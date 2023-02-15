package com.example.libraries

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import br.com.mauker.browsr.lib.BrowsrSDK
import br.com.mauker.browsr.lib.BrowsrLib
import io.flutter.plugin.common.PluginRegistry.*
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import kotlin.reflect.full.memberProperties
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** LibrariesPlugin */
class LibrariesPlugin(): FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private lateinit var context : Context
    private lateinit var sdk: BrowsrLib
    private var parentJob: Job? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.getApplicationContext(),flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger, @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "libraries")
        sdk = BrowsrSDK(context)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "getOrganizations" -> {
                parentJob = CoroutineScope(Dispatchers.IO).launch {
                    val orgs = sdk.getOrganizations()
                    val transformedOrgs = orgs.map { it.asMap() }

                    withContext(Dispatchers.Main) {
                        result.success(transformedOrgs)
                    }
                }
            }
            "setFavoriteOrg" -> {
                if (call.hasArgument("org_id")) {
                    val id: Int? = call.argument("org_id")

                    CoroutineScope(Dispatchers.IO).launch {
                        sdk.setFavorite(id as Int)
                    }
                }
            }
            "removeFavoriteOrg" -> {
                if (call.hasArgument("org_id")) {
                    val id: Int? = call.argument("org_id")

                    CoroutineScope(Dispatchers.IO).launch {
                        sdk.removeFavorite(id as Int)
                    }
                }
            }
            "removeAllFavorites" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    sdk.removeAllFavorites()
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        parentJob?.cancel()
    }

    inline fun <reified T : Any> T.asMap() : Map<String, Any?> {
        val props = T::class.memberProperties.associateBy { it.name }
        return props.keys.associateWith { props[it]?.get(this) }
    }
}
