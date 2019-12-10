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
            let ar = ARSCNView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            let config = ARWorldTrackingConfiguration()
            ar.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
            ARSCNDebugOptions.showWorldOrigin]
            ar.session.run(config)
            addItems(sceneView: ar)
            self.view.addSubview(ar)
            self.view.backgroundColor = UIColor.blue
        } else {
            // Fallback on earlier versions
            print("errrorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
        }
    }
    
    @available(iOS 11.0, *)
    func addItems(sceneView:ARSCNView){
        let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        node.geometry = SCNCapsule(capRadius: 0.1/2 ,height: 0.3/2)
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/4)
        node.geometry = SCNPyramid(width: 0.1, height: 0.08, length: 0.1)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node.position = SCNVector3(0.0,0.0,-0.2)
        boxNode.position = SCNVector3(0,-0.05,0)
        doorNode.position = SCNVector3(0, 0, 0.06)
        //node.eulerAngles = SCNVector3(0,0,180.degreesToRadiansFloat)
        sceneView.scene.rootNode.addChildNode(node)
        node.addChildNode(boxNode)
        boxNode.addChildNode(doorNode)
    }
}
extension Int {
    var degreesToRadians: Double {
        return Double(self) * .pi/180
    }
}

extension Int {
    var degreesToRadiansFloat: Float {
        return (Double(self) * .pi/180).toFloat
    }
}

extension Double {
    var toFloat: Float {
        return Float(self)
    }
}
