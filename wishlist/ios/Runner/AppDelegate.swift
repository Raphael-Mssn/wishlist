import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  /// JSON lu depuis le conteneur App Group (shared_files/share_data.json) quand l’app est ouverte
  /// via l’URL SharingMedia (ShareExtension). Utilisé par getSharedDataFromContainer.
  private static var pendingContainerShareJson: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    #if DEBUG
    print("[Wishy Share] didFinishLaunching done, scheduling setupShareIntentChannel")
    #endif
    DispatchQueue.main.async { [weak self] in
      self?.setupShareIntentChannelWithRetry(attempt: 0)
    }
    return result
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    let urlString = url.absoluteString
    #if DEBUG
    print("[Wishy Share] application(open url) called: \(urlString.prefix(120))\(urlString.count > 120 ? "…" : "")")
    #endif
    // ShareExtension (share_intent_package) ouvre l’app via SharingMedia-xxx://
    if urlString.contains("ShareMedia") || urlString.contains("SharingMedia") {
      #if DEBUG
      print("[Wishy Share] Share URL detected, reading container file")
      #endif
      let appGroupId = "group.com.raphtang.wishy"
      if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) {
        let fileURL = containerURL.appendingPathComponent("shared_files/share_data.json")
        if FileManager.default.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let json = String(data: data, encoding: .utf8), !json.isEmpty {
          AppDelegate.pendingContainerShareJson = json
          try? FileManager.default.removeItem(at: fileURL)
          #if DEBUG
          print("[Wishy Share] Read \(json.count) chars from container file (application open url)")
          #endif
        } else {
          #if DEBUG
          print("[Wishy Share] No container file or empty at \(fileURL.path)")
          #endif
        }
      } else {
        #if DEBUG
        print("[Wishy Share] Runner has NO container access for '\(appGroupId)'")
        #endif
      }
    }
    return super.application(app, open: url, options: options)
  }

  private static let kMaxShareChannelRetries = 25
  private static let kShareChannelRetryInterval: TimeInterval = 0.1

  private func setupShareIntentChannelWithRetry(attempt: Int) {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      if attempt < AppDelegate.kMaxShareChannelRetries {
        #if DEBUG
        print("[Wishy Share] setupShareIntentChannel: no FlutterViewController yet (attempt \(attempt + 1)), retrying")
        #endif
        DispatchQueue.main.asyncAfter(deadline: .now() + AppDelegate.kShareChannelRetryInterval) { [weak self] in
          self?.setupShareIntentChannelWithRetry(attempt: attempt + 1)
        }
      } else {
        #if DEBUG
        print("[Wishy Share] setupShareIntentChannel: FlutterViewController still not available, channel NOT set")
        #endif
      }
      return
    }
    let channel = FlutterMethodChannel(
      name: "com.raphtang.wishy/share_intent",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] (call, result) in
      if call.method == "getSharedDataFromContainer" {
        if let json = AppDelegate.pendingContainerShareJson {
          AppDelegate.pendingContainerShareJson = nil
          #if DEBUG
          print("[Wishy Share] getSharedDataFromContainer: returning \(json.count) chars (from pending)")
          #endif
          result(json)
          return
        }
        let appGroupId = "group.com.raphtang.wishy"
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else {
          #if DEBUG
          print("[Wishy Share] getSharedDataFromContainer: no container")
          #endif
          result(FlutterError(code: "no_container", message: "No App Group container", details: nil))
          return
        }
        let fileURL = containerURL.appendingPathComponent("shared_files/share_data.json")
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        guard exists,
              let data = try? Data(contentsOf: fileURL),
              let json = String(data: data, encoding: .utf8), !json.isEmpty else {
          #if DEBUG
          print("[Wishy Share] getSharedDataFromContainer: file exists=\(exists) at \(fileURL.path)")
          #endif
          result(nil)
          return
        }
        try? FileManager.default.removeItem(at: fileURL)
        #if DEBUG
        print("[Wishy Share] getSharedDataFromContainer: returning \(json.count) chars from file")
        #endif
        result(json)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    #if DEBUG
    print("[Wishy Share] setupShareIntentChannel: channel registered (attempt \(attempt + 1))")
    #endif
  }
}
