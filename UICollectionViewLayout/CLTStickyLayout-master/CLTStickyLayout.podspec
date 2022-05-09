Pod::Spec.new do |s|
  s.name         = "CLTStickyLayout"
  s.version      = "1.0.1"
  s.summary      = "😱像UITableView一样使用UICollectionView的Layout"
  s.description  = <<-DESC
                    use this Layout make you UICollectionView like more UITableView
                   DESC
  s.homepage     = "https://github.com/Yrocky/CLTStickyLayout"
  s.screenshots  = "https://github.com/Yrocky/CLTStickyLayout/raw/master/sample.png"
  s.license      = "MIT"
  s.author             = { "Yrocky" => "983272765@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/Yrocky/CLTStickyLayout.git", :tag => s.version }
  s.source_files  = "CLTStickyLayout/CLTStickyLayout.{h,m}"
  s.frameworks = "UIKit"
  s.requires_arc = true
end
