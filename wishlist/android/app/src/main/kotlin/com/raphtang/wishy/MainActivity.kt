package com.raphtang.wishy

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.raphtang.wishy/share_intent"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val activity = this
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialSharedText" -> result.success(activity.getSharedTextFromIntent(activity.intent))
                "getInitialShareExtras" -> result.success(activity.getShareExtrasFromIntent(activity.intent))
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    /**
     * Retourne les extras utiles du partage (ex. Amazon envoie url, imgUrl).
     * Utilisé par Flutter pour préremplir avec l'image et le lien canonique.
     */
    private fun getShareExtrasFromIntent(intent: Intent?): Map<String, String>? {
        if (intent == null) return null
        val target = when (intent.action) {
            Intent.ACTION_SEND -> intent
            Intent.ACTION_CHOOSER -> {
                if (android.os.Build.VERSION.SDK_INT >= 33) {
                    intent.getParcelableExtra(Intent.EXTRA_INTENT, Intent::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableExtra(Intent.EXTRA_INTENT) as? Intent
                } ?: intent
            }
            else -> return null
        }
        if (target.action != Intent.ACTION_SEND) return null
        val map = mutableMapOf<String, String>()
        target.extras?.keySet()?.forEach { key ->
            val value = target.extras?.get(key)
            if (value is String && value.isNotBlank()) {
                map[key.toString()] = value.trim()
            }
        }
        return map.takeIf { it.isNotEmpty() }
    }

    /**
     * Lit le texte partagé depuis l'intent (EXTRA_TEXT, EXTRA_SUBJECT, EXTRA_STREAM ou ClipData).
     * Complément au plugin share_intent_package pour les partages type text/uri-list (ex. Fnac)
     * ou quand le texte est dans ClipData (Android 10+).
     */
    private fun getSharedTextFromIntent(intent: Intent?): String? {
        if (intent == null) return null
        val target = when (intent.action) {
            Intent.ACTION_SEND -> intent
            Intent.ACTION_CHOOSER -> {
                if (android.os.Build.VERSION.SDK_INT >= 33) {
                    intent.getParcelableExtra(Intent.EXTRA_INTENT, Intent::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableExtra(Intent.EXTRA_INTENT) as? Intent
                } ?: intent
            }
            else -> return null
        }
        if (target.action != Intent.ACTION_SEND) return null
        val type = target.type
        if (type == null || !type.startsWith("text/")) return null

        val subject = target.getStringExtra(Intent.EXTRA_SUBJECT)?.trim()?.takeIf { it.isNotEmpty() }
        val extraText = target.getStringExtra(Intent.EXTRA_TEXT)?.trim()?.takeIf { it.isNotEmpty() }
        if (subject != null || extraText != null) {
            val combined = when {
                subject != null && extraText != null -> "$subject $extraText"
                extraText != null -> extraText
                else -> subject
            }
            if (combined != null) return combined
        }

        target.getStringExtra(Intent.EXTRA_TEXT)?.trim()?.takeIf { it.isNotEmpty() }?.let { return it }

        val streamUri = if (android.os.Build.VERSION.SDK_INT >= 33) {
            target.getParcelableExtra(Intent.EXTRA_STREAM, android.net.Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            target.getParcelableExtra(Intent.EXTRA_STREAM) as? android.net.Uri
        }
        if (streamUri != null) readUriAsText(streamUri)?.let { return it }

        target.clipData?.let { clip ->
            if (clip.itemCount > 0) {
                clip.getItemAt(0).uri?.let { uri -> readUriAsText(uri)?.let { return it } }
            }
        }

        if (intent !== target && intent.clipData != null) {
            val clip = intent.clipData!!
            if (clip.itemCount > 0) {
                clip.getItemAt(0).uri?.let { uri -> readUriAsText(uri)?.let { return it } }
            }
        }

        return null
    }

    private fun readUriAsText(uri: android.net.Uri): String? {
        return try {
            contentResolver.openInputStream(uri)?.use { input ->
                BufferedReader(InputStreamReader(input)).use { reader ->
                    reader.readText().trim().takeIf { it.isNotEmpty() }
                }
            }
        } catch (_: Exception) {
            null
        }
    }
}
