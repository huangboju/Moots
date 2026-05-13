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

// MARK: - ViewController
//
// The view hierarchy is built in code (`loadView` does not call super) so the legacy storyboard
// layout is bypassed entirely. All previously-IBAction methods are kept so existing callers and
// the storyboard's First Responder bindings still resolve.

class ViewController: NSViewController, NSTextFieldDelegate, NSTextViewDelegate {

    // MARK: Auth method / environment

    private var authMethodSegmented: NSSegmentedControl!
    private var environmentSegmented: NSSegmentedControl!

    // MARK: Token-based credential fields

    private var bundleIdTextField: NSTextField!
    private var keyIdTextField: NSTextField!
    private var teamIdTextField: NSTextField!

    private var bundleIdRow: NSView!
    private var keyIdRow: NSView!
    private var teamIdRow: NSView!

    // MARK: File / certificate picker

    private var fileChooserLabel: NSTextField!
    private var cerPopUpButton: NSPopUpButton!

    // MARK: Device token

    private var deviceTokenTextField: NSTextField!

    // MARK: Payload

    private var payloadTextView: NSTextView!
    private var payloadScrollView: NSScrollView!
    private var payloadValidationLabel: NSTextField!
    private var payloadTemplateButton: NSPopUpButton!

    // MARK: Logs

    private var logTextView: NSTextView!
    private var logScrollView: NSScrollView!

    // MARK: Status / actions

    private var statusDot: NSView!
    private var statusLabel: NSTextField!
    private var connectButton: NSButton!
    private var sendButton: NSButton!
    private var sendSpinner: NSProgressIndicator!
    private var inlineBanner: InlineBanner!

    /// The top tab bar that hosts the environment switcher (开发/生产), placed at the very top
    /// of the view above the form so the active environment is always obvious.
    private var topTabBar: NSView!

    // MARK: State

    private var _cerName: String?
    private var _lastSelectCerPath: String?
    private var _currentSec: Sec?
    private lazy var _certificates: [Sec] = []
    private var _p8FilePath: String = "" {
        willSet {
            let fileURL = URL(fileURLWithPath: newValue)
            _p8FileName = fileURL.lastPathComponent
            _p8PrivateKey = try? P8.getPrivateKey(fromP8: newValue)
            _authToken = nil
        }
    }
    private var _p8PrivateKey: String?
    private var _p8FileName: String = ""

    /// Caches the APNs provider JWT across `send()` calls so we never trip the 20-minute
    /// `TooManyProviderTokenUpdates` window.
    private var _authToken: AuthenticationToken?

    private var deviceTokenString: String?
    private var isConnected: Bool = false {
        didSet { updateStatus() }
    }
    private var isSending: Bool = false {
        didSet { updateActionAvailability() }
    }
    private var socket: Socket?
    private lazy var session: URLSession = .shared
    private lazy var userDefaults: UserDefaults = .standard
    private var _env: Environment = .delelopment
    private var _authMethod: AuthenticationMethod = .tokenBased
    private let currentSecKey = "lastSelected"

    private static let payloadTemplates: [(title: String, body: String)] = [
        ("Alert only", "{\n  \"aps\": {\n    \"alert\": \"This is some fancy message.\"\n  }\n}"),
        ("Alert + Badge", "{\n  \"aps\": {\n    \"alert\": \"This is some fancy message.\",\n    \"badge\": 1\n  }\n}"),
        ("Alert + Badge + Sound", "{\n  \"aps\": {\n    \"alert\": \"This is some fancy message.\",\n    \"badge\": 1,\n    \"sound\": \"default\"\n  }\n}"),
        ("Rich Alert", "{\n  \"aps\": {\n    \"alert\": {\n      \"title\": \"Hello\",\n      \"subtitle\": \"From RPush\",\n      \"body\": \"This is some fancy message.\"\n    },\n    \"badge\": 1,\n    \"sound\": \"default\"\n  }\n}"),
        ("Background Push", "{\n  \"aps\": {\n    \"content-available\": 1\n  }\n}"),
    ]

    // MARK: - View loading

    override func loadView() {
        // Do NOT call super: that would load the legacy storyboard layout.
        let root = NSView()
        root.translatesAutoresizingMaskIntoConstraints = false
        self.view = root
        buildUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        readUserData()
        applyAuthMethod(animated: false)
        applyEnvironment()
        loadKeychain()
        updateStatus()
        updateActionAvailability()
        installKeyboardShortcuts()
    }

    // MARK: - Public API (kept for compatibility)

    func fillFromHistoryRecord(_ record: PushHistoryRecord) {
        deviceTokenTextField.stringValue = formatDeviceToken(record.deviceToken)
        setPayloadText(record.payload)

        if record.authMethodEnum == .tokenBased {
            authMethodSegmented.selectedSegment = 1
            _authMethod = .tokenBased
            bundleIdTextField.stringValue = record.bundleId ?? ""
            keyIdTextField.stringValue = record.keyId ?? ""
            teamIdTextField.stringValue = record.teamId ?? ""
        } else {
            authMethodSegmented.selectedSegment = 0
            _authMethod = .certificateBased
        }
        applyAuthMethod(animated: false)

        if record.environmentEnum == .production {
            environmentSegmented.selectedSegment = 1
            _env = .production
        } else {
            environmentSegmented.selectedSegment = 0
            _env = .delelopment
        }
        applyEnvironment()

        writeUserData()
        displayLog("从历史记录填充数据：\(record.formattedDate)", isWarning: false)
    }

