//
//  pushNotificationModel.swift
//  HayStack-Latest
//
//  Created by rajesh gandru on 15/12/22.
//

import Foundation
//import Foundation
//import UIKit
//import Firebase
//import FirebaseMessaging
//import UserNotifications
//
//class PushNotificationManager : NSObject, MessagingDelegate, UNUserNotificationCenterDelegate  {
//
//    static let shared = PushNotificationManager( )
//
//    var userID: String = ""
//    var instanceIDToken : String = ""
//    let defaults = UserDefaults.standard
//
//    override init( ) {
//        super.init()
//    }
//
//    func setUserId(identifier: String) {
//        userID = identifier
//    }
//
//    func registerForPushNotifications() {
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM)
//            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//
//        UIApplication.shared.registerForRemoteNotifications()
//        UNMutableNotificationContent().sound = UNNotificationSound.default
//
//
//            // Messaging.messaging().shouldEstablishDirectChannel = true
//
//        updateFirestorePushTokenIfNeeded()
//    }
//
//
//    func getNotificationSettings( ) {
//        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else {return}
//            DispatchQueue.main.async{UIApplication.shared.registerForRemoteNotifications()}
//        }
//    }
//
//    func updateFirestorePushTokenIfNeeded( ) {
//      //  let mytoken = Messaging.messaging().fcmToken
//        if let token = Messaging.messaging().fcmToken {
//            let usersRef = Firestore.firestore().collection("users_table").document(userID)
//            usersRef.setData(["fcmToken": token], merge: true)
//        }
//    }
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }
//
//    func application(received remoteMessage: MessagingRemoteMessage) {
//        print("applicationReceivedRemoteMessage")
//        print(remoteMessage.appData)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        print("REMOTE NOTIFICATION RECEIVED")
//    }
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//        updateFirestorePushTokenIfNeeded()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(response)
//    }
//
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound])
//    }
//
//    func getTokenDirectly( ) {
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remoted instance ID token: \(result.token)")
//                self.instanceIDToken = result.token
//                self.updateFirestorePushTokenIfNeeded()
//            }
//        }
//    }
//}
