import UIKit
import Flutter
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Initialize Flutter engine
    let flutterEngine = FlutterEngine(name: "main_engine")
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)

    // Attach Flutter view controller manually
    let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = flutterViewController
    self.window?.makeKeyAndVisible()

    print("Flutter view controller attached manually.")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
