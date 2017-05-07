platform :ios, '8.0'
#use_frameworks!

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

target "ARRing" do

pod 'ATNavigationController'
pod 'MJExtension'
pod 'MJRefresh'
pod 'MBProgressHUD', :git => 'https://github.com/CoderLT/MBProgressHUD.git'
pod 'SDWebImage'
pod 'AFNetworking'
pod 'ADTransitionController'
pod 'WebViewJavascriptBridge'
#pod 'AMap2DMap'
#pod 'AMapSearch'
pod 'UMengAnalytics' # 标准SDK，含IDFA
#pod 'UMengMessage'
#pod 'UMengSocial'
#pod 'UMengFeedback'
pod 'CTAssetsPickerController'
pod 'INTULocationManager'
pod 'Masonry'
#pod 'FXPageControl'
#pod 'UITableView+FDTemplateLayoutCell'
pod 'KVOController'
pod 'Aspects'
pod 'YYKit'
#pod 'CYLTabBarController'
#pod 'Qiniu', :git => 'https://github.com/qiniu/objc-sdk.git', :branch => 'AFNetworking-3.x'
pod 'YTKKeyValueStore'
pod 'MMPopupView'
#pod 'SKTagView'
#pod 'CocoaHTTPServer'
#pod 'ZXingObjC'
#pod 'LBXScan'
#pod 'RESideMenu'
#pod 'REFrostedViewController'
#pod 'FSCalendar'
#pod 'RongCloudIMKit'
#pod 'GPUImage'
#pod 'CSStickyHeaderFlowLayout'
#pod 'JDStatusBarNotification'
end
