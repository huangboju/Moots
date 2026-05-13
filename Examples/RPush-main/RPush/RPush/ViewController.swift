//
//  ViewController.swift
//  RPush
//
//  Created by Axe on 2021/1/5.
//
//  [iOS远程推送--APNs详解](https://blog.csdn.net/weixin_37409570/article/details/96575120)

import Cocoa
import AppKit

private let CertificateAppleDelelopmentPushHost = "gateway.sandbox.push.apple.com"
private let CertificateAppleProductionPushHost = "gateway.push.apple.com"
private let CertificateApplePushPort: Int = 2195

private let TokenAuthenticationAppleDelelopmentPushHost = "api.development.push.apple.com"
private let TokenAuthenticationAppleProductionPushHost = "api.push.apple.com"
private let TokenAuthenticationApplePushScheme = "https"
private let TokenAuthenticationApplePushPort: Int = 443
private func TokenAuthenticationApplePushPath(withDeviceToken deviceToken: String) -> String {
    return "/3/device/\(deviceToken)"
}

// See https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/APNSOverview.html#//apple_ref/doc/uid/TP40008194-CH8-SW1
class ViewController: NSViewController, NSTextFieldDelegate {
    
    /// 选择证书认证方式
    @IBOutlet weak var cerAuthButton: NSButton!
    
    /// 选择token认证方式
    @IBOutlet weak var tokenAuthButton: NSButton!
    
    @IBOutlet weak var bundleIdTitleLabel: NSTextField!
    @IBOutlet weak var bundleIdTextField: NSTextField!
    
    @IBOutlet weak var keyIdTitleLabel: NSTextField!
    @IBOutlet weak var keyIdTextField: NSTextField!
    
    @IBOutlet weak var teamIdTitleLabel: NSTextField!
    @IBOutlet weak var teamIdTextField: NSTextField!
    
    /// 选择证书标题
    @IBOutlet weak var chooseCerTitleLabel: NSTextField!
    
    /// 选择证书的下拉按选择钮
    @IBOutlet weak var cerPopUpButton: NSPopUpButton!
    
    /// 选择消息体样式的下拉按选择钮
    @IBOutlet weak var payloadPopUpButton: NSPopUpButton!
    
    /// 消息体输入框
    @IBOutlet weak var deviceTokenTextField: NSTextField!
    
    /// 显示消息体的输入框
    @IBOutlet weak var payloadTextField: NSTextField!
    
    /// 显示log的输入框
    @IBOutlet var logTextView: NSTextView!
    
    /// 选择开发环境的复选框
    @IBOutlet weak var developmentButton: NSButton!
    
    /// 选择生产环境的复选框
    @IBOutlet weak var productionButton: NSButton!
    
    /// 连接服务器按钮
    @IBOutlet weak var connectServiceButton: NSButton!
    
    private var _cerName: String?
    private var _lastSelectCerPath: String?
    private var _currentSec: Sec?
    private lazy var _certificates: [Sec] = []
    private var _p8FilePath: String = "" {
        willSet {
            let fileURL = URL(fileURLWithPath: newValue)
            _p8FileName = fileURL.lastPathComponent
            _p8PrivateKey = try? P8.getPrivateKey(fromP8: newValue)
            // Switching to a different .p8 invalidates any cached JWT.
            _authToken = nil
        }
    }
    private var _p8PrivateKey: String?
    private var _p8FileName: String = ""

    /// Caches the APNs provider JWT across `send()` calls. APNs forbids re-issuing the JWT
    /// faster than every 20 minutes (`TooManyProviderTokenUpdates`), so we keep one long-lived
    /// instance per (keyId, teamId, p8) tuple and let it decide when to refresh.
    private var _authToken: AuthenticationToken?
    private var deviceTokenString: String? // 格式化后的deviceToken
    private var isConnected: Bool = false
    private var socket: Socket?
    private lazy var session: URLSession = .shared
    private lazy var userDefaults: UserDefaults = .standard
    private var _env: Environment = .delelopment
    private var _authMethod: AuthenticationMethod = .certificateBased // 鉴权方式，默认为证书认证
    private let currentSecKey = "lastSelected"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [bundleIdTextField,
        keyIdTextField,
        teamIdTextField,
        deviceTokenTextField,
        payloadTextField].forEach { $0?.delegate = self }
        
