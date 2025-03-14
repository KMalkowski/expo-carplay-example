import UIKit
import Expo
import ExpoModulesCore
import React

@UIApplicationMain
@objc
class AppDelegate: EXReactDelegateWrapper, UIApplicationDelegate, RCTBridgeDelegate {
    // MARK: - Properties
    
    private let moduleName = "main"  // RN module name
    private let initialProps: [String: Any] = [:]  // Initial props
    private var window: UIWindow?  // Add window property
    
    // MARK: - App Lifecycle
    
    @discardableResult
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the bridge with self as the delegate
        guard let bridge = RCTBridge(delegate: self, launchOptions: launchOptions) else {
            print("Failed to initialize RCTBridge")
            return false
        }
        
        // Create the root view with the unwrapped bridge
        let rootView = RCTRootView(
            bridge: bridge,
            moduleName: moduleName,
            initialProperties: initialProps
        )
        
        // Set up the window
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UIViewController()
        rootViewController.view = rootView
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
    
    // MARK: - RCTBridgeDelegate Methods
    
    func sourceURL(for bridge: RCTBridge!) -> URL! {
        return bundleURL()
    }
    
    func bundleURL() -> URL? {
        #if DEBUG
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: ".expo/.virtual-metro-entry")
            ?? Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
    
    // MARK: - Linking
    
    func application(_ application: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return RCTLinkingManager.application(application, open: url, options: options)
    }
    
    func application(_ application: UIApplication,
                    continue userActivity: NSUserActivity,
                    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return RCTLinkingManager.application(application,
                                           continue: userActivity,
                                           restorationHandler: restorationHandler)
    }
    
    // MARK: - Root View Factory
    
    override func createRCTRootViewFactory() -> RCTRootViewFactory {
        let configuration = RCTRootViewFactoryConfiguration(
            bundleURL: bundleURL(),
            newArchEnabled: fabricEnabled,
            turboModuleEnabled: turboModuleEnabled,
            bridgelessEnabled: bridgelessEnabled
        )
        
        return EXReactRootViewFactory(
            reactDelegate: self,
            configuration: configuration,
            turboModuleManagerDelegate: self
        )
    }
}

// MARK: - RCTTurboModuleManagerDelegate
extension AppDelegate: RCTTurboModuleManagerDelegate {
    // Implement required TurboModule delegate methods here if needed
}