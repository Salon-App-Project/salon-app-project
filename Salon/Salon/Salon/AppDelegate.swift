
import UIKit
import IQKeyboardManagerSwift
import ParseSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static let sharedManager = AppDelegate()
    class AppDelegate {
        class var sharedInstance: AppDelegate {
            return sharedManager
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        UIApplication.shared.registerForRemoteNotifications()
        
        ParseSwift.initialize(applicationId: "LJ4TDrxv0l0n3FmE1hZLZi4Octtpik87LzuliZsz",
                              clientKey: "XoBKwgM1GKcPgxY9aMUmDW3YOzFAwjp7mQN1Etf0",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)

        NotificationCenter.default.addObserver(forName: Notification.Name("login"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.login()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name("loginsalon"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.loginSalon()
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("logout"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.logOut()
        }
        
        if User.current != nil {
            if let type = User.current!.usertype {
                if type == "user" {
                    login()
                }
                else {
                    loginSalon()
                }
            }
        }
        
        return true
    }

    private func login() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigation")
    }
    
    private func loginSalon() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SalonHomeNavigation")
        
    }

    private func logOut() {
        User.logout { [weak self] result in

            switch result {
            case .success:

                // Make sure UI updates are done on main thread when initiated from background thread.
                DispatchQueue.main.async {

                    // Instantiate the storyboard that contains the view controller you want to go to (i.e. destination view controller).
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    // Instantiate the destination view controller (in our case it's a navigation controller) from the storyboard.
                    let viewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigation")

                    // Programmatically set the current displayed view controller.
                    self?.window?.rootViewController = viewController
                }
            case .failure(let error):
                print("Log out error: \(error)")
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