    // MARK: - NSTextFieldDelegate

    func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSTextField else { return }
        if field === deviceTokenTextField {
            // Live-format as the user types, preserving caret at the end.
            let raw = field.stringValue.replacingOccurrences(of: " ", with: "")
            let formatted = formatDeviceToken(raw)
            if formatted != field.stringValue {
                field.stringValue = formatted
                if let editor = field.currentEditor() {
                    editor.selectedRange = NSRange(location: formatted.count, length: 0)
                }
            }
            updateActionAvailability()
        }
        writeUserData()
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        writeUserData()
        updateActionAvailability()
    }

    // MARK: - NSTextViewDelegate

    func textDidChange(_ notification: Notification) {
        guard let tv = notification.object as? NSTextView, tv === payloadTextView else { return }
        validatePayload(tv.string)
        userDefaults.setString(tv.string, forKey: UserDefaults.payloadKey)
        updateActionAvailability()
    }

    // MARK: - Actions (existing IBAction surface, retained for compatibility)

    @IBAction func selectCerPopUpButtonClicked(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            pickerCerOrP8File { [weak self] filePath in
                guard let self = self, let path = filePath else { return }
                self.applyCerOrP8File(from: path)
            }
        default:
            switch _authMethod {
            case .certificateBased:
                resetConnect()
                _currentSec = _certificates[sender.indexOfSelectedItem - 1]
                _cerName = _currentSec?.name
                if let cerName = _cerName {
                    displayLog("选择推送证书 \(cerName)", isWarning: false)
                }
            case .tokenBased:
                displayLog("选择P8文件 \(_p8FileName)", isWarning: false)
                resetConnect()
            }
            updateActionAvailability()
        }
    }

    @IBAction func connectServerButtonClicked(_ sender: NSButton!) {
        connect()
    }

    @IBAction func sendMessageButtonClicked(_ sender: NSButton) {
        send()
    }

    @IBAction func payloadSelectButtonClicked(_ sender: NSPopUpButton) {
        applyPayloadTemplate(at: sender.indexOfSelectedItem)
    }

    @IBAction func environmentSwitchAction(_ sender: NSButton) {
        // Legacy IBAction kept for storyboard compatibility. Live UI uses the segmented control
        // and routes through `environmentSegmentedChanged(_:)` directly.
    }

    @IBAction func authMethodSwitchAction(_ sender: NSButton) {
        // Legacy IBAction kept for storyboard compatibility.
    }

    // MARK: - UI construction

    private func buildUI() {
        // Inline banner (top of the content area).
        inlineBanner = InlineBanner()
        inlineBanner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inlineBanner)

        // Top tab bar hosting the environment switcher.
        topTabBar = buildTopTabBar()
        view.addSubview(topTabBar)

        // Build a vertical split: form/editor on top, log panel on bottom.
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        mainStack.alignment = .leading
        mainStack.distribution = .fill
        mainStack.spacing = 14
        mainStack.edgeInsets = NSEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        // Section: Auth method (env switcher lives in the top tab bar above) -
        let authRow = makeFormRow(label: "鉴权方式：", control: makeAuthMethodSegmented())

        // Section: Token-based fields ----------------------------------------
        bundleIdTextField = makeTextField(placeholder: "com.example.app")
        keyIdTextField    = makeTextField(placeholder: "10 位 Key ID（如 2X9R4HXF34）")
        teamIdTextField   = makeTextField(placeholder: "10 位 Team ID")
        bundleIdTextField.delegate = self
        keyIdTextField.delegate = self
        teamIdTextField.delegate = self

        bundleIdRow = makeFormRow(label: "Bundle ID：", control: bundleIdTextField)
        keyIdRow    = makeFormRow(label: "Key ID：",    control: keyIdTextField)
        teamIdRow   = makeFormRow(label: "Team ID：",   control: teamIdTextField)

        // Section: file picker ------------------------------------------------
        cerPopUpButton = NSPopUpButton(frame: .zero, pullsDown: false)
        cerPopUpButton.translatesAutoresizingMaskIntoConstraints = false
        cerPopUpButton.target = self
        cerPopUpButton.action = #selector(selectCerPopUpButtonClicked(_:))
        cerPopUpButton.setContentHuggingPriority(.init(1), for: .horizontal)
        let fileLabel = NSTextField(labelWithString: "选择推送证书：")
        fileLabel.alignment = .right
        fileLabel.font = .systemFont(ofSize: 13)
        fileLabel.textColor = .labelColor
        fileChooserLabel = fileLabel
        let fileRow = makeFormRow(labelView: fileLabel, control: cerPopUpButton)

        // Section: device token ----------------------------------------------
        deviceTokenTextField = makeTextField(placeholder: "粘贴设备 Device Token（可带或不带空格）")
        deviceTokenTextField.delegate = self
        deviceTokenTextField.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        let copyTokenButton = makeIconButton(symbol: "doc.on.doc",
                                             tooltip: "复制 Device Token",
                                             action: #selector(copyDeviceTokenClicked))
        let tokenStack = NSStackView(views: [deviceTokenTextField, copyTokenButton])
        tokenStack.spacing = 6
        tokenStack.alignment = .centerY
        let tokenRow = makeFormRow(label: "Device Token：", control: tokenStack)

        let formGrid = NSStackView(views: [authRow, bundleIdRow, keyIdRow, teamIdRow, fileRow, tokenRow])
        formGrid.orientation = .vertical
        formGrid.alignment = .leading
        formGrid.spacing = 8
        formGrid.translatesAutoresizingMaskIntoConstraints = false

        // Section: payload editor + toolbar -----------------------------------
        let payloadHeader = buildPayloadHeader()
        buildPayloadEditor()
        payloadValidationLabel = NSTextField(labelWithString: "")
        payloadValidationLabel.font = .systemFont(ofSize: 11)
        payloadValidationLabel.textColor = .secondaryLabelColor
        payloadValidationLabel.lineBreakMode = .byTruncatingTail

        let payloadStack = NSStackView(views: [payloadHeader, payloadScrollView, payloadValidationLabel])
        payloadStack.orientation = .vertical
        payloadStack.alignment = .leading
        payloadStack.spacing = 6
        payloadStack.translatesAutoresizingMaskIntoConstraints = false

        // Section: log panel --------------------------------------------------
        let logHeader = buildLogHeader()
        buildLogTextView()
        let logStack = NSStackView(views: [logHeader, logScrollView])
        logStack.orientation = .vertical
        logStack.alignment = .leading
        logStack.spacing = 4
        logStack.translatesAutoresizingMaskIntoConstraints = false

        // Section: bottom action bar ------------------------------------------
        let actionBar = buildActionBar()

        mainStack.addArrangedSubview(formGrid)
        mainStack.addArrangedSubview(payloadStack)
        mainStack.addArrangedSubview(logStack)
        mainStack.addArrangedSubview(actionBar)

        // Constraints ---------------------------------------------------------
        NSLayoutConstraint.activate([
            inlineBanner.topAnchor.constraint(equalTo: view.topAnchor),
            inlineBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inlineBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            topTabBar.topAnchor.constraint(equalTo: inlineBanner.bottomAnchor),
            topTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            mainStack.topAnchor.constraint(equalTo: topTabBar.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            formGrid.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 20),
            formGrid.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -20),

            payloadStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 20),
            payloadStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -20),
            payloadScrollView.leadingAnchor.constraint(equalTo: payloadStack.leadingAnchor),
            payloadScrollView.trailingAnchor.constraint(equalTo: payloadStack.trailingAnchor),
            payloadScrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),

            logStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 20),
            logStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -20),
            logScrollView.leadingAnchor.constraint(equalTo: logStack.leadingAnchor),
            logScrollView.trailingAnchor.constraint(equalTo: logStack.trailingAnchor),
            logScrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110),

            actionBar.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 20),
            actionBar.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -20),
        ])

        // Stretch payload as the window grows.
        payloadScrollView.setContentHuggingPriority(.init(1), for: .vertical)
        payloadScrollView.setContentCompressionResistancePriority(.required, for: .vertical)
        logScrollView.setContentHuggingPriority(.init(50), for: .vertical)
    }

    // MARK: Form helpers

    private func makeFormRow(label: String, control: NSView) -> NSView {
        let lbl = NSTextField(labelWithString: label)
        lbl.alignment = .right
        lbl.font = .systemFont(ofSize: 13)
        lbl.textColor = .labelColor
        return makeFormRow(labelView: lbl, control: control)
    }

    private func makeFormRow(labelView: NSTextField, control: NSView) -> NSView {
        let container = NSView()
        container.translatesAutoresizingMaskIntoConstraints = false
        labelView.translatesAutoresizingMaskIntoConstraints = false
        control.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(labelView)
        container.addSubview(control)
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            labelView.centerYAnchor.constraint(equalTo: control.centerYAnchor),
            labelView.widthAnchor.constraint(equalToConstant: 100),

            control.leadingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: 12),
            control.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            control.topAnchor.constraint(equalTo: container.topAnchor),
            control.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        return container
    }

    private func makeAuthMethodSegmented() -> NSSegmentedControl {
        let seg = NSSegmentedControl(labels: ["证书 (.cer)", "Token (.p8)"],
                                     trackingMode: .selectOne,
                                     target: self,
                                     action: #selector(authMethodSegmentedChanged(_:)))
        // Default to Token-based auth — it's the modern, recommended path and matches
        // `_authMethod` initial value.
        seg.selectedSegment = 1
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.segmentStyle = .rounded
        authMethodSegmented = seg
        return seg
    }

    private func makeEnvironmentSegmented() -> NSSegmentedControl {
        let seg = NSSegmentedControl(labels: ["开发环境", "生产环境"],
                                     trackingMode: .selectOne,
                                     target: self,
                                     action: #selector(environmentSegmentedChanged(_:)))
        seg.selectedSegment = 0
        seg.translatesAutoresizingMaskIntoConstraints = false
        // `.capsule` is the modern pill-shaped tab style on macOS 11+; on earlier systems
        // it gracefully degrades to the default rounded look.
        if #available(macOS 11.0, *) {
            seg.segmentStyle = .capsule
            seg.controlSize = .large
        } else {
            seg.segmentStyle = .texturedRounded
        }
        seg.setWidth(120, forSegment: 0)
        seg.setWidth(120, forSegment: 1)
        environmentSegmented = seg
        return seg
    }

    private func buildTopTabBar() -> NSView {
        // NSVisualEffectView gives the bar a native title-bar style backdrop that adapts
        // automatically to light / dark appearance changes.
        let bar = NSVisualEffectView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.material = .titlebar
        bar.blendingMode = .withinWindow
        bar.state = .active

        let segmented = makeEnvironmentSegmented()
        bar.addSubview(segmented)

        let separator = NSBox()
        separator.boxType = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(separator)

        NSLayoutConstraint.activate([
            bar.heightAnchor.constraint(equalToConstant: 48),

            segmented.centerXAnchor.constraint(equalTo: bar.centerXAnchor),
            segmented.centerYAnchor.constraint(equalTo: bar.centerYAnchor, constant: -1),

            separator.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bar.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
        return bar
    }

    private func makeTextField(placeholder: String) -> NSTextField {
        let tf = NSTextField()
        tf.placeholderString = placeholder
        tf.font = .systemFont(ofSize: 13)
        tf.bezelStyle = .roundedBezel
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }

    private func makeIconButton(symbol: String, tooltip: String, action: Selector) -> NSButton {
        let btn = NSButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.bezelStyle = .texturedRounded
        btn.imagePosition = .imageOnly
        btn.target = self
        btn.action = action
        btn.toolTip = tooltip
        if #available(macOS 11.0, *) {
            btn.image = NSImage(systemSymbolName: symbol, accessibilityDescription: tooltip)
        } else {
            btn.title = "Copy"
            btn.imagePosition = .noImage
        }
        return btn
    }

    private func buildPayloadHeader() -> NSView {
        let title = NSTextField(labelWithString: "Payload (JSON)")
        title.font = .systemFont(ofSize: 13, weight: .semibold)

        payloadTemplateButton = NSPopUpButton(frame: .zero, pullsDown: true)
        payloadTemplateButton.translatesAutoresizingMaskIntoConstraints = false
        payloadTemplateButton.bezelStyle = .texturedRounded
        payloadTemplateButton.addItem(withTitle: "模板")
        for tpl in Self.payloadTemplates { payloadTemplateButton.addItem(withTitle: tpl.title) }
        payloadTemplateButton.target = self
        payloadTemplateButton.action = #selector(payloadSelectButtonClicked(_:))

        let formatBtn = NSButton(title: "格式化", target: self, action: #selector(formatPayloadClicked))
        formatBtn.bezelStyle = .texturedRounded
        formatBtn.toolTip = "美化 JSON 缩进"

        let minifyBtn = NSButton(title: "压缩", target: self, action: #selector(minifyPayloadClicked))
        minifyBtn.bezelStyle = .texturedRounded
        minifyBtn.toolTip = "去除空白字符，减小推送体积"

        let copyBtn = makeIconButton(symbol: "doc.on.doc",
                                     tooltip: "复制 Payload",
                                     action: #selector(copyPayloadClicked))

        let spacer = NSView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.init(1), for: .horizontal)

        let stack = NSStackView(views: [title, spacer, payloadTemplateButton, formatBtn, minifyBtn, copyBtn])
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        return stack
    }

    private func buildPayloadEditor() {
        let scroll = NSTextView.scrollableTextView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.borderType = .lineBorder
        payloadScrollView = scroll

        let tv = scroll.documentView as! NSTextView
        tv.delegate = self
        tv.isAutomaticQuoteSubstitutionEnabled = false
        tv.isAutomaticDashSubstitutionEnabled = false
        tv.isAutomaticTextReplacementEnabled = false
        tv.isAutomaticSpellingCorrectionEnabled = false
        tv.isAutomaticLinkDetectionEnabled = false
        tv.isAutomaticDataDetectionEnabled = false
        tv.isRichText = false
        tv.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        tv.string = "{\"aps\":{\"alert\":\"This is some fancy message.\",\"badge\":1,\"sound\":\"default\"}}"
        tv.textContainerInset = NSSize(width: 6, height: 6)
        payloadTextView = tv
    }

    private func buildLogHeader() -> NSView {
        let title = NSTextField(labelWithString: "日志")
        title.font = .systemFont(ofSize: 13, weight: .semibold)

        let copyBtn = NSButton(title: "复制", target: self, action: #selector(copyLogClicked))
        copyBtn.bezelStyle = .texturedRounded

        let clearBtn = NSButton(title: "清空", target: self, action: #selector(clearLogClicked))
        clearBtn.bezelStyle = .texturedRounded
        clearBtn.toolTip = "⌘L"

        let spacer = NSView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.init(1), for: .horizontal)

        let stack = NSStackView(views: [title, spacer, copyBtn, clearBtn])
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    private func buildLogTextView() {
        let scroll = NSTextView.scrollableTextView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.borderType = .lineBorder
        logScrollView = scroll

        let tv = scroll.documentView as! NSTextView
        tv.isEditable = false
        tv.isRichText = true
        tv.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        tv.textContainerInset = NSSize(width: 6, height: 6)
        logTextView = tv
    }

    private func buildActionBar() -> NSView {
        // Status indicator
        statusDot = NSView()
        statusDot.translatesAutoresizingMaskIntoConstraints = false
        statusDot.wantsLayer = true
        statusDot.layer?.cornerRadius = 5
        NSLayoutConstraint.activate([
            statusDot.widthAnchor.constraint(equalToConstant: 10),
            statusDot.heightAnchor.constraint(equalToConstant: 10),
        ])

        statusLabel = NSTextField(labelWithString: "")
        statusLabel.font = .systemFont(ofSize: 12)
        statusLabel.textColor = .secondaryLabelColor

        sendSpinner = NSProgressIndicator()
        sendSpinner.translatesAutoresizingMaskIntoConstraints = false
        sendSpinner.style = .spinning
        sendSpinner.controlSize = .small
        sendSpinner.isDisplayedWhenStopped = false

        connectButton = NSButton(title: "连接服务器", target: self, action: #selector(connectServerButtonClicked(_:)))
        connectButton.bezelStyle = .rounded

        sendButton = NSButton(title: "推送消息", target: self, action: #selector(sendMessageButtonClicked(_:)))
        sendButton.bezelStyle = .rounded
        sendButton.keyEquivalent = "\r"
        sendButton.keyEquivalentModifierMask = [.command]
        sendButton.toolTip = "⌘⏎ 发送"

        let leftStack = NSStackView(views: [statusDot, statusLabel])
        leftStack.orientation = .horizontal
        leftStack.spacing = 6
        leftStack.alignment = .centerY
        leftStack.translatesAutoresizingMaskIntoConstraints = false

        let rightStack = NSStackView(views: [sendSpinner, connectButton, sendButton])
        rightStack.orientation = .horizontal
        rightStack.spacing = 8
        rightStack.alignment = .centerY
        rightStack.translatesAutoresizingMaskIntoConstraints = false

        let bar = NSView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(leftStack)
        bar.addSubview(rightStack)
        NSLayoutConstraint.activate([
            leftStack.leadingAnchor.constraint(equalTo: bar.leadingAnchor),
            leftStack.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            rightStack.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
            rightStack.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            bar.heightAnchor.constraint(equalToConstant: 36),
        ])
        return bar
    }

    // MARK: - Auth method / environment

    @objc private func authMethodSegmentedChanged(_ sender: NSSegmentedControl) {
        let newMethod: AuthenticationMethod = (sender.selectedSegment == 1) ? .tokenBased : .certificateBased
        guard newMethod != _authMethod else { return }
        _authMethod = newMethod
        applyAuthMethod(animated: true)
        readUserData()
        reloadCerPopUpButton()
        resetConnect()
        displayLog(_authMethod == .certificateBased ? "切至证书鉴权方式" : "切至 Token 鉴权方式", isWarning: false)
    }

    @objc private func environmentSegmentedChanged(_ sender: NSSegmentedControl) {
        let newEnv: Environment = (sender.selectedSegment == 1) ? .production : .delelopment
        guard newEnv != _env else { return }
        _env = newEnv
        applyEnvironment()
        resetConnect()
        loadKeychain()
        displayLog(_env == .delelopment ? "切至开发环境" : "切至生产环境", isWarning: false)
    }

    private func applyAuthMethod(animated: Bool) {
        let token = (_authMethod == .tokenBased)
        bundleIdRow.isHidden = !token
        keyIdRow.isHidden = !token
        teamIdRow.isHidden = !token
        connectButton.isHidden = token
        fileChooserLabel.stringValue = token ? "选择 P8 文件：" : "选择推送证书："
        reloadCerPopUpButton()
        updateActionAvailability()
    }

    private func applyEnvironment() {
        // Reflect env to connect indicator color & status text via updateStatus.
        updateStatus()
    }

    // MARK: - File picker

    private func pickerCerOrP8File(_ completionHandler: @escaping (String?) -> Void) {
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
                completionHandler(openPanel.urls[0].path)
            default:
                completionHandler(nil)
            }
        }
    }

    private func applyCerOrP8File(from path: String) {
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
                inlineBanner.show(message: "不是有效的推送证书", style: .error)
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
        updateActionAvailability()
    }

    private func loadKeychain() {
        _certificates = SecManager.fetchAllPushCertificates(withEnvironment: _env)
        if let lastCerPath = _lastSelectCerPath, !lastCerPath.isEmpty,
           let cert = try? SecManager.fetchCertificate(from: lastCerPath) {
            var sec = Sec(secCertificate: cert)
            sec.key = currentSecKey
            _certificates.append(sec)
        }
        displayLog("读取钥匙串中的证书", isWarning: false)
        reloadCerPopUpButton()
    }

    private func reloadCerPopUpButton() {
        cerPopUpButton.removeAllItems()
        switch _authMethod {
        case .certificateBased:
            cerPopUpButton.addItem(withTitle: "从文件中选择 iOS 推送证书 (.cer)…")
            for (idx, sec) in _certificates.enumerated() {
                let title = (sec.name ?? "(unnamed)") + "  " + sec.expire
                cerPopUpButton.addItem(withTitle: title)
                if let cerName = _cerName, !cerName.isEmpty, cerName == sec.name {
                    cerPopUpButton.selectItem(at: idx + 1)
                    _currentSec = sec
                }
            }
        case .tokenBased:
            cerPopUpButton.addItem(withTitle: "从文件中选择 P8 文件 (.p8)…")
            if !_p8FileName.isEmpty {
                cerPopUpButton.addItem(withTitle: _p8FileName)
                cerPopUpButton.selectItem(at: 1)
            }
        }
    }

    // MARK: - Connect / send

    private func connect() {
        guard !isConnected else {
            displayLog("服务器已连接，无需重新连接", isWarning: false)
            return
        }
        guard let certificate = _currentSec?.certificate else {
            inlineBanner.show(message: "请先选择有效的推送证书", style: .error)
            displayLog("读取证书失败", isWarning: true)
            return
        }
        let host = certificateApplePushHost(with: _env)
        let port = certificateApplePushPort(with: _env)
        socket = Socket(address: host, port: port, cert: certificate)
        displayLog("正在连接服务器中…", isWarning: false)
        socket?.connect { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.displayLog("服务器连接成功", isWarning: false)
                this.isConnected = true
            case let .failure(error):
                this.inlineBanner.show(message: "服务器连接失败：\(error)", style: .error)
                this.displayLog("服务器连接失败：\(error)", isWarning: true)
                this.isConnected = false
            }
        }
    }

    private func send() {
        let deviceToken = deviceTokenTextField.stringValue
        let payload = payloadText

        guard !deviceToken.isEmpty else {
            inlineBanner.show(message: "Device Token 不能为空", style: .error)
            displayLog("Device Token 是无效的", isWarning: true)
            return
        }
        guard !payload.isEmpty else {
            inlineBanner.show(message: "Payload 不能为空", style: .error)
            displayLog("Payload 是无效的", isWarning: true)
            return
        }

        switch _authMethod {
        case .certificateBased:
            sendCertificateBased(deviceToken: deviceToken, payload: payload)
        case .tokenBased:
            sendTokenBased(deviceToken: deviceToken, payload: payload)
        }
    }

    private func sendCertificateBased(deviceToken: String, payload: String) {
        guard isConnected else {
            inlineBanner.show(message: "请先点击「连接服务器」", style: .warning)
            displayLog("未连接至服务器", isWarning: true)
            return
        }
        guard !_certificates.isEmpty else {
            inlineBanner.show(message: "证书缺失，请先选择证书", style: .error)
            return
        }

        let pkg = APNsProviderCertificates(deviceToken: deviceToken, payload: payload)
        deviceTokenTextField.stringValue = pkg.formattedDeviceToken
        deviceTokenString = pkg.formattedDeviceToken
        writeUserData()

        isSending = true
        socket?.send(data: pkg.data) { [weak self] result in
            guard let this = self else { return }
            this.isSending = false
            let isSuccess: Bool
            switch result {
            case .success:
                this.inlineBanner.show(message: "推送成功", style: .success)
                this.displayLog("推送成功", isWarning: false)
                isSuccess = true
            case .failure(let error):
                this.inlineBanner.show(message: "推送失败：\(error)", style: .error)
                this.displayLog("推送失败：\(error)", isWarning: true)
                isSuccess = false
            }
            let record = PushHistoryRecord(
                deviceToken: deviceToken, payload: payload,
                authMethod: this._authMethod, environment: this._env,
                isSuccess: isSuccess)
            PushHistoryManager.shared.addRecord(record)
        }
    }

    private func sendTokenBased(deviceToken: String, payload: String) {
        guard !_p8FilePath.isEmpty else {
            inlineBanner.show(message: "请先选择 .p8 文件", style: .error)
            return
        }

        let keyId = keyIdTextField.stringValue
        let teamId = teamIdTextField.stringValue
        let bundleId = bundleIdTextField.stringValue

        guard !bundleId.isEmpty else {
            inlineBanner.show(message: "Bundle ID 不能为空", style: .error); return
        }
        guard keyId.count == 10 else {
            inlineBanner.show(message: "Key ID 必须为 10 位字符", style: .error); return
        }
        guard teamId.count == 10 else {
            inlineBanner.show(message: "Team ID 必须为 10 位字符", style: .error); return
        }

        if _authToken?.keyId != keyId || _authToken?.teamId != teamId {
            _authToken = AuthenticationToken(keyId: keyId, teamId: teamId)
        }
        let authToken = _authToken!

        let jwtToken: JWT.Token
        do {
            if let pk = _p8PrivateKey {
                jwtToken = try authToken.generateJWTToken(fromP8PrivateKey: pk)
            } else {
                jwtToken = try authToken.generateJWTToken(fromP8: _p8FilePath)
            }
        } catch {
            inlineBanner.show(message: "生成 JWT 失败：\(error.localizedDescription)", style: .error)
            displayLog("生成 JWT 失败：\(error.localizedDescription)", isWarning: true)
            return
        }

        let cleanedDeviceToken = deviceToken.replacingOccurrences(of: " ", with: "")
        let url = tokenAuthenticationApplePushURL(with: _env, deviceToken: cleanedDeviceToken)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bundleId, forHTTPHeaderField: "apns-topic")
        request.httpBody = payload.data(using: .utf8)

        isSending = true
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isSending = false }
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            var reason: String?
            if let data = data,
               let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                reason = dict["reason"] as? String
            }
            let isSuccess: Bool
            DispatchQueue.main.async {
                if statusCode == 200 {
                    self.inlineBanner.show(message: "推送成功 (HTTP 200)", style: .success)
                    self.displayLog("推送成功 (HTTP 200)", isWarning: false)
                } else {
                    let errmsg = reason ?? error?.localizedDescription ?? "HTTP \(statusCode)"
                    self.inlineBanner.show(message: "推送失败：\(errmsg)", style: .error)
                    self.displayLog("推送失败：HTTP \(statusCode) — \(errmsg)", isWarning: true)
                }
            }
            isSuccess = (statusCode == 200)
            let record = PushHistoryRecord(
                deviceToken: deviceToken, payload: payload,
                authMethod: self._authMethod, environment: self._env,
                bundleId: bundleId, keyId: keyId, teamId: teamId,
                isSuccess: isSuccess)
            PushHistoryManager.shared.addRecord(record)
        }
        task.resume()
    }

    private func disconnect(force: Bool) {
        socket?.disconnect(force: force)
        isConnected = false
    }

    private func resetConnect() {
        if isConnected {
            displayLog("重置连接", isWarning: false)
        }
        disconnect(force: true)
    }

    // MARK: - Status / availability

    private func updateStatus() {
        let envText = (_env == .delelopment) ? "开发" : "生产"
        switch _authMethod {
        case .certificateBased:
            if isConnected {
                statusDot.layer?.backgroundColor = NSColor.systemGreen.cgColor
                statusLabel.stringValue = "已连接 · \(envText)环境"
            } else {
                statusDot.layer?.backgroundColor = NSColor.systemGray.cgColor
                statusLabel.stringValue = "未连接 · \(envText)环境"
            }
        case .tokenBased:
            statusDot.layer?.backgroundColor = NSColor.systemBlue.cgColor
            statusLabel.stringValue = "Token 模式 · \(envText)环境"
        }
    }

    private func updateActionAvailability() {
        let hasToken = !deviceTokenTextField.stringValue.isEmpty
        let hasPayload = !payloadText.isEmpty
        sendButton.isEnabled = hasToken && hasPayload && !isSending
        if isSending { sendSpinner.startAnimation(nil) } else { sendSpinner.stopAnimation(nil) }
    }

    // MARK: - Payload helpers

    private var payloadText: String {
        return payloadTextView?.string ?? ""
    }

    private func setPayloadText(_ text: String) {
        payloadTextView.string = text
        validatePayload(text)
    }

    private func validatePayload(_ text: String) {
        guard !text.isEmpty else {
            payloadValidationLabel.stringValue = ""
            return
        }
        guard let data = text.data(using: .utf8) else {
            payloadValidationLabel.stringValue = "无法编码为 UTF-8"
            payloadValidationLabel.textColor = .systemRed
            return
        }
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let bytes = data.count
            payloadValidationLabel.stringValue = "✓ JSON 合法，\(bytes) bytes"
            payloadValidationLabel.textColor = .systemGreen
        } catch {
            payloadValidationLabel.stringValue = "JSON 错误：\(error.localizedDescription)"
            payloadValidationLabel.textColor = .systemRed
        }
    }

    private func applyPayloadTemplate(at index: Int) {
        // Index 0 is the title item ("模板"); skip it.
        guard index >= 1, index - 1 < Self.payloadTemplates.count else { return }
        setPayloadText(Self.payloadTemplates[index - 1].body)
        writeUserData()
        // Reset selection back to title.
        payloadTemplateButton.selectItem(at: 0)
    }

    @objc private func formatPayloadClicked() {
        guard let data = payloadText.data(using: .utf8) else { return }
        do {
            let obj = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let pretty = try JSONSerialization.data(withJSONObject: obj,
                                                    options: [.prettyPrinted, .sortedKeys])
            if let str = String(data: pretty, encoding: .utf8) {
                setPayloadText(str)
            }
        } catch {
            inlineBanner.show(message: "无法格式化：\(error.localizedDescription)", style: .error)
        }
    }

    @objc private func minifyPayloadClicked() {
        guard let data = payloadText.data(using: .utf8) else { return }
        do {
            let obj = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let minified = try JSONSerialization.data(withJSONObject: obj, options: [])
            if let str = String(data: minified, encoding: .utf8) {
                setPayloadText(str)
            }
        } catch {
            inlineBanner.show(message: "无法压缩：\(error.localizedDescription)", style: .error)
        }
    }

    @objc private func copyPayloadClicked() {
        copyToPasteboard(payloadText, hint: "已复制 Payload")
    }

    @objc private func copyDeviceTokenClicked() {
        copyToPasteboard(deviceTokenTextField.stringValue, hint: "已复制 Device Token")
    }

    @objc private func copyLogClicked() {
        copyToPasteboard(logTextView.string, hint: "已复制日志")
    }

    @objc private func clearLogClicked() {
        logTextView.string = ""
    }

    private func copyToPasteboard(_ text: String, hint: String) {
        guard !text.isEmpty else { return }
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(text, forType: .string)
        inlineBanner.show(message: hint, style: .info, duration: 1.2)
    }

    // MARK: - Keyboard shortcuts

    private func installKeyboardShortcuts() {
        // ⌘L for clearing logs.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return event }
            guard self.view.window?.isKeyWindow == true else { return event }
            if event.modifierFlags.contains(.command), event.charactersIgnoringModifiers == "l" {
                self.clearLogClicked()
                return nil
            }
            return event
        }
    }

    // MARK: - User data persistence

    private func readUserData() {
        switch _authMethod {
        case .certificateBased:
            if let cerName = userDefaults.getString(forKey: UserDefaults.CertificateAuthInfoKey.cerName.rawValue),
               !cerName.isEmpty {
                _cerName = cerName
            }
            if let cerPath = userDefaults.getString(forKey: UserDefaults.CertificateAuthInfoKey.cerPath.rawValue),
               !cerPath.isEmpty {
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
            if let p8FilePath = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.p8FilePath.rawValue),
               !p8FilePath.isEmpty {
                _p8FilePath = p8FilePath
            }
            if let p8PrivateKey = userDefaults.getString(forKey: UserDefaults.JSONWebTokenAuthInfoKey.p8PrivateKey.rawValue),
               !p8PrivateKey.isEmpty {
                _p8PrivateKey = p8PrivateKey
            }
        }
        if let deviceToken = userDefaults.getString(forKey: UserDefaults.deviceTokenKey) {
            deviceTokenTextField.stringValue = deviceToken
        }
        if let payload = userDefaults.getString(forKey: UserDefaults.payloadKey) {
            setPayloadText(payload)
        } else {
            validatePayload(payloadText)
        }
    }

    private func writeUserData() {
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
        userDefaults.setString(payloadText, forKey: UserDefaults.payloadKey)
    }

    // MARK: - Hosts

    private func certificateApplePushHost(with env: Environment) -> String {
        switch env {
        case .delelopment: return CertificateAppleDelelopmentPushHost
        case .production:  return CertificateAppleProductionPushHost
        }
    }

    private func certificateApplePushPort(with env: Environment) -> Int {
        return CertificateApplePushPort
    }

    private func tokenAuthenticationApplePushURL(with env: Environment, deviceToken: String) -> URL {
        let host: String
        switch env {
        case .delelopment: host = TokenAuthenticationAppleDelelopmentPushHost
        case .production:  host = TokenAuthenticationAppleProductionPushHost
        }
        var c = URLComponents()
        c.scheme = TokenAuthenticationApplePushScheme
        c.host = host
        c.port = TokenAuthenticationApplePushPort
        c.path = TokenAuthenticationApplePushPath(withDeviceToken: deviceToken)
        guard let url = c.url else { fatalError() }
        return url
    }

    // MARK: - Logging

    fileprivate func displayLog(_ message: String, isWarning: Bool) {
        let exec: () -> Void = { [weak self] in
            guard let self = self else { return }
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let timestamp = formatter.string(from: Date())
            var attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.monospacedSystemFont(ofSize: 11, weight: .regular)
            ]
            attrs[.foregroundColor] = isWarning ? NSColor.systemRed : NSColor.labelColor
            let line = NSAttributedString(string: "[\(timestamp)] \(message)\n", attributes: attrs)
            self.logTextView.textStorage?.append(line)
            self.logTextView.scrollToEndOfDocument(nil)
        }
        if Thread.isMainThread { exec() } else { DispatchQueue.main.async(execute: exec) }
    }
}

