import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
    var urlChannel: FlutterMethodChannel?;
    var versionChannel: FlutterMethodChannel?;
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller = window.rootViewController as? FlutterViewController;
    urlChannel = FlutterMethodChannel.init(name: "deeplink.channel/registration", binaryMessenger: controller!);
    let versionChannel = FlutterMethodChannel.init(name: "getVersionChannel", binaryMessenger: controller!);
    
    versionChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        // Handle battery messages.
        switch (call.method) {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion);
        case "getAppVersionName":
            result(Bundle.main.releaseVersionNumber);
        case "getAppVersionCode":
            result(Bundle.main.buildVersionNumber);
        case "getAppID":
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                result(bundleIdentifier) //Your App ID on App Store
            } else {
                result("No App ID Found");
            }
            
        default:
            result(FlutterMethodNotImplemented);
        }
    });
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
 
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    // chiamata quando si apre l'app da un link
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        NSLog("url host \(url.host)")
        NSLog("url path \(url.path)")
        NSLog("url \(url)")
        let urlPath : String = url.path as String
        let urlHost : String = url.host as! String
        //let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", Bundle:nil)
        
        if (urlHost == "com.bajeli.infoscuolapp") {
            NSLog("INTERCEPTED com.bajeli.infoscuolapp OK!")
            NSLog("INTERCEPTED registration OK!" )
        }
        let verityToke=getQueryStringParameter(url: url.absoluteString,param:"verifyToken")
        urlChannel?.invokeMethod("autoRegistrationLogin",arguments: ["verifyToken":verityToke ])
        return true
    }
   
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