        payloadTextField.stringValue = "{\"aps\":{\"alert\":\"This is some fancy message.\",\"badge\":6,\"sound\": \"default\"}}"
        
        authMethodSwitchAction(cerAuthButton)
        environmentSwitchAction(developmentButton)
    }
    
    func fillFromHistoryRecord(_ record: PushHistoryRecord) {
        deviceTokenTextField.stringValue = record.deviceToken
        payloadTextField.stringValue = record.payload
        
        if record.authMethodEnum == .tokenBased {
            authMethodSwitchAction(tokenAuthButton)
            tokenAuthButton.state = .on
            cerAuthButton.state = .off
            bundleIdTextField.stringValue = record.bundleId ?? ""
            keyIdTextField.stringValue = record.keyId ?? ""
            teamIdTextField.stringValue = record.teamId ?? ""
        } else {
            authMethodSwitchAction(cerAuthButton)
            cerAuthButton.state = .on
            tokenAuthButton.state = .off
        }
        
        if record.environmentEnum == .production {
            productionButton.state = .on
            developmentButton.state = .off
            environmentSwitchAction(productionButton)
        } else {
            developmentButton.state = .on
            productionButton.state = .off
            environmentSwitchAction(developmentButton)
        }
        
        writeUserData()
        displayLog("从历史记录填充数据：\(record.formattedDate)", isWarning: false)
    }
    
    // MARK: NSTextFieldDelegate
    
    func controlTextDidEndEditing(_ obj: Notification) {
        if obj.object as? NSObject == deviceTokenTextField {
            let formattedDeviceToken = formatDeviceToken(deviceTokenTextField.stringValue)
            displayLog("格式化DeviceToken: '\(formattedDeviceToken)'", isWarning: false)
            deviceTokenTextField.stringValue = formattedDeviceToken
        }
        writeUserData()
    }
    
    // MARK: Actions
    
    /// 选择证书下拉按钮点击事件
    @IBAction func selectCerPopUpButtonClicked(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            pickerCerOrP8File { filePath in
                if let path = filePath {
                    self.applyCerOrP8File(from: path)
                }
            }
        default:
            switch _authMethod {
            case .certificateBased:
                resetConnect()
                _currentSec = _certificates[sender.indexOfSelectedItem - 1]
                _cerName = _currentSec?.name
                if let cerName = _cerName {
                    let message = "选择推送证书 \(cerName)"
                    displayLog(message, isWarning: false)
                }
            case .tokenBased:
                let message = "选择P8文件 \(_p8FileName)"
                displayLog(message, isWarning: false)
                resetConnect()
            }
        }
    }
    
    /// 链接服务器按钮点击事件
    @IBAction func connectServerButtonClicked(_ sender: NSButton!) {
        connect()
    }
    
    /// 发送消息按钮点击事件
    @IBAction func sendMessageButtonClicked(_ sender: NSButton) {
        send()
    }
    
    /// 消息体样式按钮点击事件
    @IBAction func payloadSelectButtonClicked(_ sender: NSPopUpButton) {
        let stringValue: String
        // See [Creating the Remote Notification Payload](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CreatingtheNotificationPayload.html#//apple_ref/doc/uid/TP40008194-CH10-SW1)
        switch sender.indexOfSelectedItem {
        case 1:
            stringValue = "{\"aps\":{\"alert\":\"This is some fancy message.\"}}"
        case 2:
            stringValue = "{\"aps\":{\"alert\":\"This is some fancy message.\",\"badge\":6}}"
        default:
            stringValue = "{\"aps\":{\"alert\":\"This is some fancy message.\",\"badge\":6,\"sound\": \"default\"}}"
        }
        payloadTextField.stringValue = stringValue
    }
    
    /// 环境切换事件
    @IBAction func environmentSwitchAction(_ sender: NSButton) {
        resetConnect()
        if sender == developmentButton {
            displayLog("切至开发环境", isWarning: false)
            _env = .delelopment
        } else if sender == productionButton {
            displayLog("切至生产环境", isWarning: false)
            _env = .production
        }
        loadKeychain()
    }
    
    /// 鉴权方式切换事件
    @IBAction func authMethodSwitchAction(_ sender: NSButton) {
        resetConnect()
        if sender == cerAuthButton {
            displayLog("切至证书鉴权方式", isWarning: false)
            _authMethod = .certificateBased
            bundleIdTextField.isEnabled = false
            keyIdTextField.isEnabled = false
            teamIdTextField.isEnabled = false
            connectServiceButton.isHidden = false
            chooseCerTitleLabel.stringValue = "选择推送证书："
            bundleIdTitleLabel.textColor = NSColor.tertiaryLabelColor
            keyIdTitleLabel.textColor = NSColor.tertiaryLabelColor
            teamIdTitleLabel.textColor = NSColor.tertiaryLabelColor
        } else if sender == tokenAuthButton {
            displayLog("切至Token鉴权方式", isWarning: false)
            _authMethod = .tokenBased
            bundleIdTextField.isEnabled = true
            keyIdTextField.isEnabled = true
            teamIdTextField.isEnabled = true
            connectServiceButton.isHidden = true
            chooseCerTitleLabel.stringValue = "选择P8文件："
            bundleIdTitleLabel.textColor = NSColor.labelColor
            keyIdTitleLabel.textColor = NSColor.labelColor
            teamIdTitleLabel.textColor = NSColor.labelColor
        }
        readUserData()
        reloadCerPopUpButton()
    }
        
    private func reloadCerPopUpButton() {
        
        cerPopUpButton.removeAllItems()
        
        switch _authMethod {
        case .certificateBased:
            cerPopUpButton.addItems(withTitles: ["从文件中选择iOS推送证书(.cer)"])
            for (idx, sec) in _certificates.enumerated() {
                let title = sec.name! + " " + sec.expire
                cerPopUpButton.addItem(withTitle: title)
                
                if let cerName = _cerName, !cerName.isEmpty, cerName == sec.name {
                    displayLog("选择证书 \(cerName)", isWarning: false)
                    cerPopUpButton.selectItem(at: idx + 1)
                    resetConnect()
                    _currentSec = sec
                    _cerName = sec.name
                }
            }
        case .tokenBased:
            cerPopUpButton.addItems(withTitles: ["从文件中选择P8文件(.p8)"])
            if !_p8FileName.isEmpty {
                cerPopUpButton.addItem(withTitle: _p8FileName)
                let idx = cerPopUpButton.itemTitles.firstIndex(of: _p8FileName) ?? 0
                cerPopUpButton.selectItem(at: idx)
            }
        }
    }
    
}
 
