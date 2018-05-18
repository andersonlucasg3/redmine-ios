# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

def default_pods
   use_frameworks!
   inhibit_all_warnings!
   
   pod 'Swift.Json'
   pod 'Alamofire'
   pod 'SwiftyTimer'
   pod 'Reachability'
   pod 'KeychainAccess'
   pod 'GenericDataSourceSwift'
   pod 'PKHUD'
   pod 'UIColor-HexString'
   pod 'FileKit'

   # Firebase/Fabric
   pod 'Firebase/Core'
   pod 'Fabric'
   pod 'Crashlytics'
   
end

target 'Redmine' do
  
   default_pods

end

target 'RedMock' do

   default_pods

end

# post install configuration

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
        end
    end
end
