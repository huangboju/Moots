Pod::Spec.new do |s|
   s.name = 'CollectionViewTableKit'
   s.version = '1.0.0'
   s.license = 'MIT'

   s.summary = 'UICollectionView toolset written in swift, making multicolumn tables a breeze.'
   s.homepage = 'https://github.com/mschonvogel/CollectionViewTableKit'
   s.social_media_url = 'https://twitter.com/schonvogel'
   s.author = 'Malte Schonvogel'

   s.source = { :git => 'https://github.com/mschonvogel/CollectionViewTableKit.git', :tag => s.version }
   s.source_files = 'Source/*.swift'

   s.ios.deployment_target = '9.0'
end