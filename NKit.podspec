Pod::Spec.new do |s|
  s.name         = "NKit"
  s.version      = "2.1.77"
  s.summary      = "NKit provides some exteions of UIKit and Foundation classes"
  s.homepage     = "http://knacker.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/nghiaphunguyen/NKit", :tag => s.version}
  s.source_files  = "Classes", "NKit/Source/**/*.{swift}"
  s.requires_arc = true

  s.dependency 'SnapKit', '3.2.0'
  s.dependency 'NRxSwift', '1.0.21'
  s.dependency 'RxCocoa', '3.5.0'
  s.dependency 'OAStackView', '1.0.1'
  s.dependency 'Diff', '0.5.3'

end