// MARK: Keychain
private extension ViewController {
        
    func loadKeychain() {
        _certificates = SecManager.fetchAllPushCertificates(withEnvironment: _env)
        if let lastCerPath = _lastSelectCerPath, !lastCerPath.isEmpty, let cert = try? SecManager.fetchCertificate(from: lastCerPath) {
            var sec = Sec(secCertificate: cert)
            sec.key = currentSecKey
            _certificates.append(sec)
        }
        displayLog("读取钥匙串中的证书", isWarning: false)
        reloadCerPopUpButton()
    }
}

// MARK: Socket
private extension ViewController {
        
    // Establish a TLS session with APNs.
    func connect() {
        
        guard !isConnected else {
            displayLog("服务器已连接，无需重新连接", isWarning: false)
            return
        }
        
        guard let certificate = _currentSec?.certificate else {
            showAlert("读取证书失败")
            displayLog("读取证书失败", isWarning: true)
            return
        }
        
        let host = certificateApplePushHost(with: _env)
        let port = certificateApplePushPort(with: _env)

        socket = Socket(address: host, port: port, cert: certificate)
        
        displayLog("正在连接服务器中...", isWarning: false)
        
        // Establish connection to server.
        socket?.connect { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.displayLog("服务器连接成功", isWarning: false)
                this.isConnected = true
            case let .failure(error):
                this.showAlert("服务器连接失败: \(error)")
                this.displayLog("服务器连接失败: \(error)", isWarning: true)
                this.isConnected = false
            }
        }
    }
    
    func send() {
    
        let deviceToken = deviceTokenTextField.stringValue
        let payload = payloadTextField.stringValue
        
        guard !deviceToken.isEmpty else {
            let errmsg = "Device Token 是无效的"
            showAlert(errmsg)
            displayLog(errmsg, isWarning: true)
            return
        }
        
        guard !payload.isEmpty else {
            let errmsg = "Payload 是无效的"
            showAlert(errmsg)
            displayLog(errmsg, isWarning: true)
            return
        }
        
        switch _authMethod {
        case .certificateBased:
            
            // Validate input
            guard isConnected else {
                showAlert("未连接至服务器")
                displayLog("未连接至服务器", isWarning: true)
                return
            }
            
            guard !_certificates.isEmpty else {
                showAlert("证书缺失")
                displayLog("证书缺失", isWarning: true)
                return
            }
            
            let apnsProviderCertificates = APNsProviderCertificates(deviceToken: deviceToken, payload: payload)
            displayLog("格式化DeviceToken: '\(apnsProviderCertificates.formattedDeviceToken)'", isWarning: false)
            deviceTokenTextField.stringValue = apnsProviderCertificates.formattedDeviceToken
            
            self.deviceTokenString = apnsProviderCertificates.formattedDeviceToken
            
            writeUserData()
            
            socket?.send(data: apnsProviderCertificates.data) { [weak self] result in
                guard let this = self else { return }
                let isSuccess: Bool
                switch result {
                case .success:
                    this.showAlert("推送成功")
                    this.displayLog("推送成功", isWarning: false)
                    isSuccess = true
                case .failure(let error):
                    this.showAlert("推送失败: \(error)")
                    this.displayLog("推送失败：\(error)", isWarning: true)
                    isSuccess = false
                }
                let record = PushHistoryRecord(
                    deviceToken: deviceToken, payload: payload,
                    authMethod: this._authMethod, environment: this._env,
                    isSuccess: isSuccess)
                PushHistoryManager.shared.addRecord(record)
            }
        case .tokenBased:
            
            // Validate input
            guard !_p8FilePath.isEmpty else {
                let errmsg = "p8文件缺失"
                showAlert(errmsg)
                displayLog(errmsg, isWarning: true)
                return
            }
            
            let keyId = keyIdTextField.stringValue
            let teamId = teamIdTextField.stringValue
            let bundleId = bundleIdTextField.stringValue
            
            guard !bundleId.isEmpty else {
                let errmsg = "Bundle ID 是无效的"
                showAlert(errmsg)
                displayLog(errmsg, isWarning: true)
                return
            }
            
            // A 10-character key identifier (kid) key, obtained from your developer account
            guard keyId.count == 10 else {
                let errmsg = "Key ID是无效的"
                showAlert(errmsg)
                displayLog(errmsg, isWarning: true)
                return
            }
            
            // The issuer (iss) registered claim key, whose value is your 10-character Team ID, obtained from your developer account
            guard teamId.count == 10 else {
                let errmsg = "Team ID是无效的"
                showAlert(errmsg)
                displayLog(errmsg, isWarning: true)
                return
            }
            
            // Reuse the same AuthenticationToken instance across sends so its internal JWT cache
            // can survive (and obey APNs's 20-minute minimum refresh window). Recreate it only
            // when the credentials actually change.
            if _authToken?.keyId != keyId || _authToken?.teamId != teamId {
                _authToken = AuthenticationToken(keyId: keyId, teamId: teamId)
            }
            let authToken = _authToken!

            let jwtToken: JWT.Token
            do {
                if let privateKey = _p8PrivateKey {
                    jwtToken = try authToken.generateJWTToken(fromP8PrivateKey: privateKey)
                } else {
                    jwtToken = try authToken.generateJWTToken(fromP8: _p8FilePath)
                }
            } catch {
                let errmsg = "生成JWT失败: \(error.localizedDescription)"
                showAlert(errmsg)
                displayLog(errmsg, isWarning: true)
                return
            }
            
            let newDeviceToken = deviceToken.replacingOccurrences(of: " ", with: "")
            let url = tokenAuthenticationApplePushURL(with: _env, deviceToken: newDeviceToken)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(bundleId, forHTTPHeaderField: "apns-topic")
            request.httpBody = payload.data(using: .utf8)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                let statusCode = (response as! HTTPURLResponse).statusCode
                var reason: String?
                if let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    print("response dict: \(dict)")
                    reason = dict["reason"] as? String
                }
                let isSuccess: Bool
                if statusCode == 200 {
                    self.showAlert("推送成功")
                    self.displayLog("推送成功", isWarning: false)
                    isSuccess = true
                } else {
                    let errmsg = reason ?? error!.localizedDescription
                    self.showAlert("推送失败: \(errmsg)")
                    self.displayLog("推送失败：\(errmsg)", isWarning: true)
                    isSuccess = false
                }
                let record = PushHistoryRecord(
                    deviceToken: deviceToken, payload: payload,
                    authMethod: self._authMethod, environment: self._env,
                    bundleId: bundleId, keyId: keyId, teamId: teamId,
                    isSuccess: isSuccess)
                PushHistoryManager.shared.addRecord(record)
            }
            task.resume()
        }
    }
    
    func disconnect(force: Bool) {
        displayLog("断开连接", isWarning: false)
        displayLog("----------------------------------", isWarning: false)
        
        // Close connection to server.
        socket?.disconnect(force: force)
        isConnected = false
    }
    
    func resetConnect() {
        displayLog("重置连接", isWarning: false)
        disconnect(force: true)
    }
}


