Pod::Spec.new do |s|
  s.name         = "NKit"
  s.version      = "0.2"
  s.summary      = "NKit provides some exteions of UIKit and Foundation classes"
  s.homepage     = "http://knacker.com"
  s.license      = "MIT"
  s.author       = "Nghia Nguyen"
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://bitbucket.org/nghiaphunguyen/nkit", :tag => s.version}
  s.source_files  = "Classes", "NKit/NKit/**/*.{swift}"
  s.requires_arc = true

  s.dependency 'SnapKit'
end