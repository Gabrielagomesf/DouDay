package com.duoday.duoday

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {
    
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // Handle received FCM messages
        super.onMessageReceived(remoteMessage)
    }
    
    override fun onNewToken(token: String) {
        // Handle FCM token refresh
        super.onNewToken(token)
    }
}