// MARK: User Data
private extension ViewController {
    
    func readUserData() {
        displayLog("读取保存的信息", isWarning: false)
                
        switch _authMethod {
        case .certificateBased:
            if let cerName = userDefaults.getString(forKey: UserDefaults.CertificateAuthInfoKey.cerName.rawValue), !cerName.isEmpty {
                _cerName = cerName
            }
            if let cerPath = userDefaults.getString(forKey: UserDefaults.CertificateAuthInfoKey.cerPath.rawValue), !cerPath.isEmpty {
                _lastSelectCerPath = cerPath
            }
        case .tokenBased:
            if let bundleId = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.bundleId.rawValue) {
                bundleIdTextField.stringValue = bundleId
            }
            if let keyId = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.keyId.rawValue) {
                keyIdTextField.stringValue = keyId
            }
            if let teamId = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.teamId.rawValue) {
                teamIdTextField.stringValue = teamId
            }
            if let p8FilePath = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.p8FilePath.rawValue), !p8FilePath.isEmpty {
                _p8FilePath = p8FilePath
            }
            if let p8PrivateKey = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.p8PrivateKey.rawValue), !p8PrivateKey.isEmpty {
                _p8PrivateKey = p8PrivateKey
            }
        }
        if let deviceToken = userDefaults.getString(forKey: UserDefaults.deviceTokenKey) {
            deviceTokenTextField.stringValue = deviceToken
        }
        if let payload = userDefaults.getString(forKey: UserDefaults.payloadKey) {
            payloadTextField.stringValue = payload
        }
    }
    
    func writeUserData() {
        switch _authMethod {
        case .certificateBased:
            userDefaults.setString(_lastSelectCerPath, forKey: UserDefaults.CertificateAuthInfoKey.cerPath.rawValue)
            userDefaults.setString(_cerName, forKey: UserDefaults.CertificateAuthInfoKey.cerName.rawValue)
        case .tokenBased:
            userDefaults.setString(bundleIdTextField.stringValue, forKey: UserDefaults.JSONWebTokenAuthInfoKey.bundleId.rawValue)
            userDefaults.setString(keyIdTextField.stringValue, forKey: UserDefaults.JSONWebTokenAuthInfoKey.keyId.rawValue)
            userDefaults.setString(teamIdTextField.stringValue, forKey: UserDefaults.JSONWebTokenAuthInfoKey.teamId.rawValue)
            userDefaults.setString(_p8FilePath, forKey: UserDefaults.JSONWebTokenAuthInfoKey.p8FilePath.rawValue)
            userDefaults.setString(_p8PrivateKey, forKey: UserDefaults.JSONWebTokenAuthInfoKey.p8PrivateKey.rawValue)
        }
        userDefaults.setString(deviceTokenTextField.stringValue, forKey: UserDefaults.deviceTokenKey)
        userDefaults.setString(payloadTextField.stringValue, forKey: UserDefaults.payloadKey)
        displayLog("保存推送消息", isWarning: false)
    }
}

