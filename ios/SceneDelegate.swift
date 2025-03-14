import UIKit
import ExpoModulesCore
import React

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let hasCreatedBridge = appDelegate.initApp(from: connectionOptions)

        let rootViewController = appDelegate.createRootViewController()
        appDelegate.setRootView(appDelegate.rootView, to: rootViewController)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        self.window = window
        appDelegate.window = window
        window.makeKeyAndVisible()

        let splashScreenService = EXModuleRegistryProvider.getSingletonModule(for: EXSplashScreenService.self) as? EXSplashScreenService

        appDelegate.finishedLaunching(with: connectionOptions)

        if !hasCreatedBridge {
            splashScreenService?.hideSplashScreen(for: rootViewController, options: .default, successCallback: { _ in }, failureCallback: { message in
                print("Hiding splash screen from root view controller did not succeed: \(message)")
            })
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.application(UIApplication.shared, continue: userActivity, restorationHandler: { _ in })
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let context = URLContexts.first {
            let url = context.url
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.application(UIApplication.shared, open: url, options: [:])
        }
    }
}