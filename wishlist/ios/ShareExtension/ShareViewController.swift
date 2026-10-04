import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the UI to make it seamless
        self.view.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Process the shared content and navigate to main app
        DispatchQueue.main.async {
            self.handleSharedContent()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Close extension immediately to avoid UI issues
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        handleSharedContent()
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }
    
    private func handleSharedContent() {
        guard let extensionContext = extensionContext else {
            closeShareExtension()
            return
        }
        
        
        let attachments = extensionContext.inputItems
            .compactMap { $0 as? NSExtensionItem }
            .flatMap { $0.attachments ?? [] }
        
        
        if attachments.isEmpty {
            closeShareExtension()
            return
        }
        
        var shareData: [String: Any] = [:]
        var allFilePaths: [String] = []
        var allTextContent: [String] = []
        let group = DispatchGroup()
        
        for (attachmentIndex, attachment) in attachments.enumerated() {
            group.enter()
            
            // Process files first (prioritize files over text/URLs)
            if attachment.hasItemConformingToTypeIdentifier("public.file-url") {
                attachment.loadItem(forTypeIdentifier: "public.file-url", options: nil) { [weak self] (item, error) in
                    self?.processFileItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths)
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("public.image") {
                attachment.loadItem(forTypeIdentifier: "public.image", options: nil) { [weak self] (item, error) in
                    self?.processFileItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths)
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("public.movie") {
                attachment.loadItem(forTypeIdentifier: "public.movie", options: nil) { [weak self] (item, error) in
                    self?.processFileItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths)
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("public.audio") {
                attachment.loadItem(forTypeIdentifier: "public.audio", options: nil) { [weak self] (item, error) in
                    self?.processFileItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths)
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("com.adobe.pdf") {
                attachment.loadItem(forTypeIdentifier: "com.adobe.pdf", options: nil) { [weak self] (item, error) in
                    self?.processFileItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths)
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("public.url") {
                // Vérifier public.url avant public.data : Safari envoie souvent l’URL sous ce type.
                attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (item, error) in
                    if let url = item as? URL {
                        allTextContent.append(url.absoluteString)
                    }
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("public.plain-text") {
                attachment.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { [weak self] (item, error) in
                    if let text = item as? String, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        allTextContent.append(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("text/uri-list") {
                // Souvent utilisé pour partager des liens (ex. Safari, certaines apps).
                attachment.loadItem(forTypeIdentifier: "text/uri-list", options: nil) { [weak self] (item, error) in
                    if let data = item as? Data, let text = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
                        allTextContent.append(text)
                    } else if let text = item as? String, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        allTextContent.append(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    group.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier("public.data") {
                attachment.loadItem(forTypeIdentifier: "public.data", options: nil) { [weak self] (item, error) in
                    self?.processFileItem(item: item, error: error, index: attachmentIndex, allFilePaths: &allFilePaths)
                    group.leave()
                }
            } else {
                let typeIdentifier = attachment.registeredTypeIdentifiers.first ?? "public.data"
                attachment.loadItem(forTypeIdentifier: typeIdentifier, options: nil) { [weak self] (item, error) in
                    if let url = item as? URL {
                        if url.isFileURL {
                            allFilePaths.append(url.path)
                        } else {
                            allTextContent.append(url.absoluteString)
                        }
                    } else if let text = item as? String, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        allTextContent.append(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            
            // Prepare share data
            if !allFilePaths.isEmpty {
                shareData["filePaths"] = allFilePaths
                shareData["mimeType"] = self?.determineMimeType(from: allFilePaths.first ?? "") ?? "application/octet-stream"
            }
            
            if !allTextContent.isEmpty {
                shareData["text"] = allTextContent.joined(separator: "\n")
                if shareData["mimeType"] == nil {
                    shareData["mimeType"] = "text/plain"
                }
            }
            
            guard !shareData.isEmpty else {
                #if DEBUG
                print("[Wishy Share] ShareExtension: no content extracted, not opening app")
                #endif
                self?.closeShareExtension()
                return
            }
            self?.saveShareData(shareData)
            // Délai pour laisser UserDefaults et le conteneur partagé se synchroniser avant d’ouvrir l’app
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self?.navigateToMainApp()
            }
        }
    }
    
    private func processFileItem(item: Any?, error: Error?, index: Int, allFilePaths: inout [String]) {
        if let url = item as? URL {
            allFilePaths.append(url.path)
        }
    }
    
    private func determineMimeType(from path: String) -> String {
        let fileExtension = path.lowercased().split(separator: ".").last?.description ?? ""
        
        switch fileExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "bmp":
            return "image/bmp"
        case "heic", "heif":
            return "image/heic"
        case "mp4":
            return "video/mp4"
        case "mov":
            return "video/quicktime"
        case "avi":
            return "video/x-msvideo"
        case "mp3":
            return "audio/mpeg"
        case "wav":
            return "audio/wav"
        case "m4a":
            return "audio/mp4"
        case "pdf":
            return "application/pdf"
        case "doc":
            return "application/msword"
        case "docx":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "xls":
            return "application/vnd.ms-excel"
        case "xlsx":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "zip":
            return "application/zip"
        case "txt":
            return "text/plain"
        case "html":
            return "text/html"
        case "json":
            return "application/json"
        default:
            return "application/octet-stream"
        }
    }
    
    private func saveShareData(_ data: [String: Any]) {
        guard let appGroupId = Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String else {
            #if DEBUG
            print("[Wishy Share] ShareExtension: AppGroupId not found in Info.plist")
            #endif
            return
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            return
        }
        
        // 1. Écrire dans le conteneur App Group (shared_files) — l’app peut lire via FileManager même si UserDefaults a Container: (null)
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) {
            let sharedFilesDir = containerURL.appendingPathComponent("shared_files")
            let shareDataFile = sharedFilesDir.appendingPathComponent("share_data.json")
            do {
                try FileManager.default.createDirectory(at: sharedFilesDir, withIntermediateDirectories: true)
                try jsonData.write(to: shareDataFile)
                #if DEBUG
                print("[Wishy Share] ShareExtension: data saved to container")
                #endif
            } catch {
                #if DEBUG
                print("[Wishy Share] ShareExtension: error writing to container: \(error)")
                #endif
            }
        } else {
            #if DEBUG
            print("[Wishy Share] ShareExtension: no container URL for \(appGroupId)")
            #endif
        }
        
        // 2. Temp file (simulateur / compat plugin)
        let sharedTmpPath = URL(fileURLWithPath: "/tmp/")
        let shareFilePath = sharedTmpPath.appendingPathComponent("share_intent_data_\(appGroupId).json")
        try? jsonData.write(to: shareFilePath)
        
        // 3. UserDefaults App Group (fallback si l’app a accès)
        var userDefaults: UserDefaults?
        if let groupDefaults = UserDefaults(suiteName: appGroupId) {
            userDefaults = groupDefaults
        } else {
            userDefaults = UserDefaults.standard
        }
        
        if let userDefaults = userDefaults, let jsonString = String(data: jsonData, encoding: .utf8) {
            userDefaults.removeObject(forKey: "shareData")
            userDefaults.removeObject(forKey: "ShareKey")
            userDefaults.removeObject(forKey: "SharingKeyData")
            userDefaults.set(jsonString, forKey: "shareData")
            userDefaults.set([data], forKey: "ShareKey")
            userDefaults.set(jsonString, forKey: "SharingKeyData")
            userDefaults.synchronize()
        }
    }
    
    private func navigateToMainApp() {
        guard let bundleId = Bundle.main.object(forInfoDictionaryKey: "MainAppBundleId") as? String else {
            #if DEBUG
            print("[Wishy Share] ShareExtension: MainAppBundleId not found in Info.plist")
            #endif
            closeShareExtension()
            return
        }
        
        let urlScheme = "SharingMedia-\(bundleId)://"
        guard let url = URL(string: urlScheme) else {
            closeShareExtension()
            return
        }
        
        if #available(iOS 18.0, *) {
            var responder: UIResponder? = self
            while responder != nil {
                if let app = responder as? UIApplication {
                    app.open(url, options: [:], completionHandler: { [weak self] success in
                        #if DEBUG
                        print("[Wishy Share] ShareExtension: app launch \(success ? "ok" : "failed")")
                        #endif
                        DispatchQueue.main.async {
                            self?.closeShareExtension()
                        }
                    })
                    break
                }
                responder = responder?.next
            }
        } else {
            var responder: UIResponder? = self
            let selectorOpenURL = sel_registerName("openURL:")
            while responder != nil {
                if responder?.responds(to: selectorOpenURL) == true {
                    _ = responder?.perform(selectorOpenURL, with: url)
                    break
                }
                responder = responder?.next
            }
            closeShareExtension()
        }
    }
    
    private func closeShareExtension() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