// MARK: Cer/p8 File

private extension ViewController {
    
    /// 从本地选择.cer/p8文件
    func pickerCerOrP8File(_ completionHandler: @escaping (String?) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowsOtherFileTypes = false
        switch _authMethod {
        case .certificateBased:
            openPanel.allowedFileTypes = ["cer"]
        case .tokenBased:
            openPanel.allowedFileTypes = ["p8"]
        }
        
        openPanel.beginSheetModal(for: NSApplication.shared.windows[0]) { modalResponse in
            switch modalResponse {
            case .OK:
                let path = openPanel.urls[0].path
                completionHandler(path)
            default:
                completionHandler(nil)
            }
        }
    }
    
    func applyCerOrP8File(from path: String) {
    
    switch _authMethod {
    case .certificateBased:
        var cert: SecCertificate?
        
        do {
            cert = try SecManager.fetchCertificate(from: path)
        } catch {
            displayLog(error.localizedDescription, isWarning: true)
        }
        
        guard let certificate = cert else {
            displayLog("证书获取不到", isWarning: true)
            return
        }
        
        guard certificate.isPush else {
            showAlert("不是有效的推送证书")
            displayLog("不是有效的推送证书", isWarning: true)
            return
        }
        
        _lastSelectCerPath = path
        
        _certificates.removeAll { $0.key == currentSecKey }
        
        var sec = Sec(secCertificate: certificate)
        sec.key = currentSecKey
        _cerName = sec.name
        _currentSec = sec
        
        _certificates.append(sec)
        
    case .tokenBased:
        _p8FilePath = path
    }
    
    resetConnect()
    reloadCerPopUpButton()
    writeUserData()
}
}

