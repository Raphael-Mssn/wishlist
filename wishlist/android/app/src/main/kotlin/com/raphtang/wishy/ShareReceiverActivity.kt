package com.raphtang.wishy

import android.app.Activity
import android.content.Intent
import android.os.Bundle

/**
 * Point d'entrée des partages (SEND / SEND_MULTIPLE), sans interface.
 *
 * Le sélecteur de partage d'Android lance la cible dans la tâche de l'app
 * source (ex. Amazon) avec des flags (MULTIPLE_TASK, NEW_DOCUMENT) qui
 * passent outre le launchMode de MainActivity : MainActivity recevait donc le
 * partage dans une seconde instance, avec un second moteur Flutter qui restait
 * sur un écran noir.
 *
 * Cette activité transmet le partage à MainActivity depuis Wishy lui-même,
 * avec des flags maîtrisés : l'instance existante le reçoit via onNewIntent,
 * ou MainActivity démarre normalement si l'app n'était pas lancée.
 */
class ShareReceiverActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val forward = Intent(intent).apply {
            setClass(this@ShareReceiverActivity, MainActivity::class.java)
            // Les flags d'origine sont remplacés ; les droits de lecture sur les
            // URI partagées (images) sont re-transmis, sinon ils disparaissent
            // avec cette activité.
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_GRANT_READ_URI_PERMISSION
        }
        startActivity(forward)
        finish()
    }
}
