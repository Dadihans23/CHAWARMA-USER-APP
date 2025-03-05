import UIKit
import Flutter
import GoogleMaps
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyAxJmVGEVe1mAot3ZhjJF5C7vI9rdZcgdQ")
    GeneratedPluginRegistrant.register(with: self)

    // this is for for ground services
        SwiftFlutterForegroundTaskPlugin.setPluginRegistrantCallback { registry in
          GeneratedPluginRegistrant.register(with: registry)
        }
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