// MARK: Host & Port
private extension ViewController {
    
    /// See [Legacy Notification Format](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/LegacyNotificationFormat.html#//apple_ref/doc/uid/TP40008194-CH14-SW1)
    func certificateApplePushHost(with env: Environment) -> String {
        switch env {
        case .delelopment:
            return CertificateAppleDelelopmentPushHost
        case .production:
            return CertificateAppleProductionPushHost
        }
    }
    
    func certificateApplePushPort(with env: Environment) -> Int {
        return CertificateApplePushPort
    }
    
    /// See [Communicating with APNs](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1)
    func tokenAuthenticationApplePushURL(with env: Environment, deviceToken: String) -> URL {
        let host: String
        switch env {
        case .delelopment:
            host = TokenAuthenticationAppleDelelopmentPushHost
        case .production:
            host = TokenAuthenticationAppleProductionPushHost
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = TokenAuthenticationApplePushScheme
        urlComponents.host = host
        urlComponents.port = TokenAuthenticationApplePushPort
        urlComponents.path = TokenAuthenticationApplePushPath(withDeviceToken: deviceToken)
        
        guard let url = urlComponents.url else {
            fatalError()
        }
        
        return url
    }
    
}

// MARK: Helper

private extension ViewController {
    
    private func showAlert(_ message: String) {
        let execute: () -> Void = {
            let alert = NSAlert()
            alert.alertStyle = .warning
            alert.messageText = message
            alert.beginSheetModal(for: self.view.window!)
        }
        DispatchQueue.main.async(execute: execute)
    }
        
    private func displayLog(_ message: String, isWarning: Bool) {
        let execute: () -> Void = {
            var attributes: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: 12.0)]
            if isWarning {
                attributes[.foregroundColor] = NSColor.red
            } else {
                attributes[.foregroundColor] = NSColor.black
            }
            let attributeText = NSAttributedString(string: message, attributes: attributes)
            
            self.logTextView.textStorage?.append(attributeText)
            self.logTextView.textStorage?.mutableString.append("\n")
            
            let visibleRange = NSRange(location: self.logTextView.textStorage!.length - 1, length: 1)
            self.logTextView.scrollRangeToVisible(visibleRange)
        }
        DispatchQueue.main.async(execute: execute)
    }
    
}