// MARK: - InlineBanner

/// A slim status banner that slides over the top of the content. Replaces noisy NSAlert popups
/// for non-critical feedback.
final class InlineBanner: NSView {

    enum Style {
        case info, success, warning, error

        var background: NSColor {
            switch self {
            case .info:    return NSColor(calibratedRed: 0.20, green: 0.50, blue: 0.95, alpha: 1)
            case .success: return NSColor(calibratedRed: 0.18, green: 0.68, blue: 0.36, alpha: 1)
            case .warning: return NSColor(calibratedRed: 0.95, green: 0.70, blue: 0.20, alpha: 1)
            case .error:   return NSColor(calibratedRed: 0.90, green: 0.30, blue: 0.27, alpha: 1)
            }
        }
    }

    private let label = NSTextField(labelWithString: "")
    private var heightConstraint: NSLayoutConstraint!
    private var hideTimer: Timer?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor

        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }

    required init?(coder: NSCoder) { fatalError("not implemented") }

    func show(message: String, style: Style, duration: TimeInterval = 2.4) {
        label.stringValue = message
        layer?.backgroundColor = style.background.cgColor
        hideTimer?.invalidate()
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.18
            heightConstraint.animator().constant = 28
        }
        hideTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
            self?.hide()
        }
    }

    func hide() {
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.18
            heightConstraint.animator().constant = 0
        }
    }
}
