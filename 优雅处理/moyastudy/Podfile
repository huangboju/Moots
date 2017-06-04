source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

# Pods for MoyaStudy
def common_pods
  pod 'Alamofire'
  pod 'ObjectMapper'
end

def spec_pods
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'PromiseKit'
  pod 'PromiseKit/Alamofire'
end 

target 'MoyaStudy' do
  
  common_pods
  spec_pods

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end


