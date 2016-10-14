# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'NKit' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NKit
pod 'SnapKit’, ‘0.22.0’
pod 'NRxSwift', '0.2.10'
pod 'ATTableView'
pod 'RxCocoa', '2.6.0'
pod 'RxSwift', '2.6.0'
pod 'NTZStackView'
pod 'OAStackView'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "2.3"
        end
    end
end
