import UIKit
import CoreData
import GooglePlaces
import IQKeyboardManagerSwift
import GoogleMaps
import FirebaseCore
import Firebase
import FirebaseMessaging
 

var LognedUserType = ""
var newDeviceId = ""
var inServerSavedDeviceId = ""
let GOOGLE_API_KEY = "AIzaSyAK7N4kOTSAWpSlzoOQk9_dKp9Sci2sshY"

@main
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate{

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0);
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppUpdater.shared.showUpdate(withConfirmation: false)
        //API key in GMSServices and GMSPlaceClient
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        //FirebaseApp.configure()
        self.FireBaseAppDelegateDidFineshMethod(application : application, launchOptions: launchOptions)
        self.navigateToPage()
        self.setupIQKeyboardManager()
        return true
    }
  
    func navigateToPage(){
        
        if let loginedUser = UserDefaults.standard.string(forKey: "LognedUserType")  as? String{
            LognedUserType = loginedUser
        }
 
        if UserDefaults.standard.bool(forKey: "IsUserLogined") {
          var navigation = UINavigationController()
          let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "DashBoard", bundle: nil)
        
              let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "mainTabvC") as! mainTabvC
              self.window = UIWindow(frame: UIScreen.main.bounds)
              navigation = UINavigationController(rootViewController: initialViewControlleripad)
        
          self.window?.rootViewController = navigation
          self.window?.makeKeyAndVisible()
        }else {
            var navigation = UINavigationController()
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          
                let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.window = UIWindow(frame: UIScreen.main.bounds)
                navigation = UINavigationController(rootViewController: initialViewControlleripad)
          
            self.window?.rootViewController = navigation
            self.window?.makeKeyAndVisible()
        }
          
      }

    func setupIQKeyboardManager(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
     
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppUpdater.shared.showUpdate(withConfirmation: false)
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HayStack_Latest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate {
    
    func FireBaseAppDelegateDidFineshMethod(application : UIApplication,launchOptions : [UIApplication.LaunchOptionsKey: Any]?){
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        handleNotificationWhenAppIsKilled(launchOptions)
         //remote Notifications
        if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, err) in
                if err != nil {
                    //Something bad happend
                } else {
                    UNUserNotificationCenter.current().delegate = self
                    //  Messaging.messaging().delegate = self
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
         if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert], completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            })
        }else{
            let notificationSettings = UIUserNotificationSettings(types: [.badge,.sound,.alert], categories: nil)
            DispatchQueue.main.async {
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func handleNotificationWhenAppIsKilled(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        // Check if launched from the remote notification and application is close
        
        if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
            
            let result = remoteNotification as! Dictionary<String,AnyObject>
            
            print(result)
            
            if let alert = result["type"] as? String {
                
            
        }
        }
    }
    
}
extension AppDelegate:UNUserNotificationCenterDelegate{
    // Push Notification
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("\n\n\n\n\n ==== FCM Token:  ",fcmToken)
        connectToFcm()
    }
    
   
    
    // Push Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("tap on on forground app",userInfo)
        
        let result = userInfo as! Dictionary<String,AnyObject>
        
        print(result)
        
        let state = UIApplication.shared.applicationState
        
        if state == .background{
            
 
        }else if state == .active {
            
 
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error.localizedDescription)
        print("Not registered notification")
    }
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let refreshedToken = Messaging.messaging().fcmToken {
            print("InstanceID token: \(refreshedToken)")
            newDeviceId = refreshedToken
            print(newDeviceId)
            Messaging.messaging().apnsToken = deviceToken
            print("Token generated: ", refreshedToken)
        }
        UserDefaults.standard.set(newDeviceId, forKey:"device_id")
        UserDefaults.standard.synchronize()
        //        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().isAutoInitEnabled = true
      //  Messaging.messaging().shouldEstablishDirectChannel = false

        //messaging().shouldEstablishDirectChannel = true
        if let token = Messaging.messaging().fcmToken {
            print("\n\n\n\n\n\n\n\n\n\n ====== TOKEN DCS: " + token)
        }
    }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//
//    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

//      let dataDict:[String: String] = ["token": fcmToken ?? ""]
//      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        
        print("Firebase registration token: \(fcmToken)")
        if let fcmTokenstr = fcmToken {
        newDeviceId = fcmTokenstr
        UserDefaults.standard.set(newDeviceId, forKey:"device_id")
        UserDefaults.standard.synchronize()
        let devicetoken : String!
        devicetoken = UserDefaults.standard.string(forKey:"device_id") as String?
        print(devicetoken)
        }
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let content = notification.request.content
        
        print("\(content.userInfo)")
        
        
        
        print("GOT A NOTIFICATION")
        
        
        let result = content.userInfo as! Dictionary<String,AnyObject>
        
        print(result)
        
        let state = UIApplication.shared.applicationState
        
        if state == .background{
            
          
            
        }else if state == .active {
            
        
        }
        
        
//        if self.window?.rootViewController?.topViewController is ConversationVC {
//            completionHandler([])
//        } else {
            completionHandler([.alert, .badge, .sound])
       // }
        
        //completionHandler([.alert, .sound])
        
    }
    
    func saveChatIDS(ChatID : String){
        let chatdata = UserDefaults.standard.value(forKey: "ChatIDArray") as? [String]
        print(chatdata)
        if chatdata?.count ?? 0 <= 0{
            var dataArray = [String]()
            dataArray.append(ChatID)
            UserDefaults.standard.setValue(dataArray, forKey: "ChatIDArray")
        }else{
            print(chatdata)
            var chatlistIds = [String]()
            chatlistIds = chatdata ?? []
            chatlistIds.append(ChatID)
            UserDefaults.standard.setValue(chatlistIds, forKey: "ChatIDArray")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IGotChatMSG"), object: nil,userInfo: ["ChatID" : ChatID])
    }
  
  
    
    
    func alerfunc(msg : String){
        let alert = UIAlertController(title: "HayStack -63d RD", message:msg, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
