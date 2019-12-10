import UIKit
import Flutter
import ARKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "AR", binaryMessenger: controller.binaryMessenger)
        
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "get" else {
                
                
                
                return
            }
            self.startAr()
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",message: "Battery info unavailable",details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
    
    func startAr(){
        let ar = ArViewController()
        UIApplication.shared.keyWindow?.rootViewController?.present(ar, animated: true, completion: nil)
    }
}


class ArViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreateAr()
    }
    
    func CreateAr(){
        if #available(iOS 11.0, *) {
            var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x:160,y: 284)
            label.textAlignment = .center
            label.backgroundColor = UIColor.red
            label.text = "I'm a test label"
            self.view.addSubview(label)
            self.view.backgroundColor = UIColor.blue
        } else {
            // Fallback on earlier versions
            print("errrorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
        }
    }
}
