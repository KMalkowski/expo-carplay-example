import UIKit
import CarPlay

class CarSceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, 
                                   didConnect interfaceController: CPInterfaceController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.initAppFromScene(nil)
        
        RNCarPlay.connect(with: interfaceController, window: templateApplicationScene.carWindow)
    }

    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, 
                                   didDisconnect interfaceController: CPInterfaceController) {
        RNCarPlay.disconnect()
    }
}