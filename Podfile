# frozen_string_literal: true

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

install! 'cocoapods', deterministic_uuids: false, warn_for_unused_master_specs_repo: false

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

target 'SampleMVVM' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Hide library warnings in Xcode
  inhibit_all_warnings!

  # Pods for SampleMVVM
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxOptional', '~> 4.1.0'
  pod 'R.swift', '~> 5.3.0'
  pod 'SwiftLint', '~> 0.41.0'
  pod 'PINRemoteImage', '~> 3.0.3'
  pod 'RealmSwift', '~> 10.2.0'
  pod 'Alamofire', '~> 4.9.0'
  pod 'LineSDKSwift', '~> 5.7.0'
  pod 'CropViewController', '~> 2.6.0'
  pod 'PKHUD', '~> 5.0'

  target 'SampleMVVMTests' do
    inherit! :search_paths
    pod 'RxTest', '~> 5.1.1'
    pod 'RxBlocking', '~> 5.1.1'
  end
end
