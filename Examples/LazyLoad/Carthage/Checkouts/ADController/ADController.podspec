
Pod::Spec.new do |s|

  s.name         = "ADController"
  s.version      = "1.0.1"
  s.summary      = "让广告弹框简单一点"
  s.homepage     = "https://github.com/huangboju/ADController"
  s.license      = "MIT"
  s.author       = { "huangboju" => "529940945@qq.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/huangboju/ADController.git", :tag => "#{s.version}" }
  s.source_files = "Classes/**/*.swift"
  s.resources = "Classes/Resources/ADController.bundle"
  s.framework  = "UIKit"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
