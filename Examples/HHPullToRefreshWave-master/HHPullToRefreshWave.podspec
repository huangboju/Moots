Pod::Spec.new do |spec|
  spec.name         = "HHPullToRefreshWave"
  spec.version      = "1.0.1"
  spec.authors      = { "Herui" => "heruicross@gmail.com" }
  spec.homepage     = "https://github.com/red3/HHPullToRefreshWave"
  spec.summary      = "Wave animation pull to refresh for iOS"
  spec.source       = { :git => "https://github.com/red3/HHPullToRefreshWave.git", :tag => '1.0.1' }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.platform = :ios, '7.0'
  spec.source_files = "HHPullToRefreshWave/*"

  spec.requires_arc = true
  
  spec.ios.deployment_target = '7.0'
  spec.ios.frameworks = ['UIKit', 'Foundation'] 
end
