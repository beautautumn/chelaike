import UIKit
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?
    var mainViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = UserModel.currentUser() {
            self.mainViewController = MainViewController()
            EnumerizeModel.setup()
        } else {
            self.mainViewController = LoginViewController()
        }
        PgyUpdateManager.sharedPgy().start(withAppId: ConfigUtils.pgyerAppKey())
        PgyUpdateManager.sharedPgy().checkUpdate()
        self.window!.rootViewController = self.mainViewController
        self.window!.makeKeyAndVisible()

        if #available(iOS 10, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            
        } else if #available(iOS 8, *) {
            // 可以自定义 categories
            JPUSHService.register(
                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                    UIUserNotificationType.sound.rawValue |
                    UIUserNotificationType.alert.rawValue,
                categories: nil)
        } else {
            // ios 8 以前 categories 必须为nil
            JPUSHService.register(
                forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
                    UIRemoteNotificationType.sound.rawValue |
                    UIRemoteNotificationType.alert.rawValue,
                categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: ConfigUtils.jpushKey(), channel: "web", apsForProduction: true)
        if let options = launchOptions {
            if let userInfo = options[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                // app关闭后点击远程消息
                self.onReceiveMessage(userInfo)
            }
        }

        IQKeyboardManager.shared.enable = true

        AMapServices.shared().apiKey = ConfigUtils.mapAppKey()
        
        return true
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        //    app打开时点击消息
        let userInfo = response.notification.request.content.userInfo
        self.onReceiveMessage(userInfo)
    }
    
    func onReceiveMessage(_ userInfo: [AnyHashable : Any]) {
        if let data = (userInfo as NSDictionary) as? [String: Any] {
            if let state = data["state"] as? String {
                if let billId = data["billId"] as? String {
                    switch state {
                    case "还款申请", "还款状态变更":
                        let controller = RepaymentDetailViewController()
                        controller.recordId = Int(billId)
                        let navigation = UINavigationController(rootViewController: controller)
                        self.mainViewController?.present(navigation, animated: true, completion: nil)
                    case "换车申请", "换车状态变更":
                        let controller = ReplaceDetailViewController()
                        controller.recordId = Int(billId)
                        let navigation = UINavigationController(rootViewController: controller)
                        self.mainViewController?.present(navigation, animated: true, completion: nil)
                    default:
                        let controller = LoanDetailViewController()
                        controller.recordId = Int(billId)
                        let navigation = UINavigationController(rootViewController: controller)
                        self.mainViewController?.present(navigation, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!,
                                 withCompletionHandler completionHandler: ((Int) -> Void)!) {
        //    收到消息
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue));
        NotificationCenter.default.post(name: NSNotification.Name("MessageRefresh"),
                                        object: nil,
                                        userInfo: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AddNotificationCount"), object: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "StopStatisticsTimer"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "RestartStatisticsTimer"), object: nil)
    }
}

