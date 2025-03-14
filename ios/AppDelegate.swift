import UIKit
import Expo
import ExpoModulesCore
import React

@UIApplicationMain
@objc class AppDelegate: EXExpoAppDelegateWrapper {
    // MARK: - Properties
    private var reactDelegate: EXReactDelegateWrapper?

    // MARK: - Initialization
    override init() {
        super.init()
        self.reactDelegate = EXReactDelegateWrapper(expoReactDelegate: expoAppDelegate.reactDelegate)
    }

    // MARK: - App Lifecycle
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        moduleName = "main"  // Set your RN module name
        initialProps = [:]   // Add custom props if needed
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - RCTAppDelegate Overrides
    override func sourceURL(for bridge: RCTBridge!) -> URL! {
        return bundleURL()  // Delegate to bundleURL()
    }

    override func bundleURL() -> URL! {
        #if DEBUG
            let url = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: ".expo/.virtual-metro-entry")
            return url ?? Bundle.main.url(forResource: "main", withExtension: "jsbundle")!
        #else
            return Bundle.main.url(forResource: "main", withExtension: "jsbundle")!
        #endif
    }

    @objc func bundleURL() -> URL {
        return bundleURL() as URL  // Convert URL! to URL
    }

    // MARK: - Linking (Optional)
    override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return super.application(application, open: url, options: options) || RCTLinkingManager.application(application, open: url, options: options)
    }

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let result = RCTLinkingManager.application(application, continue: userActivity, restorationHandler: restorationHandler)
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler) || result
    }

    // MARK: - Root View Factory (For TurboModules)
    override func createRCTRootViewFactory() -> RCTRootViewFactory! {
        let configuration = RCTRootViewFactoryConfiguration(
            bundleURL: bundleURL(),
            newArchEnabled: fabricEnabled,
            turboModuleEnabled: turboModuleEnabled,
            bridgelessEnabled: bridgelessEnabled
        )

        configuration.createRootViewWithBridge = { [weak self] bridge, moduleName, initProps in
            return self?.createRootView(with: bridge, moduleName: moduleName, initProps: initProps)
        }

        configuration.createBridgeWithDelegate = { [weak self] delegate, launchOptions in
            return self?.createBridge(with: delegate, launchOptions: launchOptions)
        }

        return EXReactRootViewFactory(reactDelegate: self.reactDelegate!, configuration: configuration, turboModuleManagerDelegate: self)
    }
}

// MARK: - RCTTurboModuleManagerDelegate
extension AppDelegate: RCTTurboModuleManagerDelegate {
    // Add TurboModule delegate methods if needed for your plugin
}