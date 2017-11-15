# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'teleBang' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for teleBang
	pod 'Alamofire', '~> 4.3'
pod 'SwiftyJSON'
pod 'ObjectMapper', '~> 2.2'
pod 'Eureka'
pod 'SnapKit', '~> 3.1.2'
pod 'Kingfisher', '~> 3.0'
pod 'AlamofireObjectMapper', '~> 4.0'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'RAMAnimatedTabBarController', "~> 2.0.13"
pod 'SlideMenuControllerSwift'
pod 'SwiftOverlays', '~> 3.0.0'
pod "XCDYouTubeKit", "~> 2.5.5"
pod 'RealmSwift'
pod 'Fabric'
pod 'Crashlytics'
pod 'IHKeyboardAvoiding'
pod 'Firebase/Core'
pod 'Firebase/AdMob'
pod 'Paystack'
  target 'teleBangTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'teleBangUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = ‘3.1’
        end
    end
  end
