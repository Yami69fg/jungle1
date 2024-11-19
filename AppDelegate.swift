import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var mainWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.mainWindow = UIWindow(frame: UIScreen.main.bounds)
        self.mainWindow?.rootViewController = UINavigationController(rootViewController: JungleLoadingViewController())
        self.mainWindow?.makeKeyAndVisible()
        
        if UserDefaults.standard.object(forKey: "soundOn") == nil {
            UserDefaults.standard.set(true, forKey: "soundOn")
        }
        if UserDefaults.standard.object(forKey: "vibrationOn") == nil {
            UserDefaults.standard.set(true, forKey: "vibrationOn")
        }
        if UserDefaults.standard.string(forKey: "jungleSelectedImageName") == nil {
            UserDefaults.standard.set("MainJungle", forKey: "jungleSelectedImageName")
        }
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        return .portrait
    }


}

