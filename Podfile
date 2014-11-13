platform :ios, :deployment_target => "7.0"
workspace 'WLANAudit'

xcodeproj 'WLANAudit.xcodeproj'

target :wlanaudit do
  xcodeproj 'WLANAudit.xcodeproj'
  pod 'Realm', '~> 0.87'
  pod 'DZNEmptyDataSet'
  pod 'QuickDialog', '~> 1.0'
  pod 'libKeygen', :git => "https://github.com/RobertoEstrada/libKeygen.git", :tag => "1.0.0"
  
  post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-WLANAudit-acknowledgements.plist', 'WLANAudit/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  end
end